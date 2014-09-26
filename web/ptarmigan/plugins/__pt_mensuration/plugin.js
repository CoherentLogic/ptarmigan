var __pt_mensuration = new pt_plugin({
		plugin_name: '__pt_mensuration',
		
		on_installed: function () {
			return(true);
		},

		on_coordinates_received: function (latlng) {
			//this.notify(this.text, 'You have entered ' + (this.coordinates.length + 1) + ' sets of coordinates. Click the marker when you are ready to complete the measurement.');
			return(true);
		},
		
		on_activate: function (options) { 
			var mode = options.mode;
			this.shape_type = options.mode;
			
			switch(mode) {
				case 'polyline':
					this.notify(this.text, 'Click a point to begin drawing a polyline. Click the marker at the end of the polyline when you are ready to measure its length.');					
					break;
				case 'polygon':
					this.notify(this.text, 'Click a point to begin drawing polygon. Click the marker at the last point you entered when you are ready to measure its area.');
					break;			
			}			
			this.take_map_ownership();
			this.request_shape({shape: mode});			
			return (true); 
		},
		
		on_deactivate: function () { 
			this.release_bare_map();
		},
		
		on_shape_complete: function (shape, coordinates) {
			
			var opening_text = '';
			var opening_parens = '';
			var closing_parens = '';
			
			switch(this.shape_type) {
				case 'polyline':
					opening_text = 'LINESTRING';
					opening_parens = '('
					closing_parens = ')';
					break;
				case 'polygon':
					opening_text = 'POLYGON';
					opening_parens = '((';
					closing_parens = '))';
					break;					
			}
			
			var wkt_string = opening_text + opening_parens;
			
			for(i = 0; i < coordinates.length; i++) {
				if(i == (coordinates.length - 1)) {
					if(this.shape_type === 'polyline') {
						str_term = '';
					}
					else {
						str_term = ', ';
					}
				}
				else {
					str_term = ', ';
				}
				wkt_string += coordinates[i].lng + ' ' + coordinates[i].lat + str_term;
			}
			
			if(this.shape_type === 'polygon') { 
				wkt_string += coordinates[0].lng + ' ' + coordinates[0].lat;
			}
			
			wkt_string += closing_parens;
			var url = 'app/data/mensuration.cfm?wkt=' + escape(wkt_string) + '&shape_type=' + escape(this.shape_type);
			var response_meters = request(url);
			
			var resp_data = new Array();
			
			if(this.shape_type === 'polygon') {	// area
			
				var sqft = new _mnsr('SQUARE FEET', response_meters * 10.7639);
				var sqyd = new _mnsr('SQUARE YARDS',  response_meters * 1.19599);
				var sqmi = new _mnsr('SQUARE MILES',  response_meters * 3.86102e-7);
				var sqm = new _mnsr('SQUARE METERS',  response_meters);
				var hect = new _mnsr('HECTARES',  response_meters * 0.0001);
				var dec = new _mnsr('DECARES', response_meters * 0.001);				
				var ares = new _mnsr('ARES',  response_meters * 0.01);
				var acres = new _mnsr('ACRES', response_meters * 0.000247105);			
				
				resp_data.push(acres);
				resp_data.push(ares);
				resp_data.push(dec);
				resp_data.push(hect);
				resp_data.push(sqft);
				resp_data.push(sqm);
				resp_data.push(sqmi);
				resp_data.push(sqyd);
				
				var resp_store = Ext.create('Ext.data.Store', {
					model: 'pt_gis.model.mensuration_result',
					data: resp_data
				});
					
				var t_cls = this;
				var resp_win = Ext.create('Ext.window.Window', {
					title: this.text + ' (Area)',
					width: 300,
					height: 400,
					id: 'mensuration_area_results',
					items: [{
						xtype: 'gridpanel',		
						forceFit: true,	
						store: resp_store,			
						columns: [{
							text: 'Unit',
							dataIndex: 'unit_type'
						}, {
							text: 'Results',
							dataIndex: 'measured_value'
						}]
					}],
					buttons: [{
						text: 'Close',
						scope: this,
						handler: function () {
							Ext.getCmp('mensuration_area_results').close();
							t_cls.release_bare_map();
						}				
					}]
				}).show();
			}
			else { // distance
				var m = new _mnsr('METERS',  response_meters);
				var uf = new _mnsr('US FEET',  response_meters * 3.28084);
				var yd = new _mnsr('YARDS',  response_meters * 1.09361);
				var fu = new _mnsr('FURLONGS',  response_meters * 0.00497096954);
				var fa = new _mnsr('FATHOMS',  response_meters * 0.546806649);
				var ch = new _mnsr('CHAINS',  response_meters * 0.0497096954);
				var lk = new _mnsr('LINKS',  response_meters * 4.9709595959);				
				var hd = new _mnsr('HANDS',  response_meters * 9.84251969);			
				var mi = new _mnsr('MILES',  response_meters * 0.000621371);
				var km = new _mnsr('KILOMETERS',  response_meters * 0.001);
				var rd = new _mnsr('RODS',  response_meters * 0.198838782);
				var sf = new _mnsr('SURVEY FEET',  response_meters * 3.2808334366796);
								
				resp_data.push(ch);
				resp_data.push(fa);
				resp_data.push(fu);
				resp_data.push(hd);
				resp_data.push(km);
				resp_data.push(lk);
				resp_data.push(m);
				resp_data.push(mi);
				resp_data.push(rd);
				resp_data.push(sf);
				resp_data.push(uf);
				resp_data.push(yd);
								
				var resp_store = Ext.create('Ext.data.Store', {
					model: 'pt_gis.model.mensuration_result',
					data: resp_data
				});
							
				var t_cls = this;
				var resp_win = Ext.create('Ext.window.Window', {
					title: this.text + ' (Distance)',
					width: 300,
					height: 400,
					id: 'mensuration_distance_results',
					items: [{
						xtype: 'gridpanel',		
						forceFit: true,	
						store: resp_store,			
						columns: [{
							text: 'Unit',
							dataIndex: 'unit_type'
						}, {
							text: 'Results',
							dataIndex: 'measured_value'
						}]
					}],
					buttons: [{
						text: 'Close',
						scope: this,
						handler: function () {
							Ext.getCmp('mensuration_distance_results').close();
							t_cls.release_bare_map();
						}				
					}]
				}).show();
			} // if (shape_type === ...)
			
		}, // on_shape_complete()
		
		selectable: false,
		text: 'Measurements'
	}
);

function _mnsr (unit, value) {
	this.unit_type = unit;
	this.measured_value = value;
	
	return(this);
}
