<cfmodule template="../security/require.cfm" type="">
<cfquery name="get_projects" datasource="#session.company.datasource#">
	SELECT id FROM projects ORDER BY due_date
</cfquery>

<cfswitch expression="#url.action#">
	<cfcase value="edit">
		<cfset e_action="edit_project.cfm">
	</cfcase>
	<cfcase value="view">
		<cfset e_action="view_project.cfm">
	</cfcase>
</cfswitch>

<table width="100%" border="1" class="pretty">
	<tr>
		<th>PROJECT NAME</th>
		<th>PROJECT NUMBER</th>
		<th>DUE DATE</th>
		<th>CUSTOMER</th>
		<th>ACTIONS</th>
	</tr>	
	<cfoutput query="get_projects">

		<cfset t = CreateObject("component", "ptarmigan.project").open(id)>
		<form name="e_#id#" method="post" action="#e_action#">
		<input type="hidden" name="id" value="#t.id#">
		<tr>		
			<td>#t.project_name#</td>
			<td>#t.project_number#</td>
			<td>#dateFormat(t.due_date, "MM/DD/YYYY")#</td>
			<td>#t.customer().company_name#</td>
			<td><a href="edit_project.cfm?id=#id#">Edit Project</a></td>
		</tr>
		</form>
	</cfoutput>
	

</table>