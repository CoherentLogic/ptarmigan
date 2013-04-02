/*
 * map_guider.js
 * 
 * provides support for tours
 * 
 */

function start_tour()
{
	guiders.createGuider({
		attachTo: "#map",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "In the map view, you will see the basemap imagery and parcel layer for the current map. The result of clicking on a parcel depends on the <strong>query mode</strong> currently selected.<br><br>Click <strong>Next</strong> to learn about query modes.",
		id: "tour-mapview",
		next: "tour-querymodes",
		overlay: true,
		title: "Map View" 
	}).show();
	
	guiders.createGuider({
		attachTo: "#clickmode-group",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "These are the <strong>query mode</strong> buttons. Only one may be selected at a time, and the selected button determines the result of clicking on a parcel or on the map. From left to right, they are <strong>Research</strong>, <strong>Documents</strong>, and <strong>Measure</strong>.<br><br>Click <strong>Next</strong> to learn about the <strong>Research</strong> mode.",
		id: "tour-querymodes",
		next: "tour-querymodes-research",
		overlay: false,
		position: 6,
		title: "Query Modes" 
	});
	
	guiders.createGuider({
		attachTo: "#click-research",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the button for selecting the <strong>Research</strong> query mode. When this query mode is selected, clicking a parcel will show you ownership, location, valuation, and other information pertinent to the parcel.<br><br>Click <strong>Next</strong> to learn about the <strong>Documents</strong> mode.",
		id: "tour-querymodes-research",
		next: "tour-querymodes-documents",
		overlay: false,
		position: 6,
		title: "Research Query Mode" 
	});
	
	guiders.createGuider({
		attachTo: "#click-documents",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the button for selecting the <strong>Documents</strong> query mode. When this query mode is selected, clicking a parcel will show you a list of documents that have been associated with the parcel. You will then be able to view the documents, add them to your Google Drive, e-mail them to other users, or download them to your computer<br><br>Click <strong>Next</strong> to learn about the <strong>Measure</strong> mode.",
		id: "tour-querymodes-documents",
		next: "tour-querymodes-measure",
		overlay: false,
		position: 6,
		title: "Documents Query Mode" 
	});
	
	guiders.createGuider({
		attachTo: "#click-measure",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the button for selecting the <strong>Measure</strong> query mode. When this query mode is selected, you will be able to click two points in the map view, and learn the bearing, distance, and forward azimuth between those points.<br><br>Click <strong>Next</strong> to learn about the <strong>Query Sidebar</strong>.",
		id: "tour-querymodes-measure",
		next: "tour-sidebar",
		overlay: false,
		position: 6,
		title: "Measure Query Mode" 
	});
	
	guiders.createGuider({
		attachTo: "#map-sidebar",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the <strong>Query Sidebar</strong>. This is where parcel information, lists of documents, and measurements will be displayed.<br><br>Click <strong>Next</strong> to learn about <strong>Search Types</strong>.",
		id: "tour-sidebar",
		next: "tour-search-types",
		overlay: false,
		position: 3,
		title: "Query Sidebar" 
	});
	
	guiders.createGuider({
		attachTo: "#search-type",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the <strong>Search Types</strong> menu. By clicking on the drop-down arrow, you will be presented with a list of the various types of searches you can perform on the GIS data. You can search on property code, address, reception number, account number, owner name, subdivision/lot/block, or section/township/range. Simply select a search type, type your search terms in the text field to the left of the search types drop-down arrow, and click the icon that looks like a magnifying glass.<br><br>Click <strong>Next</strong> to learn about the <strong>Status Bar</strong>.",
		id: "tour-search-types",
		next: "tour-status-bar",
		overlay: false,
		position: 6,
		title: "Search Types" 
	});
	
	guiders.createGuider({
		attachTo: "#map-status-bar",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the <strong>Status Bar</strong>. In it is displayed the overall system status, number of parcels in the current viewport, network status, property code, and current latitude/longitude in degrees/minutes/seconds.<br><br>Click <strong>Next</strong> to learn about the <strong>View</strong> buttons.",
		id: "tour-status-bar",
		next: "tour-view-types",
		overlay: false,
		position: 12,
		title: "Status Bar" 
	});
	
	guiders.createGuider({
		attachTo: "#map-status-bar",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll},
				  {name: "Next"}],
		description: "This is the <strong>Status Bar</strong>. In it is displayed the overall system status, number of parcels in the current viewport, network status, property code, and current latitude/longitude in degrees/minutes/seconds.<br><br>Click <strong>Next</strong> to learn about the <strong>View</strong> buttons.",
		id: "tour-status-bar",
		next: "tour-view-buttons",
		overlay: false,
		position: 12,
		title: "Status Bar" 
	});
	
	guiders.createGuider({
		attachTo: "#view-group",
		buttons: [{name: "Exit Tour", onclick: guiders.hideAll}],
		description: "These are the <strong>View</strong> buttons. They allow you to select the normal map view or a view of the currently-loaded document.<br><br>That's the end of the tour! We hope you enjoy using Ptarmigan GIS.",
		id: "tour-view-buttons",
		next: "tour-view-buttons",
		overlay: false,
		position: 6,
		title: "View Buttons" 
	});

	
}

