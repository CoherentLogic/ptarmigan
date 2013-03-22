/*
 * gis.js
 * ptarmigan GIS 
 * 
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */

var current_parcels = "";
var current_parcel_count = 0;
var map = "";
var nw_latitude = 0;
var nw_longitude = 0;
var se_latitude = 0;
var se_longitude = 0;
var overlays = [];
var current_control_id;
var left_click_mode = "info";
var search_results_visible = false;

var got_first_point = false;

var first_lat = 0;
var first_lng = 0;
var second_lat = 0;
var second_lng = 0;

function click_mode(mode)
{
	left_click_mode = mode;
}

function init_map(control_id, center_latitude, center_longitude)
{
    current_control_id = control_id;

    var map_options = {
	center:new google.maps.LatLng(center_latitude, center_longitude),
	zoom: 16,
	minZoom: 15,
	mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(document.getElementById(control_id), map_options);

    google.maps.event.addListener(map, 'idle', redraw);
    google.maps.event.addListener(map, 'mousemove', function(e) {
   		var theLat = LocationFormatter.decimalLatToDMS(e.latLng.lat());
   		var theLng = LocationFormatter.decimalLongToDMS(e.latLng.lng());
   		
   		
   		$("#current-latitude").html(theLat);
   		$("#current-longitude").html(theLng);
	});
	
	google.maps.event.addListener(map, 'click', function(e) {
		
		switch(left_click_mode) {
			case 'info':
				break;
			case 'measure':
				if (got_first_point) {
					second_lat = e.latLng.lat();
					second_lng = e.latLng.lng();
					var azimuth = forward_azimuth(first_lat, first_lng, second_lat, second_lng);
					var dist = distance(first_lat, first_lng, second_lat, second_lng);
					
					var brng = bearing(azimuth_to_angle(azimuth));					
					
					$("#mensuration-results").html('<strong>' + brng + ' ' + dist.toFixed(2) + "'</strong><br>Forward Azimuth: " + azimuth);
	
					
					var mensurationCoords = [
						new google.maps.LatLng(first_lat, first_lng),
					    new google.maps.LatLng(second_lat, second_lng)					   
					];
					var mensurationPLine = new google.maps.Polyline({
					    path: mensurationCoords,
					    strokeColor: "red",
					    strokeOpacity: 1.0,
					    strokeWeight: 2
					});
					
					mensurationPLine.setMap(map);
										
					got_first_point = false;
				}
				else {
					first_lat = e.latLng.lat();
					first_lng = e.latLng.lng();
					got_first_point = true;
				}
				break;
			
		}
		
	});
    
}

function distance(lat1, lon1, lat2, lon2)
{
	var R = 6371; // km
	var dLat = (lat2-lat1).toRad();
	var dLon = (lon2-lon1).toRad();
	var lat1 = lat1.toRad();
	var lat2 = lat2.toRad();
	
	var a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
	var d = R * c;
	
		
	return(d * 3280.84);
}

Number.prototype.between = function(first,last)
{
    return (first < last ? this >= first && this <= last : this >= last && this <= first);
}

function bearing(azimuth)
{
	var quadrant = 0;
	var ns = "";
	var ew = "";
	
	var out_brng = "";
		
	
	if(azimuth.between(0, 89)) {
		quadrant = 1;
		ns = "N";
		ew = "E";
		out_brng = azimuth;
	}
	if(azimuth.between(90, 179)) {
		quadrant = 2;
		ns = "S";
		ew = "E";
		out_brng = 180 - azimuth;
	}
	if(azimuth.between(180, 269)) {
		quadrant = 3;
		ns = "S";
		ew = "W";		
		out_brng = azimuth - 180;
	}
	if(azimuth.between(270, 359)) {
		quadrant = 4;
		ns = "N";
		ew = "W";
		out_brng = 360 - azimuth;
	}
	
	return(LocationFormatter.decimalBearingToDMS(out_brng, ns, ew));
}

function forward_azimuth(lat1, lon1, lat2, lon2)
{
	var dLat = (lat2-lat1).toRad();
	var dLon = (lon2-lon1).toRad();
	var lat1 = lat1.toRad();
	var lat2 = lat2.toRad();
	var y = Math.sin(dLon) * Math.cos(lat2);
	var x = Math.cos(lat1)*Math.sin(lat2) - Math.sin(lat1)*Math.cos(lat2)*Math.cos(dLon);
	var brng = Math.atan2(y, x).toDeg();
		

	return(brng);
}

function azimuth_to_angle(fwd_az)
{
	if (fwd_az > 0) {
		return (fwd_az);
	}
	else {
		return (360 - Math.abs(fwd_az));
	}
}

function map_recenter(latitude, longitude)
{
	var newLatLng = new google.maps.LatLng(latitude, longitude);
	map.setCenter(newLatLng);
	var marker = new google.maps.Marker({	   
        position: newLatLng,
        map: map
    });
}

function loading(value)
{
    if(value) {
	
    }
    else {

    }
} 

function redraw()
{

    update_viewport_parameters();
    retrieve_parcels(nw_latitude, nw_longitude, se_latitude, se_longitude);
}


function retrieve_parcels(nw_latitude, nw_longitude, se_latitude, se_longitude)
{
    var url = "/parcels/json/parcels.cfm?nw_latitude=" + escape(nw_latitude);
    url = url + "&nw_longitude=" + escape(nw_longitude);
    url = url + "&se_latitude=" + escape(se_latitude);
    url = url + "&se_longitude=" + escape(se_longitude);
    
        
    var xml_http;
    xml_http = http_request_object();
        
        
    xml_http.onreadystatechange = function()
    {
	switch(xml_http.readyState) {
	case 4:
	//ready
	current_parcels = eval('(' + xml_http.responseText + ')');
	current_parcel_count = current_parcels.PARCELS.length;
	document.getElementById('loader').innerHTML = "Loaded " + current_parcel_count + " parcels.";

	var i = 0;
	var j = 0;
	var point_count = 0;
	var coords = [];
	var polygon = "";	
	var percent = 0;

	//clear all overlays
	while(overlays[0]) {
	    overlays.pop().setMap(null);
	}
	
	document.getElementById('loader').innerHTML = "Adding parcels to map...";

	loading(false);

	//loop through the parcels array
	for(i = 0; i < current_parcel_count; i++) {

	    percent = Math.round((i * 100) / current_parcel_count);

	    set_progress(percent);
	   
	    point_count = current_parcels.PARCELS[i].POLYGONS.length;
	    
	    coords.length = point_count;

	    for(j = 0; j < point_count; j++) {		
		coords[j] = new google.maps.LatLng(current_parcels.PARCELS[i].POLYGONS[j].LATITUDE, current_parcels.PARCELS[i].POLYGONS[j].LONGITUDE);		
	    }
	    
	    current_parcel = current_parcels[i]
		polygon = new google.maps.Polygon({paths: coords, parcel_index: i, fillColor: 'silver', strokeColor: 'gray', strokeWeight: 1});
	    parcel_id = current_parcels.PARCELS[i].ID;
	    google.maps.event.addListener(polygon, 'mouseover', function () {	    
		    display_info(this.parcel_index);
		});
	    google.maps.event.addListener(polygon, 'click', function () {
		    if (left_click_mode == 'info') {
		    	open_window(this.parcel_index);
		    }
		});

	    overlays.push(polygon);	 
	    overlays[overlays.length - 1].setMap(map);	    	    
	}
	document.getElementById('loader').innerHTML =  current_parcel_count + " parcels in viewport";
	set_progress(0);

	break;
	case 1:
	document.getElementById('loader').innerHTML = "Loading...";
	loading(true);
	//in progress
	break;
	}
    }
    xml_http.open("GET", url, true);
    xml_http.send(null);
}

function set_progress(value)
{
    //document.getElementById('progress_bar').style.width = value + "%";
}

function display_info(parcel_index) 
{
    var p = current_parcels.PARCELS[parcel_index];

    load("PARCEL_ID", p.PARCEL_ID);
    load("current-parcel", "APN " + p.PARCEL_ID);
    load("ACCOUNT_NUMBER", p.ACCOUNT_NUMBER);
    load("RECEPTION_NUMBER", p.RECEPTION_NUMBER);
    load("OWNER_NAME", p.OWNER_NAME);
    load("MAILING_ADDRESS", p.MAILING_ADDRESS + "<br>" + p.MAILING_CITY + " " + p.MAILING_STATE + " " + p.MAILING_ZIP);
    load("PHYSICAL_ADDRESS", p.PHYSICAL_ADDRESS + "<br>" + p.PHYSICAL_CITY + " " + p.PHYSICAL_STATE + " " + p.PHYSICAL_ZIP);
    load("LEGAL_SECTION", p.SECTION + " T" + p.TOWNSHIP + " R" + p.RANGE);
    load("SUBDIVISION", p.SUBDIVISION + " LOT " + p.LOT + " BLOCK " + p.BLOCK);
    load("LAND_VALUE", "$" + p.ASSESSED_LAND_VALUE);
    load("BUILDING_VALUE", "$" + p.ASSESSED_BUILDING_VALUE);
    load("AREA", p.AREA_ACRES);
}

function open_window(parcel_index)
{
    var url = '/parcels/parcel_window.cfm?id=' + escape(current_parcels.PARCELS[parcel_index].ID);

    
    open_dialog(url, "Parcel " + current_parcels.PARCELS[parcel_index].PARCEL_ID, 650, 590);

}

function load(span_id, value)
{
    document.getElementById(span_id).innerHTML = value;
}

function update_viewport_parameters()
{
    var bounds = map.getBounds();    
    var nw = bounds.getNorthEast();
    var se = bounds.getSouthWest();

    nw_latitude = nw.lat();
    nw_longitude = nw.lng();
    se_latitude = se.lat();
    se_longitude = se.lng();
    
    //alert("nw_lat: " + nw_latitude + " nw_lon: " + nw_longitude + " se_lat: " + se_latitude + " se_lon: " + se_longitude);
 
}

function getPos(el) 
{
    // yay readability
    for (var lx=0, ly=0;
         el != null;
         lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
    return {x: lx,y: ly};
}

function set_search_type() 
{
	var search_type = $("#search-type").val();
	var search_div = "#" + search_type;

	hide_search_types();	
	$(search_div).show();
}

function hide_search_types () 
{
	$("#search-geocode").hide();
	$("#search-property-address").hide();
	$("#search-apn").hide();
	$("#search-reception-number").hide();
	$("#search-account-number").hide();
	$("#search-owner-name").hide();
	$("#search-legal-section").hide();
	$("#search-subdivision").hide();
	
}

function map_search ()
{
	search_results_visible = true;
	size_ui();
	
	var url = "/parcels/map_search_results.cfm?search_type=" + escape($("#search-type").val());
	
	switch($("#search-type").val()) {
		case "search-geocode":
			url += "&geocode=" + $("#s-geocode").val();
		break;
		case "search-property-address":
			url += "&property_address=" + $("#s-property-address").val();
		break;
		case "search-apn":
			url += "&apn=" + $("#s-apn").val();
		break;
		case "search-reception-number":
			url += "&reception_number=" + $("#s-reception-number").val();
		break;
		case "search-account-number":
			url += "&account_number=" + $("#s-account-number").val();
		break;
		case "search-owner-name":
			url += "&owner_name=" + $("#s-owner-name").val();
		break;
		case "search-legal-section":
			url += "&section=" + $("#s-section").val(); 
			url += "&township=" + $("#s-township").val();
			url += "&range=" + $("#s-range").val();
		break;
		case "search-subdivision":
			url += "&subdivision=" + $("#s-subdivision").val(); 
			url += "&lot=" + $("#s-lot").val();
			url += "&block=" + $("#s-block").val();
		
		break;
		
	}
	$("#map-search-results").html(request(url));
}

function close_map_search()
{
	search_results_visible = false;
	size_ui();
	
}

// A static class for converting between Decimal and DMS formats for a location
// ported from: http://andrew.hedges.name/experiments/convert_lat_long/
// Decimal Degrees = Degrees + minutes/60 + seconds/3600
// more info on formats here: http://www.maptools.com/UsingLatLon/Formats.html
// use: LocationFormatter.DMSToDecimal( 45, 35, 38, LocationFormatter.SOUTH );
// or:  LocationFormatter.decimalToDMS( -45.59389 );

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


