<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Parcel Map - ptarmigan</title>		
		<cfoutput>
		<cfif url.map_type EQ "osm">
			<link rel="stylesheet" href="#session.root_url#/leaflet/leaflet.css">
			<script src="#session.root_url#/leaflet/leaflet.js"></script>
			<script type="text/javascript" src="#session.root_url#/parcels/gis_leaflet.js"></script>		
			<script type="text/javascript" src="#session.root_url#/parcels/proj4js/lib/proj4js-combined.js"></script>	
		<cfelse>
			<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
			<script type="text/javascript" src="#session.root_url#/parcels/gis.js"></script>
		</cfif>
		<script src="#session.root_url#/ux.js"></script>
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<link rel="stylesheet" type="text/css" href="#session.root_url#/parcels/parcels.css">
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		<script type="text/javascript" src="#session.root_url#/jstree/jquery.jstree.js"></script>
		<script type="text/javascript" src="#session.root_url#/parcels/geo.js"></script>
		<script type="text/javascript" src="#session.root_url#/parcels/latlon.js"></script>
		</cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {   								
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				size_ui();	   		 
				<cfoutput>
				init_map('map', #session.system.center_latitude#, #session.system.center_longitude#);
				</cfoutput>
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
					if (map_visible) {
						$("#map").show();
						$("#content-box").hide();
						$("#map").height($("#map-inner-container").height() - $("#map-search-results").height());
					}
					else {
						$("#map").hide();
						$("#content-box").show();
						$("#content-box").height($("#map-inner-container").height() - $("#map-search-results").height());										
					}
					$("#map_search_results").width($(document).width() - $("#map-sidebar").width() - 1);
					$("#content-box").width($(document).width() - $("#map-sidebar").width() - 1);													
				}
				else {
					$("#map-search-results").hide();
					if (map_visible) {
						$("#map").show();
						$("#content-box").hide();
						$("#map").height($("#map-inner-container").height());
					}
					else {
						$("#map").hide();	
						$("#content-box").show();
						$("#content-box").height($("#map-inner-container").height());	
						$("#content-box").width($(document).width() - $("#map-sidebar").width() - 1);
					}
				} // if (search_results_visible)
			} /* size_ui() */		
		</script>
	</head>
	<body>
		<cfoutput>
		<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
		</cfoutput>
		<div id="map-outer-container">
			<div id="header">
				<cfoutput><img src="#session.root_url#/ptarmigan-full.png" style="margin-top:25px;"></cfoutput>	
				<cfif session.logged_in EQ true>
				<div id="account-info">
					<cfoutput>
					#session.user.full_name()#
					</cfoutput>
				</div>
				</cfif>
			</div>			
			<div id="map-toolbar">
				<div id="map-toolbar-tube">
				
					<cfinclude template="map_search.cfm">
					<cfoutput>
					<button id="view-content" class="middle-button" onclick="switch_views('content');" style="margin-left:5px;"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/page_white.png" style="vertical-align:middle;"> </button>
					<button id="view-map" class="middle-button" onclick="switch_views('map');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map.png" style="vertical-align:middle;"> </button>
				
					<button id="click-research" class="middle-button" style="margin-left:10px;" onclick="click_mode('research');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/information.png" style="vertical-align:middle;"></button>
					<button id="click-documents" class="middle-button" onclick="click_mode('documents');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/page_white_copy.png" style="vertical-align:middle;"></button>
					<button id="click-measure" class="right-button" onclick="click_mode('measure');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/timeline_marker.png" style="vertical-align:middle;"></button>

					<!--- <cfif session.logged_in EQ true>
						<button class="right-button" style="margin-left:10px;"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map_add.png" style="vertical-align:middle;"></button>
					</cfif> --->
					</cfoutput>
					
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
				<div id="content-box" style="display:none;background-color:white;">
				
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