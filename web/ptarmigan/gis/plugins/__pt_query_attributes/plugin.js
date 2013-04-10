var __pt_query_attributes = new pt_plugin({
		plugin_name: 'Query Attributes',
		
		on_installed: function () {
			
		},
		
		on_activate: function () { 
			return (true); 
		},
		
		on_deactivate: function () { 
			return (true); 
		},
		
		on_feature_click: function (event_object, layer_object) {			
			var layer_id = layer_object.id;
			var feature_id =  event_object.target.feature._pt_feature_id;
			
			var feature_json = this.get_feature_data(layer_id, feature_id);
			
			Ext.create('Ext.data.Store', {
				storeId: 'featureAttributes',
				fields: ['attribute', 'value'],
				data: feature_json,
				proxy: {
					type: 'memory',
					reader: {
						type: 'json'
					}
				}
			})
			
			if(this.grid) {
				Ext.getCmp('plugin-box').remove(this.grid);
			}
			
			this.grid = Ext.create('Ext.grid.Panel', {
				title: 'Feature Attributes',
				width: 400,
				forceFit: true,
				constrain: true,
				store: Ext.data.StoreManager.lookup('featureAttributes'),
				autoScroll: true,
				columns: [
					{ text: 'Attribute', dataIndex: 'attribute'},
					{ text: 'Value', dataIndex: 'value'}
				],				
			});
			
			
			Ext.getCmp('plugin-box').add(this.grid);
			
		
			
		}
	}
);

