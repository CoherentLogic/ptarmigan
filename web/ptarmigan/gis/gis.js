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
	var base_layer_osm_overview = L.tileLayer(cloudmade_url, {attribution:''});
	
	// set up aerial layer
	var mapquest_url = 'http://otile1.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg';
	var base_layer_aerial = L.tileLayer(mapquest_url, {attribution:'Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency'});
	
	// initialize the map control with the base layers
	this.leaflet_map = L.map(options.attach_to, {
		center: new L.LatLng(options.initial_center_latitude, options.initial_center_longitude),
		zoom: options.initial_zoom_level,
		layers: [base_layer_aerial, base_layer_osm]
	});
	
	this.overview_map = L.map("area-overview", {
		center: new L.LatLng(options.initial_center_latitude, options.initial_center_longitude),
		zoom: 12,
		layers: [base_layer_osm_overview],
		dragging: false,
		touchZoom: false,
		scrollWheelZoom: false,
		boxZoom: false,
		zoomControl: false,
		attributionControl: false
	});
		
	var base_maps = {
		"Aerial": base_layer_aerial,		
		"Base": base_layer_osm							
	};
	
	L.control.layers(base_maps).addTo(this.leaflet_map);			
	
	// set up the layers structure
	this.layers = new Array();

	url = options.root_url + '/gis/json/all_layers.cfm';
	var layers_json = eval('(' + request(url) + ')');

	for(i = 0; i < layers_json.length; i++) {
		this.layers.push(new pt_layer(layers_json[i]));	
	}
		
	// define this map's viewport
	this.viewport = new pt_viewport(this);

	// set up the base layers to regenerate the viewport when loaded		
	this.leaflet_map.on('moveend', this.viewport.regenerate, this.viewport);
	this.leaflet_map.on('zoomend', this.viewport.regenerate, this.viewport);
	this.viewport.regenerate();
	/**
	 * default plugin for handling feature hover
	 */
	var map_accessor = this;
	
	this.leaflet_map.on('mousemove', function (e) {
		map_accessor.on_map_hover(e);
	});
	
	this.leaflet_map.on('click', function (e) {
		map_accessor.on_map_click(e);
	});

	
	var __pt_plugin_default = new pt_plugin({
		plugin_name: '__pt_plugin_default',
		on_installed: function () {
			pt_debug('Ptarmigan GIS Default Plugin (V0.02-EXP) [Installed]');
		},
		on_activate: function () { 
			// The default plugin must always own the map in order to 
			// fire UI update events. However, the default plugin is 
			// well-behaved, in that it will not do anything to interfere 
			// with the operations of other plugins that own the map.				
			this.take_map_ownership();
			
			pt_debug('Ptarmigan GIS Default Plugin (V0.02-EXP) [Activated]');						
			
			return(true);
		},
		on_deactivate: function () { return (true); },
		on_feature_hover: function (event_object, layer_object) {
			this.map_object.status.feature_id = layer_object.layer_key_abbreviation + ' ' + event_object.target.feature._pt_feature_id;
			this.map_object.status.layer = layer_object.layer_name;
			this.map_object.on_status_changed(map_accessor.status);
			event_object.target.setStyle({color:'blue'});
		},
		on_feature_mouseout: function(event_object, layer_object) {
			event_object.target.setStyle({color:layer_object.color});
		},
		on_map_hover: function (event_object) {
			this.map_object.status.latitude = event_object.latlng.lat;
			this.map_object.status.longitude = event_object.latlng.lng;
			this.map_object.on_status_changed(map_accessor.status);
		},
		on_map_click: function (event_object) {
			
		}
	});
	
	
	
	this.install_plugin(__pt_plugin_default);
	this.activate_plugin('__pt_plugin_default');    

	return(this);
}

pt_map.prototype.install_plugin = function (plugin) {
	plugin.map_object = this;
	this.plugins.push(plugin);
	
	
	if(plugin.selectable) {
		// add it to the main toolbar
		var tb = Ext.getCmp('main-toolbar');
		var __pt_acc_plugin = plugin;
		plugin.toolbar_button = Ext.create('Ext.button.Button', {
			__pt_plugin: plugin,
			icon: 'plugins/' + plugin.plugin_name + '/toolbar-icon.png',
			text: plugin.text,
			enableToggle: true,
			handler: function () {
				if(this.pressed) {
					this.__pt_plugin.activate();
				}
				else {
					this.__pt_plugin.deactivate();
				}
			}
		});
		tb.add(plugin.toolbar_button);
	}
	
	this.plugins[this.plugins.length - 1].on_installed();
		
	return(this.plugins.length - 1);
};

pt_map.prototype.activate_plugin = function (plugin_name) {		
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].plugin_name === plugin_name) {
			return(this.plugins[i].activate());
		}
	}
	
};

pt_map.prototype.on_feature_click = function (event_object, layer_object) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].active && this.plugins[i].owns_map) {
			this.plugins[i].on_feature_click(event_object, layer_object);
		}
	}
};

pt_map.prototype.on_feature_hover = function (event_object, layer_object) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].active && this.plugins[i].owns_map) {
			this.plugins[i].on_feature_hover(event_object, layer_object);
		}
		else {
			
		}
	}
};

pt_map.prototype.on_feature_mouseout = function (event_object, layer_object) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].active && this.plugins[i].owns_map) {
			this.plugins[i].on_feature_mouseout(event_object, layer_object);
		}
	}
};

pt_map.prototype.on_map_hover = function (event_object) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].active && this.plugins[i].owns_map) {
			this.plugins[i].on_map_hover(event_object);
		}
	}
};

pt_map.prototype.on_map_click = function (event_object) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].active && this.plugins[i].owns_map) {
			this.plugins[i].on_map_click(event_object);			
		}
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
	this.id = layer_json.id;
	this.layer_name = layer_json.layer_name;
	this.projection = layer_json.layer_projection;
	this.projection_name = layer_json.layer_projection_name;
	this.layer_key_abbreviation = layer_json.layer_key_abbreviation;
	this.layer_key_name = layer_json.layer_key_name;
	this.color = layer_json.layer_color;
	
	// network stuff
	this.request_pending = false;
	this.xml_http = http_request_object();
	
	switch(layer_json.layer_enabled) {
		case 0: this.enabled = false; break;
		case 1: this.enabled = true; break;		
	} 
	
	return(this);	
}


pt_layer.prototype.render = function (viewport) {
	var layer_url = viewport.ptarmigan_map.root_url + '/gis/json/geojson.cfm?layer_id=' + escape(this.id);
	layer_url += '&nw_latitude=' + escape(viewport.nw_latitude);
	layer_url += '&nw_longitude=' + escape(viewport.nw_longitude);
	layer_url += '&se_latitude=' + escape(viewport.se_latitude);
	layer_url += '&se_longitude=' + escape(viewport.se_longitude);	
	
	// clear all features from viewport
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
				if (current_features.features) {
					layer_obj.current_feature_count = current_features.features.length;
								
					var current_feature = new L.geoJson(current_features, {
						onEachFeature: function (feature, layer) {
							layer.feature._pt_feature_id = feature.properties.feature_id;
							layer.feature._pt_layer_id = feature.properties.layer_id;
							
							layer.on('click', function (e) {
								viewport.ptarmigan_map.on_feature_click(e, layer_obj);
							});
							
							layer.on('mouseover', function (e) {
								viewport.ptarmigan_map.on_feature_hover(e, layer_obj);
							});
							
							layer.on('mouseout', function (e) {
								viewport.ptarmigan_map.on_feature_mouseout(e, layer_obj);
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
					
					viewport.ptarmigan_map.status.feature_count = viewport.current_feature_count();
					viewport.ptarmigan_map.status.system_busy = false;
					viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				}
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
	this.overview_rect = null;
	
	
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
    
    if(this.overview_rect) {
    	this.ptarmigan_map.overview_map.removeLayer(this.overview_rect);
    }
    
    this.overview_rect = L.rectangle(bounds, {color: 'red', weight:2, fill: false, opacity: 1.0});
    this.overview_rect.addTo(this.ptarmigan_map.overview_map);
    
    
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

pt_viewport.prototype.current_feature_count = function() {
	var tmp_fc = 0;
	
	for(i = 0; i < this.ptarmigan_map.layers.length; i++) {
		tmp_fc = tmp_fc + this.ptarmigan_map.layers[i].current_feature_count;	
	}
	
	return(tmp_fc);
}

/**
 * pt_plugin
 */
function pt_plugin (options) 
{
	if (!options.on_installed) {
		alert('Plugin Error: Callback function on_installed() is not defined.');
	}
	else {
		this.on_installed = options.on_installed;
	}
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
	if (options.on_feature_mouseout) {
		this.on_feature_mouseout = options.on_feature_mouseout;
	}
	else {
		this.on_feature_mouseout = function (event, layer_object) { return(true); };
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
	if (options.selectable) {
		this.selectable = true;
	}
	else {
		this.selectable = false;
	}
	if (options.text) {
		this.text = options.text;
	}
	this.active = false;		
	this.owns_map = false;

}

pt_plugin.prototype.activate = function () {
	this.active = true;
	return (this.on_activate());
}

pt_plugin.prototype.deactivate = function () {
	this.active = false;
	return (this.on_deactivate());
}

pt_plugin.prototype.get_feature_data = function (layer_id, feature_id) {
	var feature_json_url = this.map_object.root_url + '/gis/json/feature.cfm?feature_id=' + feature_id + '&layer_id=' + layer_id;
	var feature_json = eval('(' + request(feature_json_url) + ')');
	
	return (feature_json);
};

pt_plugin.prototype.take_map_ownership = function () {
	// Revoke map ownership from all plugins above index id 0 (the default plugin),
	// and give this plugin ownership over the map. This will allow the plugin's
	// mouse event handlers to fire.	
	for(i = 1; i < this.map_object.plugins.length; i++) {
		this.map_object.plugins[i].owns_map = false;
	}
	
	pt_debug("Plugin " + this.plugin_name + " has taken ownership of the map.");
	
	this.owns_map = true;
};

pt_plugin.prototype.release_map_ownership = function () {
	pt_debug("Plugin " + this.plugin_name + " has released ownership of the map.");
	
	this.owns_map = false
};

pt_plugin.prototype.gather_coordinates = function (count) {
	
};

function pt_plugin_manager (map_object) {
	this.map_obj = map_object;	
	return (this);
}

pt_plugin_manager.prototype.load_plugin = function (plugin_name) {
	var script_url = 'plugins/' + plugin_name + '/plugin.js';
	var script_element = document.createElement('script');
	
	script_element.setAttribute("type", "text/javascript");
	script_element.setAttribute("src", script_url);		
	
	var accessor = this;
	script_element.onload = function () {
		var plugin_var = eval(plugin_name);
		console.log('Plugin ' + plugin_name + ' has been dynamically loaded.');
		accessor.map_obj.install_plugin(plugin_var);		
	};
	document.getElementsByTagName("head")[0].appendChild(script_element);	

};

pt_plugin_manager.prototype.load_all = function(store) {
		
	var accessor = this;
	store.each(function (r) {
		var plugin_name = r.get('plugin_name');		
		accessor.load_plugin(plugin_name);
	});
	
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
	console.log(msg);
}
