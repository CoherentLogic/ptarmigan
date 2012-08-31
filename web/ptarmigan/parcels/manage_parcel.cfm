<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(url.id)>
<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>

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

<head>
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

<body onload="draw_parcels();">
	<div id="container">
		<div id="header">
			<h1>Parcel Viewer</h1>
		</div>
		
		<div id="navigation">
			<cfoutput>
			<form name="parcel_properties" action="insert_parcel.cfm" method="post">
			<table class="property_dialog">
				<tr>
					<th colspan="2">PROPERTIES</th>
				</tr>
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
			</form>
			</cfoutput>
		</div>
		
		<div id="content">
			<cflayout type="tab">
				<cflayoutarea title="Map">
					<div id="map" style="width:100%;height:480px;">
						
					</div>
				</cflayoutarea>
				<cflayoutarea title="Projects">
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
					</div>
				</cflayoutarea>										
				<cflayoutarea title="Documents">
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
					</div>
				
				</cflayoutarea>
			</cflayout>			
		</div>
	</div>
</body>
