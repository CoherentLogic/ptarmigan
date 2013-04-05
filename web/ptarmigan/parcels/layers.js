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

	// set up OSM layer
	var cloudmade_url = 'http://b.tile.cloudmade.com/' + options.cloudmade_api_key + '/1155/256/{z}/{x}/{y}.png';
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
	var vp_obj = this.viewport;
	base_layer_osm.on('load', this.viewport.regenerate, this.viewport);	
	base_layer_aerial.on('load', this.viewport.regenerate, this.viewport);
	this.leaflet_map.on('viewreset', this.viewport.regenerate, this.viewport);

	return(this);
}

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
	var layer_url = viewport.ptarmigan_map.root_url + '/parcels/json/layer.cfm?layer_id=' + escape(this.id);
	layer_url += '&nw_latitude=' + escape(viewport.nw_latitude);
	layer_url += '&nw_longitude=' + escape(viewport.nw_longitude);
	layer_url += '&se_latitude=' + escape(viewport.se_latitude);
	layer_url += '&se_longitude=' + escape(viewport.se_longitude);
	
	pt_debug(layer_url);
	
	// clear all polygons from viewport
	viewport.clear_polygons();
	
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
				var current_parcels = eval('(' + layer_obj.xml_http.responseText + ')');
				var current_parcel_count = current_parcels.PARCELS.length;
				var point_count = 0;
				var coords = [];
				var polygon = "";					
			 	var parcel_color = "";
			 	
				//loop through the parcels array
				for(i = 0; i < current_parcel_count; i++) {
					var point_count = current_parcels.PARCELS[i].POLYGONS.length;
					
					coords = [];
					for(j = 0; j < point_count; j++) {		
						coords[j] = new L.LatLng(current_parcels.PARCELS[i].POLYGONS[j].LATITUDE, current_parcels.PARCELS[i].POLYGONS[j].LONGITUDE);		
				    }
				    current_parcel = current_parcels[i];
					polygon = new L.Polygon(coords);		
					polygon.parcel_key = current_parcels.PARCELS[i].PARCEL_KEY;
					polygon.parcel_index = i;					    
				    parcel_color = "#2262CC";
					    
					polygon.setStyle({
				        color: parcel_color,
				        weight: 1,
				        opacity: 0.6,
				        fillOpacity: 0.1,
				        fillColor: current_parcels.PARCELS[i].FILL_COLOR
				    });
				    					    	   					    
					viewport.polygons.push(polygon);	 
	    			viewport.polygons[viewport.polygons.length - 1].addTo(viewport.ptarmigan_map.leaflet_map);					    					   
				} // parcels
				
				viewport.ptarmigan_map.status.parcel_count = current_parcel_count;
				viewport.ptarmigan_map.status.system_busy = false;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				break;
		
		}
	}
	this.xml_http.open("GET", layer_url, true);
    this.xml_http.send(null); 
	
	return(this);		
};

/**
 * pt_viewport
 *  
 * @param {Object} map_object
 */
function pt_viewport(map_object) {
	this.ptarmigan_map = map_object;	
	this.polygons = new Array();
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

pt_viewport.prototype.clear_polygons = function () {
	if (this.polygons) {
		while(this.polygons[0]) {		   
		    this.ptarmigan_map.leaflet_map.removeLayer(this.polygons.pop());		    
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
			this.ptarmigan_map.layers[i].render(this);
		}
	}
	
	return(this);
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
	this.parcel_id = "No Parcel";
	this.parcel_count = 0;
	this.bounding_rectangle = null;
}

/**
 * utilities 
 */
function pt_debug(msg) {
	$("#pt-debug").text(msg);	
}
