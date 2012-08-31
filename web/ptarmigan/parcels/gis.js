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
var current_center = "";
var current_radius = "";
var overlays = [];
var current_control_id;
var redraw_needed = true;

function init_map(control_id, center_latitude, center_longitude)
{
    current_control_id = control_id;

    var map_options = {
	center:new google.maps.LatLng(center_latitude, center_longitude),
	zoom: 14,
	mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(document.getElementById(control_id), map_options);

    google.maps.event.addListener(map, 'dragend', redraw);
    google.maps.event.addListener(map, 'zoom_changed', redraw);

}


function loading(value)
{
    var loading_div = document.getElementById('loading_div');
    var map_div = document.getElementById(current_control_id);
    var map_width = map_div.offsetWidth;
    var map_height = map_div.offsetHeight;
    var loading_width = 400;
    var loading_height = 300;
    var map_div_left = 442;
    var loading_left = 0;
    var loading_right = 0;

    if(value) {
	loading_div.style.left = (((map_width) / 2) - (loading_width / 2)) + "px";
	loading_div.style.top = (((map_height - 200) / 2) - (loading_height / 2)) + "px";
	loading_div.style.display = "block";
    }
    else {
	loading_div.style.display = "none";

    }

} 

function redraw()
{

    update_viewport_parameters();
    if(redraw_needed) {
	retrieve_parcels(current_center.lat(), current_center.lng(), current_radius);
    }
}


function retrieve_parcels(center_latitude, center_longitude, radius)
{
    var url = "/ptarmigan/parcels/json/parcels.cfm?center_latitude=" + escape(center_latitude);
    url = url + "&center_longitude=" + escape(center_longitude);
    url = url + "&radius=" + escape(radius) + "&suppress_everything";

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
	
	//clear all overlays
	while(overlays[0]) {
	    overlays.pop().setMap(null);
	}
      
	//loop through the parcels array
	for(i = 0; i < current_parcel_count; i++) {
	    point_count = current_parcels.PARCELS[i].POLYGONS.length;
	    
	    coords.length = point_count;

	    for(j = 0; j < point_count; j++) {		
		coords[j] = new google.maps.LatLng(current_parcels.PARCELS[i].POLYGONS[j].LATITUDE, current_parcels.PARCELS[i].POLYGONS[j].LONGITUDE);		
	    }
	    
	    current_parcel = current_parcels[i]
	    polygon = new google.maps.Polygon({paths: coords, parcel_index: i});
	    parcel_id = current_parcels.PARCELS[i].ID;
	    google.maps.event.addListener(polygon, 'mouseover', function () {	    
		    display_info(this.parcel_index);
		});
	    google.maps.event.addListener(polygon, 'click', function () {
		    open_window(this.parcel_index);
		});

	    overlays.push(polygon);	 
	    overlays[overlays.length - 1].setMap(map);	    	    
	}
	loading(false);

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

function display_info(parcel_index) 
{
    var p = current_parcels.PARCELS[parcel_index];

    load("PARCEL_ID", p.PARCEL_ID);
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
    var url = '/ptarmigan/parcels/parcel_window.cfm?id=' + escape(current_parcels.PARCELS[parcel_index].ID) + '&suppress_headers';

    ColdFusion.Window.create('parcel_' + parcel_index, 'Parcel ' + current_parcels.PARCELS[parcel_index].PARCEL_ID,
			     url,
			     {height:530,width:630,modal:false,closable:true,
				     draggable:true,resizable:false,center:true,initshow:true});

}

function load(span_id, value)
{
    document.getElementById(span_id).innerHTML = value;
}

function update_viewport_parameters()
{
    var bounds = map.getBounds();    
    var center = bounds.getCenter();
    var ne = bounds.getNorthEast();

    // r = radius of the earth in statute miles
    var r = 3963.0;  

    // Convert lat or lng from decimal degrees into radians (divide by 57.2958)
    var lat1 = center.lat() / 57.2958; 
    var lon1 = center.lng() / 57.2958;
    var lat2 = ne.lat() / 57.2958;
    var lon2 = ne.lng() / 57.2958;

    // distance = circle radius from center to Northeast corner of bounds
    current_radius = r * Math.acos(Math.sin(lat1) * Math.sin(lat2) + 
			    Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1));

    current_center = center;
}


