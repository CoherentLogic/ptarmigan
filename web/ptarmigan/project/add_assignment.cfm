<cfmodule template="../security/require.cfm" type="project">

<cfset e = CreateObject("component", "ptarmigan.employee").open(url.employee_id)>
<cfset t = CreateObject("component", "ptarmigan.task").open(url.task_id)>

<cfif IsDefined("form.submit_assignment")>
	<cfset a = CreateObject("component", "ptarmigan.assignment")>
	
	<cfset a.employee_id = url.employee_id>
	<cfset a.task_id = url.task_id>
	<cfset a.start_date = CreateODBCDate(form.start_date)>
	<cfset a.end_date = CreateODBCDate(form.end_date)>
	<cfset a.instructions = form.instructions>
	<cfset a.address = form.address>
	<cfset a.city = form.city>
	<cfset a.state = form.state>
	<cfset a.zip = form.zip>
	<cfset a.latitude = form.latitude>
	<cfset a.longitude = form.longitude>
	<cfset a.location_preference = form.location_preference>
	
	<cfset a.create()>
	<cfset session.message = "Created an assignment">
	<cfquery name="get_task_codes" datasource="#session.company.datasource#">
		SELECT id FROM task_codes ORDER BY task_name
	</cfquery>
	
	<cfset tc = ArrayNew(1)>
	
	<cfoutput query="get_task_codes">
		<cfset t = CreateObject("component", "ptarmigan.task_code").open(id)>
		<cfset ArrayAppend(tc, t)>
	</cfoutput>
	
	<h1>Select Task Codes</h1>
	<p><em>Only the task codes you select here will be available for time cards recorded against this assignment.</em></p>
	
	<cfoutput>
	<form name="select_task_codes" action="add_assignment.cfm?employee_id=#url.employee_id#&task_id=#url.task_id#&assignment_id=#a.id#" method="post">
	</cfoutput>
	<table border="1" width="100%" class="pretty">
		<tr>
			<th>SELECT</th>
			<th>TASK CODE</th>
			<th>NAME</th>
			<th>RATE</th>
			<th>UNIT TYPE</th>
			<th>BILLABLE</th>
		</tr>
		<cfloop array="#tc#" index="c_tc">
		<cfoutput>
		<cfset field_name = Replace(c_tc.id, "-", "_", "all")>
		<tr>
			<td><input type="checkbox" name="selected_codes" value="#field_name#"></td>
			<td>#c_tc.task_code#</td>
			<td>#c_tc.task_name#</td>
			<td>
				BILLED TO CUSTOMER: <input type="text" name="rate_#field_name#"><br>
				PAID TO EMPLOYEE: <input type="text" name="employee_rate_#field_name#"></td>
			</td>
			<td>#c_tc.unit_type#</td>
			<td><input type="checkbox" name="billable" value="#field_name#"></td>
		</tr>
		</cfoutput>
		</cfloop>
	</table>
	<input type="submit" name="submit_codes" value="Submit">
	</form>
	
	
<cfelseif IsDefined("form.submit_codes")>

	
	
	<cfset selected_codes = ListToArray(form.selected_codes)>

	<cfloop array="#selected_codes#" index="code">

		<cfset real_code = replace(code, "_", "-", "all")>
				
		<cfset rate_field = "form.rate_#code#">
		<cfset rate_value = evaluate(rate_field)>			
		
		<cfset employee_rate_field = "form.employee_rate_#code#">	
		<cfset employee_rate_value = evaluate(employee_rate_field)>
		
		<cfif IsDefined("form.billable")>
			<cfset bill = ListToArray(form.billable)>				
			
			<cfloop array="#bill#" index="b">
				<cfif b EQ code>
					<cfset billable = 1>
					<cfbreak>
				<cfelse>
					<cfset billable = 0>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset billable = 0>
		</cfif>
		
		<cfset ca = CreateObject("component", "ptarmigan.code_assign")>
		
		<cfset ca.task_code_id = real_code>
		<cfset ca.assignment_id = url.assignment_id>
		<cfset ca.rate = rate_value>
		<cfset ca.employee_rate = employee_rate_value>
		<cfset ca.billable = billable>
		
		<cfset ca.create()>
		
		
		<cfset billable = 1>
				
		
	</cfloop>
	
	<cfset asgn = CreateObject("component","ptarmigan.assignment").open(url.assignment_id)>
	<cfset task = CreateObject("component", "ptarmigan.task").open(asgn.task_id)>
	<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(task.milestone_id)>
	
	<cfset session.message = "Assignment created for " & e.full_name()>
	
	
	<cfoutput>
	<center>
		<h1>Assignment Created</h1>
		<a href="edit_project.cfm?id=#milestone.project_id#">Return to project</a>
	</center>
	</cfoutput>
	
	<cflocation url="edit_project.cfm?id=#milestone.project_id#">
<cfelse>
	<h1>Add Assignment</h1>
	
	<cfoutput>
	<form name="add_assignment" action="add_assignment.cfm?employee_id=#url.employee_id#&task_id=#url.task_id#" method="post">
	
		<table>
			<tr>
				<td>Employee:</td>
				<td>#e.last_name#, #e.honorific# #e.first_name# #e.middle_initial# #e.suffix# (#e.title#)</td>
			</tr>
			<tr>
				<td>Task:</td>
				<td>#t.task_name#</td>
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
				<td>Instructions to employee:</td>
				<td><textarea name="instructions" rows="10" cols="50"></textarea></td>
			</tr>
			<tr>
				<td>Street address:</td>
				<td><input type="text" name="address"></td>
			</tr>
			<tr>
				<td>City:</td>
				<td><input type="text" name="city"></td>
			</tr>
			<tr>
				<td>State:</td>
				<td><input type="text" name="state" size="2" maxlength="2"></td>
			</tr>
			<tr>
				<td>ZIP:</td>
				<td><input type="text" name="zip" size="5" maxlength="5"></td>
			</tr>
			<tr>
				<td>Latitude:</td>
				<td><input type="text" name="latitude"></td>
			</tr>
			<tr>
				<td>Longitude:</td>
				<td><input type="text" name="longitude"></td>
			</tr>
			<tr>
				<td>Location preference:</td>
				<td>
					<select name="location_preference">
						<option value="0">Street address</option>
						<option value="1">Latitude, Longitude</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="right">
					<input type="submit" name="submit_assignment" value="Submit">
				</td>
			</tr>
		</table>				
	</form>
	</cfoutput>
</cfif>