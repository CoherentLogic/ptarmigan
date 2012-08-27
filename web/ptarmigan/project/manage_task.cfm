<cfmodule template="../security/require.cfm" type="project">

<cfquery name="get_employees" datasource="#session.company.datasource#">
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
	<cfif form.completed EQ 1>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	
	<cfset t.update()>
</cfif>

<div id="container">
<div id="header">	
	<h1>Manage Task</h1>
	<cfoutput>
	<a href="edit_project.cfm?id=#ms.project_id#">Return to project</a>
	</cfoutput>
</div>
<div id="navigation">
<cflayout type="accordion">
	<cflayoutarea title="PROPERTIES">
		<cfoutput>
		<form name="manage_task" action="manage_task.cfm?id=#url.id#" method="post">
			<table class="property_dialog" style="margin:0;padding:0;">
				<tr>
					<td>Task name</td>
					<td><input type="text" name="task_name" value="#t.task_name#" size="40"></td>
				</tr>
				<tr>
					<td>Status</td>
					<td>
						<select name="completed">
						<option value="0" <cfif t.completed EQ 0>selected</cfif>>Incomplete</option>
						<option value="1" <cfif t.completed EQ 1>selected</cfif>>Complete</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Start date</td>
					<td><input type="text" name="start_date" value="#dateFormat(t.start_date, 'mm/dd/yyyy')#"></td>
				</tr>
				<tr>
					<td>End date</td>
					<td><input type="text" name="end_date" value="#dateFormat(t.end_date, 'mm/dd/yyyy')#"></td>		
				</tr>			
				<tr>
					<td>Budget</td>
					<td><input type="text" name="budget" value="#t.budget#"></td>
				</tr>
				<tr>
					<td>Instructions:</td>
					<td>
						<textarea name="description" rows="6">#t.description#</textarea>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right">
						<input type="submit" name="submit" value="Save">
					</td>
				</tr>
			</table>
		</form>
		</cfoutput>
	</cflayoutarea>
</cflayout>
</div>
<div id="content">
<cflayout type="tab">
	<cflayoutarea title="Assignments">
		<table border="1" width="100%" class="pretty" style="margin:0px;">
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
	</cflayoutarea>
</cflayout>