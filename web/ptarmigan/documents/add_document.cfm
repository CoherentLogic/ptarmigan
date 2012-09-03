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
	
	<cflocation url="#session.root_url#/documents/manage_document.cfm?id=#d.id#" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Document" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="add_document" id="add_document" action="#session.root_url#/documents/add_document.cfm" method="post">
			<div style="padding:20px;">
				<cflayout type="tab">		
					<cflayoutarea title="Basic Information">
						<div style="padding:4px;height:240px;">
						<table>
							<tr>
								<td>Name:</td>
								<td><cfinput type="text" name="document_name"></td>
							</tr>
							<tr>
								<td>Document #:</td>
								<td><cfinput type="text" name="document_number"></td>
							</tr>
							<tr>
								<td>Description:</td>
								<td><textarea name="description"></textarea></td>
							</tr>								
						</table>
						</div>
					</cflayoutarea>
					<cflayoutarea title="Filing Information">
						<div style="padding:4px;height:240px;">
							<table>
								<tr>
									<td>Filing date:</td>
									<td><cfinput type="text" name="filing_date" value="#dateFormat(Now(), 'mm/dd/yyyy')#"></td>
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
					</cflayoutarea>
				</cflayout>										
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_document');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>
