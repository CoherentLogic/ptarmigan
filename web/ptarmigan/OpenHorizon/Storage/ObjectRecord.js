/*
 * $Id$
 *
 * Copyright (C) 2011 John Willis
 *
 * This file is part of Prefiniti.
 *
 * Prefiniti is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Prefiniti is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

var current_object = null;

function ObjectInit(Obj)
{
	current_object = new ObjectRecord(Obj);		
	return(true);
}

 
function ObjectRecord(id, on_ready)
{
	this.r_id = id;
	if (on_ready) {
		this.ready_callback = on_ready;
	}
	this.ajax = AjaxGetXMLHTTP();
	this.xml = null;	

	// properties
	this.id = null;
	this.type = null;
	this.name = null;
	this.thumbnail = null;
	this.created = null;
	this.status = null;
	this.parent = null;
	this.ownerpk = null;
	this.sitepk = null;
	this.latitude = null;
	this.longitude = null;
	
	this.asklocation = false;		
	this.haslocation = false;
	
	
	
	this.url = '/OpenHorizon/Storage/ObjectRecord.cfm?sk=' + escape(session_key) + '&orms_id=' + escape(this.r_id);	
	//alert(this.url);
	this.ajax.open("GET", this.url, false);
	this.ajax.send(null);
		
	this.xmldoc = this.ajax.responseXML;
	
	var orms_nodes = this.xmldoc.getElementsByTagName("orms"); 
	var object_count = orms_nodes.length;
	
	var id_node = orms_nodes[0].getElementsByTagName("id");
	var type_node = orms_nodes[0].getElementsByTagName("type");
	var name_node = orms_nodes[0].getElementsByTagName("name");
	var thumbnail_node = orms_nodes[0].getElementsByTagName("thumbnail");
	var created_node = orms_nodes[0].getElementsByTagName("created");
	var status_node = orms_nodes[0].getElementsByTagName("status");
	var parent_node = orms_nodes[0].getElementsByTagName("parent");
	var owner_node = orms_nodes[0].getElementsByTagName("owner-pk");
	var site_node = orms_nodes[0].getElementsByTagName("site-pk");
	var latitude_node = orms_nodes[0].getElementsByTagName("latitude");
	var longitude_node = orms_nodes[0].getElementsByTagName("longitude");
	var longitude_node = orms_nodes[0].getElementsByTagName("longitude");
	var asklocation_node = orms_nodes[0].getElementsByTagName("ask-location");
	var haslocation_node = orms_nodes[0].getElementsByTagName("has-location");
	// properties
	this.id = id_node[0].firstChild.nodeValue;
	this.type = type_node[0].firstChild.nodeValue;
	this.name = name_node[0].firstChild.nodeValue;
	this.thumbnail = thumbnail_node[0].firstChild.nodeValue;
	this.created = created_node[0].firstChild.nodeValue;
	this.status = status_node[0].firstChild.nodeValue;
	this.parent = parent_node[0].firstChild.nodeValue;
	this.ownerpk = owner_node[0].firstChild.nodeValue;
	this.sitepk = site_node[0].firstChild.nodeValue;
	try {
		this.latitude = latitude_node[0].firstChild.nodeValue;
		this.longitude = longitude_node[0].firstChild.nodeValue;
	}
	catch (ex) {
		this.latitude = null;
		this.longitude = null;
	}
	var tmpask = asklocation_node[0].firstChild.nodeValue;	
	
	if (tmpask == 0) {
		this.asklocation = false;
	}
	else {
		this.asklocation = true;
	}
	
	var tmphas = haslocation_node[0].firstChild.nodeValue;	
	
	if (tmphas == 0) {
		this.haslocation = false;
	}
	else {
		this.haslocation = true;
	}

	this.LocationCheck();	

	if (this.ready_callback) {
		this.ready_callback(this);
	}

} 	

ObjectRecord.prototype.IsOwner = function (user_pk) {
	if (this.ownerpk == user_pk) {
		return (true);
	}
	else {
		return (false);
	}
}

ObjectRecord.prototype.LocationCheck = function () {
	if (this.IsOwner(glob_userid)) {
		if(this.asklocation) {
			var url = '/orms/locate_object.cfm?orms_id=' + escape(this.id);
			ORMSDialog(url);	
		}
	}
}

ObjectRecord.prototype.ShowLocation = function () {
	var url = '/orms/locate_object.cfm?orms_id=' + escape(this.id);
	ORMSDialog(url);
}
	 
	 