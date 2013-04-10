<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Ptarmigan GIS</title>		
		<cfoutput>		
		<link rel="stylesheet" href="#session.root_url#/leaflet-master/leaflet.css">
		<script src="#session.root_url#/leaflet-master/leaflet-src.js"></script>
		<script type="text/javascript" src="#session.root_url#/gis/gis.js"></script>		
		<script type="text/javascript" src="#session.root_url#/gis/gis_ui.js"></script>		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<link rel="stylesheet" type="text/css" href="#session.root_url#/gis/gis.css">
		<link rel="stylesheet" type="text/css" href="#session.root_url#/guiders/guiders-1.3.0.css">
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		<script type="text/javascript" src="#session.root_url#/guiders/guiders-1.3.0.js"></script>
		<script type="text/javascript" src="#session.root_url#/gis/map_guider.js"></script>
		<script type="text/javascript" src="#session.root_url#/gis/geo.js"></script>
		<script type="text/javascript" src="#session.root_url#/gis/latlon.js"></script>
		<script type="text/javascript" src="#session.root_url#/gis/plugins/__pt_query_attributes/plugin.js"></script>
		</cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {   								
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				size_ui();	   		 
				
				
				$("#view-group").buttonset();
				$("#clickmode-group").buttonset();
				$("#map-search").button();
				$("#help-mode").button();
				$("#toggle-header").button();
				$("#start-tour").button();
				$("#reset-mensuration").button();
				//$("#sidebar-accordion").accordion();
				<cfoutput>
				init_map('map', '#session.root_url#', '#session.system.cloudmade_api_key#', #session.system.center_latitude#, #session.system.center_longitude#, update_status_bar);
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
		<div id="plugin-output" style="display:none;">
		</div>
		<cfoutput>
		<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
		</cfoutput>
		<div id="map-outer-container">
			<div id="header">
				<cfoutput><img src="#session.root_url#/ptarmigan-full.png" style="margin-top:25px;"></cfoutput>	
				<cfif session.logged_in EQ true>
				<div id="account-info">
					<cfoutput>
					#session.user.full_name()#<br>
					
					</cfoutput>
				</div>
				</cfif>
				
			</div>			
			<div id="map-toolbar">
				<div id="map-toolbar-tube">
					
					<div class="button-group" id="layers-group" style="margin-top:2px;">
						<cfinclude template="layers.cfm">
					</div>
					
					<div class="button-group">
					<cfinclude template="map_search.cfm">
					</div>
					<cfoutput>
					
					<div id="view-group" class="button-group">
						<input type="radio" name="view-group" id="view-map" onclick="switch_views('map');" checked="checked"><label title="Show map" for="view-map"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map.png" style="vertical-align:middle;"></label>
						<input type="radio" name="view-group" id="view-content" onclick="switch_views('content');"><label title="Show document" for="view-content"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/page_white.png" style="vertical-align:middle;"></label>

					</div>
					
					<div id="clickmode-group" class="button-group">
						<input type="radio" name="clickmode-group" id="click-research" onclick="click_mode('research');" checked="checked"><label title="Research query mode" for="click-research"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/information.png" style="vertical-align:middle;"></label>
						<input type="radio" name="clickmode-group" id="click-documents" onclick="click_mode('documents');"><label title="Documents query mode" for="click-documents"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/page_white_copy.png" style="vertical-align:middle;"></label>
						<input type="radio" name="clickmode-group" id="click-measure" onclick="click_mode('measure');"><label title="Measure query mode" for="click-measure"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/ruler_2.png" style="vertical-align:middle;"></label>
					</div>
					
					<div class="button-group">
						<input type="checkbox" id="toggle-header" onchange="toggle_header();"><label title="Full-screen mode" for="toggle-header"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/arrow_out.png" style="vertical-align:middle;"></label>						
					</div>
					
					</cfoutput>
					
				</div>
			</div>		
		
			<div id="map-inner-container">
				<div id="map-sidebar" style="background-color:#eeeeee;">
				
					<div id="sidebar-accordion">						
						<div>
							<p>
							<cfinclude template="layer_control.cfm">
							</p>
						</div>
						
						
					</div>
					
					
					
					<cfif IsDefined("url.pt_debug")>
						<cfset debug_visibility = "block">
					<cfelse>
						<cfset debug_visibility = "none">
					</cfif>
					
					<cfoutput>
					<div style="display:#debug_visibility#;">
						<textarea id="pt-debug" rows="10" style="width:100%;"></textarea>
					</div>
					</cfoutput>
					
					<!--- <div class="sidebar-box">
						<p>You can take a guided tour of the Ptarmigan GIS system to familiarize yourself with its use.</p>
						<p>You can click &quot;Exit Tour&quot; at any time to end the tour. </p>
						<div style="float:right;">
							<button id="start-tour" onclick="start_tour();">Start Tour</button>
						</div>
					</div> --->
				</div>
				<div id="map-search-results" style="display:none;">
				</div>
				<div id="map">
												
				</div>
				<div id="content-box" style="display:none;background-color:white;">
				
				</div>
			</div>
			
		
			<div id="map-status-bar">
			 	<!---
			 		this.system_message = "Welcome to Ptarmigan GIS";
	this.network_status = "Network Idle";
	this.network_busy = false;
	this.network_response = null;
	this.layer = "No Layer";
	this.latitude = "--";
	this.longitude = "--";
	this.parcel_id = "No Parcel";
	this.parcel_count = 0;
	this.bounding_rectangle = null;
}
			 	--->
				<span id="system_message" class="status-bar-segment-right" title="System message"></span>
				<span id="network_status" class="status-bar-segment-right" title="Network status"></span>
				<span id="layer" class="status-bar-segment-right" title="Current layer"></span>
				<span id="parcel_count" class="status-bar-segment-right" title="Parcel count"></span>				
				<span class="status-bar-segment-right" id="parcel_id" title="Current parcel">No Parcel</span>
				<span class="status-bar-segment-right" id="latitude" title="Current latitude">Latitude</span>
				<span class="status-bar-segment" id="longitude" title="Current longitude">Longitude</span>
				
			</div>
		
		</div>
	
	</body>
</html>