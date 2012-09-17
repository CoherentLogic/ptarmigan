<!--- TODO: Update log-in requirements --->
<cfsilent>
	<cfset object =  CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset milestone = object.get()>
	<cfset total_budget_used = milestone.total_expenses()>
	<cfset percent_budget_used = int((total_budget_used * 100) / milestone.budget)>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfmodule template="#session.root_url#/security/require.cfm" type="">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!--- <cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab"> --->
	<cfoutput>	
		<title>#milestone.object_name()# - ptarmigan</title>		
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
				$( "#percentage-complete").progressbar({
					<cfoutput>value: #milestone.percent_complete#</cfoutput>
				});
				$( "#budget-used").progressbar({
					<cfoutput>value: #percent_budget_used#</cfoutput>
				});
				$("#expenses-table").dataTable({
        			"bJQueryUI": true,
        			"sPaginationType": "full_numbers"
				});
				<cfoutput>
				$("##normal").click(function () {
					render_gantt('#session.root_url#', '#milestone.project().id#', 'normal')	
				});			
				$("##optimistic").click(function () {
					render_gantt('#session.root_url#', '#milestone.project().id#', 'optimistic')	
				});			
				$("##pessimistic").click(function () {
					render_gantt('#session.root_url#', '#milestone.project().id#', 'pessimistic')	
				});			
				$("##estimated").click(function () {
					render_gantt('#session.root_url#', '#milestone.project().id#', 'estimated')	
				});			
				</cfoutput>
				$("#view").buttonset();
				
				
				
				<cfoutput>render_gantt('#session.root_url#', '#milestone.project().id#', 'normal');</cfoutput>
   		 });
	</script>
</head>
<body>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="header">
			<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>#milestone.object_name()#</strong></h1></cfoutput></td>
				</tr>
				<tr>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick="print_chart('#session.root_url#', '#milestone.project().id#', durations());"><img src="#session.root_url#/images/print.png" align="absmiddle"> Print</button>
						<button class="pt_buttons" onclick="download_chart('#session.root_url#', '#milestone.project().id#', durations());"><img src="#session.root_url#/images/download.png" align="absmiddle"> Download</button>
						<button class="pt_buttons" onclick="email_chart('#session.root_url#', '#milestone.project().id#', durations());"><img src="#session.root_url#/images/e-mail.png" align="absmiddle"> Email</button>
						<button class="pt_buttons" onclick="add_task('#session.root_url#', '#milestone.project().id#', '#milestone.id#');"><img src="#session.root_url#/images/add.png" align="absmiddle"> Task</button>
						<button class="pt_buttons" onclick="add_expense('#session.root_url#', '#milestone.id#', 'milestones', '#milestone.id#');"><img src="#session.root_url#/images/add.png" align="absmiddle"> Expense</button>
						<button class="pt_buttons" onclick="add_document('#session.root_url#', '#milestone.id#', '#milestone.id#', 'OBJ_MILESTONE');"><img src="#session.root_url#/images/add.png" align="absmiddle"> New Document</button>
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
					<li><a href="#tabs-paper">Milestone</a></li>					
					<li><a href="#tabs-gantt">Gantt Chart</a></li>
			</ul>
			<div id="tabs-paper">
				<div id="left-column" class="panel">
					<h1>Milestone Details</h1>
					<p>
					<cfoutput>
					<table>
						<tbody>
						<tr>
							<td>Name:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="milestone_name" width="auto" show_label="false" full_refresh="false"></td>
							<td>Start date:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="start_date" width="auto" show_label="false" full_refresh="true">
							</td>
						</tr>
						<tr>
							<td>Project:</td>
							<td><a href="#session.root_url#/project/edit_project.cfm?id=#milestone.project().id#">#milestone.project().object_name()#</a></td>
							<td>End Dates:</td>
							<td>
								Optimistic: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date_optimistic" width="auto" show_label="false" full_refresh="true"><br>
								Normal: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date" width="auto" show_label="false" full_refresh="true"><br>
								Pessimistic: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date_pessimistic" width="auto" show_label="false" full_refresh="true">																				
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
						</tbody>
					</table>
					</cfoutput>
					</p>
					
					<h1>Tasks</h1>
					<cfset tasks = milestone.tasks()>
					
					<cfloop array="#tasks#" index="t">
						<cfoutput>
						<p><a href="#session.root_url#/project/manage_task.cfm?id=#t.id#">#t.task_name#</a></p>
						</cfoutput>
					</cfloop>
			
					<h1>Expenses</h1>
					<cfif ArrayLen(milestone.expenses()) EQ 0>
						<p><em>No expenses recorded for this milestone.</em></p>
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
								<cfloop array="#milestone.expenses()#" index="expense">
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
					Total Expenses: <cfoutput>#numberFormat(milestone.total_expenses(), ",_$___.__")#</cfoutput>
					<br><br>
					<em>Note: these figures reflect only the current task.</em>
				</div>  <!--- right-column --->
			</div> <!--- paper --->
			<div id="tabs-gantt">
				
				<span id="view">
					<input autocomplete="off" type="radio" value="normal" id="normal" name="view_duration" checked="checked" /><label for="normal">Normal</label>
					<input autocomplete="off" type="radio" value="pessimistic" id="pessimistic" name="view_duration" /><label for="pessimistic">Pessimistic</label>
					<input autocomplete="off" type="radio" value="optimistic" id="optimistic" name="view_duration" /><label for="optimistic">Optimistic</label>
					<input autocomplete="off" type="radio" value="estimated" id="estimated" name="view_duration" /><label for="estimated">Estimated</label>
				</span>
				<div class="gantt" style="float:left;">	</div>
			</div>
		</div> <!--- tabs --->
	</div> <!--- container --->

</body>

</html>
