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
	<cfset basics_errors = 0>
	<cfset location_errors = 0> 
	<cfset ownership_errors = 0>
	<cfset valuation_errors = 0>
	<cfset survey_errors = 0>
	<cfset geodetic_errors = 0>
	
	<cfif isdefined("form.submit")>
		<cfset data_valid = true>
		
		<cfif form.parcel_id EQ "">
			<cfset basics_errors = basics_errors + 1>
			<cfset parcel_id_error = "Parcel ID required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.parcel_id) GT 255>
			<cfset basics_errors = basics_errors + 1>
			<cfset parcel_id_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.area_sq_ft NEQ "">
			<cfif not isnumeric(form.area_sq_ft)>
				<cfset basics_errors = basics_errors + 1>
				<cfset area_sq_ft_error = "Must be a numeric value">
				<cfset data_valid = false>
			</cfif>
		</cfif>
		
		<cfif form.area_sq_yd NEQ "">
			<cfif not isnumeric(form.area_sq_yd)>
				<cfset basics_errors = basics_errors + 1>
				<cfset area_sq_yd_error = "Must be a numeric value">
				<cfset data_valid = false>
			</cfif>
		</cfif>
		
		<cfif form.area_acres NEQ "">
			<cfif not isnumeric(form.area_acres)>
				<cfset basics_errors = basics_errors + 1>
				<cfset area_acres_error = "Must be a numeric value">
				<cfset data_valid = false>
			</cfif>
		</cfif>
		
		<cfif len(form.reception_number) GT 255>
			<cfset basics_errors = basics_errors + 1>
			<cfset reception_number_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.subdivision) GT 255>
			<cfset location_errors = location_errors + 1>
			<cfset subdivision_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.lot) GT 255>
			<cfset location_errors = location_errors + 1>
			<cfset lot_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.block) GT 255>
			<cfset location_errors = location_errors + 1>
			<cfset block_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.section) GT 5>
			<cfset location_errors = location_errors + 1>
			<cfset section_error = "Must be 5 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.township) GT 5>
			<cfset location_errors = location_errors + 1>
			<cfset township_error = "Must be 5 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.range) GT 5>
			<cfset location_errors = location_errors + 1>
			<cfset range_error = "Must be 5 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.physical_address) GT 255>
			<cfset location_errors = location_errors + 1>
			<cfset physical_address_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.physical_city) GT 255>
			<cfset location_errors = location_errors + 1>
			<cfset physical_city_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.physical_state) GT 2>
			<cfset location_errors = location_errors + 1>
			<cfset physical_state_error = "Must be 2 characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.physical_zip) GT 5>
			<cfset location_errors = location_errors + 1>
			<cfset physical_zip_error = "Must be 5 characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.owner_name) GT 255>
			<cfset ownership_errors = ownership_errors + 1>
			<cfset owner_name_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.account_number) GT 255>
			<cfset ownership_errors = ownership_errors + 1>
			<cfset account_number_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mailing_address) GT 255>
			<cfset ownership_errors = ownership_errors + 1>
			<cfset mailing_address_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mailing_city) GT 255>
			<cfset ownership_errors = ownership_errors + 1>
			<cfset mailing_city_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mailing_state) GT 2>
			<cfset ownership_errors = ownership_errors + 1>
			<cfset mailing_state_error = "Must be 2 characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mailing_zip) GT 5>
			<cfset ownership_errors = ownership_errors + 1>
			<cfset mailing_zip_error = "Must be 5 characters">
			<cfset data_valid = false>
		</cfif>
		
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
			
			<cfset wkt_string = "POLYGON((">
			
			<cfloop array="#points_array#" index="pts">
				<cfset lat = left(pts, find(":", pts) - 1)>
				<cfset lon = mid(pts, find(":", pts) + 1, len(pts))>
				
				<cfset wkt_string = wkt_string & lon & " " & lat & ",">
				
				<cfoutput>
					Latitude: '#lat#' Longitude: '#lon#'<br>
				</cfoutput>
				<cfset p.add_point(lat, lon)>
			</cfloop>
			
			<cfset first_point = points_array[1]>
			<cfset lat = left(first_point, find(":", first_point) - 1)>
			<cfset lon = mid(first_point, find(":", first_point) + 1, len(first_point))>
			<cfset wkt_string = wkt_string & lon & " " & lat & ",">
			
			<cfset wkt_string = left(wkt_string, len(wkt_string) - 1) & "))">
			<cfset p.wkt = wkt_string>
			<cfset p.update()>
			
			<cfoutput>#p.wkt#</cfoutput>
			
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
			<div class="form_instructions">
				<p>Required fields marked with *</p>
			</div>
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
						<cfif not isdefined("form.submit")>
								<h1>Add Parcel Wizard</h1>
								<p>This wizard will guide you through adding a new parcel. Required fields are marked with the asterisk character (<strong>*</strong>).</p>
								<p>Please press <strong>Next</strong> to continue.</p>
							<cfelse>
								<cfif data_valid EQ false>							
									<h1>Oops...</h1>
									<p>You have the following errors in your data entry:</p>
									<table width="100%">
									<tr>
									<td valign="top">
									<blockquote>
										<!---
											<cfset basics_errors = 0>
											<cfset location_errors = 0> 
											<cfset ownership_errors = 0>
											<cfset valuation_errors = 0>
											<cfset survey_errors = 0>
											<cfset geodetic_errors = 0>
										--->
										<cfoutput>
										<cfif basics_errors GT 0>										
											<em>#basics_errors# errors in <strong>Basics</strong></em>										
										</cfif>
										<cfif location_errors GT 0>										
											<em>#location_errors# errors in <strong>Location</strong></em>							
										</cfif>
										<cfif ownership_errors GT 0>										
											<em>#ownership_errors# errors in <strong>Ownership</strong></em>							
										</cfif>
										</cfoutput>
									</blockquote>
									</td>
									<td valign="top">
										<blockquote>
										<cfoutput>
										<cfif valuation_errors GT 0>										
											<em>#valuation_errors# errors in <strong>Valuation</strong></em>
										</cfif>
										<cfif survey_errors GT 0>										
											<em>#survey_errors# errors in <strong>Survey</strong></em>
										</cfif>
										</cfoutput>
										</blockquote>
									</td>
									</tr>
									</table>								
								</cfif>
							</cfif>
						<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="0" tab_selector="##tabs-min">
						</div>
					</div>
					<div id="basics">
						<div style="height:600px; width:100%; position:relative;">
							<table>							
								<tr>
									<td><label>Parcel ID<strong>*</strong></label></td>
									<td>
										<input type="text" name="parcel_id" maxlength="255" <cfif isdefined("form.parcel_id")><cfoutput>value="#form.parcel_id#"</cfoutput></cfif> placeholder="255 or fewer characters" >
										<cfif isdefined("parcel_id_error")>
											<cfoutput><span class="form_error">#parcel_id_error#</span></cfoutput>
										</cfif>
									</td>					
								</tr>
								<tr>					
									<td><label>Reception number</label></td>
									<td>
										<input type="text" name="reception_number" <cfif isdefined("form.reception_number")><cfoutput>value="#form.reception_number#"</cfoutput></cfif> maxlength="50" placeholder="50 or fewer characters">
										<cfif isdefined("reception_number_error")>
											<cfoutput><span class="form_error">#reception_number_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Area (sq. ft.)</label></td>
									<td>
										<input type="text" name="area_sq_ft" id="area_sq_ft" <cfif isdefined("form.area_sq_ft")><cfoutput>value="#form.area_sq_ft#"</cfoutput></cfif> maxlength="255" placeholder="">
										<cfif isdefined("area_sq_ft_error")>
											<cfoutput><span class="form_error">#area_sq_ft_error#</span></cfoutput>
										</cfif>
									</td>					
								</tr>
								<tr>
									<td><label>Area (sq. yd.)</label></td>
									<td>
										<input type="text" name="area_sq_yd" id="area_sq_yd" <cfif isdefined("form.area_sq_yd")><cfoutput>value="#form.area_sq_yd#"</cfoutput></cfif> maxlength="255" placeholder="">
										<cfif isdefined("area_sq_yd_error")>
											<cfoutput><span class="form_error">#area_sq_yd_error#</span></cfoutput>
										</cfif>
									</td>					
								</tr>
								<tr>
									<td><label>Area (acres)</label></td>
									<td>
										<input type="text" name="area_acres" id="area_acres" <cfif isdefined("form.area_acres")><cfoutput>value="#form.area_acres#"</cfoutput></cfif> maxlength="255" placeholder="">
										<cfif isdefined("area_acres_error")>
											<cfoutput><span class="form_error">#area_acres_error#</span></cfoutput>
										</cfif>
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
									<td><label>Subdivision</label></td>
									<td>
										<input type="text" name="subdivision" <cfif isdefined("form.subdivision")><cfoutput>value="#form.subdivision#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("subdivision_error")>
											<cfoutput><span class="form_error">#subdivision_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Lot</label></td>
									<td>
										<input type="text" name="lot" <cfif isdefined("form.lot")><cfoutput>value="#form.lot#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("lot_error")>
											<cfoutput><span class="form_error">#lot_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Block</label></td>
									<td>
										<input type="text" name="block" <cfif isdefined("form.block")><cfoutput>value="#form.block#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("block_error")>
											<cfoutput><span class="form_error">#block_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Section</label></td>
									<td>
										<input type="text" name="section" <cfif isdefined("form.section")><cfoutput>value="#form.section#"</cfoutput></cfif> maxlength="5" placeholder="5 or fewer characters">
										<cfif isdefined("section_error")>
											<cfoutput><span class="form_error">#section_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Township</label></td>
									<td nowrap>
										<input type="text" name="township" <cfif isdefined("form.township")><cfoutput>value="#form.township#"</cfoutput></cfif> maxlength="5" placeholder="5 or fewer characters">
										<select name="township_direction">
											<option value="" selected>Township Direction</option>
											<option value="N">North</option>
											<option value="S">South</option>
										</select>
										<cfif isdefined("township_error")>
											<cfoutput><span class="form_error">#township_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Range</label></td>
									<td nowrap>
										<input type="text" name="range" <cfif isdefined("form.range")><cfoutput>value="#form.range#"</cfoutput></cfif> maxlength="5" placeholder="5 or fewer characters">
										<select name="range_direction">
											<option value="" selected>Range Direction</option>
											<option value="E">East</option>
											<option value="W">West</option>
										</select>
										<cfif isdefined("range_error")>
											<cfoutput><span class="form_error">#range_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
	
								<tr>
									<td><label>Physical address</label></td>
									<td>
										<input type="text" name="physical_address" <cfif isdefined("form.physical_address")><cfoutput>value="#form.physical_address#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("physical_address_error")>
											<cfoutput><span class="form_error">#physical_address_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Physical city</label></td>
									<td>
										<input type="text" name="physical_city" <cfif isdefined("form.physical_city")><cfoutput>value="#form.physical_city#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("physical_city_error")>
											<cfoutput><span class="form_error">#physical_city_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Physical state</label></td>
									<td>
										<input type="text" name="physical_state" <cfif isdefined("form.physical_state")><cfoutput>value="#form.physical_state#"</cfoutput></cfif> maxlength="2" placeholder="XX" size="2">
										<cfif isdefined("physical_state_error")>
											<cfoutput><span class="form_error">#physical_state_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>				
								<tr>
									<td><label>Physical ZIP code</label></td>
									<td>
										<input type="text" name="physical_zip" <cfif isdefined("form.physical_zip")><cfoutput>value="#form.physical_zip#"</cfoutput></cfif> maxlength="5" placeholder="XXXXX">
										<cfif isdefined("physical_zip_error")>
											<cfoutput><span class="form_error">#physical_zip_error#</span></cfoutput>
										</cfif>
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
									<td><label>Owner name</label></td>
									<td>
										<input type="text" name="owner_name" <cfif isdefined("form.owner_name")><cfoutput>value="#form.owner_name#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("owner_name_error")>
											<cfoutput><span class="form_error">#owner_name_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Owner account number</label></td>
									<td>
										<input type="text" name="account_number" <cfif isdefined("form.account_number")><cfoutput>value="#form.account_number#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("account_number_error")>
											<cfoutput><span class="form_error">#account_number_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Mailing address</label></td>
									<td>
										<input type="text" name="mailing_address" <cfif isdefined("form.mailing_address")><cfoutput>value="#form.mailing_address#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("mailing_address_error")>
											<cfoutput><span class="form_error">#mailing_address_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Mailing city</label></td>
									<td>
										<input type="text" name="mailing_city" <cfif isdefined("form.mailing_city")><cfoutput>value="#form.mailing_city#"</cfoutput></cfif> maxlength="255" placeholder="255 or fewer characters">
										<cfif isdefined("mailing_city_error")>
											<cfoutput><span class="form_error">#mailing_city_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Mailing state</label></td>
									<td>
										<input type="text" name="mailing_state" <cfif isdefined("form.mailing_state")><cfoutput>value="#form.mailing_state#"</cfoutput></cfif> maxlength="2" placeholder="XX">
										<cfif isdefined("mailing_state_error")>
											<cfoutput><span class="form_error">#mailing_state_error#</span></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td><label>Mailing ZIP code</label></td>
									<td>
										<input type="text" name="mailing_zip" <cfif isdefined("form.mailing_zip")><cfoutput>value="#form.mailing_zip#"</cfoutput></cfif> maxlength="5" placeholder="XXXXX">
										<cfif isdefined("mailing_zip_error")>
											<cfoutput><span class="form_error">#mailing_zip_error#</span></cfoutput>
										</cfif>
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
									<td><label>Land value</label></td>
									<td>
										<input type="text" name="assessed_land_value" <cfif isdefined("form.assessed_land_value")><cfoutput>value="#form.assessed_land_value#"</cfoutput></cfif> value="0"  maxlength="255" placeholder="">
										<cfif isdefined("assessed_land_value_error")>
											<cfoutput><span class="form_error">#assessed_land_value_error#</span></cfoutput>
										</cfif>
									</td>					
								</tr>
								<tr>
									<td><label>Value of improvements</label></td>
									<td>
										<input type="text" name="assessed_building_value" <cfif isdefined("form.assessed_building_value")><cfoutput>value="#form.assessed_building_value#"</cfoutput></cfif> value="0" maxlength="255" placeholder="">
										<cfif isdefined("assessed_building_value_error")>
											<cfoutput><span class="form_error">#assessed_building_value_error#</span></cfoutput>
										</cfif>
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
									<td><label>Has ground survey</label></td>
									<td>
										<select name="ground_survey">
											<option value="1">Yes</option>
											<option value="0">No</option>
										</select>
									</td>
								</tr>
								<tr>
									<td><label>Metes &amp; bounds</label></td>
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