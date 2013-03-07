<cfmodule template="#session.root_url#/security/require.cfm" type="">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Search Documents - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
			$(document).ready(function() {   
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
				$(".pt_buttons").button();								
				
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				init_page();
			});
	</script>
</head>
<body>
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
		<cfif IsDefined("form.s_document_revision")>
			AND document_revision LIKE '%#form.document_revision#%'
		</cfif>
		<cfif IsDefined("form.s_subdivision")>
			AND subdivision LIKE '%#form.subdivision#%'
			AND lot LIKE '%#form.lot#%'
			AND block LIKE '%#form.block#%'
		</cfif>
		<cfif IsDefined("form.s_legal_section")>
			AND `section`='#form.section#'
			AND `township`='#form.township##form.township_direction#'
			AND `range`='#form.range##form.range_direction#'
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
	
	<cfmodule template="#session.root_url#/search/header.cfm" result_count="#arraylen(oa)#" result_time="#cfquery.executiontime / 1000#">
	<cfloop array="#oa#" index="d">
		<cfmodule template="#session.root_url#/search/results.cfm" id="#d.id#">		
	</cfloop>
	</div> <!--- ends div begun in header.cfm --->
<cfelse>
	<div class="form_wrapper">
		<div style="position:relative; height:100%; width:100%; background-color:white;">
			<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Search Documents" icon="#session.root_url#/images/project_dialog.png">
		
			<cfoutput><form name="document_search" id="document_search" action="#session.root_url#/documents/document_search.cfm" method="post"></cfoutput>
				<div style="padding:20px; width:auto; height:auto; overflow:auto;" id="results_area">
					<table>
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
								<label><input type="checkbox" name="s_document_number">Document number</label>
							</td>
							<td>
								<input type="text" name="document_number">
							</td>
						</tr>
						<tr>
							<td>
								<label><input type="checkbox" name="s_document_revision">Revision number</label>
							</td>
							<td>
								<input type="text" name="document_revision">
							</td>
						</tr>
						<tr>
							<td>
								<label><input type="checkbox" name="s_subdivision">Subdivision</label>
							</td>
							<td>
								<input type="text" name="subdivision">
								<label>LOT <input type="text" size="5" name="lot"></label>
								<label>BLOCK <input type="text" size="5" name="block"></label>
							</td>
						</tr>
						
						<tr>
						<td valign="top"><label><input type="checkbox" name="s_legal_section">Legal section</label></td>					
						<td>
							<label>Section<input type="text" name="section" size="3"></label>
							<label>Township <input type="text" name="township" size="3"></label>
							<select name="township_direction" style="width:80px;" autocomplete="off">
								<option value="N">NORTH</option>
								<option value="S">SOUTH</option>
							</select>
							<label>Range <input type="text" name="range" size="3"></label>
							<select name="range_direction" style="width:80px;" autocomplete="off">
								<option value="E">EAST</option>
								<option value="W">WEST</option>
							</select>
						</td>
					</tr>
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
								<label><input type="checkbox" name="s_description">Description</label>
							</td>
							<td>
								<input type="text" name="description">
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
			
			<div class="form_buttonstrip">
		    	<div style="padding:8px; float:right;" id="form_buttons">
		        	<a class="button" id="cancel_button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
					<cfoutput>
					<a class="button" id="submit_link" href="##" onclick="form_submit('document_search');"><span>Apply</span></a>
					</cfoutput>
				</div>
			</div>
		</div>
	</div> <!--- form_wrapper --->
</cfif>
</body>
</html>