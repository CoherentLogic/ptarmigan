<cfmodule template="../security/require.cfm" type="">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Add Document - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	
</head>
<body>

<cfif IsDefined("form.self_post")>
	
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
	
	<cfif data_valid EQ true>
		<cfset d = CreateObject("component", "ptarmigan.document")>
			
		<cfset d.document_name = ucase(form.document_name)>
		<cfset d.description = ucase(form.description)>
		<cfset d.document_number = form.document_number>
		<cfset d.filing_category = form.filing_category>
		<cfset d.filing_container = form.filing_container>
		<cfset d.filing_division = ucase(form.filing_division)>
		<cfset d.filing_material_type = form.filing_material_type>
		<cfset d.filing_number = ucase(form.filing_number)>
		<cfset d.filing_date = CreateODBCDate(form.filing_date)>
			
		<cfset d.create()>
		
		<cfif IsDefined("form.upload_file")>
			<cffile action="upload" filefield="form.upload_file" destination="#session.upload_path#" nameconflict="makeunique">
			<cfset d.path = cffile.serverfile>
			<cfset d.mime_type = cffile.ContentType & "/" & cffile.ContentSubType>
			<cfset d.update()>
			<cfset d.generate_thumbnail()>
		</cfif>
		
		<cfif IsDefined("form.source_object_id")>
			<cfset assoc = CreateObject("component", "ptarmigan.object_association")>
			
			<cfset assoc.source_object_id = form.source_object_id>
			<cfset assoc.source_object_class = form.source_object_class>
			<cfset assoc.target_object_id = d.id>
			<cfset assoc.target_object_class = "OBJ_DOCUMENT">
			
			<cfset assoc.create()>
		</cfif>
		<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#d.id#" addtoken="false">
		<cfabort>
	</cfif>
</cfif>
<div class="form_wrapper">
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Document" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="add_document" id="add_document" action="#session.root_url#/documents/add_document.cfm" method="post" enctype="multipart/form-data"></cfoutput>
			<!---
				passed in if we're associating the new document with something immediately on submit
			--->
			<cfif IsDefined("url.source_object_id")>
				<cfoutput>
					<input type="hidden" name="source_object_id" value="#url.source_object_id#">
					<input type="hidden" name="source_object_class" value="#url.source_object_class#">
				</cfoutput>
			</cfif>			
			<div style="padding:20px; margin-top:20px;">						
						<table>
							<tr>
								<td>Name:</td>
								<td>
									<input type="text" name="document_name" <cfif isdefined("form.document_name")><cfoutput>value="#form.document_name#"</cfoutput></cfif>>
									<cfif isdefined("document_name_error")>
										<cfoutput><span class="form_error">#document_name_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td>Document #:</td>
								<td>
									<input type="text" name="document_number" <cfif isdefined("form.document_number")><cfoutput>value="#form.document_number#"</cfoutput></cfif>>
									<cfif isdefined("document_number_error")>
										<cfoutput><span class="form_error">#document_number_error#</span></cfoutput>								
									</cfif>
								</td>
							</tr>
							<tr>
								<td>Description:</td>
								<td>
									<textarea name="description"><cfif isdefined("form.description")><cfoutput>#form.description#</cfoutput></cfif></textarea>
									<cfif isdefined("description_error")>
										<cfoutput><span class="form_error">#description_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>		
							<tr>
								<td>File:</td>
								<td><input type="file" name="upload_file"></td>
							</tr>						
						</table>
						<table>
							<tr>
								<td>Filing date:</td>
								<cfoutput>
									<td>
										<input 
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
								<td>Container:</td>
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
								<td>Container number:</td>
								<td>
									<input type="text" name="filing_division" size="4" <cfif isdefined("form.filing_division")><cfoutput>value="#form.filing_division#"</cfoutput></cfif>>
									<cfif isdefined("filing_division_error")>
										<cfoutput><span class="form_error">#filing_division_error#</span></cfoutput>
									</cfif>
								</td>					
							</tr>
							<tr>
								<td>Filing material and number/label:</td>
								<td>
									<select name="filing_material_type">
										<option value="FOLDER" selected="selected">FOLDER</option>
										<option value="BOX">BOX</option>
										<option value="PAGE">PAGE</option>
										<option value="SLIDE">SLIDE</option>
									</select>									
									<input type="text" name="filing_number" <cfif isdefined("form.filing_number")><cfoutput>value="#form.filing_number#"</cfoutput></cfif>>
									<cfif isdefined("filing_number_error")>
										<cfoutput><span class="form_error">#filing_number_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
												
						</table>					
				</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</form>
		
		<div class="form_buttonstrip">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_document');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</div>
</body>
</html>