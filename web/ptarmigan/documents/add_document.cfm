<cfmodule template="../security/require.cfm" type="">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>	
	<cfoutput>	
		<title>New Document - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   											
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">												
   		 });
	</script>
</head>
<body>
	<cfif IsDefined("form.submit")>
		
		<cfset data_valid = true>
		
		<cfif form.document_name EQ "">
			<cfset data_valid = false>
			<cfset document_name_error = "Document name is required">
		</cfif>
		
		<cfif len(form.document_name) GT 255>		
			<cfset data_valid = false>
			<cfset document_name_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.document_number) GT 255>		
			<cfset data_valid = false>
			<cfset document_number_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.description) GT 255>
			<cfset data_valid = false>
			<cfset description_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif form.filing_date NEQ "">			
			<cfif not isdate(form.filing_date)>
				<cfset data_valid = false>
				<cfset filing_date_error = "Must be a valid date">
			</cfif>
		</cfif>
		
		<cfif len(form.filing_division) GT 255>
			<cfset data_valid = false>
			<cfset filing_division_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.filing_number) GT 255>
			<cfset data_valid = false>
			<cfset filing_number_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.document_revision) GT 45>
			<cfset data_valid = false>
			<cfset document_revision_error = "Must be 45 or fewer characters">
		</cfif>
		
		<cfif len(form.section) GT 5>
			<cfset data_valid = false>
			<cfset section_error = "Must be 5 or fewer characters">
		</cfif>
		
		<cfif len(form.township) GT 5>
			<cfset data_valid = false>
			<cfset township_error = "Must be 5 or fewer characters">
		</cfif>
		
		<cfif len(form.range) GT 5>
			<cfset data_valid = false>
			<cfset range_error = "Must be 5 or fewer characters">
		</cfif>
		
		<cfif len(form.subdivision) GT 255>
			<cfset data_valid = false>
			<cfset subdivision_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.lot) GT 45>
			<cfset data_valid = false>
			<cfset lot_error = "Must be 45 or fewer characters">
		</cfif>
		
		<cfif len(form.block) GT 45>
			<cfset data_valid = false>
			<cfset block_error = "Must be 45 or fewer characters">
		</cfif>
		
		<cfif len(form.usrs_sheet) GT 45>
			<cfset data_valid = false>
			<cfset usrs_sheet_error = "Must be 45 or fewer characters">
		</cfif>
		
		<cfif len(form.usrs_parcel) GT 45>
			<cfset data_valid = false>
			<cfset usrs_parcel_error = "Must be 45 or fewer characters">
		</cfif>
		
		<cfif len(form.owner_name) GT 255>
			<cfset data_valid = false>
			<cfset owner_name_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.address) GT 45>		
			<cfset data_valid = false>
			<cfset address_error = "Must be 45 or fewer characters">
		</cfif>
	
		<cfif len(form.city) GT 45>		
			<cfset data_valid = false>
			<cfset city_error = "Must be 45 or fewer characters">
		</cfif>
	
		<cfif len(form.state) GT 45>		
			<cfset data_valid = false>
			<cfset state_error = "Must be 45 or fewer characters">
		</cfif>
	
		<cfif form.zip NEQ "">
			<cfif len(form.zip) NEQ 5>		
				<cfset data_valid = false>
				<cfset zip_error = "Must be 5 characters">
			</cfif>
		</cfif>
	
		<cfif data_valid EQ true>
			data valid
			<cfset d = CreateObject("component", "ptarmigan.document")>
				
			<cfset d.document_name = ucase(form.document_name)>
			<cfset d.description = ucase(form.description)>
			<cfset d.document_number = form.document_number>
			<cfset d.document_revision = form.document_revision>
			<cfset d.filing_category = form.filing_category>
			<cfset d.filing_container = form.filing_container>
			<cfset d.filing_division = ucase(form.filing_division)>
			<cfset d.filing_material_type = form.filing_material_type>
			<cfset d.filing_number = ucase(form.filing_number)>
			<cfset d.filing_date = CreateODBCDate(form.filing_date)>
			
			<cfset d.subdivision = ucase(form.subdivision)>
			<cfset d.lot = ucase(form.lot)>
			<cfset d.block = ucase(form.block)>
			
			<cfset d.section = form.section>
			<cfset d.township = form.township & form.township_direction>
			<cfset d.range = form.range & form.range_direction>
			
			<cfset d.usrs_parcel = form.usrs_parcel>
			<cfset d.usrs_sheet = form.usrs_sheet>	
			
			<cfset d.owner_name = ucase(form.owner_name)>	
			<cfset d.address = ucase(form.address)>
			<cfset d.city = ucase(form.city)>
			<cfset d.state = ucase(form.state)>
			<cfset d.zip = ucase(form.zip)>		
			
			<cfset d.create()>
			
			<cfif IsDefined("form.upload_file")>
				<cffile action="upload" filefield="form.upload_file" destination="#session.upload_path#" nameconflict="makeunique">
				<cfset d.path = cffile.serverfile>
				<cfset d.mime_type = cffile.ContentType & "/" & cffile.ContentSubType>
				<cfset d.update()>
				<cfset d.generate_thumbnail()>
			</cfif>
	
			<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#d.id#" addtoken="false">		 			
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
					<li><a href="#new-document">New Document</a></li>					
				</ul>
				<div id="new-document">
					<div style="position:relative;">
					<cfoutput><form name="add_document" id="add_document" action="#session.root_url#/documents/add_document.cfm" method="post" enctype="multipart/form-data"></cfoutput>										
					<table>
						<tr>
							<td><label>Name<strong>*</strong></label></td>
							<td>
								<input <cfif isdefined("document_name_error")>class="error_field"</cfif> type="text" name="document_name" <cfif isdefined("form.document_name")><cfoutput>value="#form.document_name#"</cfoutput></cfif>>
								<cfif isdefined("document_name_error")>
									<cfoutput><span class="form_error">#document_name_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						<tr>
							<td><label>Document #</label></td>
							<td>
								<input <cfif isdefined("document_number_error")>class="error_field"</cfif> type="text" name="document_number" <cfif isdefined("form.document_number")><cfoutput>value="#form.document_number#"</cfoutput></cfif>>
								<cfif isdefined("document_number_error")>
									<cfoutput><span class="form_error">#document_number_error#</span></cfoutput>								
								</cfif>
							</td>
						</tr>
						<tr>
							<td><label>Revision</label></td>
							<td>
								<input <cfif isdefined("document_revision_error")>class="error_field"</cfif> type="text" name="document_revision" <cfif isdefined("form.document_revision")><cfoutput>value="#form.document_revision#"</cfoutput></cfif>>
								<cfif isdefined("document_revision_error")>
									<cfoutput><span class="form_error">#document_revision_error#</span></cfoutput>								
								</cfif>
							</td>
						</tr>

						<tr>
							<td><label>Description</label></td>
							<td>
								<textarea <cfif isdefined("description_error")>class="error_field"</cfif>  name="description"><cfif isdefined("form.description")><cfoutput>#form.description#</cfoutput></cfif></textarea>
								<cfif isdefined("description_error")>
									<cfoutput><span class="form_error">#description_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>		
						<tr>
							<td><label>File</label></td>
							<td><input type="file" name="upload_file"></td>
						</tr>													
						<tr>
							<td><label>Subdivision</label></td>
							<td>
								<input <cfif isdefined("subdivision_error")>class="error_field"</cfif>  type="text" name="subdivision" <cfif isdefined("form.subdivision")>value=<cfoutput>#form.subdivision#</cfoutput></cfif>>
								<cfif isdefined("subdivision_error")>
									<cfoutput><span class="form_error">#subdivision_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>									
						<tr>
							<td><label>Lot</label></td>
							<td>
								<input <cfif isdefined("lot_error")>class="error_field"</cfif> type="text" name="lot" <cfif isdefined("form.lot")>value=<cfoutput>#form.lot#</cfoutput></cfif>>
								<cfif isdefined("lot_error")>
									<cfoutput><span class="form_error">#lot_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						<tr>
							<td><label>Block</label></td>
							<td>
								<input <cfif isdefined("block_error")>class="error_field"</cfif> type="text" name="block" <cfif isdefined("form.block")>value=<cfoutput>#form.block#</cfoutput></cfif>>
								<cfif isdefined("block_error")>
									<cfoutput><span class="form_error">#block_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td><label>Section</label></td>
							<td>
								<input <cfif isdefined("section_error")>class="error_field"</cfif> type="text" name="section" <cfif isdefined("form.section")>value=<cfoutput>#form.section#</cfoutput></cfif>>
								<cfif isdefined("section_error")>
									<cfoutput><span class="form_error">#section_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td><label>Township</label></td>
							<td>
								<input <cfif isdefined("township_error")>class="error_field"</cfif>  type="text" name="township" <cfif isdefined("form.township")>value=<cfoutput>#form.township#</cfoutput></cfif>>
								<select name="township_direction">
									<option value="" selected>Township Direction</option>
									<option value="N">NORTH</option>
									<option value="S">SOUTH</option>
								</select>
								<cfif isdefined("township_error")>
									<cfoutput><span class="form_error">#township_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td><label>Range</label></td>
							<td>
								<input <cfif isdefined("range_error")>class="error_field"</cfif> type="text" name="range" <cfif isdefined("form.range")>value=<cfoutput>#form.range#</cfoutput></cfif>>
								<select name="range_direction">
									<option value="" selected>Range Direction</option>
									<option value="E">EAST</option>
									<option value="W">WEST</option>
								</select>
								<cfif isdefined("range_error")>
									<cfoutput><span class="form_error">#range_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td><label>USRS parcel</label></td>
							<td>
								<input <cfif isdefined("usrs_parcel_error")>class="error_field"</cfif> type="text" name="usrs_parcel" <cfif isdefined("form.usrs_parcel")>value=<cfoutput>#form.usrs_parcel#</cfoutput></cfif>>									
								<cfif isdefined("usrs_parcel_error")>
									<cfoutput><span class="form_error">#usrs_parcel_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td><label>USRS sheet</label></td>
							<td>
								<input <cfif isdefined("usrs_sheet_error")>class="error_field"</cfif> type="text" name="usrs_sheet" <cfif isdefined("form.usrs_sheet")>value=<cfoutput>#form.usrs_sheet#</cfoutput></cfif>>									
								<cfif isdefined("usrs_sheet_error")>
									<cfoutput><span class="form_error">#usrs_sheet_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						<tr>
							<td><label>Owner name</label></td>
							<td>
								<input <cfif isdefined("owner_name_error")>class="error_field"</cfif> type="text" name="owner_name" <cfif isdefined("form.owner_name")>value=<cfoutput>#form.owner_name#</cfoutput></cfif>>
								<cfif isdefined("owner_name_error")>
									<cfoutput><span class="form_error">#owner_name_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td><label>Property address</label></td>
							<td>
								<label>Street <input <cfif isdefined("address_error")>class="error_field"</cfif>  type="text" name="address" <cfif isdefined("form.owner_name")>value=<cfoutput>#form.owner_name#</cfoutput></cfif>></label>
								<cfif isdefined("address_error")>
									<cfoutput><span class="address_error">#address_error#</span></cfoutput>
								</cfif><br>
								<label>City <input <cfif isdefined("city_error")>class="error_field"</cfif> type="text" name="city" <cfif isdefined("form.city")>value=<cfoutput>#form.city#</cfoutput></cfif>></label>
								<cfif isdefined("city_error")>
									<cfoutput><span class="city_error">#city_error#</span></cfoutput>
								</cfif><br>
								<label>State <input <cfif isdefined("state_error")>class="error_field"</cfif> type="text" name="state" <cfif isdefined("form.state")>value=<cfoutput>#form.state#</cfoutput></cfif>></label>
								<cfif isdefined("state_error")>
									<cfoutput><span class="state_error">#state_error#</span></cfoutput>
								</cfif><br>
								<label>ZIP code <input <cfif isdefined("zip_error")>class="error_field"</cfif> type="text" name="zip" <cfif isdefined("form.zip")>value=<cfoutput>#form.zip#</cfoutput></cfif>></label>
								<cfif isdefined("zip_error")>
									<cfoutput><span class="zip_error">#zip_error#</span></cfoutput>
								</cfif><br>
							</td>
						</tr>
						<tr>
							<td><label>Filing date</label></td>
							<cfoutput>
								<td>
									<input
											<cfif isdefined("filing_date_error")>class="error_field"</cfif>  
											type="text" 
											name="filing_date" 
											<cfif isdefined("form.filing_date")>
												value="#form.filing_date#"
											<cfelse>										
												value="#dateFormat(Now(), 'mm/dd/yyyy')#"
											</cfif>>
									<cfif isdefined("filing_date_error")>
										<cfoutput><span class="form_error">#filing_date_error#</span></cfoutput>
									</cfif>
								</td>
							</cfoutput>
						</tr>
						<tr>
							<td><label>Container</label></td>
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
							</td>					
						</tr>
						<tr>
							<td><label>Container number</label></td>
							<td>
								<input <cfif isdefined("filing_division_error")>class="error_field"</cfif> type="text" name="filing_division" size="4" <cfif isdefined("form.filing_division")><cfoutput>value="#form.filing_division#"</cfoutput></cfif>>
								<cfif isdefined("filing_division_error")>
									<cfoutput><span class="form_error">#filing_division_error#</span></cfoutput>
								</cfif>
							</td>					
						</tr>
						<tr>
							<td><label>Filing material and number/label</label></td>
							<td>
								<select name="filing_material_type">
									<option value="FOLDER" selected="selected">FOLDER</option>
									<option value="BOX">BOX</option>
									<option value="PAGE">PAGE</option>
									<option value="SLIDE">SLIDE</option>
								</select>									
								<input <cfif isdefined("filing_number_error")>class="error_field"</cfif> type="text" name="filing_number" <cfif isdefined("form.filing_number")><cfoutput>value="#form.filing_number#"</cfoutput></cfif>>
								<cfif isdefined("filing_number_error")>
									<cfoutput><span class="form_error">#filing_number_error#</span></cfoutput>
								</cfif>
							</td>
						</tr>											
					</table>																
					<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="1" current_tab="0" tab_selector="##tabs-min">
				</form>		
				</div>					
				</div>	<!--- new-document --->			
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>


