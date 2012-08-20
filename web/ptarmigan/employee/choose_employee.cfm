<cfmodule template="../security/require.cfm" type="">
<cfquery name="get_employees" datasource="ptarmigan">
	SELECT id FROM employees ORDER BY last_name,first_name
</cfquery>

<cfswitch expression="#url.action#">
	<cfcase value="edit">
		<cfset e_action="edit_employee.cfm">
	</cfcase>
	<cfcase value="view">
		<cfset e_action="view_employee.cfm">
	</cfcase>
</cfswitch>

<table width="100%" border="1">
	<tr>
		<th>EMPLOYEE FULL NAME</th>
		<th>JOB TITLE</th>
		<th>HIRE DATE</th>
		<th>STATUS</th>
		<th>ACTIONS</th>
	</tr>	
	<cfoutput query="get_employees">

		<cfset t = CreateObject("component", "ptarmigan.employee").open(id)>
		
		<cfif t.clocked_in EQ 1>
			<cfset ctcai = CreateObject("component", "ptarmigan.code_assign").open(t.clocked_task_code_asgn_id)>
			<cfset task_code = CreateObject("component", "ptarmigan.task_code").open(ctcai.task_code_id)>
			<cfset asgnm = CreateObject("component", "ptarmigan.assignment").open(ctcai.assignment_id)>
			<cfset task = CreateObject("component", "ptarmigan.task").open(asgnm.task_id)>
			<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(task.milestone_id)>
			<cfset project = CreateObject("component", "ptarmigan.project").open(milestone.project_id)>
		</cfif>
		<form name="e_#id#" method="post" action="#e_action#">
		<input type="hidden" name="id" value="#t.id#">
		<tr>		
			<td>#t.last_name#, #t.honorific# #t.first_name# #t.middle_initial# #t.suffix#</td>
			<td>#t.title#</td>
			<td>#dateFormat(t.hire_date, "mm/dd/yyyy")#</td>
			<td>
				
				<cfif t.clocked_in EQ 1>
					<strong>IN</strong><br>
					#task_code.task_name#: #project.project_name#<br>
					SINCE #dateFormat(t.clocked_timestamp, "MM/DD/YYYY")# #timeFormat(t.clocked_timestamp, "h:mm tt")#
					
				<cfelse>
					<strong>OUT</strong>
				</cfif>
			
			</td>
			<td><input type="submit" name="submit_#t.username#" value="#ucase(url.action)#"></td>
		</tr>
		</form>
	</cfoutput>
	

</table>