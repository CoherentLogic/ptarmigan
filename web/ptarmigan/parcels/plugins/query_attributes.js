var __pt_query_attributes = new pt_plugin({
		plugin_name: 'Query Attributes',
		on_activate: function () { return (true); },
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
	}
);

