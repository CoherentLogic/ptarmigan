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
					<div style="float:right; padding-right:20px;">
					<cfoutput>
					<button class="left-button"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/information.png" style="vertical-align:middle;"> Info</button>
					<button class="middle-button"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/timeline_marker.png" style="vertical-align:middle;"> Measure</button>
					<button class="middle-button"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/star.png" style="vertical-align:middle;"> Bookmark</button>
<!--- 
					<button class="right-button"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map_add.png" style="vertical-align:middle;"> New Parcel</button>
 --->
					</cfoutput>
					</div>
				</div>
			</div>		
		
			<div id="map-inner-container">
				<div id="map-sidebar">
					<span class="map-sidebar-header">Bookmarks</span>					
					
					<ul>
						<li><a href="##">Las Cruces</a></li>
						<li><a href="##">Truth or Consequences</a></li>
					</ul>					
					
					<span class="map-sidebar-header">Current Parcel</span>
					
					<table>
					<tr>
						<td>APN:</td>
						<td><span id="PARCEL_ID"></span></td>
					</tr>
					<tr>
						<td>Account Number:</td>
						<td><span id="ACCOUNT_NUMBER"></span></td>
					</tr>
					<tr>
						<td>Reception Number:</td>
						<td><span id="RECEPTION_NUMBER"></span></td>
					</tr>
					<tr>
						<td>Owner Name:</td>
						<td><span id="OWNER_NAME"></span></td>
					</tr>
					<tr>
						<td>Mailing Address:</td>
						<td><span id="MAILING_ADDRESS"></span></td>
					</tr>
					<tr>
						<td>Physical Address:</td>
						<td><span id="PHYSICAL_ADDRESS"></span></td>
					</tr>
					<tr>
						<td>Legal Section:</td>
						<td><span id="LEGAL_SECTION"></span></td>
					</tr>
					<tr>
						<td>Subdivision:</td>
						<td><span id="SUBDIVISION"></span></td>
					</tr>
					<tr>
						<td>Land Value:</td>
						<td><span id="LAND_VALUE"></span></td>
					</tr>
					<tr>
						<td>Building Value:</td>
						<td><span id="BUILDING_VALUE"></span></td>
					</tr>
					<tr>
						<td>Area:</td>
						<td><span id="AREA"></span></td>
					</tr>
					<tr>
						<td>Ground Survey:</td>
						<td><span id="GROUND_SURVEY"></span></td>
					</tr>
					</table>
				</div>
				<div id="map">
						map	
				</div>
			</div>
			
		
			<div id="map-status-bar">
							
				<span id="status" class="status-bar-segment-right">Ready</span>
				<span id="loader" class="status-bar-segment"></span>
				<div id="status-bar-right">
					<span class="status-bar-segment-right" id="current-parcel">No Parcel</span>
					<span class="status-bar-segment-right" id="current-latitude">Latitude</span>
					<span class="status-bar-segment" id="current-longitude">Longitude</span>
				</div>
			</div>
		
		</div>
	
	</body>
</html>