<cfmodule template="../security/require.cfm" type="project">

<cfif IsDefined("form.submit")>
	<cfset tc = CreateObject("component", "ptarmigan.task_code")>
	
	<cfset tc.task_code = form.task_code>
	<cfset tc.task_name = form.task_name>
	<cfset tc.unit_type = form.unit_type>
	
	<cfset tc.create()>
	
	<center>
		<h1>Task Code Created</h1>
		<a href="../right.cfm">My Dashboard</a>
	</center>
	
<cfelse>
	<h1>Add Task Code</h1>
	<form name="add_task_code" action="add_task_code.cfm" method="post">	
	<table>
		<tr>
			<td>Task code:</td>
			<td><input type="text" name="task_code"></td>
		</tr>
		<tr>
			<td>Name:</td>
			<td><input type="text" name="task_name"></td>
		</tr>
		<tr>
			<td>Charge per:</td>
			<td>
				<select name="unit_type">
					<option value="HOUR">Hour</option>
					<option value="DAY">Day</option>
					<option value="WEEK">Week</option>
					<option value="MONTH">Month</option>
					<option value="YEAR">Year</option>
					<option value="QUARTER">Quarter</option>
					<option value="SHEET">Sheet</option>
					<option value="JOB">Job</option>
					<option value="LINE">Line</option>
				</select>
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
</cfif>