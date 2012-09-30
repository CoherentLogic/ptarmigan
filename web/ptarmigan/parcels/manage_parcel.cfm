<cfsilent>
	<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(url.id)>
	<cfset session.current_object = CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset object = CreateObject("component", "ptarmigan.object").open(url.id)>
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
	<cfoutput>	
		<title>Parcel #parcel.parcel_id# - ptarmigan</title>
	
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">	
		<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "98%");
					
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$('#navigation_bar').css("float", "left");
				$(".ui-state-default").css("color", "black");
				
				draw_parcels();
				$(".pt_buttons").button();								
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
   		 });
   		 	
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
	<cfinclude template="#session.root_url#/navigation.cfm">			
	<!--- BEGIN LAYOUT --->
	<div id="container">
		<div id="header">
		<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>#parcel.object_name()#</strong></h1></cfoutput></td>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick="add_link('#url.id#', 'OBJ_PARCEL');"><img src="#session.root_url#/images/link.png" align="absmiddle"> Link To</button>
						<button class="pt_buttons" onclick="add_document('#session.root_url#', '#parcel.id#', '#parcel.id#', 'OBJ_PARCEL');"><img src="#session.root_url#/images/add.png" align="absmiddle"> New Document</button>
						<cfif session.user.is_admin() EQ true>							
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#url.id#');"><img src="#session.root_url#/images/trash.png"> Trash</button>
						</cfif>						
						</cfoutput>
					</td>
				</tr>
			</table>
		</div>	
		
		<div id="content"  style="margin:0px;width:100%;">
			<div id="tabs">
				<ul>
					<li><a href="#map_tab">Map</a></li>
					<li><a href="#parcel_tab">Parcel</a></li>
					
					
				</ul>
				<div id="parcel_tab">
					<div id="left-column" class="panel">
						<h1>Recording</h1>
						<p>
						<cfoutput>
						<table>
							<tbody>
							<tr>
								<td>APN:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="parcel_id" width="auto" show_label="false" full_refresh="false"></td>
								<td>Reception Number:</td>
								<td>
									<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="reception_number" width="auto" show_label="false" full_refresh="false">
								</td>
							</tr>												
							</tbody>
						</table>
						</cfoutput>
						</p>
						<h1>Location</h1>
						<p>
						<cfoutput>
						<table>
							<tbody>
							<tr>
								<td>Subdivision:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="subdivision" width="auto" show_label="false" full_refresh="false"></td>
								<td>Lot:</td>
								<td>
									<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="lot" width="auto" show_label="false" full_refresh="false">
								</td>
							</tr>	
							<tr>
								<td>Block:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="block" width="auto" show_label="false" full_refresh="false"></td>
								<td>Section:</td>
								<td>
									<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="section" width="auto" show_label="false" full_refresh="false">
								</td>
							</tr>		
							<tr>
								<td>Township:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="township" width="auto" show_label="false" full_refresh="false"></td>
								<td>Range:</td>
								<td>
									<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="range" width="auto" show_label="false" full_refresh="false">
								</td>
							</tr>												
							</tbody>
						</table>
						</cfoutput>
						</p>
					
						<h1>Ownership</h1>
						<p>
							<cfoutput>
							<table>
								<tbody>
								<tr>
									<td>Owner:</td>
									<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="owner_name" width="auto" show_label="false" full_refresh="false"></td>
									<td>Account Number:</td>
									<td>
										<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="account_number" width="auto" show_label="false" full_refresh="false">
									</td>
								</tr>								
								<tr>
									<td>Physical address:</td>
									<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="physical_address" width="auto" show_label="false" full_refresh="false"></td>
									<td>Physical city:</td>
									<td>
										<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="physical_city" width="auto" show_label="false" full_refresh="false">
									</td>
								</tr>	
								<tr>
									<td>Physical state:</td>
									<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="physical_state" width="auto" show_label="false" full_refresh="false"></td>
									<td>Physical ZIP:</td>
									<td>
										<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="physical_zip" width="auto" show_label="false" full_refresh="false">
									</td>
								</tr>	
								<tr>
									<td>Mailing address:</td>
									<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mailing_address" width="auto" show_label="false" full_refresh="false"></td>
									<td>Mailing city:</td>
									<td>
										<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mailing_city" width="auto" show_label="false" full_refresh="false">
									</td>
								</tr>	
								<tr>
									<td>Mailing state:</td>
									<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mailing_state" width="auto" show_label="false" full_refresh="false"></td>
									<td>Mailing ZIP:</td>
									<td>
										<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mailing_zip" width="auto" show_label="false" full_refresh="false">
									</td>
								</tr>	
								</tbody>
							</table>
							</cfoutput>
						</p>
						<h1>Assessed Values</h1>
						<p>
						<cfoutput>
						<table>
							<tbody>
							<tr>
								<td>Land:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="assessed_land_value" width="auto" show_label="false" full_refresh="false"></td>
								<td>Building:</td>
								<td>
									<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="assessed_building_value" width="auto" show_label="false" full_refresh="false">
								</td>
							</tr>												
							</tbody>
						</table>
						</cfoutput>
						</p>
						<h1>Area</h1>
						<p>
						<cfoutput>
						<table>
							<tbody>
							<tr>
								<td>Square feet:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="area_sq_ft" width="auto" show_label="false" full_refresh="false"></td>
								<td>Square yards:</td>
								<td>
									<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="area_sq_yd" width="auto" show_label="false" full_refresh="false">
								</td>
							</tr>		
							<tr>
								<td>Acres:</td>
								<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="area_acres" width="auto" show_label="false" full_refresh="false"></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>												
							</tbody>
						</table>
						</cfoutput>
						</p>
						<h1>Legal Description (Metes &amp; Bounds)</h1>
						<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="metes_and_bounds" width="auto" show_label="false" full_refresh="false">
						<h1>Documents</h1>
						<cfif ArrayLen(object.get_associated_objects("OBJ_DOCUMENT", "TARGET")) EQ 0>
							<p><em>No documents associated with this parcel</em></p>
						<cfelse>
							<p>
							<div style="overflow:hidden">
							<cfloop array="#object.get_associated_objects('OBJ_DOCUMENT', 'TARGET')#" index="document">
								<cfoutput>
									<cfmodule template="#session.root_url#/documents/thumbnail.cfm" id="#document.get().id#">
								</cfoutput>
							</cfloop>
							</p>
							</div>
						</cfif>					
						<h1>Edit History</h1>
						<cfif object.get_audits().recordcount EQ 0>
							<p><em>No edits associated with this parcel</em></p>
						<cfelse>
							<cfset aud_query = object.get_audits()>
							<cfoutput query="aud_query">
								<cfset emp = CreateObject("component", "ptarmigan.object").open(employee_id)>
								<div class="comment_box">
									<span style="font-size:10px;color:gray;">#dateFormat(edit_date, "full")# #timeFormat(edit_date, "h:mm tt")# C/O ##: #change_order_number#</span>								
									<p><span style="color:##2957a2;">#emp.get().object_name()#</span> changed <strong>#member_name#</strong> from <strong>#original_value#</strong> to <strong>#new_value#</strong>
									<br><em>#comment#</em>
									</p>																
								</div>
							</cfoutput>
						</cfif>	
					</div>
					<div id="right-column" class="panel">
						<cfmodule template="#session.root_url#/objects/related_items.cfm" object_id="#object.id#">
					</div>
				</div> <!--- parcel_tab --->
				<div id="map_tab">
					<div id="map" style="width:100%;height:480px;">
						
					</div> <!--- map --->
				</div> <!--- map_tab --->
				
			</div> <!--- tabs --->
		</div> <!--- content --->
	</div> <!--- container --->
</body>
</html>









