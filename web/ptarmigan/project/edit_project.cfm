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
<cflayout type="accordion">
	<cflayoutarea title="PROPERTIES">
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
	</cflayoutarea>
</cflayout>
<cflayout type="accordion">
	<cflayoutarea title="BUDGET OVERVIEW" initcollapsed="false">
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
	</cflayoutarea>
</cflayout>
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
	<!--- <cflayoutarea initHide="true" title="Milestones &amp; Tasks">
		<a name="milestones">
		<h2>Milestones</h2>
		<p>Current milestone in <strong>bold</strong>. Click a milestone's name to edit the milestone.</p>
		<cfoutput>
		<form name="add_milestone" action="add_milestone.cfm?return=edit_project.cfm&id=#project_id#" method="post">
		<input type="hidden" name="project_id" value="#p.id#"> 
		<input type="submit" name="submit" value="Add Milestone">
		</form>
		</cfoutput>
		<cfloop array="#milestones#" index="ms">	
			
			<cfif ms.milestone_number EQ p.current_milestone><strong></cfif>
				<cfoutput>
					<form name="add_task_#ms.id#" action="add_task.cfm?return=edit_project.cfm&id=#project_id#" method="post">
					#ms.milestone_number#.&nbsp;&nbsp;
					<a href="edit_milestone.cfm?id=#ms.id#">#ms.milestone_name#</a>&nbsp; <cfif ms.floating EQ 0>(#dateFormat(ms.start_date, 'm/dd/yyyy')#-#dateFormat(ms.end_date, 'm/dd/yyyy')#)</cfif>
					<cfif ms.floating EQ 1>
						[FLOATING]
					<cfelse>
						[FIXED]
					</cfif>
					
						<input type="hidden" name="milestone_id" value="#ms.id#">
						<input type="submit" name="submit" value="Add Task">
						<cfif ms.floating EQ 0>
						<input type="submit" name="set_milestone" value="Make Current">
						</cfif>
					</form>
				</cfoutput>
			<cfif ms.milestone_number EQ p.current_milestone></strong></cfif>
			<blockquote>		
				<cfset m_tasks = ms.tasks()>
				<cfif ArrayLen(m_tasks) GT 0>
					<ol>			
					<cfloop array="#m_tasks#" index="c_task">
							<cfoutput>
							<li><a href="manage_task.cfm?id=#c_task.id#">#c_task.task_name#</a> (#dateFormat(c_task.start_date,'m/dd/yyyy')#-#dateFormat(c_task.end_date,'m/dd/yyyy')#)&nbsp;&nbsp;
									<cfif c_task.completed EQ 1>
										[COMPLETE]
									<cfelse>
										[INCOMPLETE]
									</cfif></li>
								
							</cfoutput>			
					</cfloop>
					</ol>
				<cfelse>
					<em>No tasks have been added for this milestone.</em>
				</cfif>
			</blockquote>
		</cfloop>
		</form>
	</cflayoutarea> --->
</cflayout>
</div>
</div>