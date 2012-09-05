<cfsilent>
	<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(url.id)>
	<cfquery name="parcel_points" datasource="#session.company.datasource#">
		SELECT * FROM parcel_points WHERE parcel_id='#url.id#'
	</cfquery>
	
	<cfif find("S", parcel.township) GT 0>
		<cfset t_township_direction = "S">
		<cfif find("S", parcel.township) GT 1>
			<cfset ts_part = left(parcel.township, find("S", parcel.township) - 1)>
		<cfelse>
			<cfset ts_part = "">
		</cfif>
	<cfelse>
		<cfset t_township_direction = "N">
		<cfif find("N", parcel.township) GT 1>
			<cfset ts_part = left(parcel.township, find("N", parcel.township) - 1)>
		<cfelse>
			<cfset ts_part = "">
		</cfif>
	</cfif>
	
	<cfif find("E", parcel.range) GT 0>
		<cfset t_range_direction = "E">
		<cfif find("E", parcel.range) GT 1>
			<cfset r_part = left(parcel.range, find("E", parcel.range) - 1)>
		<cfelse>
			<cfset r_part = "">
		</cfif>
	<cfelse>
		<cfset t_range_direction = "W">
		<cfif find("W", parcel.range) GT 1>
			<cfset r_part = left(parcel.range, find("W", parcel.range) - 1)>
		<cfelse>
			<cfset r_part = "">
		</cfif>
	</cfif>
	<cfif IsDefined("form.submit")>
		<cfset parcel.parcel_id = form.parcel_id>
		<cfset parcel.area_sq_ft = form.area_sq_ft>
		<cfset parcel.area_sq_yd = form.area_sq_yd>
		<cfset parcel.area_acres = form.area_acres>
		<cfset parcel.account_number = form.account_number>
		<cfset parcel.mailing_address = form.mailing_address>
		<cfset parcel.mailing_city = form.mailing_city>
		<cfset parcel.mailing_state = form.mailing_state>
		<cfset parcel.mailing_zip = form.mailing_zip>
		<cfset parcel.physical_address = form.physical_address>
		<cfset parcel.physical_city = form.physical_city>
		<cfset parcel.physical_state = form.physical_state>
		<cfset parcel.physical_zip = form.physical_zip>
		<cfset parcel.subdivision = form.subdivision>
		<cfset parcel.lot = form.lot>
		<cfset parcel.block = form.block>
		<cfset parcel.assessed_land_value = form.assessed_land_value>
		<cfset parcel.assessed_building_value = form.assessed_building_value>
		<cfset parcel.section = form.section>
		<cfset parcel.township = form.township & form.township_direction>
		<cfset parcel.range = form.range & form.range_direction>
		<cfset parcel.reception_number = form.reception_number>
		<cfset parcel.owner_name = form.owner_name>
		<cfset parcel.metes_and_bounds = form.metes_and_bounds>
		<cfset parcel.ground_survey = form.ground_survey>
	
		<cfset parcel.update()>		
	</cfif>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab,cftooltip">
	<cfoutput>	
		<title>Parcel #parcel.parcel_id# - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
		<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menu.css" />
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menubar.css" />
		<link type="text/css" href="#session.root_url#/jquery_ui/css/redmond/jquery-ui-1.8.23.custom.css" rel="Stylesheet" />	
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-ui.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menu.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menubar.js"></script>
		<script src="http://view.jqueryui.com/menubar/ui/jquery.ui.position.js" type="text/javascript"></script>
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "850px");
				$("#accordion").accordion();		
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
				
				draw_parcels();
   		 });
	</script>
	<script type="text/javascript">
		function draw_parcels()
		{
			<cfoutput>
			var mapOptions = {
	          center: new google.maps.LatLng(#parcel.center_latitude#, #parcel.center_longitude#),
	          zoom: 15,
	          mapTypeId: google.maps.MapTypeId.ROADMAP
	        };
	        </cfoutput>
	
	        var map = new google.maps.Map(document.getElementById('map'),
	          mapOptions);
	          
	        var parcel = [];
	        
	        var coords = [
				<cfoutput query="parcel_points">
			   		new google.maps.LatLng(#latitude#, #longitude#),
			   	</cfoutput>
			 ];
						 
			
			 parcel.push(new google.maps.Polygon({
			   paths: coords,
			 }));
			
			 parcel[parcel.length-1].setMap(map);
	         
			
		}
	</script>
</head>
<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->
	<div id="container">
		<div id="header">
			<cfinclude template="#session.root_url#/top.cfm">
			<cfinclude template="#session.root_url#/navigation.cfm">			
		</div>	
		<div id="navigation">			
			<div id="accordion">
				<p><a href="##">Parcel Properties</a></p>
				<div>
					<cfoutput>
						<form name="parcel_properties" action="manage_parcel.cfm?id=#url.id#" method="post">
						<table class="property_dialog">							
							<tr>
								<td>Parcel ID</td>
								<td><input type="text" name="parcel_id" value="#parcel.parcel_id#"></td>					
							</tr>
							<tr>
								<td>Area (sq. ft.)</td>
								<td><input type="text" name="area_sq_ft" id="area_sq_ft" value="#parcel.area_sq_ft#"></td>					
							</tr>
							<tr>
								<td>Area (sq. yd.)</td>
								<td><input type="text" name="area_sq_yd" id="area_sq_yd" value="#parcel.area_sq_yd#"></td>					
							</tr>
							<tr>
								<td>Area (acres)</td>
								<td><input type="text" name="area_acres" id="area_acres" value="#parcel.area_acres#"></td>					
							</tr>
							<tr>
								<td>Owner name</td>
								<td><input type="text" name="owner_name" value="#parcel.owner_name#"></td>
							</tr>
							<tr>
								<td>Account number</td>
								<td><input type="text" name="account_number" value="#parcel.account_number#"></td>
							</tr>
							<tr>
								<td>Subdivision</td>
								<td><input type="text" name="subdivision" value="#parcel.subdivision#"></td>
							</tr>
							<tr>
								<td>Lot</td>
								<td><input type="text" name="lot" value="#parcel.lot#"></td>
							</tr>
							<tr>
								<td>Block</td>
								<td><input type="text" name="block" value="#parcel.block#"></td>
							</tr>
							<tr>
								<td>Section</td>
								<td><input type="text" name="section" value="#parcel.section#"></td>
							</tr>
							<tr>
								<td>Township</td>
								<td nowrap>
									<input type="text" name="township" style="width:78%;" value="#ts_part#" autocomplete="off">
									<select name="township_direction" style="width:20%;" autocomplete="off">
										<option value="N" <cfif t_township_direction EQ "N">selected="selected"</cfif>>North</option>
										<option value="S" <cfif t_township_direction EQ "S">selected="selected"</cfif>>South</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Range</td>
								<td nowrap>
									<input type="text" name="range" style="width:78%;" value="#r_part#">
									<select name="range_direction" style="width:20%;" autocomplete="off">
										<option value="E" <cfif t_range_direction EQ "E">selected="selected"</cfif>>East</option>
										<option value="W" <cfif t_range_direction EQ "W">selected="selected"</cfif>>West</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Mailing address</td>
								<td><input type="text" name="mailing_address" value="#parcel.mailing_address#"></td>
							</tr>
							<tr>
								<td>Mailing city</td>
								<td><input type="text" name="mailing_city" value="#parcel.mailing_city#"></td>
							</tr>
							<tr>
								<td>Mailing state</td>
								<td><input type="text" name="mailing_state" value="#parcel.mailing_state#"></td>
							</tr>
							<tr>
								<td>Mailing ZIP</td>
								<td><input type="text" name="mailing_zip" value="#parcel.mailing_zip#"></td>
							</tr>
							<tr>
								<td>Physical address</td>
								<td><input type="text" name="physical_address" value="#parcel.physical_address#"></td>
							</tr>
							<tr>
								<td>Physical city</td>
								<td><input type="text" name="physical_city" value="#parcel.physical_city#"></td>
							</tr>
							<tr>
								<td>Physical state</td>
								<td><input type="text" name="physical_state" value="#parcel.physical_state#"></td>
							</tr>				
							<tr>
								<td>Physical ZIP</td>
								<td><input type="text" name="physical_zip" value="#parcel.physical_zip#"></td>
							</tr>
							<tr>
								<td>Assessed land value</td>
								<td><input type="text" name="assessed_land_value" value="#parcel.assessed_land_value#"></td>					
							</tr>
							<tr>
								<td>Assessed building value</td>
								<td><input type="text" name="assessed_building_value" value="#parcel.assessed_building_value#"></td>
							</tr>
							<tr>					
								<td>Reception number</td>
								<td><input type="text" name="reception_number" value="#parcel.reception_number#"></td>
							</tr>
							<tr>
								<td>Has ground survey</td>
								<td>
									<select name="ground_survey" autocomplete="off">
										<option value="1" <cfif parcel.ground_survey EQ 1>selected="selected"</cfif>>Yes</option>
										<option value="0" <cfif parcel.ground_survey EQ 0>selected="selected"</cfif>>No</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Metes &amp; bounds</td>
								<td>
									<textarea name="metes_and_bounds">#parcel.metes_and_bounds#</textarea>
								</td>
							</tr>
						</table>
						<input type="submit" name="submit" value="Apply">
						</form>
					</cfoutput>
				</div> <!--- parcel properties --->
			</div>     <!--- accordion --->
		</div> <!--- navigation --->
		<div id="content">
			<div id="tabs">
				<ul>
					<li><a href="#tab1">Map</a></li>
					<li><a href="#tab2">Projects</a></li>
					<li><a href="#tab3">Documents</a></li>
				</ul>
				<div id="tab1">
					<div id="map" style="width:100%;height:480px;">
						
					</div> <!--- map --->
				</div> <!--- tab1 --->
				<div id="tab2">
					<div id="projects" style="width:100%;height:480px;overflow:auto;">
						<cfquery name="projects" datasource="#session.company.datasource#">
							SELECT id FROM projects ORDER BY project_name
						</cfquery>
						<cfset projs = ArrayNew(1)>
						<cfoutput query="projects">
							<cfset p = CreateObject("component", "ptarmigan.project").open(id)>						
							<cfset ArrayAppend(projs, p)>
						</cfoutput>
						
						<table width="100%" class="pretty" style="margin:0;">
							<tr>
								<th>ASSOCIATED</th>
								<th>PROJECT NAME</th>
								<th>CUSTOMER</th>								
							</tr>
							<cfloop array="#projs#" index="p">
								<cfoutput>
								<cfset c_id = CreateUUID()>
								<tr><!---function associate_parcel(root_url, ctl_id, parcel_id, element_table, element_id)--->
									<td><input type="checkbox" id="#c_id#" <cfif parcel.associated('projects', p.id) EQ true>checked</cfif> 
									onclick="associate_parcel('#session.root_url#', '#c_id#', '#parcel.id#', 'projects', '#p.id#');">
									</td>
									<td>#p.project_name#</td>
									<td>#p.customer().company_name#</td>
								</tr>
								</cfoutput>
							</cfloop>
						</table>
					</div> <!--- projects --->
				</div> <!--- tab2 --->
				<div id="tab3">
					<div id="documents" style="width:100%;height:480px;overflow:auto;">
						<cfquery name="parcel_docs" datasource="#session.company.datasource#">
							SELECT document_id FROM document_associations WHERE element_table='parcels' AND element_id='#url.id#'
						</cfquery>
						<cfset docs = ArrayNew(1)>
						<cfoutput query="parcel_docs">
							<cfset d = CreateObject("component", "ptarmigan.document").open(document_id)>
							<cfset ArrayAppend(docs, d)>
						</cfoutput>
						
						<table width="100%" class="pretty" style="margin:0;">
							<tr>
								<th>NAME</th>
								<th>DOCUMENT NO.</th>
								<th>FILING INFORMATION</th>								
								<th>ACTIONS</th>
							</tr>
							<cfloop array="#docs#" index="d">
								<cfoutput>
									<tr>
										<td>#d.document_name#</td>
										<td>#d.document_number#</td>
										<td>FILED #dateFormat(d.filing_date, "m/dd/yyyy")# IN
											#d.filing_category# #d.filing_container# #d.filing_division# #d.filing_material_type# #d.filing_number#
										</td>
										<td><a href="../documents/manage_document.cfm?id=#d.id#">Open Document</a></td>
									</tr>
								</cfoutput>
							</cfloop>
						</table>
					</div> <!--- documents --->
				</div> <!--- tab3 --->
			</div> <!--- tabs --->
		</div> <!--- content --->
	</div> <!--- container --->
</body>
</html>









