<cfsilent>
	<cfmodule template="../security/require.cfm" type="project">
	<cfset project = CreateObject("component", "ptarmigan.project").open(url.project_id)>
	<cfquery name="get_constraints" datasource="#session.company.datasource#">
		SELECT * FROM task_constraints ORDER BY id
	</cfquery>
	<cfset tasks = project.tasks()>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Add Project - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		<script type="text/javascript">
			$(document).ready(function() {   
				init_page();
			});
		</script>
	</cfoutput>			
</head>
<body>

<cfif IsDefined("form.self_post")>
	
	<cfset data_valid = true>

	<cfif form.task_name EQ "">
		<cfset data_valid = false>
		<cfset task_name_error = "Task name is required">
	</cfif>
	
	<cfif len(form.task_name) GT 255>
		<cfset data_valid = false>
		<cfset task_name_error = "Must be 255 or fewer characters">
	</cfif>
	
	<cfif len(form.description) GT 1600>
		<cfset data_valid = false>
		<cfset description_error = "Must be 1600 or fewer characters">
	</cfif>
	
	<cfif not isnumeric(form.duration)>
		<cfset data_valid = false>
		<cfset duration_error = "Must be a positive number greater than zero">
	</cfif>
	
	<cfif isnumeric(form.duration)>
		<cfif form.duration LT 1>
			<cfset data_valid = false>
			<cfset duration_error = "Must be a positive number greater than zero">
		</cfif>
	</cfif>

	<cfif form.deadline NEQ "">
		<cfif not isdate(form.deadline)>
			<cfset data_valid = false>
			<cfset deadline_error = "Must be a valid date in the format MM/DD/YYYY">
		</cfif>
	</cfif>
			
	<cfif len(form.task_group) GT 255>
		<cfset data_valid = false>
		<cfset task_group_error = "Must be 255 or fewer characters">
	</cfif>
	
	<cfif form.constraint_date NEQ "">
		<cfif not isdate(form.constraint_date)>
			<cfset data_valid = false>
			<cfset constraint_date_error = "Must be a valid date in the format MM/DD/YYYY">
		</cfif>
	</cfif>
	
	<cfif not isnumeric(form.budget)>
		<cfset data_valid = false>
		<cfset budget_error = "Must be a number greater than zero">
	<cfelse>
		<cfif form.budget LT 0.01>
			<cfset data_valid = false>
			<cfset budget_error = "Must have a budget of at least one cent">
		</cfif>
	</cfif>
	
	
	
	<cfif data_valid EQ true>
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
		<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#t.id#" addtoken="false">	
	</cfif>		
</cfif>
<div class="form_wrapper">
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Task" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="add_task" id="add_task" action="#session.root_url#/project/add_task.cfm?project_id=#url.project_id#" method="post"></cfoutput>
			<div style="padding:20px; font-size:12pt; margin-top:20px;">				

				<table width="100%" style="margin-top:20px;">					
					<tr>		
						<td>Task name:</td>
						<td>
							<input type="text" name="task_name" <cfif isdefined("form.task_name")><cfoutput>	value="#form.task_name#"	</cfoutput></cfif>><br />
								<cfif IsDefined("task_name_error")>
									<cfoutput><span class="form_error">#task_name_error#</span></cfoutput><br/>
								</cfif>
							<label><input type="checkbox" name="completed">Completed</input></label>
						</td>
					</tr>
					<tr>
						<td>Duration (days):</td>
						<td><input type="text" name="duration" <cfif isdefined("form.duration")><cfoutput>	value="#form.duration#"	</cfoutput></cfif>><br />
								<cfif IsDefined("duration_error")>
									<cfoutput><span class="form_error">#duration_error#</span></cfoutput>
								</cfif>
						
						</td>
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
							<input class="pt_dates" type="text" name="constraint_date" <cfif isdefined("form.constraint_date")><cfoutput>	value="#form.constraint_date#"	</cfoutput></cfif>><br />
								<cfif IsDefined("constraint_date_error")>
									<cfoutput><span class="form_error">#constraint_date_error#</span></cfoutput>
								</cfif>
						</td>
					</tr>
					<tr>
						<td>Deadline:</td>
						<td>
							<input class="pt_dates" type="text" name="deadline" <cfif isdefined("form.deadline")><cfoutput>	value="#form.deadline#"	</cfoutput></cfif>><br />
								<cfif IsDefined("deadline_error")>
									<cfoutput><span class="form_error">#deadline_error#</span></cfoutput>
								</cfif>
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
							<input type="text" name="task_group" <cfif isdefined("form.task_group")><cfoutput>	value="#form.task_group#"	</cfoutput></cfif>><br />
								<cfif IsDefined("task_group_error")>
									<cfoutput><span class="form_error">#task_group_error#</span></cfoutput>
								</cfif>
						</td>
					</tr>
					<tr>
						<td>Budget:</td>
						<td>$<input type="text" name="budget"><br />
								<cfif IsDefined("budget_error")>
									<cfoutput><span class="form_error">#budget_error#</span></cfoutput>
								</cfif>
						</td>
					</tr>
					<tr>
						<td>Instructions:</td>
						<td><textarea name="description" rows="2" cols="40"><cfif isdefined("form.description")><cfoutput>#form.description#</cfoutput></cfif></textarea><br />
								<cfif IsDefined("description_error")>
									<cfoutput><span class="form_error">#description_error#</span></cfoutput>
								</cfif>
						</td>
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
		
		<div class="form_buttonstrip">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.history.go(-1);"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_task');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</div> <!--- form_wrapper --->
</body>
</html>