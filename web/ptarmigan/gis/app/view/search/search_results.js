Ext.define('pt_gis.view.search.search_results', {
	extend: 'Ext.window.Window',
	alias: 'widget.featuresearchresults',
	title: 'Search Results',
	bodyPadding: 5,
	layout: 'column',
	
	initComponent: function() {			
   	
        this.on('afterrender', function () {
        	var sess = pt_gis.getApplication().__ptarmigan_session;
        	
        	// set up OSM layer
			var cloudmade_url = 'http://{s}.tile.cloudmade.com/' + sess.s.system.cloudmade_api_key + '/1155/256/{z}/{x}/{y}.png';
			var base_layer_osm = L.tileLayer(cloudmade_url, {attribution:'Map data &copy; OpenStreetMap contributors'});
			var base_layer_osm_overview = L.tileLayer(cloudmade_url, {attribution:''});
        	        
        	this.__results_map = L.map('search_results_map', {
				center: new L.LatLng(sess.s.system.center_latitude, sess.s.system.center_longitude),
				zoom: 10,
				layers: [base_layer_osm],
				zoomControl: true,
				attributionControl: false
			});
				
			var map_accessor = this.__results_map;		
			
			this.store.each(function(r) {
				var coords = new L.LatLng(r.get('center_latitude'), r.get('center_longitude'));
				var marker = new L.Marker(coords);
				marker.addTo(map_accessor);
			});
			
			sess.most_recent_search = this.store;
					        	        	        	
        }, this);
        
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
				listeners: {
					itemclick: {
						fn: function(ctx, record, item, index, e, eOpts) {
							var lat = record.get('center_latitude');
							var lng = record.get('center_longitude');
							var coords = new L.LatLng(lat, lng);
							var parent_window = ctx.findParentByType('featuresearchresults');
							parent_window.__results_map.panTo(coords);
							console.log("record: %o, parent_window: %o", record, parent_window);
						}
					}
				},
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
				}, {
					text: 'Layer ID',
					dataIndex: 'layer_id',
					hidden: true
				}]
			}, {
				columnWidth: 0.3,
				margin: '0 0 0 10',
				xtype: 'fieldset',
				title: 'Map',
				layout: 'anchor',
				defaultType: 'textField',
				items: [{
					xtype: 'displayfield',
					renderer: function (){						
						return ('<div id="search_results_map" style="width:245px;height:180px;"></div>');
					}
					
				}]
			}],
			buttons: [{
                text: 'Send to Map',
                action: 'open',
                scope: this,
                handler: function () {
                	var sess = pt_gis.getApplication().__ptarmigan_session;
                	var store = sess.most_recent_search;
                	var main_map = pt_gis.getApplication().__ptarmigan_gis.leaflet_map;
                	
                	store.each(function (r) {
                		var coords = new L.LatLng(r.get('center_latitude'), r.get('center_longitude'));
						var marker = new L.Marker(coords);
						marker.addTo(main_map);	
                	});
                	
                	var search_res_grid = Ext.create('Ext.grid.Panel', {
                		title: 'Search Results',
                		store: store,
                		forceFit: true,
                		collapsible: true,                		
                		columns:[{
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
						}, {
							text: 'Layer ID',
							dataIndex: 'layer_id',
							hidden: true
						}]
                	});
                	
                	search_res_grid.on('itemclick', function(ctx, record, item, index, e, eOpts) {
                		var lyr = record.get('layer_id');
                		var feat = record.get('feature_id');
                		var lat = record.get('center_latitude');
                		var lng = record.get('center_longitude');
                		var coords = new L.LatLng(lat, lng);
                		
                		var feature = new pt_feature({
                			layer_id: lyr,
                			feature_id: feat
                		}).show_attributes();
                		
                		pt_gis.getApplication().__ptarmigan_gis.leaflet_map.panTo(coords);
                	});
                	
                	Ext.getCmp('latest-search').add(search_res_grid);	
                	
                	this.close();
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
