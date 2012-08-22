<cfmodule template="../security/require.cfm" type="project">




<cfset t = CreateObject("component", "ptarmigan.milestone").open(url.id)>
	
<cfif IsDefined("form.submit_milestone")>
	<cfset t.milestone_number = form.milestone_number>
	<cfset t.milestone_name = form.milestone_name>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.budget = form.budget>
	<cfif IsDefined("form.floating")>
		<cfset t.floating = 1>
	<cfelse>
		<cfset t.floating = 0>
	</cfif>

	<cfset t.update()>
	
	<cfset session.message="Milestone updated">
	
	
	
	<cflocation url="edit_project.cfm?id=#t.project_id#">
<cfelse>

	<h1>Edit Milestone</h1>
	
	<cfoutput>
	<form name="add_milestone" action="edit_milestone.cfm?id=#url.id#" method="post">
		<table>
			<tr>
				<td>Milestone number:</td>
				<td><input type="text" name="milestone_number" value="#t.milestone_number#"></td>
			</tr>
			<tr>
				<td>Milestone name:</td>
				<td><input type="text" name="milestone_name" value="#t.milestone_name#"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><label><input type="checkbox" name="floating" <cfif t.floating EQ 1>checked</cfif>>Floating</td>
			</tr>
			<tr>
				<td>Start date (MM/DD/YYYY):</td>
				<td><input type="text" name="start_date" value="#dateFormat(t.start_date, 'mm/dd/yyyy')#"></td>
			</tr>
			<tr>
				<td>End date (MM/DD/YYYY):</td>
				<td><input type="text" name="end_date" value="#dateFormat(t.end_date, 'mm/dd/yyyy')#"></td>		
			</tr>			
			<tr>
				<td>Budget:</td>
				<td>$<input type="text" name="budget" value="#t.budget#"></td>
			</tr>	
			<tr>
				<td>&nbsp</td>
				<td align="right"><input type="submit" name="submit_milestone" value="Submit"></td>
			</tr>
		</table>
	</form>
	</cfoutput>

</cfif>