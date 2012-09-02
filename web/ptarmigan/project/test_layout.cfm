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
	<cfoutput>	
		<title>#p.project_name# - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
	</cfoutput>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree">
</head>

<body>
	
	
	<!--- BEGIN LAYOUT --->
	<cflayout type="border" fitToWindow="true">
		<cflayoutarea position="top">
			<cfinclude template="../top.cfm">
		</cflayoutarea>	
		<cflayoutarea position="left" collapsible="true" title="PROPERTIES">			
			<cfoutput>
			<form name="project_header" action="edit_project.cfm?id=#url.id#" method="post">
			</cfoutput>
			
			 <table class="property_dialog">
				<tr>
					<th>PROJECT BROWSER</th>
				</tr>
			 </table>
			<div style="width:100%;height:300px;font-family:Arial,Helvetica,sans-serif;color:black;overflow:auto;" class="tree">
			<cfmodule template="project_browser.cfm" id="#project_id#">	
			</div>			
			<table class="property_dialog">
				<tr>
					<th colspan="2">PROJECT PROPERTIES</th>
				</tr>
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
			
			
			<table class="property_dialog">
				<tr>
					<th>MILESTONE/TASK</th>
					<th>BUDGET</th>
				</tr>
			<cfloop array="#milestones#" index="ms">
				<cfoutput>
				<tr>
					<td>#ms.milestone_name#</td>
					<td>#numberFormat(ms.budget,",_$___.__")#</td>
					
				</tr>
				</cfoutput>
				<cfset tasks = ms.tasks()>
				<cfloop array="#tasks#" index="t">
					<cfoutput>
					<tr>
						<td style="padding-left:5px;">#t.task_name#</td>
						<td>#numberFormat(t.budget,",_$___.__")#</td>					
					</tr>
					</cfoutput>
				</cfloop>
			</cfloop>
			</table>
		</cflayoutarea>
		<cflayoutarea position="center">
			<cfinclude template="../navigation.cfm">
			<cflayout type="tab" tabheight="100%">
				<cflayoutarea title="Normal">
					<cfmodule template="gantt_toolbar.cfm" project_id="#project_id#" durations="normal">
					<cfmodule template="gantt_chart.cfm" id="#project_id#" mode="edit" durations="normal">
				</cflayoutarea>
				<cflayoutarea title="Pessimistic">
					<cfmodule template="gantt_toolbar.cfm" project_id="#project_id#" durations="pessimistic">
					<cfmodule template="gantt_chart.cfm" id="#project_id#" mode="edit" durations="pessimistic">
				</cflayoutarea>
				<cflayoutarea title="Optimistic">
					<cfmodule template="gantt_toolbar.cfm" project_id="#project_id#" durations="optimistic">
					<cfmodule template="gantt_chart.cfm" id="#project_id#" mode="edit" durations="optimistic">
				</cflayoutarea>
				<cflayoutarea title="Estimated Probability">
					<cfmodule template="gantt_toolbar.cfm" project_id="#project_id#" durations="estimated">
					<cfmodule template="gantt_chart.cfm" id="#project_id#" mode="edit" durations="estimated">
				</cflayoutarea>	
				<cflayoutarea title="Budget Allocation">
					<cfmodule template="budget.cfm" id="#project_id#" mode="edit">
				</cflayoutarea>
				<cflayoutarea title="Expenses">
					<cfmodule template="expenses.cfm" id="#project_id#" mode="edit">
				</cflayoutarea>
				<cflayoutarea title="Alerts">
					<cfmodule template="alerts.cfm" id="#project_id#">
				</cflayoutarea>
			</cflayout>
		</cflayoutarea>
		<cflayoutarea position="bottom">
			Copyright &copy; 2012 Coherent Logic Development LLC
		</cflayoutarea>
	</cflayout>
	

</body>

</html>
