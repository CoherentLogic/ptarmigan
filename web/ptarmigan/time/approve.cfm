<cfmodule template="../security/require.cfm" type="time">

<cfif IsDefined("form.submit")>
	<cfset entries_to_approve = ListToArray(form.approve)>
	
	<cfloop array="#entries_to_approve#" index="entry">
		<cfset te = CreateObject("component", "ptarmigan.time_entry").open(entry)>
		<cfif form.select_action EQ "approve">
			<cfset te.approve(session.user.id)>
		<cfelse>
			<cfset te.deny(session.user.id)>
		</cfif>
	</cfloop>
	
	<cfif form.select_action EQ "approve">
		<cfoutput><p>You have <strong>approved</strong> #ArrayLen(entries_to_approve)# time entries.</p></cfoutput>
	<cfelse>
		<cfoutput><p>You have <strong>denied</strong> #ArrayLen(entries_to_approve)# time entries.</p></cfoutput>
	</cfif>
	
</cfif>

<cfquery name="get_time_entries" datasource="ptarmigan">
	SELECT  id 
	FROM 	time_entries 
	WHERE	approved=0
	ORDER BY start_time
</cfquery>

<cfif get_time_entries.RecordCount GT 0>
<form name="approve_time" action="approve.cfm" method="post">
<label>Selection Action: 
<select name="select_action">
	<option value="approve" selected>Approve</option>
	<option value="deny">Deny</option>
</select>
</label>
<table width="100%" border="1">
	<tr>
		<th></th>
		<th>EMPLOYEE</th>
		<th>PROJECT</th>
		<th>MILESTONE</th>
		<th>SUBTASK</th>
		<th>TASK CODE</th>
		<th>START TIME</th>
		<th>END TIME</th>
		<th>HOURS</th>
		<th>BILL</th>
		<th>PAY</th>
	</tr>			
	<cfoutput query="get_time_entries">
		<cfset te = CreateObject("component", "ptarmigan.time_entry").open(get_time_entries.id)>
		<cfset tca = CreateObject("component", "ptarmigan.code_assign").open(te.task_code_assignment_id)>
		<cfset asgn = CreateObject("component", "ptarmigan.assignment").open(tca.assignment_id)>
		<cfset task_code = CreateObject("component", "ptarmigan.task_code").open(tca.task_code_id)>
		<cfset task = CreateObject("component", "ptarmigan.task").open(asgn.task_id)>
		<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(task.milestone_id)>
		<cfset project = CreateObject("component", "ptarmigan.project").open(milestone.project_id)>
		<cfset emp = CreateObject("component", "ptarmigan.employee").open(asgn.employee_id)>
		
		<cfset hours = te.hours_decimal()>
		
		<cfset emp_rate = tca.employee_rate>
		<cfset bill_rate = tca.rate>
		
		<cfset current_pay = emp_rate * hours>
		<cfset current_bill = bill_rate * hours>
		
		<tr>
			<td><input type="checkbox" name="approve" value="#id#"></td>
			<td>#emp.last_name#, #emp.honorific# #emp.first_name# #emp.middle_initial# #emp.suffix#</td>
			<td>#project.project_name#</td>
			<td>#milestone.milestone_name#</td>
			<td>#task.task_name#</td>
			<td>#task_code.task_name#</td>
			<td>#DateFormat(te.start_time, "M/DD/YYYY")# #te.RoundTo15(te.start_time)#</td>
			<td>#DateFormat(te.end_time, "M/DD/YYYY")# #te.RoundTo15(te.end_time)#</td>
			<td>#te.hours_decimal()#</td>
			<td>$#current_bill#</td>
			<td>$#current_pay#</td>
		</tr>
			
		
	</cfoutput>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td align="right">
			<input type="submit" name="submit" value="Submit">
		</td>
</table>
</form>
<cfelse>
	<p><em>There are no outstanding time entries to be processed.</em></p>
</cfif>