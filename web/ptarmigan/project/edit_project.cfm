<cfajaximport tags="cfwindow,cfform,cfinput-datefield">

<cfmodule template="../security/require.cfm" type="project">

<cfif NOT IsDefined("form.submit_header")>
	<cfif IsDefined("form.id")>
		<cfset project_id = form.id>
	<cfelse>
		<cfset project_id = url.id>
	</cfif>
</cfif>



<cfquery name="get_customers" datasource="#session.company.datasource#">
	SELECT id,company_name FROM customers ORDER BY company_name
</cfquery>

<cfset p = CreateObject("component", "ptarmigan.project").open(project_id)>

<cfif IsDefined("form.submit_header")>
	<cfset p.project_number = form.project_number>
	<cfset p.project_name = ucase(form.project_name)>
	<cfset p.customer_id = form.customer_id>
	<cfset p.due_date = CreateODBCDate(form.due_date)>
	<cfset p.tax_rate = form.tax_rate>
	<cfset p.instructions = ucase(form.instructions)>
	<cfset p.start_date = CreateODBCDate(form.start_date)>
	<cfset p.budget = form.budget>
	
	<cfset p.update()>
</cfif>
<cfset c = CreateObject("component", "ptarmigan.employee").open(p.created_by)>
<cfset cn = "#c.last_name#, #c.honorific# #c.first_name# #c.middle_initial# #c.suffix#">
<cfset milestones = p.milestones()>
<div id="container">
<div id="header">
	<h1><cfoutput>#p.project_name#</cfoutput></h1>
	
	<cfif IsDefined("form.submit_header")>
	<p><em>Changes saved.</em></p>
	</cfif>
</div>
<div id="navigation">
		<form name="project_header" action="edit_project.cfm" method="post">
		<cfoutput>
		<input type="hidden" name="id" value="#project_id#">	
		</cfoutput>
		
		
		<!--- 
		<cfoutput> | <a href="#header">Project Info</a> | <a href="#instructions">Instructions</a> | <a href="#milestones">Milestones</a>
		 --->
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
			<tr>
				<td>&nbsp;</td>
				<td align="right">
				<input type="submit" name="submit_header" value="Save">
				</td>
			</tr>
		</table>
		</form>
		<table class="property_dialog">
			<tr>
				<th>MILESTONE/TASK</th>
				<th>BUDGET</th>
				<th>%</th>
			</tr>
		<cfloop array="#milestones#" index="ms">
			<cfset pct = int((ms.budget * 100) / p.budget)>
			<cfif pct GT 100>
				<cfset col = "red">
				<cfset pct = 100>
			<cfelse>
				<cfset col = "green">
			</cfif>
			<cfoutput>
			<tr>
				<td>#ms.milestone_name#</td>
				<td>#numberFormat(ms.budget,",_$___.__")#</td>
				<td>
					<div style="width:50px;color:white;">
					<div style="width:#pct#%;background-color:#col#;">&nbsp;</div>
					<!---#pct#%--->
					</div>
				</td>
			</tr>
			</cfoutput>
			<cfset tasks = ms.tasks()>
			<cfloop array="#tasks#" index="t">
				<cfset pct = int((t.budget * 100) / ms.budget)>
				<cfif pct GT 100>
					<cfset col = "red">
					<cfset pct = 100>
				<cfelse>
					<cfset col = "green">
				</cfif>
				<cfoutput>
				<tr>
					<td style="padding-left:5px;">#t.task_name#</td>
					<td>#numberFormat(t.budget,",_$___.__")#</td>
					<td>
						<div style="width:50px;color:white;">
						<div style="width:#pct#%;background-color:#col#;">&nbsp;</div>
						<!---#pct#%--->
						</div>
					</td>
				</tr>
				</cfoutput>
			</cfloop>
		</cfloop>
		</table>
</div>
<div id="content">
<cflayout type="tab">
	
	
	
	
	
	
	
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
</cflayout>
</div>
</div>