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
var left_click_mode = "research";

var active_layer = "";

var search_results_visible = false;
var map_visible = true;

var tile_layer = null;

var got_first_point = false;

var first_lat = 0;
var first_lng = 0;
var second_lat = 0;
var second_lng = 0;

var highlight_color = "#7daed4";
var alert_color = "red";

var control_manager = null;

var polylines = [];
var polyline_count = 0;

var markers = [];
var marker_count = 0;

var default_viewport = "";

function update_status_bar(status) {
	/*
	 * this.system_message = "Welcome to Ptarmigan GIS";
	this.network_status = "Network Idle";
	this.network_busy = false;
	this.network_response = null;
	this.layer = "No Layer";
	this.latitude = "--";
	this.longitude = "--";
	this.parcel_id = "No Parcel";
	this.parcel_count = 0;
	this.bounding_rectangle = null;
	 */
	
	$("#system_message").html(status.system_message);
	$("#network_status").html(status.network_status);
	$("#layer").html(status.layer);
	$("#latitude").html(LocationFormatter.decimalLatToDMS(status.latitude));
	$("#longitude").html(LocationFormatter.decimalLatToDMS(status.longitude));
	$("#parcel_id").html(status.feature_id);
	$("#parcel_count").html(status.feature_count + " Features");
	$("#layer").html(status.layer);
	
	if (status.system_busy) {
		$('#map').css('cursor', 'progress');	
	}
	else {		
		$('#map').css('cursor', 'default');
	}
}

function inline_doc_view(document_id) 
{
	var url = '/parcels/plugins/Documents/view.cfm?id=' + escape(document_id);
	$("#view-content").click();
	switch_views('content');
	$("#content-box").html(request(url));
}

function switch_views(view_name)
{
	switch(view_name) {
		case 'map':
			map_visible = true;
			break;
		case 'content':
			map_visible = false;
			break;
	}
	
	size_ui();
}

function toggle_header() 
{
	var chkState = $("#toggle-header").is(":checked");
	
	if (chkState) {
		$("#header").css("height", "0px");
		$("#header").hide();
	}
	else {
		$("#header").css("height", "100px");
		$("#header").show();
	}
	size_ui();
}


function click_mode(mode)
{
	hide_all_plugins();
	left_click_mode = mode;
	
	switch_views('map');
	
	switch (mode) {
		case 'research':
			$("#plugin-1").show();
			break;
		case 'measure':
			$("#plugin-2").show();
			break;
		case 'documents':
			$("#plugin-3").show();
			break;
	}
}

function hide_all_plugins()
{
	$("#plugin-1").hide();
	$("#plugin-2").hide();
	$("#plugin-3").hide();	
}

var default_map = "";


function init_map(control_id, root_url, cloudmade_api_key, center_latitude, center_longitude, status_changed_callback) 
{
	default_map = new pt_map({attach_to: control_id,
							root_url: root_url,
							cloudmade_api_key: cloudmade_api_key,
							initial_center_latitude: center_latitude,
							initial_center_longitude: center_longitude,
							initial_zoom_level: 16,
							on_status_changed: status_changed_callback});
							
	default_map.install_plugin(__pt_query_attributes);
}

function zyzzyx(control_id, center_latitude, center_longitude)
{
	default_viewport = new pt_viewport()

    current_control_id = control_id;



    
  	var cloudmadeUrl = 'http://b.tile.cloudmade.com/60fe8cc7e8bb44579699f32a87bc7c2a/1155/256/{z}/{x}/{y}.png';
	var basemap_cm = L.tileLayer(cloudmadeUrl, {attribution:'Map data &copy; OpenStreetMap contributors'});
	
	//var cldUrl = 'http://osm.coherent-logic.com/osm/{z}/{x}/{y}.png';
	//var basemap_cld = L.tileLayer(cldUrl, {attribution:'Map data &copy; OpenStreetMap contributors'});
	
	var mqAerialUrl = 'http://otile1.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.jpg';
	var aerial = L.tileLayer(mqAerialUrl, {attribution:'Portions Courtesy NASA/JPL-Caltech and U.S. Depart. of Agriculture, Farm Service Agency'});
	
	
	basemap_cm.on('load', redraw);
	//basemap_cld.on('load', redraw);	
	aerial.on('load', redraw);
	
	
	map = L.map(control_id, {
		center: new L.LatLng(center_latitude, center_longitude),
		zoom: 16,
		layers: [aerial, basemap_cm]
	});
	
	var baseMaps = {
		"Aerial Imagery": aerial,		
		"Basemap": basemap_cm							
	};
	
	L.control.layers(baseMaps).addTo(map);	



	map.on('viewreset', redraw);

	map.on('mousemove', function(e) {
   		var theLat = LocationFormatter.decimalLatToDMS(e.latlng.lat);
   		var theLng = LocationFormatter.decimalLongToDMS(e.latlng.lng);
   		
   		
   		$("#current-latitude").html(theLat);
   		$("#current-longitude").html(theLng);
   		
   		if(left_click_mode == 'measure') {
   			
   			if (got_first_point) {
	   			for(i in polylines) {
					map.removeLayer(polylines[i]);
				}
				polyline_count = 0;
				
				var mCoords = [
					new L.LatLng(first_lat, first_lng),
					new L.LatLng(e.latlng.lat, e.latlng.lng)
				];
				
				polyline_count++;
				polylines[polyline_count] = new L.Polyline(mCoords);
				polylines[polyline_count].addTo(map);
			}
   		}
	});
	
	map.on('click', function(e) {
		
		switch(left_click_mode) {
			case 'research':
				break;
			case 'measure':
				if (got_first_point) {
					second_lat = e.latlng.lat;
					second_lng = e.latlng.lng;
					var azimuth = forward_azimuth(first_lat, first_lng, second_lat, second_lng);
					var dist = distance(first_lat, first_lng, second_lat, second_lng);
					
					var brng = bearing(azimuth_to_angle(azimuth));					
					
					
					var res = '<h3>' + brng + ' ' + dist.toFixed(2) + "'</h3>";
					res += '<p>Forward azimuth ' + azimuth.toFixed(6) + '</p>'; 
								
					var text_path = brng + ' ' + dist.toFixed(2) + "'";
							
					$("#mensuration-results").html(res);
					
					var mensurationCoords = [
						new L.LatLng(first_lat, first_lng),
					    new L.LatLng(second_lat, second_lng)								   		  
					];
					
					polyline_count++;
					polylines[polyline_count] = new L.Polyline(mensurationCoords);
					try {
					polylines[polyline_count].setText(text_path, {repeat: false, fillColor: 'blue'});
					}
					catch (ex) {
						//do nothing
					}					
					polylines[polyline_count].addTo(map);
										
					got_first_point = false;
				}
				else {
					reset_mensuration();
					first_lat = e.latlng.lat;
					first_lng = e.latlng.lng;
					var res = '<p>Measuring from ' + LocationFormatter.decimalLatToDMS(first_lat) + ', ' + LocationFormatter.decimalLatToDMS(first_lng) + '...</p>';
					res += '<p>Please click a second point in order to complete this measurement.</p>';
					
					$("#mensuration-results").html(res);
					
					got_first_point = true;
				}
				break;
			
		}
		
	});
    
    $("#gis-status").html('OSM GIS support loaded');
}

function reset_mensuration ()
{
	for(i in polylines) {
		map.removeLayer(polylines[i]);
	}
	
	polyline_count = 0;
	
	$("#mensuration-results").html('<p>Click on two map points to measure the bearing and distance between them.</p>');
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
	default_map.leaflet_map.setView([latitude, longitude], 18);	
	var marker = new L.marker([latitude, longitude]).addTo(default_map.leaflet_map);
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

function network_status(status)
{
	$("#network-status").html(status);
}


var request_active = false;
//var xml_http = false;

function retrieve_parcels(nw_latitude, nw_longitude, se_latitude, se_longitude)
{
    var url = "/parcels/json/parcels.cfm?nw_latitude=" + escape(nw_latitude);
    url = url + "&nw_longitude=" + escape(nw_longitude);
    url = url + "&se_latitude=" + escape(se_latitude);
    url = url + "&se_longitude=" + escape(se_longitude);
        
    
    if(xml_http) {
    	if (request_active) {
    		xml_http.abort();
    		network_status('Aborted');
    	}
    }
        
    request_active = true;
    
    xml_http = http_request_object();
        
        
    xml_http.onreadystatechange = function()
    {
	switch(xml_http.readyState) {
	case 4:
	
	if(xml_http.status == 200) {
		network_status("Request Completed");
		request_active = false;
	}
	else {
		network_status('<span style="color:red">Network Error (' + xml_http.status +  ')</span>');
		request_active = false;
	}
	
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
 	var parcel_color = "";
 	
	//clear all overlays
	while(overlays[0]) {
	    map.removeLayer(overlays.pop());
	}
	
	document.getElementById('loader').innerHTML = "Adding parcels to map...";

	loading(false);

	//loop through the parcels array
	for(i = 0; i < current_parcel_count; i++) {

	    percent = Math.round((i * 100) / current_parcel_count);

	    set_progress(percent);
	   
	    point_count = current_parcels.PARCELS[i].POLYGONS.length;
	    
	    coords = new Array();
	    coords.length = point_count;
		
	    for(j = 0; j < point_count; j++) {		
			coords[j] = new L.LatLng(current_parcels.PARCELS[i].POLYGONS[j].LATITUDE, current_parcels.PARCELS[i].POLYGONS[j].LONGITUDE);		
	    }
	    
	    current_parcel = current_parcels[i];
		polygon = new L.Polygon(coords);		
	    polygon.parcel_id = current_parcels.PARCELS[i].ID;
	    polygon.parcel_index = i;
	    
	    if (current_parcels.PARCELS[i].ALERTS == 0)  {
	    	parcel_color = "#2262CC";
	    }
	    else {
	    	parcel_color = alert_color;
	    }
	    
	    polygon.setStyle({
            color: parcel_color,
            weight: 1,
            opacity: 0.6,
            fillOpacity: 0.1,
            fillColor: current_parcels.PARCELS[i].FILL_COLOR
        });
	    	   
	    
	    polygon.on('mouseover',  function (e) {	 
	    	e.target.setStyle({fillColor:highlight_color, color:"green", fillOpacity: 0.9});
		    display_info(e.target.parcel_index);
		});
		
		polygon.on('mouseout', function (e) {		
			if (current_parcels.PARCELS[e.target.parcel_index].ALERTS == 0)  {
		    	parcel_color = "#2262CC";
		    }
		    else {
		    	parcel_color = alert_color;
		    }	
			e.target.setStyle({fillColor:current_parcels.PARCELS[e.target.parcel_index].FILL_COLOR, color:parcel_color, fillOpacity: 0.1});
		});
		
	    
	    polygon.on('click', function (e) {
		    if (left_click_mode == 'research') {
		    	var url = '/parcels/plugins/ParcelQuery/result.cfm?parcel_id=' + escape(e.target.parcel_id);
		    	$('#research-results').html(request(url));
		    	$('.tree').jstree({
		    		"themes" : {
		    			"theme" : "apple",
		    			"dots" : false,
		    			"icons" : false
		    		},
		    		"plugins" : [ "themes", "html_data" ]});
		    }
		    if (left_click_mode == 'documents') {
		    	var url = '/parcels/plugins/Documents/result.cfm?parcel_id=' + escape(e.target.parcel_id);
		    	$('#documents-results').html(request(url));
		    	$('.tree').jstree({
		    		"themes" : {
		    			"theme" : "apple",
		    			"dots" : false,
		    			"icons" : false
		    		},
		    		"plugins" : [ "themes", "html_data" ]});
		    }
		});

	    overlays.push(polygon);	 
	    overlays[overlays.length - 1].addTo(map);
	       	    
	}
	$("#loader").html(current_parcel_count + " parcels in viewport");
	set_progress(0);

	break;
	case 1:
	request_active = true;
	network_status('Connection Established');
	$("#loader").html("Loading...");
	loading(true);
	//in progress
	break;
	case 3:
	request_active = true;
	network_status('Processing Request');
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

    load("current-parcel", "UPC " + p.PARCEL_ID);
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

    nw_latitude = nw.lat;
    nw_longitude = nw.lng;
    se_latitude = se.lat;
    se_longitude = se.lng;
    
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

