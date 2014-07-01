/*
 * gis.js
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
		};
	}
	this.status = new pt_status();
	this.on_status_changed(this.status);
	this.shape = null;
	this.shape_marker = null;
	
	// the plugins array
	this.plugins = new Array();

	// initialize the map control
	this.leaflet_map = L.map(options.attach_to, {
		center: new L.LatLng(options.initial_center_latitude, options.initial_center_longitude),
		zoom: options.initial_zoom_level,
		zoomControl: false,
		minZoom: options.mininum_zoom_level,
		maxZoom: options.maximum_zoom_level
	});

	// read in raster layer data
	var raster = JSON.parse(request('app/data/raster_layers_read.cfm'));
	this.raster_layers = [];

	for (i = 0; i < raster.length; i++) {
		var rast = {};

		rast.leaflet_layer =  L.tileLayer(raster[i].url, {attribution: raster[i].attribution});
		rast.attributes = raster[i];

		this.raster_layers.push(rast);
	}

	var base_layer_osm_overview = null;

	for (i = 0; i < raster.length; i++) {
		if (this.raster_layers[i].attributes.layer_enabled == '1') {
			this.leaflet_map.addLayer(this.raster_layers[i].leaflet_layer);
			base_layer_osm_overview = L.tileLayer(raster[i].url, {attribution: ''});
			this.raster_layers[i].leaflet_layer.redraw();
		}
	}

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
	
	var closure = this;
	this.overview_map.on('click', function(event) {
		closure.leaflet_map.panTo(event.latlng);
	});
		
		
	// set up the layers structure
	this.layers = new Array();

	url = options.root_url + '/gis/json/all_layers.cfm';
	var layers_json = JSON.parse(request(url));

	for(i = 0; i < layers_json.length; i++) {
		this.layers.push(new pt_layer(layers_json[i]));	
	}
		
	// define this map's viewport
	this.viewport = new pt_viewport(this);

	// set up the base layers to regenerate the viewport when loaded		
	this.leaflet_map.on('moveend', this.viewport.regenerate, this.viewport);
	this.leaflet_map.on('zoomend', this.viewport.regenerate, this.viewport);
	this.leaflet_map.on('resize', this.viewport.regenerate, this.viewport);
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
			return (true);
		},
		on_activate: function () { 
			// The default plugin must always own the map in order to 
			// fire UI update events. However, the default plugin is 
			// well-behaved, in that it will not do anything to interfere 
			// with the operations of other plugins that own the map.				
			this.take_map_ownership();
			
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

pt_map.prototype.reset_plugin_buttons = function (except) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].toolbar_button) {
			if (this.plugins[i].toolbar_button === except) {
				//do nothing
			} 
			else {
				this.plugins[i].deactivate();
				this.plugins[i].toolbar_button.toggle(false);
			}
		}
	}
};

pt_map.prototype.install_plugin = function (plugin) {
	plugin.map_object = this;
	this.plugins.push(plugin);
	
	
	if(plugin.selectable) {
		// add it to the main toolbar
		var tb = Ext.getCmp('__pt_plugins_bar');
		var __pt_acc_plugin = plugin;
		plugin.toolbar_button = Ext.create('Ext.button.Button', {
			__pt_plugin: plugin,
			icon: 'plugins/' + plugin.plugin_name + '/toolbar-icon.png',
			text: plugin.text,
			enableToggle: true,
			handler: function () {
				var plugin_options = {noOptions: 'true'};
				if(this.pressed) {
					plugin.map_object.reset_plugin_buttons(this);
					this.__pt_plugin.activate(plugin_options);
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

pt_map.prototype.get_plugin_reference = function(plugin_name) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].plugin_name === plugin_name) {
			return(this.plugins[i]);
		}
	}
};

pt_map.prototype.activate_plugin = function (plugin_name, options) {		
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].plugin_name === plugin_name) {
			return(this.plugins[i].activate(options));
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
			if(this.plugins[i].drawing_shape === true) {
				this.plugins[i].preview_coordinates(event_object.latlng);
			}
		}
	}
};

pt_map.prototype.on_map_click = function (event_object) {
	for(i = 0; i < this.plugins.length; i++) {
		if(this.plugins[i].active && this.plugins[i].owns_map) {
			this.plugins[i].on_map_click(event_object);
			if(this.plugins[i].drawing_shape === true) {
				this.plugins[i].got_coordinates(event_object.latlng);
			}			
		}
	}
};

pt_map.prototype.clear_shape = function () {
	if (this.shape) {
		this.leaflet_map.removeLayer(this.shape);
		this.shape = null;		
	}
};

pt_map.prototype.clear_shape_marker = function () {
	if (this.shape_marker) {
		this.leaflet_map.removeLayer(this.shape_marker);
		this.shape_marker = null;
	}
};


/**
 * pt_layer
 *  
 * @param {Object} layer_json
 */
pt_layer.prototype.AJAX_READY = 4;
pt_layer.prototype.AJAX_CONNECTED = 1;
pt_layer.prototype.AJAX_LOADING = 3;

function pt_layer(layer_json) {
	
	// set the object's properties based on the passed-in JSON structure
	this.id = layer_json.id;
	this.layer_name = layer_json.layer_name;
	this.projection = layer_json.layer_projection;
	this.projection_name = layer_json.layer_projection_name;
	this.layer_key_abbreviation = layer_json.layer_key_abbreviation;
	this.layer_key_name = layer_json.layer_key_name;
	this.color = layer_json.layer_color;
	this.current_feature_count = 0;
	this.southwest_longitude = layer_json.southwest_coordinates[0];
	this.southwest_latitude = layer_json.southwest_coordinates[1];
	this.northeast_longitude = layer_json.northeast_coordinates[0];
	this.northeast_latitude = layer_json.northeast_coordinates[1];
	var south_west = new L.LatLng(this.southwest_latitude, this.southwest_longitude);
	var north_east = new L.LatLng(this.northeast_latitude, this.northeast_longitude);
	this.bounds = new L.LatLngBounds(south_west, north_east);
	
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
	
	// set up network transfer callback
	this.xml_http = http_request_object();
	var layer_obj = this;
	this.xml_http.onreadystatechange = function () {
		switch(layer_obj.xml_http.readyState) {
			case layer_obj.AJAX_CONNECTED:				
   			        viewport.ptarmigan_map.status.network_status = "Connection Established";
				viewport.ptarmigan_map.status.network_busy = true;
				viewport.ptarmigan_map.status.system_busy = true;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				break;
			case layer_obj.AJAX_LOADING:
			        viewport.ptarmigan_map.status.network_status = "Loading " + layer_obj.layer_name;
				viewport.ptarmigan_map.status.system_busy = true;				
				viewport.ptarmigan_map.status.network_busy = true;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				break;
			case layer_obj.AJAX_READY:
				viewport.ptarmigan_map.status.network_status = "Network Idle";
				viewport.ptarmigan_map.status.network_busy = false;
				viewport.ptarmigan_map.status.system_busy = true;
				viewport.ptarmigan_map.status.network_response = layer_obj.xml_http.status;
				viewport.ptarmigan_map.on_status_changed(viewport.ptarmigan_map.status);
				
				// parse the JSON from the server
				var current_features = JSON.parse(layer_obj.xml_http.responseText);
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
	};
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

pt_layer.prototype.zoom_extents = function () {
	var current_map = pt_gis.getApplication().__ptarmigan_gis;
	current_map.leaflet_map.fitBounds(this.bounds);
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
	this.layers_blocked = false;
	
	
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
	this.ptarmigan_map.overview_map.panTo(this.ptarmigan_map.leaflet_map.getCenter());
	
    
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
	
	var geometry_minimum_zoom = pt_gis.getApplication().__ptarmigan_session.s.system.geometry_minimum_zoom;
	var current_zoom_level = this.ptarmigan_map.leaflet_map.getZoom();

	// clear current features
	this.clear_features();

	// update the viewport's boundary
	this.update_bounds();		
	

	if (current_zoom_level >= geometry_minimum_zoom) {
		if (!this.layers_blocked) {
			// loop through the layers and tell them to render themselves to this viewport
			for(i = 0; i < this.ptarmigan_map.layers.length; i++) {
				if(this.ptarmigan_map.layers[i].enabled) {
					var layer_id = this.ptarmigan_map.layers[i].id;
					var chk_element = document.getElementById("LAYER_ENABLED_" + layer_id);
					
					if(chk_element) {
						chk_element.disabled = false;
						chk_element.checked = true;
					}

					this.ptarmigan_map.layers[i].abort_active_transfers();
					this.ptarmigan_map.layers[i].render(this);					
				}
			}
		}
	}
	else {
		for(i = 0; i < this.ptarmigan_map.layers.length; i++) {
			var layer_id = this.ptarmigan_map.layers[i].id;
			var chk_element = document.getElementById("LAYER_ENABLED_" + layer_id);

			if(chk_element) {
				chk_element.checked = false;
				chk_element.disabled = true;
			}
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
};

pt_viewport.prototype.block_layers = function () {
	this.layers_blocked = true;
	this.clear_features();
	
	return(true);
};

pt_viewport.prototype.unblock_layers = function () {
	this.layers_blocked = false;
	this.clear_features();
	this.regenerate();
	
	return(true);
};

/**
 * pt_plugin
 */
function pt_plugin (options) 
{
	if (options.shape_style) {
		this.shape_style = options.shape_style;
	}
	else {
		this.shape_style = {color: 'green', weight:1, opacity: 1.0};
	}
	if (!options.on_installed) {
		alert('Plugin Error: Callback function on_installed() is not defined.');
	}
	else {
		this.on_installed = options.on_installed;
	}
	if (!options.on_activate) {
		alert('Plugin Error: Callback function on_activate() is not defined.');		
		return(false);
	}
	else {
		this.on_activate = options.on_activate;
	}
	if (options.on_coordinates_received) {
		this.on_coordinates_received = options.on_coordinates_received;
	}
	else {
		this.on_coordinates_received = function (coordinates) { return(true); };
	}
	if (options.on_shape_complete) {
		this.on_shape_complete = options.on_shape_complete;
	}
	else {
		this.on_shape_complete = function (shape, coordinates) { return(true); };
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
	this.drawing_shape = false;
	this.shape_type = 'polyline';
	this.coordinates = new Array();
	this.shape_started = false;

}

pt_plugin.prototype.activate = function (options) {
	this.active = true;
	return (this.on_activate(options));
};

pt_plugin.prototype.deactivate = function () {
	this.active = false;
	return (this.on_deactivate());
};

pt_plugin.prototype.get_feature_data = function (layer_id, feature_id) {
	var feature_json_url = this.map_object.root_url + '/gis/json/feature.cfm?feature_id=' + feature_id + '&layer_id=' + layer_id;
	var feature_json = JSON.parse(request(feature_json_url));
	
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
	
	this.owns_map = false;
};

pt_plugin.prototype.request_bare_map = function () {
	this.map_object.viewport.block_layers();
};

pt_plugin.prototype.release_bare_map = function () {
	this.map_object.viewport.unblock_layers();
};

pt_plugin.prototype.request_shape = function (config) {
	this.drawing_shape = true;
	this.shape_type = config.shape;
	this.request_bare_map();
	this.coordinates = new Array();
	
	return(this);
};

pt_plugin.prototype.got_coordinates = function (latlng) {
	this.shape_started = true;
	if(this.on_coordinates_received(latlng)) {
		if(this.drawing_shape) {
			this.coordinates.push(latlng);
			this.map_object.clear_shape();
			switch(this.shape_type) {
				case 'polyline':
					var shape = new L.Polyline(this.coordinates, this.shape_style);				 
					break;
				case 'polygon':
					var shape = new L.Polygon(this.coordinates, this.shape_style);
					break;
				case 'rectangle':					
					var shape = new L.Rectangle(this.coordinates, this.shape_style);
					break;				
			}
			this.map_object.shape = shape;
			this.map_object.shape.addTo(this.map_object.leaflet_map);
			
			
			var plugin_closure = this;
			this.map_object.clear_shape_marker();
			this.map_object.shape_marker = new L.marker(latlng, {zIndexOffset: 10000});			
			this.map_object.shape_marker.on('click', function(e) {							
				plugin_closure.shape_complete(plugin_closure.map_object.shape);
			});
			this.map_object.shape_marker.addTo(this.map_object.leaflet_map);
			
		}
	}
};

pt_plugin.prototype.preview_coordinates = function (latlng) {
	if(this.shape_started) {
		var tmp_coords = null;
		tmp_coords = new Array();		
		tmp_coords = pt_clone_object(this.coordinates);				
		tmp_coords.push(latlng);
		
		this.map_object.clear_shape();
		switch(this.shape_type) {
			case 'polyline':
				var shape = new L.Polyline(tmp_coords, this.shape_style);				 
				break;
			case 'polygon':
				var shape = new L.Polygon(tmp_coords, this.shape_style);
				break;
			case 'rectangle':
				var shape = new L.Rectangle(tmp_coords, this.shape_style);
				break;				
		}
		this.map_object.shape = shape;
		this.map_object.shape.addTo(this.map_object.leaflet_map);		
	}
};

pt_plugin.prototype.shape_complete = function (shape) {
	this.shape_started = false;
	this.drawing_shape = false;	
		
	var tmp_coords = this.coordinates;
	this.map_object.clear_shape();
	switch(this.shape_type) {
		case 'polyline':
			shape = new L.Polyline(tmp_coords, this.shape_style);				 
			break;
		case 'polygon':
			shape = new L.Polygon(tmp_coords, this.shape_style);
			break;
		case 'rectangle':
			shape = new L.Rectangle(tmp_coords, this.shape_style);
			break;				
	}
	
	this.map_object.clear_shape_marker();
	this.map_object.clear_shape();
	this.map_object.shape = shape;		
	shape.addTo(this.map_object.leaflet_map);
	this.on_shape_complete(shape, this.coordinates);
	this.coordinates = null;	

};



pt_plugin.prototype.notify = function(title, text) {
	Ext.create('widget.uxNotification', {position: 't',
										useXAxis: true,
										cls: 'ux-notification-light',
										iconCls: 'ux-notification-icon-information',
										closable: false,
										title: title,
										html: text,
										slideInDuration: 800,
										slideBackDuration: 1500,
										autoCloseDelay: 6000,
										slideInAnimation: 'bounceOut',
										slideBackAnimation: 'easeIn'
										}).show();
};

pt_plugin.prototype.cloudmade_api_key = function() {
	var key = pt_gis.getApplication().__ptarmigan_session.s.system.cloudmade_api_key;
	return(key);
};

pt_plugin.prototype.proxy_request = function(url, method, content_type) {
	var proxy_url = "proxy_request.cfm?method=" + escape(method);
	proxy_url += "&content_type=" + escape(content_type);
	proxy_url += "&proxy_url=" + escape(url);

	var result = request(proxy_url);
	return(result);
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
 * pt_search
 */
function pt_search(layer_id, search_type) {
	//this.pt_map_object = pt_gis.getApplication().__ptarmigan_gis;
	this.layer_id = layer_id;
	this.search_type = search_type;
	this.columns = new Array();	
}

pt_search.prototype.add_column = function(search_column) {
	this.columns.push(search_column);	
};

pt_search.prototype.exec = function() {
	
	Ext.Ajax.request({
		url: 'app/data/search_results.cfm',
		success: function (response) {
			var json_result = JSON.parse(response.responseText);
			
			this.data_store = Ext.create('Ext.data.Store', {
				model: 'pt_gis.model.search_result',
				data: json_result
			});
			this.view = Ext.widget('featuresearchresults', {store: this.data_store});
			this.view.show();
		},
		failure: function (response) {
			console.log("failure: " + response.responseText);
		},
		jsonData: this
	});
};

function pt_search_column (configs) {
	this.src_attribute = configs.src_attribute;
	this.operator = configs.operator;
	this.search_value = configs.search_value;
	this.column_type = configs.column_type;
	
	return(this);
}

function pt_feature (configs) {
	this.feature_id = configs.feature_id;
	this.layer_id = configs.layer_id;
	this.data_store = Ext.create('pt_gis.store.feature_attribute');
	this.data_store.getProxy().extraParams.feature_id = this.feature_id;
	this.data_store.getProxy().extraParams.layer_id = this.layer_id;
	this.data_store.reload();
	
	this.view = null;
}

pt_feature.prototype.show_attributes = function() {
	
	var pt_attributes_window = new Ext.Window({
		title: 'Feature ' + this.feature_id,
		autoScroll: true,
		bodyStyle: 'background:white',
		width: 800,
		height: 600,
		closable: true,
		modal: false,
		id: '__pt_features_window'/*,
		tbar: [{
			xtype: 'button',
			text: 'Add to Favorites',
			icon: '/OpenHorizon/Resources/Graphics/Silk/star.png'
		}]*/
	});

	var features_list = new Ext.widget('featureattributes', {store: this.data_store});				
	Ext.getCmp('__pt_features_window').add(features_list);	
	
	pt_attributes_window.show();

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
function pt_clone_object (source_object) {
  var newObj = (source_object instanceof Array) ? [] : {};
  for (i in source_object) {
    if (i == 'clone') continue;
    if (source_object[i] && typeof source_object[i] == "object") {
      newObj[i] = pt_clone_object(source_object[i]);
    } else newObj[i] = source_object[i];
  } return newObj;
};

function pt_debug(msg) {
	console.log(msg);
}

function pt_toggle_layer(layer_id) 
{
	var current_map = pt_gis.getApplication().__ptarmigan_gis;
	var chk_element = document.getElementById("LAYER_ENABLED_" + layer_id);
	var enabled_value = chk_element.checked;

	console.log(enabled_value);
	console.log(chk_element);
	for(i = 0; i < current_map.layers.length; i++) {
		if(current_map.layers[i].id === layer_id) {
			current_map.layers[i].enabled = enabled_value;			
			current_map.viewport.regenerate();			
			return;
		}
	}		
}

function pt_toggle_raster_layer(layer_id)
{	
	var current_map = pt_gis.getApplication().__ptarmigan_gis;
	var chk_element = document.getElementById("RASTER_ENABLED_" + layer_id);
	var enabled_value = chk_element.checked;
	var raster_layer = null;

	for (i = 0; i < current_map.raster_layers.length; i++) {
		if(current_map.raster_layers[i].attributes.id === layer_id) {
			raster_layer = current_map.raster_layers[i];
		}
	}

	pt_remove_all_raster_layers();

	if (enabled_value) {
		current_map.leaflet_map.addLayer(raster_layer.leaflet_layer);
		raster_layer.leaflet_layer.redraw();
		chk_element.checked = true;
	}
	
}

function pt_remove_all_raster_layers()
{
	var current_map = pt_gis.getApplication().__ptarmigan_gis;

	for(i = 0; i < current_map.raster_layers.length; i++) {
		var chk_element = document.getElementById("RASTER_ENABLED_" + current_map.raster_layers[i].attributes.id);
		chk_element.checked = false;

		current_map.leaflet_map.removeLayer(current_map.raster_layers[i].leaflet_layer);	
	}
}

function pt_layer_zoom_extents(layer_id)
{
	var current_map = pt_gis.getApplication().__ptarmigan_gis;
		
	for(i = 0; i < current_map.layers.length; i++) {
		if(current_map.layers[i].id === layer_id) {
			current_map.layers[i].zoom_extents();		
			return;
		}
	}		
	
}

function pt_search_layer(layer_id) 
{
	this.data_store = Ext.create('pt_gis.store.layer_mappings');	
	this.data_store.getProxy().extraParams.layer_id = layer_id;
	this.data_store.reload();
	this.view = Ext.widget('featuresearch', {store: this.data_store});
	this.view.show();		
}
