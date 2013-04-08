/*
 * layers.js
 * Copyright (C) 2013 Coherent Logic Development LLC
 * 
 * Author: John Willis <jwillis@coherent-logic.com>
 * Created: 4 April 2013
 *  
 */

/**
 * pt_map
 *  
 */
function pt_map(options) 
{

	// initialize object
	this.root_url = options.root_url;
	
	// set up status structure	
	if(options.on_status_changed) {
		this.on_status_changed = options.on_status_changed;
	}
	else {
		this.on_status_changed = function (status) {
			return(true);
		}
	}
	this.status = new pt_status();
	this.on_status_changed(this.status);

	// the plugins array
	this.plugins = new Array();

	// set up OSM layer
	var cloudmade_url = 'http://{s}.tile.cloudmade.com/' + options.cloudmade_api_key + '/1155/256/{z}/{x}/{y}.png';
	var base_layer_osm = L.tileLayer(cloudmade_url, {attribution:'Map data &copy; OpenStreetMap contributors'});
	
	// set up aerial layer
	var mapquest_url = 'http://otile1.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg';
	var base_layer_aerial = L.tileLayer(mapquest_url, {attribution:'Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency'});
	
	// initialize the map control with the base layers
	this.leaflet_map = L.map(options.attach_to, {
		center: new L.LatLng(options.initial_center_latitude, options.initial_center_longitude),
		zoom: options.initial_zoom_level,
		layers: [base_layer_aerial, base_layer_osm]
	});
	
	var base_maps = {
		"Aerial": base_layer_aerial,		
		"Base": base_layer_osm							
	};
	
	L.control.layers(base_maps).addTo(this.leaflet_map);			
	
	// set up the layers structure
	this.layers = new Array();

	url = options.root_url + '/parcels/json/all_layers.cfm';
	var layers_json = eval('(' + request(url) + ')');

	for(i = 0; i < layers_json.length; i++) {
		this.layers.push(new pt_layer(layers_json[i]));	
	}
		
	// define this map's viewport
	this.viewport = new pt_viewport(this);

	// set up the base layers to regenerate the viewport when loaded	
	base_layer_osm.on('load', this.viewport.regenerate, this.viewport);	
	base_layer_aerial.on('load', this.viewport.regenerate, this.viewport);
	this.leaflet_map.on('viewreset', this.viewport.regenerate, this.viewport);
	
	/**
	 * default plugin for handling feature hover
	 */
	var map_accessor = this;
	var __pt_plugin_featurehover = new pt_plugin({
		plugin_name: '__pt_plugin_parcelhover',
		on_activate: function () { return (true); },
		on_deactivate: function () { return (true); },
		on_feature_hover: function (event_object, layer_object) {
			map_accessor.status.feature_id = layer_object.layer_key_abbreviation + ' ' + event_object.target.feature._pt_feature_id;
			map_accessor.status.layer = layer_object.layer_name;
			map_accessor.on_status_changed(map_accessor.status);
		}				
	});
	
	this.install_plugin(__pt_plugin_featurehover);

	return(this);
}

pt_map.prototype.install_plugin = function (plugin) {
	this.plugins.push(plugin);
};

pt_map.prototype.on_feature_click = function (event_object, layer_object) {
	alert(event_object.target.feature._pt_feature_id);
};

pt_map.prototype.on_feature_hover = function (event_object, layer_object) {
	for(i = 0; i < this.plugins.length; i++) {
			this.plugins[i].on_feature_hover(event_object, layer_object);
	}
};

/**
 * pt_layer
 *  
 * @param {Object} layer_json
 */
pt_layer.prototype.AJAX_READY = 4;
pt_layer.prototype.AJAX_LOADING = 1;
pt_layer.prototype.AJAX_PROCESSING = 3;

function pt_layer(layer_json) {
	
	// set the object's properties based on the passed-in JSON structure
	this.id = layer_json.ID;
	this.layer_name = layer_json.LAYER_NAME;
	this.projection = layer_json.LAYER_PROJECTION;
	this.projection_name = layer_json.LAYER_PROJECTION_NAME;
	this.layer_key_abbreviation = layer_json.LAYER_KEY_ABBREVIATION;
	this.layer_key_name = layer_json.LAYER_KEY_NAME;
	this.color = layer_json.LAYER_COLOR;
	
	// network stuff
	this.request_pending = false;
	this.xml_http = http_request_object();
	
	switch(layer_json.LAYER_ENABLED) {
		case 0: this.enabled = false; break;
		case 1: this.enabled = true; break;		
	} 
	
	return(this);	
}


pt_layer.prototype.render = function (viewport) {
	var layer_url = viewport.ptarmigan_map.root_url + '/parcels/json/geojson.cfm?layer_id=' + escape(this.id);
	layer_url += '&nw_latitude=' + escape(viewport.nw_latitude);
	layer_url += '&nw_longitude=' + escape(viewport.nw_longitude);
	layer_url += '&se_latitude=' + escape(viewport.se_latitude);
	layer_url += '&se_longitude=' + escape(viewport.se_longitude);
	
	pt_debug(layer_url);
	
	// clear all polygons from viewport
	viewport.clear_features();
	
	// set up network transfer callback
	this.xml_http = http_request_object();
	var layer_obj = this;
	this.xml_http.onreadystatechange = function () {
		switch(layer_obj.xml_http.readyState) {
			case layer_obj.AJAX_LOADING:				
				viewport.ptarmigan_map.status.network_status = "Loading " + layer_obj.layer_name + "";
				viewport.ptarmigan_map.status.network_busy = true;
				viewport.ptarmigan_map.status.system_busy = true;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				break;
			case layer_obj.AJAX_PROCESSING:
				viewport.ptarmigan_map.status.network_status = "Processing Data"
				viewport.ptarmigan_map.status.system_busy = true;				
				viewport.ptarmigan_map.status.network_busy = false;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				break;
			case layer_obj.AJAX_READY:
				viewport.ptarmigan_map.status.network_status = "Network Idle"
				viewport.ptarmigan_map.status.network_busy = false;
				viewport.ptarmigan_map.status.system_busy = true;
				viewport.ptarmigan_map.status.network_response = layer_obj.xml_http.status;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				// parse the JSON from the server
				var current_features = eval('(' + layer_obj.xml_http.responseText + ')');
				var current_feature_count = current_features.features.length;
				var current_feature = new L.geoJson(current_features, {
					onEachFeature: function (feature, layer) {
						layer.feature._pt_feature_id = feature.properties.feature_id;
						layer.feature._pt_layer_id = feature.properties.layer_id;
						
						layer.on('click', function (e) {
							viewport.ptarmigan_map.on_feature_click(e, layer_obj);
						});
						
						layer.on('mouseover', function (e) {
							viewport.ptarmigan_map.on_feature_hover(e, layer_obj)
						});
					},
					style: {
						color:layer_obj.color,
						weight:1,
						opacity:1
					}
				});
				
				
				viewport.features.push(current_feature);	 
	    		viewport.features[viewport.features.length - 1].addTo(viewport.ptarmigan_map.leaflet_map);					    					   
				
				layer_obj.request_pending = false;
				
				viewport.ptarmigan_map.status.feature_count = current_feature_count;
				viewport.ptarmigan_map.status.system_busy = false;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				break;
		
		}
	}
	this.xml_http.open("GET", layer_url, true);
    this.xml_http.send(null); 
	
	return(this);		
};

pt_layer.prototype.abort_active_transfers = function () {
	if (this.xml_http) {
		if (this.request_pending === true) {
			this.xml_http.abort();
			this.request_pending = false;
		}
	}
};

/**
 * pt_viewport
 *  
 * @param {Object} map_object
 */
function pt_viewport(map_object) {
	this.ptarmigan_map = map_object;	
	this.features = new Array();
	this.nw_latitude = null;
	this.nw_longitude = null;
	this.se_latitude = null;
	this.se_longitude = null;
		
	
	return(this);
}


pt_viewport.prototype.update_bounds = function () {
	var bounds = this.ptarmigan_map.leaflet_map.getBounds();    
    var nw = bounds.getNorthEast();
    var se = bounds.getSouthWest();

    this.nw_latitude = nw.lat;
    this.nw_longitude = nw.lng;
    this.se_latitude = se.lat;
    this.se_longitude = se.lng;
    
    return(this);
};

pt_viewport.prototype.clear_features = function () {
	if (this.features) {
		while(this.features[0]) {		   
		    this.ptarmigan_map.leaflet_map.removeLayer(this.features.pop());		    
		}
	}
	
	return(this);
};

pt_viewport.prototype.regenerate = function() {
	
	// update the viewport's boundary
	this.update_bounds();		
	
	// loop through the layers and tell them to render themselves to this viewport
	for(i = 0; i < this.ptarmigan_map.layers.length; i++) {
		if(this.ptarmigan_map.layers[i].enabled) {
			this.ptarmigan_map.layers[i].abort_active_transfers();
			this.ptarmigan_map.layers[i].render(this);
		}
	}
	
	return(this);
};

/**
 * pt_plugin
 */
function pt_plugin (options) 
{
	if (!options.on_activate) {
		alert('Plugin Error: Callback function on_activate() is not defined.');		
		return(false)
	}
	else {
		this.on_activate = options.on_activate;
	}
	if (options.on_deactivate) {
		this.on_deactivate = options.on_deactivate;
	}
	else {
		this.on_deactivate = function () { return (true); };
	}
	if (!options.plugin_name) {
		alert('Plugin Error: Plugin name is not defined.');
	}
	else {
		this.plugin_name = options.plugin_name;
	}
	if (options.on_feature_click) {
		this.on_feature_click = options.on_feature_click;
	}
	else {
		this.on_feature_click = function (event, layer_object) { return(true); };
	}
	if (options.on_feature_hover) {
		this.on_feature_hover = options.on_feature_hover;
	}
	else {
		this.on_feature_hover = function (event, layer_object) { return(true); };
	}
	if (options.on_map_click) {
		this.on_map_click = options.on_map_click;
	}
	else {
		this.on_map_click = function (event) { return(true); };
	}
	if (options.on_map_hover) {
		this.on_map_hover = options.on_map_hover;
	}
	else {
		this.on_map_hover = function (event) { return(true); };
	}
		
}

pt_plugin.prototype.gather_coordinates = function (count) {
	
};




/**
 * pt_status 
 */
function pt_status () {
	this.system_message = "Welcome to Ptarmigan GIS";
	this.network_status = "Network Idle";
	this.system_busy = true;
	this.network_busy = false;
	this.network_response = null;
	this.layer = "No Layer";
	this.latitude = "--";
	this.longitude = "--";
	this.feature_id = "No Parcel";
	this.feature_count = 0;
	this.bounding_rectangle = null;
}

/**
 * utilities 
 */
function pt_debug(msg) {
	$("#pt-debug").text(msg);	
}
