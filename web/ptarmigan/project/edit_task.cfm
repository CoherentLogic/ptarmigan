<cfmodule template="../security/require.cfm" type="project">

<cfset t = CreateObject("component", "ptarmigan.task").open(url.id)>
<cfset ms = CreateObject("component", "ptarmigan.milestone").open(url.milestone_id)>

<cfif IsDefined("form.submit")>	
	
	<cfif (t.start_date NEQ CreateODBCDate(form.start_date)) OR
		  (t.end_date NEQ CreateODBCDate(form.end_date)) OR
		  (t.end_date_optimistic NEQ CreateODBCDate(form.end_date_optimistic)) OR
		  (t.end_date_pessimistic NEQ CreateODBCDate(form.end_date_pessimistic))>
		<cfset a = CreateObject("component", "ptarmigan.audit")>
		<cfset a.employee_id = session.user.id>
		<cfset a.table_name = "tasks">
		<cfset a.table_id = url.id>
		<cfset a.change_order_number = form.change_order_number>
		<cfset a.comment = form.comment>
		
		<cfset cr = "">
		<cfif t.start_date NEQ CreateODBCDate(form.start_date)>
			<cfset cr = cr & "<br>START DATE CHANGED FROM " & dateFormat(t.start_date, "mm/dd/yyyy") & " TO " & form.start_date>
		</cfif>
		<cfif t.end_date NEQ CreateODBCDate(form.end_date)>
			<cfset cr = cr & "<br>END DATE (NORMAL) CHANGED FROM " & dateFormat(t.end_date, "mm/dd/yyyy") & " TO " & form.end_date>
		</cfif>
		<cfif t.end_date_pessimistic NEQ CreateODBCDate(form.end_date_pessimistic)>
			<cfset cr = cr & "<br>END DATE (PESSIMISTIC) CHANGED FROM " & dateFormat(t.end_date_pessimistic, "mm/dd/yyyy") & " TO " & form.end_date_pessimistic>
		</cfif>
		<cfif t.end_date_optimistic NEQ CreateODBCDate(form.end_date_optimistic)>
			<cfset cr = cr & "<br>END DATE (OPTIMISTIC) CHANGED FROM " & dateFormat(t.end_date_optimistic, "mm/dd/yyyy") & " TO " & form.end_date_optimistic>
		</cfif>

		<cfset a.what_changed = cr>		
		
		<cfset a.create()>
	</cfif>
	
	<cfset t.task_name = ucase(form.task_name)>
	<cfset t.description = ucase(form.description)>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.end_date_pessimistic = CreateODBCDate(form.end_date_pessimistic)>
	<cfset t.end_date_optimistic = CreateODBCDate(form.end_date_optimistic)>
	<cfset t.milestone_id = form.milestone_id>
	<cfset t.color = form.color>
	<cfset t.budget = form.budget>
	
	<cfif IsDefined("form.completed")>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	<cfset t.percent_complete = form.percent_complete>
	
	<cfset t.update()>
<cfelse>
	<cfquery name="get_milestones" datasource="#session.company.datasource#">
		SELECT * FROM milestones WHERE project_id='#ms.project_id#' ORDER BY milestone_number
	</cfquery>
	
	<div style="padding:20px;">
		<cfform name="edit_task" action="edit_task.cfm?id=#url.id#&milestone_id=#url.milestone_id#&suppress_headers" method="post" >
			<cflayout type="tab">
				<cflayoutarea title="Task">
					<table>
						<tr>
							<td>Task name:</td>
							<td>
								<cfinput type="text" name="task_name" value="#t.task_name#"><br>
								<label><input type="checkbox" name="completed" <cfif t.completed EQ 1>checked</cfif>>Completed</label>
							</td>
						</tr>
						<tr>
							<td>Percent complete:</td>
							<td><cfinput type="text" name="percent_complete" value="#t.percent_complete#"></td>
						</tr>
						<tr>
							<td>Milestone:</td>
							<td>
								<select name="milestone_id">
									<cfoutput query="get_milestones">
										<option value="#id#" <cfif id EQ t.milestone_id>selected</cfif>>#milestone_name#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td>Description:</td>
							<td><textarea name="description"><cfoutput>#t.description#</cfoutput></textarea></td>
						</tr>
						<tr>
							<td>Start date:</td>
							<td><cfinput type="datefield" name="start_date" value="#t.start_date#"></td>
						</tr>
						<tr>
							<td>End date (normal):</td>
							<td><cfinput type="datefield" name="end_date" value="#t.end_date#"></td>
						</tr>
						<tr>
							<td>End date (pessimistic):</td>
							<td><cfinput type="datefield" name="end_date_pessimistic" value="#t.end_date_pessimistic#"></td>
						</tr>
						<tr>
							<td>End date (optimistic):</td>
							<td><cfinput type="datefield" name="end_date_optimistic" value="#t.end_date_optimistic#"></td>
						</tr>
						<tr>
							<td>Budget:</td>
							<td>$<cfinput type="text" name="budget" value="#t.budget#"></td>
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
								</select>
							</td>
						</tr>					
					</table>
				</cflayoutarea>
				<cflayoutarea title="Auditing">
					<div style="height:370px;padding:10px;">
						<table>
							<tr>
								<td>Employee:</td>
								<td><cfoutput>#session.user.full_name()#</cfoutput></td>
							</tr>
							<tr>
								<td>Change order #:</td>
								<td><cfinput type="text" name="change_order_number"></td>
							</tr>
							<tr>
								<td>Comments:</td>
								<td><textarea rows="5" cols="40" name="comment"></textarea></td>
							</tr>
						</table>
					</div>
				</cflayoutarea>
			</cflayout>
			<input type="submit" name="submit" value="Apply">
			<input type="button" name="cancel" value="Cancel" onclick="window.location.reload();">
		</cfform>
	</div>
</cfif>

