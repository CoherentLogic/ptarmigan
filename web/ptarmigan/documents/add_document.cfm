	<cfif IsDefined("form.submit")>
	
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
		
		<cfoutput>
		<div style="width:100%; text-align:center;">
			<h1>Document Created</h1>
			<a href="#session.root_url#/documents/manage_document.cfm?id=#d.id#">Manage Document</a>
		</div>
		</cfoutput>
	
		
	<cfelse>
		<div style="padding:10px;">
		<cfform action="#session.root_url#/documents/add_document.cfm?suppress_headers" method="post">
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
					<td><cfinput type="datefield" name="filing_date" value="#dateFormat(Now(), 'mm/dd/yyyy')#"></td>
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
			
			<input type="submit" name="submit" value="Apply">
			<input type="button" name="cancel" value="Cancel" onclick="window.location.reload();">
		</cfform>
		</div>

	</cfif>
