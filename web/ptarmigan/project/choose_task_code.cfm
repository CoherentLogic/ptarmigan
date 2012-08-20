<cfmodule template="../security/require.cfm" type="project">
<cfquery name="get_task_codes" datasource="ptarmigan">
	SELECT id FROM task_codes ORDER BY task_name
</cfquery>

<cfswitch expression="#url.action#">
	<cfcase value="edit">
		<cfset e_action="edit_task_code.cfm">
	</cfcase>
	<cfcase value="view">
		<cfset e_action="view_task_code.cfm">
	</cfcase>
</cfswitch>

<table width="100%" border="1">
	<tr>
		<th>TASK CODE</th>
		<th>TASK NAME</th>
		<th>UNIT TYPE</th>		
		<th>ACTIONS</th>
	</tr>	
	<cfoutput query="get_task_codes">

		<cfset t = CreateObject("component", "ptarmigan.task_code").open(id)>
		<form name="e_#id#" method="post" action="#e_action#">
		<input type="hidden" name="id" value="#t.id#">
		<tr>		
			<td>#t.task_code#&nbsp;</td>
			<td>#t.task_name#&nbsp;</td>
			<td>#t.unit_type#&nbsp;</td>		
			<td><input type="submit" name="submit_#t.id#" value="#ucase(url.action)#"></td>
		</tr>
		</form>
	</cfoutput>
	

</table>