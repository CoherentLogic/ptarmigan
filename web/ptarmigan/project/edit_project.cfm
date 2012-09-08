<cfmodule template="../security/require.cfm" type="project">
<cfsilent>
<cfset project_id = url.id>

<cfquery name="get_customers" datasource="#session.company.datasource#">
	SELECT id,company_name FROM customers ORDER BY company_name
</cfquery>

<cfset p = CreateObject("component", "ptarmigan.project").open(project_id)>

<cfif IsDefined("form.submit_header")>
	<cfset p.project_number = form.project_number>
	<cfset p.project_name = ucase(form.project_name)>
	<cfset p.customer_id = form.customer_id>
	<cfset p.due_date = CreateODBCDate(form.due_date)>
	<cfset p.due_date_pessimistic = CreateODBCDate(form.due_date_pessimistic)>
	<cfset p.due_date_optimistic = CreateODBCDate(form.due_date_optimistic)>
	<cfset p.tax_rate = form.tax_rate>
	<cfset p.instructions = ucase(form.instructions)>
	<cfset p.start_date = CreateODBCDate(form.start_date)>
	<cfset p.budget = form.budget>
	
	<cfset p.update()>
</cfif>
<cfset c = CreateObject("component", "ptarmigan.employee").open(p.created_by)>
<cfset cn = "#c.last_name#, #c.honorific# #c.first_name# #c.middle_initial# #c.suffix#">
<cfset milestones = p.milestones()>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab,cftooltip">
	<cfoutput>	
		<title>#p.project_name# - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<link rel="stylesheet" type="text/css" href="#session.root_url#/jquery_ui/css/style.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
		
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menu.css" />
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menubar.css" />
		<link type="text/css" href="#session.root_url#/jquery_ui/css/smoothness/jquery-ui-1.8.23.custom.css" rel="Stylesheet" />	
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-ui.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menu.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menubar.js"></script>
		<script src="http://view.jqueryui.com/menubar/ui/jquery.ui.position.js" type="text/javascript"></script>
		<script src="#session.root_url#/jquery_ui/js/jquery.fn.gantt.js"></script>
		
	</cfoutput>		
	<style>
	#toolbar {
		padding: 10px 4px;
		overflow: hidden;
	}
	</style>
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "840px");
				$("#accordion").accordion();		
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				$("#navigation_bar").css("color", "black");
				$('#navigation_bar').css("float", "left");

				$("#current_element_menu").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});
				$("#project_menu").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});
				$("#project_menu").css("float", "left");
				

				$(".ui-state-default").css("color", "black");
				$("#view").buttonset();
				$("#view").css("float", "right");
				
				<cfoutput>
				select_element('#session.root_url#', 'projects', '#project_id#', '#p.project_name#');
				
				$("##current_element_menu").css("color", "black");
				$("##current_element_menu").css("float", "left");				
				$("##current_element_menu .ui-menu").css("width", "500px");
				
				
				
				$("##normal").click(function () {
					render_gantt('#session.root_url#', '#p.id#', 'normal')	
				});			
				$("##optimistic").click(function () {
					render_gantt('#session.root_url#', '#p.id#', 'optimistic')	
				});			
				$("##pessimistic").click(function () {
					render_gantt('#session.root_url#', '#p.id#', 'pessimistic')	
				});			
				$("##estimated").click(function () {
					render_gantt('#session.root_url#', '#p.id#', 'estimated')	
				});											
	
				render_gantt('#session.root_url#', '#p.id#', 'normal');	
				
				
				</cfoutput>
	   		 });
	</script>
</head>

<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	
	<cfinclude template="#session.root_url#/navigation.cfm">
	
	<!--- BEGIN LAYOUT --->
	<div id="container">
		<div id="header">
			

			<!--- <cfinclude template="#session.root_url#/top.cfm"> --->
			<div id="toolbar" class="menubar-icons" >																		
				<span id="view">
					<input type="radio" value="normal" id="normal" name="view_duration" checked="checked" /><label for="normal">Normal</label>
					<input type="radio" value="pessimistic" id="pessimistic" name="view_duration" /><label for="pessimistic">Pessimistic</label>
					<input type="radio" value="optimistic" id="optimistic" name="view_duration" /><label for="optimistic">Optimistic</label>
					<input type="radio" value="estimated" id="estimated" name="view_duration" /><label for="estimated">Estimated</label>
				</span>
				<cfoutput>
				
				<ul id="current_element_menu" class="menubar-icons">
					<li>
						<a href="##CurrentElement">#p.project_name#</a>
						<ul>
							<li>
								<div id="current_element_menubox" style="height:320px;width:500px;">
									Empty
								</div>
							</li>
						</ul>
					</li>
				</ul>
				<ul id="project_menu" class="menubar-icons">
					<li>
						<a href="##GanttChart">Gantt Chart</a>
						<ul>
							<li><a href="##" onclick="print_chart('#session.root_url#', '#p.id#', durations());">Print</a></li>
							<li><a href="##" onclick="download_chart('#session.root_url#', '#p.id#', durations());">Download</a></li>
							<li><a href="##" onclick="email_chart('#session.root_url#', '#p.id#', durations());">E-Mail</a></li>
						</ul>
					</li>
					<!---
					<li>
						<a href="##Reports">Reports</a>
						<ul>
							<li><a href="##">Schedule cost</a></li>
							<li><a href="##">Budget cost</a></li>
							<li><a href="##">Project overlay</a></li>
						</ul>
					</li>
					--->
				</ul>
				</cfoutput>
			</div>			
		</div>	
		<div id="navigation">			
			<h3>Project Browser</h3>
			<blockquote>
				<cfmodule template="project_browser.cfm" id="#project_id#">	
			</blockquote>
				
			<!---	<h3><a href="##">Project Properties</a></h3>
				<div>
					<cfoutput>
					<form name="project_header" action="edit_project.cfm?id=#url.id#" method="post">
					</cfoutput>
								
					<table class="property_dialog">
						<tr>
							<cfoutput>
							<td>Project ##</td>
							<td><input type="text" name="project_number" value="#p.project_number#"></td>
							</cfoutput>
						</tr>
						<tr>
							<cfoutput>
							<td>Name</td>
							<td><input type="text" name="project_name" value="#p.project_name#"></td>
							</cfoutput>
						</tr>
						<tr>
							<td>Customer</td>
							<td>
								<select name="customer_id">
									<cfoutput query="get_customers">
										<option value="#id#" <cfif p.customer_id EQ id>selected</cfif>>#company_name#</option>
									</cfoutput>
								</select>
							</td>
							
						</tr>	
						<tr>
							<cfoutput>
							<td>Start date</td>
							<td><input type="text" name="start_date" value="#dateFormat(p.start_date, 'MM/DD/YYYY')#"></td>
							</cfoutput>
						</tr>
						<tr>
							<cfoutput>
							<td>End date (normal)</td>
							<td><input type="text" name="due_date" value="#dateFormat(p.due_date, 'MM/DD/YYYY')#"></td>
							</cfoutput>
						</tr>
						<tr>
							<cfoutput>
							<td>End date (pessimistic)</td>
							<td><input type="text" name="due_date_pessimistic" value="#dateFormat(p.due_date_pessimistic, 'MM/DD/YYYY')#"></td>
							</cfoutput>
						</tr>
						<tr>
							<cfoutput>
							<td>End date (optimistic)</td>
							<td><input type="text" name="due_date_optimistic" value="#dateFormat(p.due_date_optimistic, 'MM/DD/YYYY')#"></td>
							</cfoutput>
						</tr>
						<tr>
							<td>Budget</td>
							<cfoutput>
							<td><input type="text" name="budget" value="#p.budget#"></td>
							</cfoutput>
						</tr>
						<tr>
							<cfoutput>
							<td>Tax rate</td>
							<td><input type="text" name="tax_rate" value="#p.tax_rate#"></td>
							</cfoutput>
						</tr>
						
						<tr>
							<cfoutput>
							<td>Created by</td> 
							<td><input type="text" readonly="true" value="#cn#"></td>
							</cfoutput>
						</tr>
						 
						<tr>
							<cfoutput>
							<td>Instructions</td>
							<td><textarea name="instructions" rows="4">#p.instructions#</textarea></td>
							</cfoutput>
						</tr>
					</table>
					<input type="submit" name="submit_header" value="Save">		
					</form>
				</div> --->							
		</div>
		<div id="content">
			
			<div id="tabs">
				<ul>
					<li><a href="#tabs-project">Project</a></li>					
					<li><a href="#tabs-budget">Budget</a></li>
					<li><a href="#tabs-expenses">Expenses</a></li>
					<li><a href="#tabs-alerts">Alerts</a></li>					
				</ul>
				<div id="tabs-project">
					<input type="hidden" id="current_element_table" value="projects">
					<cfoutput>
					<input type="hidden" id="current_element_id" value="#project_id#">
					</cfoutput>
					
				
					<div class="gantt">
					
					</div>
				</div>
				<div id="tabs-budget">
					<cfmodule template="budget.cfm" id="#project_id#" mode="edit">
				</div>
				<div id="tabs-expenses">
					<cfmodule template="expenses.cfm" id="#project_id#" mode="edit">
				</div>
				<div id="tabs-alerts">
					<cfmodule template="alerts.cfm" id="#project_id#">
				</div>
				
			</div> <!--- tabs --->
		</div> <!---content --->
	</div>	<!--- container --->

</body>

</html>
