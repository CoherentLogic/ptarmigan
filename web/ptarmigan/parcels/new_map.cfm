<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Parcel Map - ptarmigan</title>		
		<cfoutput>
		<cfif url.map_type EQ "osm">
			<link rel="stylesheet" href="#session.root_url#/leaflet/leaflet.css">
			<script src="#session.root_url#/leaflet/leaflet.js"></script>
			<script type="text/javascript" src="#session.root_url#/parcels/gis_leaflet.js"></script>
		<cfelse>
			<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
			<script type="text/javascript" src="#session.root_url#/parcels/gis.js"></script>
		</cfif>
		<script src="#session.root_url#/ux.js"></script>
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<link rel="stylesheet" type="text/css" href="#session.root_url#/parcels/parcels.css">
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		
		<script type="text/javascript" src="#session.root_url#/parcels/geo.js"></script>
		<script type="text/javascript" src="#session.root_url#/parcels/latlon.js"></script>
		</cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {   								
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				size_ui();	   		 
				init_map('map', 33.1283, -107.2522);
	   		});	   		 	
	   		
	   		$(window).resize(function() {
				size_ui();
			});
			
			function size_ui() {
				$("#map-inner-container").height($(document).height() - $("#header").height() - $("#map-toolbar").height() - $("#map-status-bar").height());	

				$("#map").width($(document).width() - $("#map-sidebar").width() - 1);
			
				//$("#map").width($(document).width());
				
				if (search_results_visible) {
					
					$("#map-search-results").show();
					$("#map-search-results").height($("#map-inner-container").height() / 3);
					$("#map").height($("#map-inner-container").height() - $("#map-search-results").height());
					$("#map_search_results").width($(document).width() - $("#map-sidebar").width() - 1);			
				}
				else {
					$("#map-search-results").hide();
					$("#map").height($("#map-inner-container").height());
				}
				
			}
			
		</script>
	</head>
	<body>
		<div id="parcel-context-menu" class="context-menu" style="display:none;left:400;top:400;">
		
		</div>
		<div id="map-outer-container">
			<div id="header">
				<cfoutput><img src="#session.root_url#/ptarmigan-full.png" style="margin-top:25px;"></cfoutput>	
			</div>			
			<div id="map-toolbar">
				<div id="map-toolbar-tube">
					<cfinclude template="map_search.cfm">
					<div style="float:right; padding-right:20px;">
					<cfoutput>
					
					<button class="left-button" onclick="click_mode('research');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/information.png" style="vertical-align:middle;"> Research</button>
					<button class="middle-button" onclick="click_mode('documents');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/page_white_copy.png" style="vertical-align:middle;"> Documents</button>
					<button class="right-button" onclick="click_mode('measure');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/timeline_marker.png" style="vertical-align:middle;"> Measure</button>

<!---
					<button class="right-button"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map_add.png" style="vertical-align:middle;"> New Parcel</button>
 --->
					</cfoutput>
					</div>
				</div>
			</div>		
		
			<div id="map-inner-container">
				<div id="map-sidebar">
					<cfinclude template="#session.root_url#/parcels/control_manager.cfm">		
				</div>
				<div id="map-search-results" style="display:none;">
				</div>
				<div id="map">
												
				</div>
			</div>
			
		
			<div id="map-status-bar">
							
				<span id="gis-status" class="status-bar-segment-right">Ready</span>
				<span id="loader" class="status-bar-segment-right">0 parcels in viewport</span>
				<span id="network-status" class="status-bar-segment">Network Idle</span>
				<div id="status-bar-right">
					<span class="status-bar-segment-right" id="current-parcel">No Parcel</span>
					<span class="status-bar-segment-right" id="current-latitude">Latitude</span>
					<span class="status-bar-segment" id="current-longitude">Longitude</span>
				</div>
			</div>
		
		</div>
	
	</body>
</html>