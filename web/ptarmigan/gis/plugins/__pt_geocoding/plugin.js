var __pt_geocoding = new pt_plugin({
		plugin_name: '__pt_geocoding',
		
		on_installed: function () { return(true); },
		
		on_activate: function () {
			var gc_search_win = new Ext.Window({
				title: 'Address Search',
				width: 1280,
				height: 420,				
				bodyPadding: 10,
				
				items: [{
					xtype: 'textfield',
					name: 'address',
					id: 'address',
					fieldLabel: 'Address',
					allowBlank: false
				} , {
					xtype: 'gridpanel',
					id: 'gc_results',
					height: 300,
					autoScroll: true,
					listeners: {
						itemclick: {
							fn: function(ctx, record, item, index, e, eOpts) {
								var lat = record.get('latitude');
								var lng = record.get('longitude');
								var coords = new L.LatLng(lat, lng);
								__pt_geocoding.map_object.leaflet_map.panTo(coords);
							}
						}
					},
					columns: [{
						text: 'Name',
						dataIndex: 'name',
						width: 450
					}, {
						text: 'Address Type',
						dataIndex: 'addressType'
					}, {
						text: 'Feature Type',
						dataIndex: 'featureType'
					}, {
						text: 'House Number',
						dataIndex: 'houseNumber'
					}, {
						text: 'Street',
						dataIndex: 'street'						
					}, {
						text: 'City',
						dataIndex: 'city'
					}, {
						text: 'State',
						dataIndex: 'state'
					}, {
						text: 'Postal Code',
						dataIndex: 'zip'
					}, {
						text: 'Country',
						dataIndex: 'country'
					}, {
						text: 'Latitude',
						dataIndex: 'latitude'					
					}, {
						text: 'Longitude',
						dataIndex: 'longitude'
					}]
				}],
				
				buttons: [{
					text: 'Cancel',
					handler: function () {
						this.up('.window').close();
					}
				} , {
					text: 'Search',
					handler: function () {
						var query_string = Ext.getCmp('address').getValue();
						Ext.getCmp('gc_results').reconfigure(__pt_geocoding.geocode(query_string));
					}
				}]
			});
			
			gc_search_win.show();
			
			return(true);
		},
				
		selectable: false,
		text: 'Address Search'
	}
);

__pt_geocoding.geocode = function (query_string) {
	var api_key = this.cloudmade_api_key();
	var cloudmade_url = "http://beta.geocoding.cloudmade.com/v3/" + api_key + "/api/geo.location.search?format=json&source=OSM&enc=UTF-8&limit=10&locale=us&q=" + escape(query_string);
	var intermediate_result = JSON.parse(this.proxy_request(cloudmade_url, "get", "application/json"));
	
	Ext.define('gc_results_model', {
		extend: 'Ext.data.Model',
		fields: ['addressType',
				'city',
				'country',
				'featureType',
				'houseNumber',
				'latitude',
				'longitude',
				'name',
				'state',
				'street',
				'zip']
	});
	
	for(place in intermediate_result.places) {
		intermediate_result.places[place].latitude = intermediate_result.places[place].position.lat;
		intermediate_result.places[place].longitude = intermediate_result.places[place].position.lon;
	}

	var result_store = Ext.create('Ext.data.Store', {
		model: 'gc_results_model',
		data: intermediate_result.places		
	});

	return(result_store);
};