<cfmodule template="../security/require.cfm" type="admin">
<cfquery name="get_customers" datasource="ptarmigan">
	SELECT id FROM customers ORDER BY company_name
</cfquery>

<cfswitch expression="#url.action#">
	<cfcase value="edit">
		<cfset e_action="edit_customer.cfm">
	</cfcase>
	<cfcase value="view">
		<cfset e_action="view_customer.cfm">
	</cfcase>
</cfswitch>

<table width="100%" border="1" class="pretty">
	<tr>
		<th>CUSTOMER NAME</th>
		<th>POINT OF CONTACT</th>
		<th>ACTIONS</th>
	</tr>	
	<cfoutput query="get_customers">

		<cfset t = CreateObject("component", "ptarmigan.customer").open(id)>
		<form name="e_#id#" method="post" action="#e_action#">
		<input type="hidden" name="id" value="#t.id#">
		<tr>		
			<td>#t.company_name#</td>
			<td>#t.poc#</td>
			<td><input type="submit" name="submit_#t.id#" value="#ucase(url.action)#"></td>
		</tr>
		</form>
	</cfoutput>
	

</table>