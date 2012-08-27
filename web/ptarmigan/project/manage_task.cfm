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
	<cfset t.end_date_pessimistic = CreateODBCDate(form.end_date_pessimistic)>
	<cfset t.end_date_optimistic = CreateODBCDate(form.end_date_optimistic)>
	<cfset t.color = form.color>
	<cfset t.budget = form.budget>
	<cfif form.completed EQ 1>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	<cfset t.percent_complete = form.percent_complete>
	
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
					<td>% Complete</td>
					<td>
						<input type="text" name="percent_complete" value="#t.percent_complete#">
					</td>		
				</tr>
				<tr>
					<td>Start date</td>
					<td><input type="text" name="start_date" value="#dateFormat(t.start_date, 'mm/dd/yyyy')#"></td>
				</tr>
				<tr>
					<td nowrap>End date (norm.)</td>
					<td><input type="text" name="end_date" value="#dateFormat(t.end_date, 'mm/dd/yyyy')#"></td>		
				</tr>			
				<tr>
					<td>End date (pess.)</td>
					<td><input type="text" name="end_date_pessimistic" value="#dateFormat(t.end_date_pessimistic, 'mm/dd/yyyy')#"></td>		
				</tr>			
				<tr>
					<td>End date (opt.)</td>
					<td><input type="text" name="end_date_optimistic" value="#dateFormat(t.end_date_optimistic, 'mm/dd/yyyy')#"></td>		
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
				<td>Color:</td>
				<td>
					<select name="color">
						<option value="aqua" <cfif t.color EQ "aqua">selected</cfif>>Aqua</option>
						<option value="black" <cfif t.color EQ "black">selected</cfif>>Black</option>
						<option value="blue" <cfif t.color EQ "blue">selected</cfif>>Blue</option>
						<option value="fuchsia" <cfif t.color EQ "fuchsia">selected</cfif>>Fuchsia</option>
						<option value="gray" <cfif t.color EQ "gray">selected</cfif>>Gray</option>
						<option value="green" <cfif t.color EQ "green">selected</cfif>>Green</option>
						<option value="lime" <cfif t.color EQ "lime">selected</cfif>>Lime</option>
						<option value="maroon" <cfif t.color EQ "maroon">selected</cfif>>Maroon</option>
						<option value="navy" <cfif t.color EQ "navy">selected</cfif>>Navy</option>
						<option value="olive" <cfif t.color EQ "olive">selected</cfif>>Olive</option>
						<option value="purple" <cfif t.color EQ "purple">selected</cfif>>Purple</option>
						<option value="red" <cfif t.color EQ "red">selected</cfif>>Red</option>
						<option value="silver" <cfif t.color EQ "silver">selected</cfif>>Silver</option>
						<option value="teal" <cfif t.color EQ "teal">selected</cfif>>Teal</option>
						<option value="yellow" <cfif t.color EQ "yellow">selected</cfif>>Yellow</option>
						<option value="pink" <cfif t.color EQ "pink">selected</cfif>>Pink</option>
						<option value="orange" <cfif t.color EQ "orange">selected</cfif>>Orange</option>
						<option value="brown" <cfif t.color EQ "brown">selected</cfif>>Brown</option>
						<option value="turquoise" <cfif t.color EQ "turquoise">selected</cfif>>Turquoise</option>
						<option value="plum" <cfif t.color EQ "plum">selected</cfif>>Plum</option>
						<option value="cyan" <cfif t.color EQ "cyan">selected</cfif>>Cyan</option>
						<option value="SteelBlue" <cfif t.color EQ "SteelBlue">selected</cfif>>Steel Blue</option>
					</select>
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