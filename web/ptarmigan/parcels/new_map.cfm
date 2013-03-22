<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Parcel Map - ptarmigan</title>
		<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
		<cfoutput>
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<link rel="stylesheet" type="text/css" href="#session.root_url#/parcels/parcels.css">
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		<script type="text/javascript" src="#session.root_url#/parcels/gis.js"></script>
		</cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {   								
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				size_ui();	   		 
				init_map('map', 32.3197, -106.7653);
	   		});	   		 	
	   		
	   		$(window).resize(function() {
				size_ui();
			});
			
			function size_ui() {
				$("#map-inner-container").height($(document).height() - $("#header").height() - $("#map-toolbar").height() - $("#map-status-bar").height());		
				$("#map").width($(document).width() - $("#map-sidebar").width() - 1);
				$("#map").height($("#map-inner-container").height());
				
			}
			
		</script>
	</head>
	<body>
		<div id="map-outer-container">
			<div id="header">
				<cfoutput><img src="#session.root_url#/ptarmigan-full.png" style="margin-top:25px;"></cfoutput>	
			</div>			
			<div id="map-toolbar">
				<div id="map-toolbar-tube">
					<input type="text" placeholder="Search" id="map-toolbar-search">
				</div>
			</div>		
		
			<div id="map-inner-container">
				<div id="map-sidebar">
					<span class="map-sidebar-header">Bookmarks</span>					
					
					<ul>
						<li><a href="##">Las Cruces</a></li>
						<li><a href="##">Truth or Consequences</a></li>
					</ul>					
				</div>
				<div id="map">
						map	
				</div>
			</div>
			
		
			<div id="map-status-bar">
				<div id="map-toolbar-tube" style="padding-top:10px;">				
				<span id="loader">
				</span>
				<div id="status-bar-right">
				<span class="status-bar-segment-right" id="current-latitude">Latitude</span>
				<span class="status-bar-segment" id="current-longitude">Longitude</span>
				</div>
			</div>
		
		</div>
	
	</body>
</html>