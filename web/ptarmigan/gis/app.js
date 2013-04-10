
Ext.application({
    name: 'pt_gis',
	autoCreateViewport: true,
    appFolder: 'app',
	models: ['layer'],
	stores: ['layers'],
    launch: function() {
        
        /*this.__ptarmigan_session = new pt_session({
        	
        });*/        
        this.__ptarmigan_map = new pt_map({
		   	attach_to: 'map',
			root_url: '',
			cloudmade_api_key: '60fe8cc7e8bb44579699f32a87bc7c2a',
			initial_center_latitude: 32.7881,
			initial_center_longitude: -107.2822,
			initial_zoom_level: 16,
			on_status_changed: function (status) {
				__pt_status_network.update(status.network_status);
				__pt_status_layer.update(status.layer);
				__pt_status_latitude.update(LocationFormatter.decimalLatToDMS(status.latitude));
				__pt_status_longitude.update(LocationFormatter.decimalLatToDMS(status.longitude));
				__pt_status_feature_id.update(status.feature_id);
				__pt_status_feature_count.update(status.feature_count + " Features");
				return(true);
			}       	
		}); /* this.__ptarmigan_map */
		
		this.__ptarmigan_map.install_plugin(__pt_query_attributes);																										   
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


