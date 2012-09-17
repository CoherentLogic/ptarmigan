<cfsilent>
	<cfset object =  CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset project = object.get()>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfmodule template="#session.root_url#/security/require.cfm" type="">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>#project.object_name()# - ptarmigan</title>		
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
				
				<cfoutput>
				$("##normal").click(function () {
					render_gantt('#session.root_url#', '#project.id#', 'normal')	
				});			
				$("##optimistic").click(function () {
					render_gantt('#session.root_url#', '#project.id#', 'optimistic')	
				});			
				$("##pessimistic").click(function () {
					render_gantt('#session.root_url#', '#project.id#', 'pessimistic')	
				});			
				$("##estimated").click(function () {
					render_gantt('#session.root_url#', '#project.id#', 'estimated')	
				});			
				</cfoutput>
				$("#view").buttonset();
				
				
				
				<cfoutput>render_gantt('#session.root_url#', '#project.id#', 'normal');</cfoutput>
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
					<td><cfoutput><h1><strong>#project.object_name()#</strong></h1></cfoutput></td>
				</tr>
				<tr>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick="print_chart('#session.root_url#', '#project.id#', durations());"><img src="#session.root_url#/images/print.png" align="absmiddle"> Print</button>
						<button class="pt_buttons" onclick="download_chart('#session.root_url#', '#project.id#', durations());"><img src="#session.root_url#/images/download.png" align="absmiddle"> Download</button>
						<button class="pt_buttons" onclick="email_chart('#session.root_url#', '#project.id#', durations());"><img src="#session.root_url#/images/e-mail.png" align="absmiddle"> Email</button>
						<button class="pt_buttons" onclick="add_milestone('#session.root_url#', '#project.id#');" id="add_ms"><img src="#session.root_url#/images/add.png" align="absmiddle"> Milestone</button>
						<button class="pt_buttons" id="add_co" onclick="add_change_order('#session.root_url#', '#project.id#')"><img src="#session.root_url#/images/add.png" align="absmiddle"> Change Order</button> 
						<button class="pt_buttons" id="apply_co" onclick="apply_change_order('#session.root_url#', '#project.id#');">Apply C/O</button>
						<button class="pt_buttons" onclick="add_document('#session.root_url#', '#project.id#', '#project.id#', 'OBJ_PROJECT');"><img src="#session.root_url#/images/add.png" align="absmiddle"> New Document</button>
						<cfif session.user.is_admin() EQ true>
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#url.id#');"><img src="#session.root_url#/images/trash.png" align="absmiddle"> Trash</button>
						</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
		</div>	<!--- header --->
		<div id="tabs">
			<ul>
					<li><a href="#tabs-paper">Project</a></li>					
					<li><a href="#tabs-gantt">Gantt Chart</a></li>
			</ul>
			<div id="tabs-paper">
				<div id="left-column" class="panel">
					<h1>Project Details</h1>
					<p>
					<cfoutput>
					<table>
						<tbody>
						<tr>
							<td>Name:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="project_name" width="auto" show_label="false" full_refresh="false"></td>
							<td>Start date:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="start_date" width="auto" show_label="false" full_refresh="true">
							</td>
						</tr>
						<tr>
							<td>Customer:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="customer_id" show_label="false" full_refresh="false"></td>
							<td>End Dates:</td>
							<td>
								Optimistic: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="due_date_optimistic" width="auto" show_label="false" full_refresh="true"><br>
								Normal: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="due_date" width="auto" show_label="false" full_refresh="true"><br>
								Pessimistic: <cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="due_date_pessimistic" width="auto" show_label="false" full_refresh="true">																				
							</td>				
						</tr>				
						<tr>
							<td>Project Number:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="project_number" width="auto" show_label="false" full_refresh="false"></td>				
							<td>Tax Rate:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="tax_rate" width="auto" show_label="false" full_refresh="false"></td>
						</tr>
						
						</tbody>
					</table>
					</cfoutput>
					</p>
					
					<h1>Instructions</h1>
					<cfoutput><p><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="instructions" width="auto" show_label="false" full_refresh="false"></p></cfoutput>			

					<h1>Milestones &amp; Tasks</h1>
					
					<cfset milestones = project.milestones()>
					<cfloop array="#milestones#" index="ms">
						<p><cfoutput><a style="color:#ms.color#;" href="#session.root_url#/project/manage_milestone.cfm?id=#ms.id#">#ms.milestone_name#</a></cfoutput>
							<blockquote>
								<cfset tasks = ms.tasks()>
								<cfloop array="#tasks#" index="t">
									<p><cfoutput><a style="color:#t.color#;" href="#session.root_url#/project/manage_task.cfm?id=#t.id#">#t.task_name#</a></cfoutput></p>
								</cfloop>
							</blockquote>
						</p>
					</cfloop>

					<h1>Budget Allocation</h1>
					<cfmodule template="budget.cfm" id="#project.id#" mode="edit">
					
			
					<br><br>
					<h1>Documents</h1>
					<cfif ArrayLen(object.get_associated_objects("OBJ_DOCUMENT")) EQ 0>
						<p><em>No documents associated with this project</em></p>
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
						<p><em>No edits associated with this project</em></p>
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
					<h1>Budget</h1>
					<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="budget" width="auto" show_label="false" full_refresh="false">

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
