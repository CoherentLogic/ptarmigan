<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(url.id)>

<div style="padding:20px;">
	<cflayout type="tab">
		<cflayoutarea title="Basic Information">
			<div style="height:400px;width:560px;">
				<div style="padding:10px;">
					<cfoutput>
						<table width="100%" border="0" cellpadding="10">
							<tr>
								<td>APN:</td>
								<td><input type="text" readonly="readonly" disabled="disabled" value="#parcel.parcel_id#"></td>
							</tr>
							<tr>
								<td>Account number:</td>
								<td><input type="text" readonly="readonly" disabled="disabled" value="#parcel.account_number#"></td>
							</tr>
							<tr>
								<td>Reception number:</td>
								<td><input type="text" readonly="readonly" disabled="disabled" value="#parcel.reception_number#"></td>
							</tr>
							<tr>
								<td>Owner(s):</td>
								<td><input type="text" size="50" readonly="readonly" disabled="disabled" value="#parcel.owner_name#"></td>
							</tr>
							<tr>
								<td>Assessed land value:</td>
								<td><input type="text" readonly="readonly" disabled="disabled" value="#numberFormat(parcel.assessed_land_value, ',_$___.__')#"></td>
							</tr>
							<tr>
								<td>Assessed building value:</td>
								<td><input type="text" readonly="readonly" disabled="disabled" value="#numberFormat(parcel.assessed_building_value, ',_$___.__')#"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>
									<cfif parcel.ground_survey EQ 1>
										<label><input autocomplete="off" type="checkbox" disabled="disabled" checked="checked">Has ground survey</label>
									<cfelse>
										<label><input autocomplete="off" type="checkbox" disabled="disabled">Has ground survey</label>
									</cfif>
								</td>
							</tr>
						</table>
					</cfoutput>				
				</div>
			</div>
		</cflayoutarea>
		<cflayoutarea title="Location">
			<div style="height:400px;width:560px;">
				<div style="padding:10px;">
					<cfoutput>
						<table width="100%" border="0" cellpadding="10">
							<tr>
								<td>Physical address:</td>
								<td>
									<textarea cols="30" rows="2" readonly="readonly" disabled="disabled">
										#parcel.physical_address#
										#parcel.physical_city# #parcel.physical_state# #parcel.physical_zip#
									</textarea>
								</td>
							</tr>
							<tr>
								<td>Mailing address:</td>
								<td>
									<textarea cols="30" rows="2" readonly="readonly" disabled="disabled">
										#parcel.mailing_address#<br>
										#parcel.mailing_city# #parcel.mailing_state# #parcel.mailing_zip#
									</textarea>
								</td>								
							</tr>
							<tr>
								<td>Legal section:</td>
								<td>
									<input type="text" readonly="readonly" disabled="disabled" value="#parcel.section# T#parcel.township# R#parcel.range#">
								</td>
							</tr>
							<tr>
								<td>Subdivision:</td>
								<td>
									<input type="text" size="40" readonly="readonly" disabled="disabled" value="#parcel.subdivision# LOT #parcel.lot# BLOCK #parcel.block#">
								</td>
							</tr>
							
						</table>
					</cfoutput>
				</div>
			</div>
		</cflayoutarea>
		<cflayoutarea title="Legal Description">
			<div style="height:400px;width:560px;">
				<div style="padding:10px;">
					<cfoutput>
						<textarea rows="15" cols="40" style="width:100%;height:60%;" disabled>
							#parcel.metes_and_bounds#
						</textarea>
					</cfoutput>
				</div>
			</div>
		</cflayoutarea>
		<cflayoutarea title="Documents">
			<div style="height:400px;width:560px;">
				<div style="padding:0px;">
					<cfoutput>
						<cfset docs = parcel.documents()>
						
						<table class="pretty" style="margin:0;" width="100%">
							<tr>
								<th>NAME</th>								
								<th>##</th>
								<th>FILING DATE</th>
								<th>DESCRIPTION</th>
								<th>FILING INFORMATION</th>
								<th>ACTIONS</th>
							</tr>
							<cfloop array="#docs#" index="d">
								<tr>
									<td>#d.document_name#</td>
									<td>#d.document_number#</td>
									<td>#dateFormat(d.filing_date, "m/dd/yyyy")#</td>
									<td>#d.description#</td>
									<td>#d.filing_category# #d.filing_container# #d.filing_division# #d.filing_material_type# #d.filing_number#</td>
									<td><a href="../documents/manage_document.cfm?id=#d.id#" target="_blank">Open Document</a></td>
								</tr>
							</cfloop>							
						</table>
						
					</cfoutput>
				</div>
			</div>
		</cflayoutarea>
	</cflayout>
</div>