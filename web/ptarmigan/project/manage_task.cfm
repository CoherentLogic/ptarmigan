<!--- TODO: Update log-in requirements --->
<cfsilent>
	<cfset object =  CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset task = object.get()>
	<cfset total_budget_used = task.total_expenses()>
	<cfset percent_budget_used = int((total_budget_used * 100) / task.budget)>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfmodule template="#session.root_url#/security/require.cfm" type="">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!--- <cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab"> --->
	<cfoutput>	
		<title>#task.object_name()# - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("overflow", "hidden");
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
				$(".pt_buttons").button();								
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				$(".pt-table").dataTable({
        			"bJQueryUI": true,
        			"sPaginationType": "full_numbers"
				});
				$( "#percentage-complete").progressbar({
					<cfoutput>value: #task.percent_complete#</cfoutput>
				});
				$( "#budget-used").progressbar({
					<cfoutput>value: #percent_budget_used#</cfoutput>
				});
				$("#expenses-table").dataTable({
        			"bJQueryUI": true,
        			"sPaginationType": "full_numbers"
				});				
												
				<cfmodule template="#session.root_url#/project/gantt_render_script.cfm" id="#task.project().id#">
   		 });
	</script>
</head>
<body>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<cfoutput>
		<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="header">
			<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>#task.object_name()#</strong></h1></cfoutput></td>
				</tr>
				<tr>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick="add_expense('#session.root_url#', '#task.id#', 'tasks', '#task.id#');"><img src="#session.root_url#/images/add.png" align="absmiddle"> Expense</button>
						<button class="pt_buttons" onclick="add_document('#session.root_url#', '#task.id#', '#task.id#', 'OBJ_TASK');"><img src="#session.root_url#/images/add.png" align="absmiddle"> New Document</button>
						<cfif session.user.is_admin() EQ true>
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#url.id#');"><img src="#session.root_url#/images/trash.png" align="absmiddle"> Move to Trash</button>
						</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
		</div>	<!--- header --->
		<div id="tabs">
			<ul>
					<li><a href="#tabs-gantt">Gantt Chart</a></li>
					<li><a href="#tabs-paper">Task</a></li>					
			</ul>
			<div id="tabs-paper">
				<div id="left-column" class="panel">
					<h1>Task Details</h1>
					<p>
					<cfoutput>
					<table>
						<tbody>
						<tr>
							<td>Name:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="task_name" width="auto" show_label="false" full_refresh="false"></td>
							<td>Start date:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="start_date" width="auto" show_label="false" full_refresh="true">
							</td>
						</tr>
						<tr>
							<td>Project:</td>
							<td><a href="#session.root_url#/project/edit_project.cfm?id=#task.project().id#">#task.project().object_name()#</a></td>
							<td>End Date:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date" width="auto" show_label="false" full_refresh="true">
							</td>				
						</tr>										
						<tr>
							<td>Completed:</td>				
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="completed" width="auto" show_label="false" full_refresh="false"></td>
							<td>Color:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="color" width="auto" show_label="false" full_refresh="false">
							</td>
						</tr>
						<tr>
							<td>Constraint:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="constraint_id" width="auto" show_label="false" full_refresh="false"></td>
							<td>Task Group:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="task_group" width="auto" show_label="false" full_refresh="false"></td>
						</tr>
						<tr>
							<td>Constraint Date:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="constraint_date" width="auto" show_label="false" full_refresh="false"></td>
							<td>Deadline:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="deadline" width="auto" show_label="false" full_refresh="false"></td>
						</tr>
						<tr>
							<td>Duration:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="duration" width="auto" show_label="false" full_refresh="false"></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>

						</tbody>
					</table>
					</cfoutput>
					</p>
					
					
					<h1>Description</h1>
					<cfoutput><p><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="description" width="auto" show_label="false" full_refresh="false"></p></cfoutput>			
			
					<h1>Predecessors</h1>
					
					<cfset preds = task.predecessors()>
					<table class="pt-table">
						<thead>
							<tr>
								<th>Task</th>
								<th>Type</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#preds#" index="pred">
								<cfoutput>
									<tr>
										<td>#pred.task_name#</td>
										<td>Finish-to-start [FS]</td>
										<td width="10%"><button class="pt_buttons" onclick="delete_predecessor('#task.id#', '#pred.id#');">Delete</button></td>
									</tr>
									
									
								</cfoutput>
							</cfloop>
							
						</tbody>
					</table>
					<div style="margin-top:30px;">
					<select name="add_predecessor" id="add_predecessor">
						<cfloop array="#task.project().tasks()#" index="tsk">
							<cfif tsk.id NEQ task.id>
								<cfoutput><option value="#tsk.id#">#tsk.task_name#</option></cfoutput>
							</cfif>
						</cfloop>
					</select>
					<cfoutput><button class="pt_buttons" onclick="add_predecessor('#task.id#', $('##add_predecessor').val(), 'FS');">Add Predecessor</button></cfoutput>
					</div>
					<h1>Expenses</h1>
					<cfif ArrayLen(task.expenses()) EQ 0>
						<p><em>No expenses recorded for this task.</em></p>
					<cfelse>
						<table id="expenses-table">
							<thead>
								<th>Date</th>
								<th>Recipient</th>
								<th>Description</th>
								<th>Amount</th>
								<th>Actions</th>
							</thead>
							<tbody>
								<cfloop array="#task.expenses()#" index="expense">
									<tr>
									<cfoutput>
										<td>#dateFormat(expense.expense_date, "m/dd/yyyy")#</td>
										<td>#expense.recipient#</td>
										<td>#expense.description#</td>
										<td>#numberFormat(expense.amount, ",_$___.__")#</td>
										<td>&nbsp;</td>
									</cfoutput>
									</tr>
								</cfloop>
							</tbody>
						</table>
					</cfif>
					<br><br>
					<h1>Documents</h1>
					<cfif ArrayLen(object.get_associated_objects("OBJ_DOCUMENT")) EQ 0>
						<p><em>No documents associated with this task.</em></p>
					<cfelse>
						<p>
						<div style="overflow:hidden">
						<cfloop array="#object.get_associated_objects('OBJ_DOCUMENT')#" index="document">
							<cfoutput>
								<cfmodule template="#session.root_url#/documents/thumbnail.cfm" id="#document.get().id#">
							</cfoutput>
						</cfloop>
						</p>
						</div>
					</cfif>
					
					<h1>Edit History</h1>
					<cfif object.get_audits().recordcount EQ 0>
						<p><em>No edits associated with this task</em></p>
					<cfelse>
						<cfset aud_query = object.get_audits()>
						<cfoutput query="aud_query">
							<cfset emp = CreateObject("component", "ptarmigan.object").open(employee_id)>
							<div class="comment_box">
								<span style="font-size:10px;color:gray;">#dateFormat(edit_date, "full")# #timeFormat(edit_date, "h:mm tt")# C/O ##: #change_order_number#</span>
								
								<p><span style="color:##2957a2;">#emp.get().object_name()#</span> changed <strong>#member_name#</strong> from <strong>#original_value#</strong> to <strong>#new_value#</strong>
								<br><em>#comment#</em>
								</p>
								
								
							</div>
						</cfoutput>
					</cfif>
					
			
				</div>	<!--- left-column --->
				<div id="right-column" class="panel">
					<h1>Completion</h1>
					
					<div id="percentage-complete"></div>
					<center><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="percent_complete" width="auto" show_label="false" full_refresh="true"></center>
					
					<h1>Budget</h1>
					<div id="budget-used"></div>
					<center><cfoutput>#percent_budget_used#%</cfoutput> Spent</center>
					<br>
					Total Budget: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="budget" width="auto" show_label="false" full_refresh="true"><br>
					Total Expenses: <cfoutput>#numberFormat(task.total_expenses(), ",_$___.__")#</cfoutput>
					<br><br>
					<em>Note: these figures reflect only the current task.</em>
				</div>  <!--- right-column --->
			</div> <!--- paper --->
			<div id="tabs-gantt">				
				<cfmodule template="gantt.cfm" id="#task.project().id#">
			</div>
		</div> <!--- tabs --->
	</div> <!--- container --->

</body>

</html>
