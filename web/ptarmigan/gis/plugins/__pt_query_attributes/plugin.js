var __pt_query_attributes = new pt_plugin({
		plugin_name: '__pt_query_attributes',
		
		on_installed: function () {
			pt_debug('Ptarmigan GIS Feature Attributes Plugin (V0.02-EXP) [Installed]');			
		},
		
		on_activate: function () { 
			pt_debug('Ptarmigan GIS Feature Attributes Plugin (V0.02-EXP) [Activated]');
			if(this.view) {
				Ext.getCmp('plugin-box').remove(this.view);
			}
			attrib_container = 	Ext.getCmp('feature-attributes-container');
			//attrib_container.expand();
			Ext.create('widget.uxNotification', {
												position: 't',
												useXAxis: true,
												cls: 'ux-notification-light',
												iconCls: 'ux-notification-icon-information',
												closable: false,
												title: this.text,
												html: 'Click a geographic feature with the left mouse button to show its attributes.',
												slideInDuration: 800,
												slideBackDuration: 1500,
												autoCloseDelay: 6000,
												slideInAnimation: 'bounceOut',
												slideBackAnimation: 'easeIn'
											}).show();
			
			this.take_map_ownership();
			return (true); 
		},
		
		on_deactivate: function () { 
			if(this.view) {
				Ext.getCmp('plugin-box').remove(this.view);
			}
			Ext.getCmp('feature-attributes-container').collapse();			
			this.release_map_ownership();
			return (true); 
		},
		
		on_feature_click: function (event_object, layer_object) {			
			var layer_id = layer_object.id;
			var feature_id =  event_object.target.feature._pt_feature_id;
			
			if(this.view) {
				Ext.getCmp('plugin-box').remove(this.view);
			}					
			
			this.data_store = Ext.create('pt_gis.store.feature_attribute');
			this.data_store.getProxy().extraParams.feature_id = feature_id;
			this.data_store.getProxy().extraParams.layer_id = layer_id;
			this.data_store.reload();
			this.view = Ext.widget('featureattributes', {store: this.data_store});						
			
			Ext.getCmp('plugin-box').add(this.view);					
			Ext.getCmp('feature-attributes-container').expand();							
		},
		selectable: true,
		text: 'Query Attributes'
	}
);

