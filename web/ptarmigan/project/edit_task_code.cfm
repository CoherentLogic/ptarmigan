<cfmodule template="../security/require.cfm" type="project">

<cfset t = CreateObject("component", "ptarmigan.task_code").open(form.id)>

<cfif IsDefined("form.submit")>
	<cfset t.task_code = form.task_code>
	<cfset t.task_name = form.task_name>
	<cfset t.unit_type = form.unit_type>
	
	<cfset t.update()>
	
	<p><em>Changes have been saved.</em></p>
</cfif>

<h1>Edit Task Code</h1>

<cfoutput>
<form name="edit_task_code" action="edit_task_code.cfm" method="post">
<input type="hidden" name="id" value="#form.id#">
	<table>
		<tr>
			<td>Task code:</td>
			<td><input type="text" name="task_code" value="#t.task_code#"></td>
		</tr>
		<tr>
			<td>Name:</td>
			<td><input type="text" name="task_name" value="#t.task_name#"></td>
		</tr>
		<tr>
			<td>Charge per:</td>
			<td>
				<select name="unit_type">
					<option value="HOUR" <cfif t.unit_type EQ "HOUR">selected</cfif>>Hour</option>
					<option value="DAY" <cfif t.unit_type EQ "DAY">selected</cfif>>Day</option>
					<option value="WEEK" <cfif t.unit_type EQ "WEEK">selected</cfif>>Week</option>
					<option value="MONTH" <cfif t.unit_type EQ "MONTH">selected</cfif>>Month</option>
					<option value="YEAR" <cfif t.unit_type EQ "YEAR">selected</cfif>>Year</option>
					<option value="QUARTER" <cfif t.unit_type EQ "QUARTER">selected</cfif>>Quarter</option>
					<option value="SHEET" <cfif t.unit_type EQ "SHEET">selected</cfif>>Sheet</option>
					<option value="JOB" <cfif t.unit_type EQ "JOB">selected</cfif>>Job</option>
					<option value="LINE" <cfif t.unit_type EQ "LINE">selected</cfif>>Line</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><input type="submit" name="submit" value="Submit"></td>
		</tr>
	</table>
</form>
</cfoutput>