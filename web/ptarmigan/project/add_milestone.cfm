<cfmodule template="../security/require.cfm" type="project">

<cfset project = CreateObject("component", "ptarmigan.project").open(url.id)>



<cfset return_url = "#url.return#?id=#url.id#">


<cfif IsDefined("form.submit_milestone")>
	<cfset t = CreateObject("component", "ptarmigan.milestone")>
	
	<cfset t.project_id = url.id>
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
	
	<cfset t.create()>
	
	<cfset session.message="Milestone created">
	
	
	
	<cflocation url="#return_url#">
<cfelse>

	<h1>Add Milestone</h1>
	
	
	<cfoutput>
	<p><em>Project date range: #dateFormat(project.start_date, 'm/dd/yyyy')#-#dateFormat(project.due_date, 'm/dd/yyyy')#</em></p>
	<form name="add_milestone" action="add_milestone.cfm?return=#url.return#&id=#url.id#" method="post">
		<table>
			<tr>
				<td>Milestone number:</td>
				<td><input type="text" name="milestone_number"></td>
			</tr>
			<tr>
				<td>Milestone name:</td>
				<td><input type="text" name="milestone_name"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><label><input type="checkbox" name="floating">Floating</td>
			</tr>
			<tr>
				<td>Start date (MM/DD/YYYY):</td>
				<td><input type="text" name="start_date"></td>
			</tr>
			<tr>
				<td>End date (MM/DD/YYYY):</td>
				<td><input type="text" name="end_date"></td>		
			</tr>			
			<tr>
				<td>Budget:</td>
				<td>$<input type="text" name="budget"></td>
			</tr>	
			<tr>
				<td>&nbsp</td>
				<td align="right"><input type="submit" name="submit_milestone" value="Submit"></td>
			</tr>
		</table>
	</form>
	</cfoutput>

</cfif>