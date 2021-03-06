var __pt_query_attributes = new pt_plugin({
		plugin_name: '__pt_query_attributes',
		
		on_installed: function () {
			return(true);
		},
		
		on_activate: function (options) { 			
			this.notify(this.text, 'Click a geographic feature with the left mouse button to show its attributes.');			
			this.take_map_ownership();
			return (true); 
		},
		
		on_deactivate: function () { 
			/*if(this.view) {
				Ext.getCmp('plugin-box').remove(this.view);
			}
			Ext.getCmp('feature-attributes-container').collapse();*/			
			this.release_map_ownership();
			return (true); 
		},
		
		on_feature_click: function (event_object, layer_object) {			
			var layer = layer_object.id;
			var feat =  event_object.target.feature._pt_feature_id;
			
			var feature = new pt_feature({
				layer_id: layer,
				feature_id: feat,
			});
			
			feature.show_attributes();
												
		},
		selectable: true,
		text: 'Feature Query'
	}
);