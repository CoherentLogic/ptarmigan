<cfsilent>
	<cfmodule template="../security/require.cfm" type="project">
	<cfset project = CreateObject("component", "ptarmigan.project").open(url.project_id)>
</cfsilent>
<cfquery name="get_constraints" datasource="#session.company.datasource#">
	SELECT * FROM task_constraints ORDER BY id
</cfquery>
<cfset tasks = project.tasks()>
<cfif IsDefined("form.self_post")>
	
	<cfset t = CreateObject("component", "ptarmigan.task")>
	
	<cfset t.task_name = form.task_name>
	<cfset t.description = form.description>
	<cfset t.project_id = url.project_id>
	<cfset t.duration = form.duration>
	<cfset t.constraint_id = form.constraint_id>
	<cfset t.deadline = CreateODBCDate(form.deadline)>
	<cfset t.task_group = form.task_group>
	<cfset t.scheduled = 0>
	<cfset t.constraint_date = CreateODBCDate(form.constraint_date)>
	<cfset t.color = form.color>
	<cfset t.budget = form.budget>
	
	<cfif IsDefined("form.completed")>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>
	
	<cfset t.create()>
	<cfset t.add_predecessor(form.predecessor)>
	
	<cflocation url="#session.root_url#/project/manage_task.cfm?id=#t.id#" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Task" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="add_task" id="add_task" action="#session.root_url#/project/add_task.cfm?project_id=#url.project_id#" method="post"></cfoutput>
			<div style="padding:20px; font-size:12pt; margin-top:20px;">				

				<table width="100%" style="margin-top:20px;">					
					<tr>		
						<td>Task name:</td>
						<td>
							<input type="text" name="task_name"><br>
							<label><input type="checkbox" name="completed">Completed</input></label>
						</td>
					</tr>
					<tr>
						<td>Duration (days):</td>
						<td><input type="text" name="duration"></td>
					</tr>
					<tr>
						<td>Weekends:</td>
						<td><label><input type="checkbox" name="exclude_weekends" id="exclude_weekends">Exclude weekends from task duration</label></td>
					</tr>
					<tr>
						<td>Constrain task:</td>
						<td>
							<select name="constraint_id">
								<cfoutput query="get_constraints">
									<option value="#id#">#constraint_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td>Constraint date:</td>
						<td>
							<input type="text" name="constraint_date">
						</td>
					</tr>
					<tr>
						<td>Deadline:</td>
						<td>
							<input type="text" name="deadline">
						</td>
					</tr>
					<tr>
						<td>Predecessor:</td>
						<td>
							<select name="predecessor" autocomplete="off">
								<option value="" selected="selected">Project start</option>
								<cfloop array="#tasks#" index="t">									
									<cfoutput>
										<option value="#t.id#">#t.task_name#</option>
									</cfoutput>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td>Task group:</td>
						<td>
							<input type="text" name="task_group">
						</td>
					</tr>
					<tr>
						<td>Budget:</td>
						<td>$<input type="text" name="budget"></td>
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
								<option value="gray" selected="selected">Gray</option>
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
		</form>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_task');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>