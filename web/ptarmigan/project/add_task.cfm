<div style="padding:20px;">
<cfmodule template="../security/require.cfm" type="project">


<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(url.milestone_id)>


<cfif IsDefined("form.set_milestone")>
	<cfset ms = CreateObject("component", "ptarmigan.milestone").open(url.milestone_id)>
	<cfset p = CreateObject("component", "ptarmigan.project").open(url.id)>
	<cfset p.current_milestone = ms.milestone_number>
	<cfset p.update()>
	
	
</cfif>

<cfif IsDefined("form.submit_add")>
	<cfset t = CreateObject("component", "ptarmigan.task")>
	
	<cfset t.task_name = form.task_name>
	<cfset t.description = form.description>
	<cfset t.milestone_id = form.milestone_id>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.end_date_pessimistic = CreateODBCDate(form.end_date_pessimistic)>
	<cfset t.end_date_optimistic = CreateODBCDate(form.end_date_optimistic)>
	<cfset t.color = form.color>

	<cfset t.budget = form.budget>
	
	<cfif IsDefined("form.completed")>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	
	<cfset t.create()>
	
	<h1>Reloading page...</h1>
	
<cfelse>
	<h3>Add task to <cfoutput>#milestone.milestone_name#</cfoutput></h3>
	<cfif milestone.floating EQ 0>
		<cfoutput><p><em>Milestone date range: #dateformat(milestone.start_date, 'm/dd/yyyy')#-#dateFormat(milestone.end_date, 'm/dd/yyyy')#</em></p></cfoutput>
	<cfelse>
		<p><em>This is a floating milestone. Start and end dates will not be available for this task.</em></p>
	</cfif>
	<cfform name="add_task" method="post" action="add_task.cfm?id=#url.id#&milestone_id=#url.milestone_id#&suppress_headers" onsubmit="window.location.reload();">
	<cfoutput>
	<input type="hidden" name="milestone_id" value="#url.milestone_id#">
	</cfoutput>
	
	<table>
		<tr>
			<td>Task name:</td>
			<td>
				<cfinput type="text" name="task_name"><br>
				<label><input type="checkbox" name="completed">Completed</input></label>
			</td>
		</tr>
		<cfif milestone.floating EQ 0>
			<tr>
				<td>Start date:</td>
				<td><cfinput type="datefield" name="start_date"></td>
			</tr>
			<tr>
				<td>End date (normal):</td>
				<td><cfinput type="datefield" name="end_date"></td>		
			</tr>
			<tr>
				<td>End date (pessimistic):</td>
				<td><cfinput type="datefield" name="end_date_pessimistic"></td>		
			</tr>
			<tr>
				<td>End date (optimistic):</td>
				<td><cfinput type="datefield" name="end_date_optimistic"></td>		
			</tr>			
		<cfelse>
			<input type="hidden" name="start_date" value="#dateFormat(today, ''mm/dd/yyyy')#">
			<input type="hidden" name="end_date" value="#dateFormat(today, ''mm/dd/yyyy')#">
			<input type="hidden" name="end_date_pessimistic" value="#dateFormat(today, ''mm/dd/yyyy')#">
			<input type="hidden" name="end_date_optimistic" value="#dateFormat(today, ''mm/dd/yyyy')#">
		</cfif>			
		<tr>
			<td>Budget:</td>
			<td>$<cfinput type="text" name="budget"></td>
		</tr>
		<tr>
			<td>Instructions:</td>
			<td><textarea name="description" rows="5" cols="40"></textarea></td>
		</tr>
		<tr>
			<td>Color:</td>
			<td>
				<select name="color">
					<option value="aqua">Aqua</option>
					<option value="black">Black</option>
					<option value="blue">Blue</option>
					<option value="fuchsia">Fuchsia</option>
					<option value="gray">Gray</option>
					<option value="green">Green</option>
					<option value="lime">Lime</option>
					<option value="maroon">Maroon</option>
					<option value="navy">Navy</option>
					<option value="olive">Olive</option>
					<option value="purple">Purple</option>
					<option value="red">Red</option>
					<option value="silver">Silver</option>
					<option value="teal">Teal</option>
					<option value="yellow">Yellow</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right">
				<input type="submit" name="submit_add" value="Apply">
				<input type="button" value="Cancel" onclick="window.location.reload()">
			</td>
		</tr>
		
	</table>			
	</cfform>	

</cfif>
</div>