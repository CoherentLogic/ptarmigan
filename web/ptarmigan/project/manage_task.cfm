<cfmodule template="../security/require.cfm" type="project">

<cfquery name="get_employees" datasource="ptarmigan">
	SELECT 		* 
	FROM 		employees 
	ORDER BY 	last_name,first_name
</cfquery>

<cfset t = CreateObject("component", "ptarmigan.task").open(url.id)>
<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>


<cfif IsDefined("form.submit")>
	<cfset t.task_name = ucase(form.task_name)>
	<cfset t.description = ucase(form.description)>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.budget = form.budget>
	<cfif IsDefined("form.completed")>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	
	<cfset t.update()>
</cfif>

<h1>Manage Task</h1>
<cfoutput>
<a href="edit_project.cfm?id=#ms.project_id#">Return to project</a>
</cfoutput>
<br/>
<br/>
<br>
<cfoutput>
<form name="manage_task" action="manage_task.cfm?id=#url.id#" method="post">
	<table>
		<tr>
			<td>Task name:</td>
			<td>
				<input type="text" name="task_name" value="#t.task_name#" size="40"><br>
				<label><input type="checkbox" name="completed" <cfif t.completed EQ 1>checked</cfif>>Completed</label>
			</td>
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
			<td>Instructions:</td>
			<td>
				<textarea name="description" rows="6" cols="80">#t.description#</textarea>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right">
				<input type="submit" name="submit" value="Submit">
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<hr>

<h2>Assignments</h2>

<table border="1" width="100%" class="pretty">
	<tr>
		<th>EMPLOYEE</th>
		<th>TITLE</th>
		<th>ASSIGNMENTS</th>
	</tr>
	<cfoutput query="get_employees">
	<cfset t = CreateObject("component", "ptarmigan.employee").open(id)>
	<tr>
		<td>#t.full_name()#</td>
		<td>#t.title#</td>
		<td>
			<cfmodule template="employee_assignments.cfm" employee_id="#t.id#" task_id="#url.id#">
		</td>
	</tr>
	</cfoutput>
</table>