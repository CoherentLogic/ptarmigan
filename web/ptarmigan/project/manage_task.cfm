<!--- TODO: Update log-in requirements --->
<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfsilent>
	<cfset task = CreateObject("component", "ptarmigan.object").open(url.id).get()>
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
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Add Assignment</button>			
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Add Work</button>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png" align="absmiddle"> Add Task</button>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/comments.png" align="absmiddle"> Add Comment</button>			
						<cfif session.user.is_admin() EQ true>
							<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/pencil.png" align="absmiddle"> Edit Task</button>
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#url.id#');"><img src="#session.root_url#/images/trash.png" align="absmiddle"> Trash Task</button>
						</cfif>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/print.png" align="absmiddle"> Print Overview</button>
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
					<td><strong>#task.milestone().object_name()#</strong></td>				
					<td>Budget:</td>
					<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="budget" width="auto" show_label="false" full_refresh="true"></td>
				</tr>
				<tr>
					<td>Completed:</td>				
					<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="completed" width="auto" show_label="false" full_refresh="false"></td>
					<td>Color:</td>
					<td>
						<div style="height:30px;width:50px;background-color:#task.color#;"></div>
					</td>
				</tr>
				</tbody>
			</table>
			</cfoutput>
			</p>
			
			<h1>Description</h1>
			<cfoutput><p><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="description" width="auto" show_label="false" full_refresh="false"></p></cfoutput>			
		</div>	<!--- left-column --->
		<div id="right-column" class="panel">
			<h1>Completion</h1>
			
			<div id="percentage-complete"></div>
			<center><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="percent_complete" width="auto" show_label="false" full_refresh="true"></center>
		</div>  <!--- right-column --->
	</div> <!--- container --->

</body>

</html>
