<cfsilent>
	<cfmodule template="../security/require.cfm" type="project">
	<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(url.milestone_id)>
</cfsilent>
<cfif IsDefined("form.self_post")>
	
	<cfset t = CreateObject("component", "ptarmigan.task")>
	
	<cfset t.task_name = form.task_name>
	<cfset t.description = form.description>
	<cfset t.milestone_id = url.milestone_id>
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
	
	<cflocation url="#session.root_url#/project/edit_project.cfm?id=#t.project().id#" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Task" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="add_task" id="add_task" action="#session.root_url#/project/add_task.cfm?id=#url.id#&milestone_id=#url.milestone_id#" method="post">
			<div style="padding:20px; font-size:12pt;">				
				<cfset proposed_start_date = dateAdd("d", 1, milestone.last_task_end_date())>
				<cfif milestone.floating EQ 0>
					<cfoutput><p><em>Milestone date range: #dateformat(milestone.start_date, 'm/dd/yyyy')#-#dateFormat(milestone.end_date, 'm/dd/yyyy')#</em></p></cfoutput>
					<p><em>Last entered task had an end date of <cfoutput>#dateFormat(milestone.last_task_end_date(), 'm/dd/yyyy')#</cfoutput></em></p>
				<cfelse>
					<p><em>This is a floating milestone. Start and end dates will not be available for this task.</em></p>
				</cfif>
				
				
				<table style="margin-top:20px;">
					<tr>
						<td>Milestone:</td>
						<td><cfoutput>#milestone.milestone_name#</cfoutput></td>
					</tr>
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
							<td><cfinput type="datefield" size="10" name="start_date" id="start_date" value="#proposed_start_date#"></td>
						</tr>
						<tr>
							<td>End date (normal):</td>
							<td>
								<label>Days from start: <cfinput type="text" size="3" name="end_date_days" id="end_date_days" onblur="add_days('#session.root_url#', 'start_date', 'end_date', 'end_date_days')"></label>
								<label><cfinput type="datefield" size="10" name="end_date" id="end_date"></label>
								
							</td>		
						</tr>
						<tr>
							<td>End date (pessimistic):</td>
							<td>
								<label>Days from start: <cfinput type="text" size="3" name="end_date_days_pessimistic" id="end_date_days_pessimistic" onblur="add_days('#session.root_url#', 'start_date', 'end_date_pessimistic', 'end_date_days_pessimistic')"></label>
								<cfinput type="datefield" size="10" id="end_date_pessimistic" name="end_date_pessimistic"></td>		
						</tr>
						<tr>
							<td>End date (optimistic):</td>
							<td>
								<label>Days from start: <cfinput type="text" size="3" name="end_date_days_optimistic" id="end_date_days_optimistic" onblur="add_days('#session.root_url#', 'start_date', 'end_date_optimistic', 'end_date_days_optimistic')"></label>
								<cfinput type="datefield" size="10" id="end_date_optimistic" name="end_date_optimistic"></td>		
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
						<td><textarea name="description" rows="2" cols="40"></textarea></td>
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
				</table>						
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_task');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>