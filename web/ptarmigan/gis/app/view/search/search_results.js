Ext.define('pt_gis.view.search.search_results', {
	extend: 'Ext.window.Window',
	alias: 'widget.featuresearchresults',
	title: 'Search Results',
	bodyPadding: 5,
	layout: 'column',
	
	initComponent: function() {			
        	
		Ext.apply(this, {
			width: 950,		
			fieldDefaults: {
				labelAlign: 'left',
				labelWidth: 90,
				anchor: '100%',
				msgTarget: 'side'
			},			
			items: [{
				columnWidth: 0.7,
				xtype: 'gridpanel',
				id: 'search-results-grid',				
				height: 400,
				forceFit: true,
				store: this.store,
				columns: [{
					text: 'Feature ID',
					dataIndex: 'feature_id',
					flex: 0								
				}, {
					text: 'Latitude',
					dataIndex: 'center_latitude',
					renderer: function (value) {
						return LocationFormatter.decimalLatToDMS(value);
					}		
				}, {
					text: 'Longitude',
					dataIndex: 'center_longitude',
					renderer: function (value) {
						return LocationFormatter.decimalLongToDMS(value);
					}
				}]
			}, {
				columnWidth: 0.3,
				margin: '0 0 0 10',
				xtype: 'fieldset',
				title: 'Map',
				layout: 'anchor',
				defaultType: 'textField'/*,
				items: [{
					
				}]*/
			}],
			buttons: [{
                text: 'Search',
                action: 'search',
                handler: function () {
                	
                }
            }, {
                text: 'Close',
                scope: this,
                handler: this.close
            }]      			
		});
		
		this.callParent();
	}
});
