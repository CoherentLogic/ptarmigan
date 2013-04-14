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
			var cloudmade_url = 'http://{s}.tile.cloudmade.com/' + sess.system.cloudmade_api_key + '/1155/256/{z}/{x}/{y}.png';
			var base_layer_osm = L.tileLayer(cloudmade_url, {attribution:'Map data &copy; OpenStreetMap contributors'});
			var base_layer_osm_overview = L.tileLayer(cloudmade_url, {attribution:''});
        	
        	this.__results_map = L.map('search_results_map', {
				center: new L.LatLng(sess.system.center_latitude, sess.system.center_longitude),
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
		        	
        	
        	console.log("afterrender store %o", this.store);
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
				defaultType: 'textField',
				items: [{
					xtype: 'displayfield',
					renderer: function (){
						console.log("Renderer on map div");
						return ('<div id="search_results_map" style="width:245px;height:180px;"></div>');
					}
					
				}]
			}],
			buttons: [{
                text: 'Open',
                action: 'open',
                handler: function () {
                	
                }
            }, {
                text: 'Close',
                scope: this,
                handler: this.close
            }]      			
		});
		console.log("Items created");
		//document.getElementById("search_results_map").innerHTML("BOOTS");
		
		this.callParent();
	}
});
