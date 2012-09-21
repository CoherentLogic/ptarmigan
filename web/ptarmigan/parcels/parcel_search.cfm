<cfif IsDefined("url.document_id")>
	<cfset document = CreateObject("component", "ptarmigan.document").open(url.document_id)>
</cfif>

<cfif IsDefined("form.self_post")>	
	<cfquery name="parcel_search" datasource="#session.company.datasource#">
		SELECT * FROM parcels
		WHERE id!=''
		<cfif IsDefined("form.s_parcel_id")>
			AND parcel_id LIKE '%#form.parcel_id#%'
		</cfif>
		<cfif IsDefined("form.s_reception_number")>
			AND reception_number LIKE '%#form.reception_number#%'
		</cfif>
		<cfif IsDefined("form.s_owner_name")>
			AND owner_name LIKE '%#form.owner_name#%'
		</cfif>
		<cfif IsDefined("form.s_account_number")>
			AND account_number LIKE '%#form.account_number#%'
		</cfif>
		<cfif IsDefined("form.s_ground_survey")>
			AND ground_survey=#form.ground_survey#
		</cfif>
		<cfif IsDefined("form.s_area_sq_ft")>
			AND area_sq_ft#form.area_sq_ft_operator##form.area_sq_ft#
		</cfif>
		<cfif IsDefined("form.s_area_sq_yd")>
			AND area_sq_yd#form.area_sq_yd_operator##form.area_sq_yd#
		</cfif>
		<cfif IsDefined("form.s_area_acres")>
			AND area_acres#form.area_acres_operator##form.area_acres#
		</cfif>
		<cfif IsDefined("form.s_assessed_land_value")>
			AND assessed_land_value#form.assessed_land_value_operator##form.assessed_land_value#
		</cfif>
		<cfif IsDefined("form.s_assessed_building_value")>
			AND assessed_building_value#form.assessed_building_value_operator##form.assessed_building_value#
		</cfif>
		<cfif IsDefined("form.s_subdivision")>
			AND subdivision LIKE '%#form.subdivision#%'
			AND lot LIKE '%#form.lot#%'
			AND block LIKE '%#form.block#%'
		</cfif>
		<cfif IsDefined("form.s_physical_address")>
			<cfif form.physical_address NEQ "">
				AND physical_address LIKE '%#form.physical_address#%'
			</cfif>
			<cfif form.physical_city NEQ "">
				AND physical_city LIKE '%#form.physical_city#%'
			</cfif>
			<cfif form.physical_state NEQ "">
				AND physical_state LIKE '%#form.physical_state#%'
			</cfif>
			<cfif form.physical_zip NEQ "">
				AND physical_zip LIKE '%#form.physical_zip#%'
			</cfif>
		</cfif>
		<cfif IsDefined("form.s_mailing_address")>
			<cfif form.mailing_address NEQ "">
				AND mailing_address LIKE '%#form.mailing_address#%'
			</cfif>
			<cfif form.mailing_city NEQ "">
				AND mailing_city LIKE '%#form.mailing_city#%'
			</cfif>
			<cfif form.mailing_state NEQ "">
				AND mailing_state LIKE '%#form.mailing_state#%'
			</cfif>
			<cfif form.mailing_zip NEQ "">
				AND mailing_zip LIKE '%#form.mailing_zip#%'
			</cfif>
		</cfif>
		<cfif IsDefined("form.s_legal_section")>
			AND `section`='#form.section#'
			AND `township`='#form.township##form.township_direction#'
			AND `range`='#form.range##form.range_direction#'
		</cfif>
	</cfquery>
	
	<cfset parcels = ArrayNew(1)>
	<cfoutput query="parcel_search">
		<cfset p = CreateObject("component", "ptarmigan.parcel").open(id)>
		<cfset ArrayAppend(parcels, p)>
	</cfoutput>

	<table class="pretty-small" style="margin:0;" style="font-size:10px;" width="100%">
		<tr>
			<th colspan="9"><cfoutput>#parcel_search.recordcount#</cfoutput> RESULTS</th>			
		</tr>
		<tr>
			<th>APN/ACCT/RCPT</th>
			<th>OWNER</th>
			<th>SUBDIVISION</th>
			<th>LOT</th>
			<th>BLOCK</th>
			<th>LEGAL SECTION</th>
			<th>AREA</th>
			<th>VALUE</th>
			<th>GRND SURVEY</th>			
		</tr>
		<cfloop array="#parcels#" index="p">		
		<tr>
			<td>
				<cfoutput>
					APN:  #p.parcel_id#<br>
					RCPT: #p.reception_number#<br>
					ACCT: #p.account_number#
				</cfoutput>
			</td>
			<td><cfoutput>#p.owner_name#</cfoutput></td>
			<td><cfoutput>#p.subdivision#</cfoutput></td>
			<td><cfoutput>#p.lot#</cfoutput></td>
			<td><cfoutput>#p.block#</cfoutput></td>
			<td>
				<cfif p.section NEQ "">
					<cfoutput>SEC #p.section# T#p.township# R#p.range#</cfoutput>
				</cfif>
			</td>
			<td>
				<cfoutput>
					#p.area_sq_ft# SQ. FT.<br>
					#p.area_sq_yd# SQ. YD.<br>
					#p.area_acres# ACRES
				</cfoutput>
			</td>
			<td>
				<cfoutput>
					LAND: #numberFormat(p.assessed_land_value, ",_$___.__")#<br>
					BLDG: #numberFormat(p.assessed_building_value, ",_$___.__")#
				</cfoutput>
			</td>
			<td>
				<cfif p.ground_survey EQ 1>Y<cfelse>N</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="9">
				<table width="100%">
					<tr>
						<td>
							<strong>PHYSICAL LOCATION:</strong><br>
							<cfoutput>
								#p.physical_address#<br>
								#p.physical_city# #p.physical_state# #p.physical_zip#
							</cfoutput>
						</td>
						<td>
							<strong>MAILING ADDRESS:</strong><br>
							<cfoutput>
								#p.mailing_address#<br>
								#p.physical_city# #p.physical_state# #p.physical_zip#
							</cfoutput>
						</td>
						<td valign="bottom" align="right" nowrap>
							<cfoutput>
								<a class="button" href="#session.root_url#/parcels/manage_parcel.cfm?id=#p.id#"><span>View parcel</span></a>															
								<cfif IsDefined("form.document_id")>
									<a class="button" href="##" onclick="associate_parcel_with_document('#session.root_url#', '#p.id#', '#form.document_id#')"><span>Attach</span></a>
								</cfif>
							</cfoutput>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</cfloop>
	</table>		
<cfelse> <!--- IsDefined("form.self_post") --->
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Search Parcels" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="parcel_search" id="parcel_search" action="#session.root_url#/parcels/parcel_search.cfm" method="post"></cfoutput>
			<div style="margin-top:20px;padding:20px; width:960px; height:670px; overflow:auto;" id="results_area">
				<cfif IsDefined("url.document_id")>
					<cfoutput>
						<input type="hidden" name="document_id" value="#url.document_id#">
					</cfoutput>
				</cfif>
				<table width="100%" border="0" cellpadding="6">					
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_parcel_id">Parcel number</label></td>
						<td><input type="text" name="parcel_id">
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_reception_number">Reception number</label></td>
						<td><input type="text" name="reception_number">
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_account_number">Account number</label></td>
						<td><input type="text" name="account_number">
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_owner_name">Owner name</label></td>
						<td><input type="text" name="owner_name">
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_ground_survey">Has ground survey</label></td>
						<td>
							<select name="ground_survey">
								<option value="1">Yes</option>
								<option value="0">No</option>
							</select>
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_area_sq_ft">Square footage</label></td>
						<td>
							<select name="area_sq_ft_operator">
								<option value=">">GREATER THAN</option>
								<option value="<">LESS THAN</option>
								<option value="=">EQUAL TO</option>
							</select>
							<input type="text" name="area_sq_ft">
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_area_sq_yd">Square yardage</label></td>
						<td>
							<select name="area_sq_yd_operator">
								<option value=">">GREATER THAN</option>
								<option value="<">LESS THAN</option>
								<option value="=">EQUAL TO</option>
							</select>
							<input type="text" name="area_sq_yd">
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_area_acres">Acreage</label></td>
						<td>
							<select name="area_acres_operator">
								<option value=">">GREATER THAN</option>
								<option value="<">LESS THAN</option>
								<option value="=">EQUAL TO</option>
							</select>
							<input type="text" name="area_acres">
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_assessed_land_value">Assessed land value</label></td>
						<td>
							<select name="assessed_land_value_operator">
								<option value="greater">GREATER THAN</option>
								<option value="less">LESS THAN</option>
								<option value="equals">EQUAL TO</option>
							</select>
							<input type="text" name="assessed_land_value">
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_assessed_building_value">Assessed building value</label></td>
						<td>
							<select name="assessed_building_value_operator">
								<option value="greater">GREATER THAN</option>
								<option value="less">LESS THAN</option>
								<option value="equals">EQUAL TO</option>
							</select>
							<input type="text" name="assessed_building_value">
						</td>
					</tr>

					<tr>
						<td valign="top"><label><input type="checkbox" name="s_subdivision">Subdivision</label></td>
						<td>
							<input type="text" name="subdivision">							
							<label>LOT <input type="text" name="lot" size="4"></label>
							<label>BLOCK <input type="text" name="block" size="4"></label>
						</td>
					</tr>					
					
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_physical_address">Physical address</label></td>
						<td>
							<table>
								<tr>
									<td>Address:</td>
									<td><input type="text" name="physical_address"></td>
								</tr>
								<tr>
									<td>City:</td>
									<td><input type="text" name="physical_city"></td>
								</tr>
								<tr>
									<td>State:</td>
									<td><input type="text" name="physical_state" size="2" maxlength="2"></td>
								</tr>
								<tr>
									<td>ZIP:</td>
									<td><input type="text" name="physical_zip" size="5" maxlength="5">
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_mailing_address">Mailing address</label></td>
						<td>
							<table>
								<tr>
									<td>Address:</td>
									<td><input type="text" name="mailing_address"></td>
								</tr>
								<tr>
									<td>City:</td>
									<td><input type="text" name="mailing_city"></td>
								</tr>
								<tr>
									<td>State:</td>
									<td><input type="text" name="mailing_state" size="2" maxlength="2"></td>
								</tr>
								<tr>
									<td>ZIP:</td>
									<td><input type="text" name="mailing_zip" size="5" maxlength="5">
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td valign="top"><label><input type="checkbox" name="s_legal_section">Legal section</label></td>					
						<td>
							<label>Section<input type="text" name="section" size="3"></label>
							<label>Township <input type="text" name="township" size="3"></label>
							<select name="township_direction" style="width:40px;" autocomplete="off">
								<option value="N">N</option>
								<option value="S">S</option>
							</select>
							<label>Range <input type="text" name="range" size="3"></label>
							<select name="range_direction" style="width:40px;" autocomplete="off">
								<option value="E">E</option>
								<option value="W">W</option>
							</select>
						</td>
					</tr>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</form>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" id="cancel_button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<cfoutput>
				<a class="button" id="submit_link" href="##" onclick="document.getElementById('self_post').value='true'; ColdFusion.Ajax.submitForm('parcel_search', '#session.root_url#/parcels/parcel_search.cfm', search_documents_complete);"><span>Apply</span></a>
				</cfoutput>
			</div>
		</div>
	</div>
</cfif>