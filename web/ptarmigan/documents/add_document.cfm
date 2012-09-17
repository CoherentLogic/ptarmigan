<cfif IsDefined("form.self_post")>
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
	<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#form.return_to#" addtoken="false">
<cfelse>
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
			<cfoutput>
			<input type="hidden" name="return_to" value="#url.return_to#">		
			</cfoutput>
			<div style="padding:20px; margin-top:20px;">
				<div id="tabs" class="pt_tabs">
					<ul>
						<li><a href="##tBasic">Basic Information</a></li>
						<li><a href="##tFiling">Filing Information</a></li>			
					</ul>
					<div id="tBasic">	
						<div style="padding:4px;height:240px;">
						<table>
							<tr>
								<td>Name:</td>
								<td><input type="text" name="document_name"></td>
							</tr>
							<tr>
								<td>Document #:</td>
								<td><input type="text" name="document_number"></td>
							</tr>
							<tr>
								<td>Description:</td>
								<td><textarea name="description"></textarea></td>
							</tr>		
							<tr>
								<td>File:</td>
								<td><input type="file" name="upload_file"></td>
							</tr>						
						</table>
						</div>
					</div>
					<div id="tFiling">
						<div style="padding:4px;height:240px;">
							<table>
								<tr>
									<td>Filing date:</td>
									<cfoutput><td><input type="text" name="filing_date" value="#dateFormat(Now(), 'mm/dd/yyyy')#"></td></cfoutput>
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
									<td><input type="text" name="filing_division" size="4"></td>					
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
										<input type="text" name="filing_number">
									</td>
								</tr>
													
							</table>
						</div>
					</div> <!--- tFiling --->
				</div> <!--- tabs --->					
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</form>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_document');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>
