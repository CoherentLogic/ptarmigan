<!--- TODO: Update log-in requirements --->
<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfsilent>
	<cfset object =  CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset task = object.get()>
	<cfset total_budget_used = task.total_expenses()>
	<cfset percent_budget_used = int((total_budget_used * 100) / task.budget)>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab">
	<cfoutput>	
		<title>#task.object_name()# - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
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
					<cfoutput>value: #task.percent_complete#</cfoutput>
				});
				$( "#budget-used").progressbar({
					<cfoutput>value: #percent_budget_used#</cfoutput>
				});
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
					<td><cfoutput><h1><strong>#task.object_name()#</strong></h1></cfoutput></td>
				</tr>
				<tr>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Assignment</button>			
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Work</button>
						<button class="pt_buttons" onclick="add_expense('#session.root_url#', 'tasks', '#task.id#');"><img src="#session.root_url#/images/add.png" align="absmiddle"> Expense</button>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Document</button>
<!--- 
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Comment</button>			
 --->
						<cfif session.user.is_admin() EQ true>
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#url.id#');"><img src="#session.root_url#/images/trash.png" align="absmiddle"> Move to Trash</button>
						</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
		</div>	<!--- header --->
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
					<td><strong>#task.project().object_name()#</strong></td>
					<td>End Dates:</td>
					<td>
						Optimistic: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date_optimistic" width="auto" show_label="false" full_refresh="true"><br>
						Normal: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date" width="auto" show_label="false" full_refresh="true"><br>
						Pessimistic: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="end_date_pessimistic" width="auto" show_label="false" full_refresh="true">																				
					</td>				
				</tr>				
				<tr>
					<td>Milestone:</td>
					<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="milestone_id" width="auto" show_label="false" full_refresh="false"></td>				
					<td></td>
					<td></td>
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
			
			<h1>Description</h1>
			<cfoutput><p><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="description" width="auto" show_label="false" full_refresh="false"></p></cfoutput>			
	
			<h1>Expenses</h1>
			<cfif ArrayLen(task.expenses()) EQ 0>
				<p><em>No expenses recorded for this task.</em></p>
			<cfelse>
				<cfloop array="#task.expenses()#" index="expense">
					<cfoutput>
						#expense.recipient#
					</cfoutput>
				</cfloop>
			</cfif>
			
			<h1>Documents</h1>
			<cfif ArrayLen(task.documents()) EQ 0>
				<p><em>No documents associated with this task.</em></p>
			<cfelse>
				<cfloop array="#task.documents()#" index="document">
					<cfoutput>
						#document.document_name#
					</cfoutput>
				</cfloop>
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
	</div> <!--- container --->

</body>

</html>
