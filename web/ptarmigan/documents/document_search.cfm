<cfif IsDefined("form.self_post")>
	
	<cfquery name="q_search_documents" datasource="#session.company.datasource#">
		SELECT id FROM documents
		WHERE	id!=''
		<cfif IsDefined("form.s_filing_date")>
			AND filing_date BETWEEN #CreateODBCDate(form.filing_date_start)# AND #CreateODBCDate(form.filing_date_end)#
		</cfif>
		<cfif IsDefined("form.s_document_name")>
			AND document_name LIKE '%#form.document_name#%'
		</cfif>
		<cfif IsDefined("form.s_description")>
			AND	description LIKE '%#form.description#%'
		</cfif>
		<cfif IsDefined("form.s_document_number")>
			AND document_number='#form.document_number#'
		</cfif>
		<cfif IsDefined("form.s_filing_information")>
			AND filing_category='#form.filing_category#'
			AND filing_container='#form.filing_container#'
			AND filing_division LIKE '%#form.filing_division#%'	
			AND filing_material_type='#form.filing_material_type#'
			AND filing_number LIKE '%#form.filing_number#%'
		</cfif>
	</cfquery>
	
	<cfset oa = ArrayNew(1)>
	<cfoutput query="q_search_documents">
		<cfset d = CreateObject("component", "ptarmigan.document").open(q_search_documents.id)>
		<cfset ArrayAppend(oa, d)>
	</cfoutput>
	
	<table width="100%" class="pretty" style="margin:0;">		
		<cfloop array="#oa#" index="d">
			<cfoutput>
				<tr>
					<td><a class="button" href="#session.root_url#/documents/manage_document.cfm?id=#d.id#"><span>Document #d.document_number#</span></a></td>
					<td>#d.document_name#</td>
				</tr>
				<tr>
					<td colspan="2">
						FILED #ucase(dateFormat(d.filing_date, "full"))# IN #d.filing_category# #d.filing_container# #d.filing_division# #d.filing_material_type# #d.filing_number#<br><hr>
						#d.description#
					</td>					
				</tr>
				
			</cfoutput>
		</cfloop>
	</table>
	
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Search Documents" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="document_search" id="document_search" action="#session.root_url#/documents/document_search.cfm" method="post"></cfoutput>
			<div style="padding:20px; width:600px; height:180px; overflow:auto;" id="results_area">
				<table>
					<tr>
						<td>
							<label><input type="checkbox" name="s_filing_date">Filing date</label>
						</td>
						<td>
							<table>
								<tr>
									<td>Between</td>
									<td>
										<input class="pt_dates" type="text" name="filing_date_start" size="10">
									</td>
									<td>
										and
									</td>
									<td>
										<input class="pt_dates" type="text" name="filing_date_end" size="10">
									</td>
								</tr>
							</table>							
						</td>
					</tr>
					<tr>
						<td>
							<label><input type="checkbox" name="s_document_name">Document name</label>						
						</td>
						<td>
							<input type="text" name="document_name">
						</td>
					</tr>
					<tr>
						<td>
							<label><input type="checkbox" name="s_description">Description</label>
						</td>
						<td>
							<input type="text" name="description">
						</td>
					</tr>
					<tr>
						<td>
							<label><input type="checkbox" name="s_document_number">Document number</label>
						</td>
						<td>
							<input type="text" name="document_number">
						</td>
					</tr>
					<tr>
						<td>
							<label><input type="checkbox" name="s_filing_information">Filing information</label>
						</td>
						<td>
							<select name="filing_category">
								<option value="FILE" selected="selected">FILE</option>
								<option value="STORAGE">STORAGE</option>
								<option value="DEED">DEED</option>
								<option value="SUBDIVISION">SUBDIVISION</option>
							</select>	
							<select name="filing_container">
								<option value="CABINET" selected="selected">CABINET</option>
								<option value="SHELF">SHELF</option>
								<option value="BOOK">BOOK</option>					
								<option value="PLAT">PLAT</option>
							</select>
							<input type="text" name="filing_division" size="4">
							<select name="filing_material_type">
								<option value="FOLDER" selected="selected">FOLDER</option>
								<option value="BOX">BOX</option>
								<option value="PAGE">PAGE</option>
								<option value="SLIDE">SLIDE</option>
							</select>
							<input type="text" name="filing_number" size="4">
						</td>
					</tr>
										
				</table>
			</div>
			
			<input type="hidden" name="self_post" id="self_post" value="">
		</form>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;" id="form_buttons">
	        	<a class="button" id="cancel_button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<cfoutput>
				<a class="button" id="submit_link" href="##" onclick="document.getElementById('self_post').value='true'; ColdFusion.Ajax.submitForm('document_search', '#session.root_url#/documents/document_search.cfm', search_documents_complete);"><span>Apply</span></a>
				</cfoutput>
			</div>
		</div>
	</div>
</cfif>