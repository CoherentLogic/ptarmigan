<cfmodule template="#session.root_url#/security/require.cfm" type="">
<!DOCTYPE html>
<html lang="en">
<head>	
	<cfoutput>	
		<title>New Parcel - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		<script src="#session.root_url#/parcels/parcels.js" type="text/javascript"></script>
		<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   											
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">		
				define_parcel();										
				$('#tabs-min').bind('tabsshow', function(event, ui) {
				    if (ui.panel.id == "geodetic") {
				        resizeMap();
				    }
				});
   		 });
	</script>
</head>
<body>
	<cfif isdefined("form.submit")>
		<cfset data_valid = true>
		
		<cfif data_valid EQ true>
			<cfset p = CreateObject("component", "ptarmigan.parcel")>
	
			<cfset p.parcel_id = form.parcel_id>
			<cfset p.area_sq_ft = form.area_sq_ft>
			<cfset p.area_sq_yd = form.area_sq_yd>
			<cfset p.area_acres = form.area_acres>
			<cfset p.owner_name = form.owner_name>
			<cfset p.account_number = form.account_number>
			<cfset p.mailing_address = form.mailing_address>
			<cfset p.mailing_city = form.mailing_city>
			<cfset p.mailing_state = form.mailing_state>
			<cfset p.mailing_zip = form.mailing_zip>
			<cfset p.physical_address = form.physical_address>
			<cfset p.physical_city = form.physical_city>
			<cfset p.physical_state = form.physical_state>
			<cfset p.physical_zip = form.physical_zip>
			<cfset p.subdivision = form.subdivision>
			<cfset p.lot = form.lot>
			<cfset p.block = form.block>
			<cfset p.assessed_land_value = form.assessed_land_value>
			<cfset p.assessed_building_value = form.assessed_building_value>
			<cfset p.section = form.section>
			<cfset p.township = form.township & form.township_direction>
			<cfset p.range = form.range & form.range_direction>
			<cfset p.reception_number = form.reception_number>
			<cfset p.ground_survey = form.ground_survey>
			<cfset p.metes_and_bounds = form.metes_and_bounds>
			<cfset p.center_latitude = form.center_latitude>
			<cfset p.center_longitude = form.center_longitude>
			
			<cfset p.create()>
			
			<cfset points_array = ListToArray(form.points)>
			
			<cfloop array="#points_array#" index="pts">
				<cfset lat = left(pts, find(":", pts) - 1)>
				<cfset lon = mid(pts, find(":", pts) + 1, len(pts))>
				
				<cfoutput>
					Latitude: '#lat#' Longitude: '#lon#'<br>
				</cfoutput>
				<cfset p.add_point(lat, lon)>
			</cfloop>
			
			<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#p.id#" addtoken="no">
		</cfif>
	</cfif>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="inner-tube">
		<div id="content-right">
			<cfinclude template="#session.root_url#/sidebar.cfm">
		</div> <!--- content-right --->
		<div id="content" style="margin:0px;width:80%;">		
			<cfmodule template="#session.root_url#/navigation-tabs.cfm">							
			<div id="tabs-min">
				<ul>
					<li><a href="#introduction">Introduction</a></li>
					<li><a href="#basics">Basics</a></li>
					<li><a href="#location">Location</a></li>
					<li><a href="#ownership">Ownership</a></li>
					<li><a href="#valuation">Valuation</a></li>
					<li><a href="#survey">Survey</a></li>
					<li><a href="#geodetic">Geodetic</a></li>
				</ul>
				<cfset tab_count = 7>
				<cfoutput><form name="parcel_properties" id="parcel_properties" method="post" action="#session.root_url#/parcels/define_parcel.cfm"></cfoutput>
					<div id="introduction">
						<div style="height:600px; width:100%; position:relative;">
						
						<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="0" tab_selector="##tabs-min">
						</div>
					</div>
					<div id="basics">
						<div style="height:600px; width:100%; position:relative;">
							<table>							
								<tr>
									<td>Parcel ID</td>
									<td>
										<input type="text" name="parcel_id">
									</td>					
								</tr>
								<tr>					
									<td>Reception number</td>
									<td><input type="text" name="reception_number"></td>
								</tr>
								<tr>
									<td>Area (sq. ft.)</td>
									<td>
										<input type="text" name="area_sq_ft" id="area_sq_ft">
									</td>					
								</tr>
								<tr>
									<td>Area (sq. yd.)</td>
									<td>
										<input type="text" name="area_sq_yd" id="area_sq_yd">
									</td>					
								</tr>
								<tr>
									<td>Area (acres)</td>
									<td>
										<input type="text" name="area_acres" id="area_acres">
									</td>					
								</tr>
							</table>
						<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="1" tab_selector="##tabs-min">
						</div>	
					</div>
					<div id="location">
						<div style="height:600px; width:100%; position:relative;">
							<table>
								<tr>
									<td>Subdivision</td>
									<td>
										<input type="text" name="subdivision">
									</td>
								</tr>
								<tr>
									<td>Lot</td>
									<td>
										<input type="text" name="lot">
									</td>
								</tr>
								<tr>
									<td>Block</td>
									<td>
										<input type="text" name="block">
									</td>
								</tr>
								<tr>
									<td>Section</td>
									<td>
										<input type="text" name="section">
									</td>
								</tr>
								<tr>
									<td>Township</td>
									<td nowrap>
										<input type="text" name="township" style="width:78%;">
										<select name="township_direction" style="width:20%;">
											<option value="N">North</option>
											<option value="S">South</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>Range</td>
									<td nowrap>
										<input type="text" name="range" style="width:78%;">
										<select name="range_direction" style="width:20%;">
											<option value="E">East</option>
											<option value="W">West</option>
										</select>
									</td>
								</tr>
	
								<tr>
									<td>Physical address</td>
									<td>
										<input type="text" name="physical_address">
									</td>
								</tr>
								<tr>
									<td>Physical city</td>
									<td>
										<input type="text" name="physical_city">
									</td>
								</tr>
								<tr>
									<td>Physical state</td>
									<td>
										<input type="text" name="physical_state">
									</td>
								</tr>				
								<tr>
									<td>Physical ZIP</td>
									<td>
										<input type="text" name="physical_zip">
									</td>
								</tr>
							</table>
							<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="2" tab_selector="##tabs-min">
						</div>					
					</div>
					<div id="ownership">
						<div style="height:600px; width:100%; position:relative;">
							<table>
								<tr>
									<td>Owner name</td>
									<td>
										<input type="text" name="owner_name">
									</td>
								</tr>
								<tr>
									<td>Account number</td>
									<td>
										<input type="text" name="account_number">
									</td>
								</tr>
								<tr>
									<td>Mailing address</td>
									<td>
										<input type="text" name="mailing_address">
									</td>
								</tr>
								<tr>
									<td>Mailing city</td>
									<td>
										<input type="text" name="mailing_city">
									</td>
								</tr>
								<tr>
									<td>Mailing state</td>
									<td>
										<input type="text" name="mailing_state">
									</td>
								</tr>
								<tr>
									<td>Mailing ZIP</td>
									<td>
										<input type="text" name="mailing_zip">
									</td>
								</tr>
							</table>
							<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="3" tab_selector="##tabs-min">
						</div>					
					</div>
					<div id="valuation">
						<div style="height:600px; width:100%; position:relative;">
							<table>
								<tr>
									<td>Land value</td>
									<td>
										<input type="text" name="assessed_land_value" value="0">
									</td>					
								</tr>
								<tr>
									<td>Value of improvements</td>
									<td>
										<input type="text" name="assessed_building_value" value="0">
									</td>
								</tr>
							</table>
							<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="4" tab_selector="##tabs-min">
						</div>					
					</div>
					<div id="survey">
						<div style="height:600px; width:100%; position:relative;">
							<table>
								<tr>
									<td>Has ground survey</td>
									<td>
										<select name="ground_survey">
											<option value="1">Yes</option>
											<option value="0">No</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>Metes &amp; bounds</td>
									<td>
										<textarea name="metes_and_bounds"></textarea>
									</td>
								</tr>
							</table>
							<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="5" tab_selector="##tabs-min">
						</div>					
					</div>
					<div id="geodetic">
						<div style="height:600px; width:100%; position:relative;">
							<div id="map" style="width:100%;height:400px;">
						
							</div>
							<table>
								<tr>
									<td><label>Points</label></td>
									<td>
										<input type="text" name="points" id="points">
									</td>
								</tr>
								<tr>
									<td><label>Center latitude</label></td>
									<td>
										<input type="text" name="center_latitude" id="center_latitude">
									</td>
								</tr>
								<tr>
									<td><label>Center longitude</label></td>
									<td>
										<input type="text" name="center_longitude" id="center_longitude">
									</td>
								</tr>
							</table>
							<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="6" tab_selector="##tabs-min">
						</div>					
					</div>
				</form>
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>

	
