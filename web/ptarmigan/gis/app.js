Ext.Loader.setConfig({
			enabled: true
		});

Ext.application({
    name: 'pt_gis',
	autoCreateViewport: true,
    appFolder: 'app',
	models: ['session', 'layer', 'raster_layer', 'pt_plugin', 'feature_attribute', 'layer_mapping', 'search_result', 'mensuration_result'],
	stores: ['session', 'layers', 'raster_layers', 'pt_plugins', 'feature_attribute', 'layer_mappings'],
	controllers: ['session', 'layers', 'features'],
    launch: function() { 		
    	this.__ptarmigan_session = new pt_session();
    	
    	if(this.__ptarmigan_session.s.system.anonymous_only != 'true') {
    		this.__ptarmigan_session.login();
    	}
		    	    	    	             
        this.__ptarmigan_gis = new pt_map({
		   	attach_to: 'map',
			root_url: '',
			cloudmade_api_key: this.__ptarmigan_session.s.system.cloudmade_api_key,
			initial_center_latitude: this.__ptarmigan_session.s.system.center_latitude,
			initial_center_longitude: this.__ptarmigan_session.s.system.center_longitude,
			initial_zoom_level: this.__ptarmigan_session.s.system.initial_zoom_level,
			minimum_zoom_level: this.__ptarmigan_session.s.system.minimum_zoom_level,
			maximum_zoom_level: this.__ptarmigan_session.s.system.maximum_zoom_level,			
			on_status_changed: function (status) {
			
			
				/*if(status.system_busy | status.network_busy) {
					document.body.style.cursor = 'progress';
				}
				else {
					document.body.style.cursor = 'default';
				}*/
			
				__pt_status_network.update(status.network_status);
				__pt_status_layer.update(status.layer);
				__pt_status_latitude.update("Latitude: " + LocationFormatter.decimalLatToDMS(status.latitude));
				__pt_status_longitude.update("Longitude: " + LocationFormatter.decimalLongToDMS(status.longitude));
				__pt_status_feature_id.update(status.feature_id);
				__pt_status_feature_count.update(status.feature_count + " Features");
				return(true);
			}       	
		}); /* this.__ptarmigan_map */																														   
    } /* launch() */
});

function LocationFormatter(){
};

LocationFormatter.NORTH = 'N';
LocationFormatter.SOUTH = 'S';
LocationFormatter.EAST = 'E';
LocationFormatter.WEST = 'W';

LocationFormatter.roundToDecimal = function( inputNum, numPoints ) {
 var multiplier = Math.pow( 10, numPoints );
 return Math.round( inputNum * multiplier ) / multiplier;
};

LocationFormatter.decimalToDMS = function( location, hemisphere ){
 if( location < 0 ) location *= -1; // strip dash '-'
 
 var degrees = Math.floor( location );          // strip decimal remainer for degrees
 var minutesFromRemainder = ( location - degrees ) * 60;       // multiply the remainer by 60
 var minutes = Math.floor( minutesFromRemainder );       // get minutes from integer
 var secondsFromRemainder = ( minutesFromRemainder - minutes ) * 60;   // multiply the remainer by 60
 var seconds = LocationFormatter.roundToDecimal( secondsFromRemainder, 2 ); // get minutes by rounding to integer

 return degrees + '° ' + minutes + "' " + seconds + '" ' + hemisphere;
};

LocationFormatter.decimalBearingToDMS = function( location, northsouth, eastwest ){
 if( location < 0 ) location *= -1; // strip dash '-'
 
 var degrees = Math.floor( location );          // strip decimal remainer for degrees
 var minutesFromRemainder = ( location - degrees ) * 60;       // multiply the remainer by 60
 var minutes = Math.floor( minutesFromRemainder );       // get minutes from integer
 var secondsFromRemainder = ( minutesFromRemainder - minutes ) * 60;   // multiply the remainer by 60
 var seconds = LocationFormatter.roundToDecimal( secondsFromRemainder, 2 ); // get minutes by rounding to integer

 return northsouth + " " + degrees + '° ' + minutes + "' " + seconds + '" ' + eastwest;
};

LocationFormatter.decimalLatToDMS = function( location ){
 var hemisphere = ( location < 0 ) ? LocationFormatter.SOUTH : LocationFormatter.NORTH; // south if negative
 return LocationFormatter.decimalToDMS( location, hemisphere );
};

LocationFormatter.decimalLongToDMS = function( location ){
 var hemisphere = ( location < 0 ) ? LocationFormatter.WEST : LocationFormatter.EAST;  // west if negative
 return LocationFormatter.decimalToDMS( location, hemisphere );
};

LocationFormatter.DMSToDecimal = function( degrees, minutes, seconds, hemisphere ){
 var ddVal = degrees + minutes / 60 + seconds / 3600;
 ddVal = ( hemisphere == LocationFormatter.SOUTH || hemisphere == LocationFormatter.WEST ) ? ddVal * -1 : ddVal;
 return LocationFormatter.roundToDecimal( ddVal, 5 );  
};


