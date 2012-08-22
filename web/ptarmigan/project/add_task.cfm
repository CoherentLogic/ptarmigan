
<cfmodule template="../security/require.cfm" type="project">

<cfset return_url = "#url.return#?id=#url.id#">

<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(form.milestone_id)>


<cfif IsDefined("form.set_milestone")>
	<cfset ms = CreateObject("component", "ptarmigan.milestone").open(form.milestone_id)>
	<cfset p = CreateObject("component", "ptarmigan.project").open(url.id)>
	<cfset p.current_milestone = ms.milestone_number>
	<cfset p.update()>
	
	<cflocation url="#return_url#">
</cfif>

<cfif IsDefined("form.submit_add")>
	<cfset t = CreateObject("component", "ptarmigan.task")>
	
	<cfset t.task_name = form.task_name>
	<cfset t.description = form.description>
	<cfset t.milestone_id = form.milestone_id>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.budget = form.budget>
	
	<cfif IsDefined("form.completed")>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	
	<cfset t.create()>
	
	<cflocation url="#return_url#">
<cfelse>

	<h1>Add Task</h1>
	<cfoutput><p><em>Milestone date range: #dateformat(milestone.start_date, 'm/dd/yyyy')#-#dateFormat(milestone.end_date, 'm/dd/yyyy')#</em></p></cfoutput>
	<cfoutput><a href="#return_url#">Return to project</a></cfoutput>
	<cfoutput>
	<form name="add_task" method="post" action="add_task.cfm?return=#url.return#&id=#url.id#">
	<input type="hidden" name="milestone_id" value="#form.milestone_id#">
	</cfoutput>
	
	<table>
		<tr>
			<td>Task name:</td>
			<td>
				<input type="text" name="task_name"><br>
				<label><input type="checkbox" name="completed">Completed</input></label>
			</td>
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
			<td>Instructions:</td>
			<td><textarea name="description" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right">
				<input type="submit" name="submit_add" value="Submit">
			</td>
		</tr>
	</table>			
	</form>	

</cfif>