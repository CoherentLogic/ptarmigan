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
    
}


function loading(value)
{
    var loading_div = document.getElementById('loading_div');
    var map_div = document.getElementById(current_control_id);
    var map_width = map_div.offsetWidth;
    var map_height = map_div.offsetHeight;
    var loading_width = 400;
    var loading_height = 300;
    var map_div_left = getPos(map_div).x;
    var loading_left = 0;
    var loading_right = 0;
	
    if(value) {
	loading_div.style.left = (((map_width / 2) - (loading_width / 2)) + map_div_left) + "px";
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
    retrieve_parcels(nw_latitude, nw_longitude, se_latitude, se_longitude);
}


function retrieve_parcels(nw_latitude, nw_longitude, se_latitude, se_longitude)
{
    var url = "/ptarmigan/parcels/json/parcels.cfm?nw_latitude=" + escape(nw_latitude);
    url = url + "&nw_longitude=" + escape(nw_longitude);
    url = url + "&se_latitude=" + escape(se_latitude);
    url = url + "&se_longitude=" + escape(se_longitude);
    url = url + "&suppress_everything";

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
		    open_window(this.parcel_index);
		});

	    overlays.push(polygon);	 
	    overlays[overlays.length - 1].setMap(map);	    	    
	}
	document.getElementById('loader').innerHTML =  current_parcel_count + " PARCELS IN VIEWPORT";
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
    document.getElementById('progress_bar').style.width = value + "%";
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
 
}

function getPos(el) {
    // yay readability
    for (var lx=0, ly=0;
         el != null;
         lx += el.offsetLeft, ly += el.offsetTop, el = el.offsetParent);
    return {x: lx,y: ly};
}



