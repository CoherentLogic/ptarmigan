<cfmodule template="../security/require.cfm" type="admin">


<cfif IsDefined("form.submit")>
	<cfset dt = CreateObject("component", "ptarmigan.document_type")>
	<cfset dt.type_name = form.type_name>
	<cfset dt.type_key = form.type_key>
	
	<cfset dt.create()>
</cfif>
<h1>Add Document Type</h1>

<cfif IsDefined("form.submit")>
	<p><em>Document type <strong><cfoutput>#UCase(form.type_name)#</cfoutput></strong> added.</em></p>
</cfif>

<form name="add_document_type" action="add_document_type.cfm" method="post">
	<table>
		<tr>
			<td>Type name:</td>
			<td><input type="text" name="type_name"></td>
		</tr>
		<tr>
			<td>Type key:</td>
			<td><input type="text" name="type_key"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><input type="submit" name="submit" value="Submit"></td>
		</tr>
	</table>
</form>