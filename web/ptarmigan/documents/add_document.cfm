	<cfif IsDefined("form.submit")>
	
		<cfset d = CreateObject("component", "ptarmigan.document")>
		
		<cfset d.document_name = ucase(form.document_name)>
		<cfset d.description = ucase(form.description)>
		<cfset d.document_number = form.document_number>
	
		<cfset d.create()>
		
		<cfoutput>
		<div style="width:100%; text-align:center;">
			<h1>Document Created</h1>
			<a href="#session.root_url#/documents/manage_document.cfm?id=#d.id#">Manage Document</a>
		</div>
		</cfoutput>
	
		
	<cfelse>
		<cfform action="#session.root_url#/documents/add_document.cfm?suppress_headers" method="post">
		<div style="padding:20px;">
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
			
			<input type="submit" name="submit" value="Apply">
			<input type="button" name="cancel" value="Cancel" onclick="window.location.reload();">
		</div>
		</cfform>
	</cfif>
