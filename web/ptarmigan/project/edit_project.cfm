<cfmodule template="../security/require.cfm" type="project">

<cfif IsDefined("form.id")>
	<cfset project_id = form.id>
<cfelse>
	<cfset project_id = url.id>
</cfif>




<cfquery name="get_customers" datasource="ptarmigan">
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
	
	<cfset p.update()>
</cfif>
<cfset c = CreateObject("component", "ptarmigan.employee").open(p.created_by)>
<cfset cn = "#c.last_name#, #c.honorific# #c.first_name# #c.middle_initial# #c.suffix#">
<cfset milestones = p.milestones()>

<form name="project_header" action="edit_project.cfm" method="post">
<cfoutput>
<input type="hidden" name="id" value="#project_id#">	
</cfoutput>
<h1>Edit Project</h1>
<cfif IsDefined("form.submit_header")>
	<p><em>Changes saved.</em></p>
</cfif>
<a href="#header">Project Info</a> | <a href="#instructions">Instructions</a> | <a href="#milestones">Milestones</a>
<h2>Project Info</h2>
<a name="header">
<table width="100%">
	<tr>
		<cfoutput>
		<td>PROJECT ##:<input type="text" name="project_number" value="#p.project_number#"></td>
		<td>NAME:<input type="text" name="project_name" value="#p.project_name#"></td>
		</cfoutput>
		<td>CUSTOMER:
			<select name="customer_id">
				<cfoutput query="get_customers">
					<option value="#id#" <cfif p.customer_id EQ id>selected</cfif>>#company_name#</option>
				</cfoutput>
			</select>
		</td>
	</tr>	
	<tr>
		<cfoutput>
		<td>&nbsp;</td>
		<td>BUDGET: <input type="text" name="budget" value="#p.budget#"></td>
		<td>START DATE: <input type="text" name="start_date" value="#dateFormat(p.start_date, 'MM/DD/YYYY')#"></td>
		</cfoutput>
	</tr>
	<tr>
		<cfoutput>
		<td>DUE DATE:<input type="text" name="due_date" value="#dateFormat(p.due_date, 'MM/DD/YYYY')#"></td>
		<td>CREATED BY: <strong>#cn#</strong></td>
		<td>TAX RATE: <input type="text" name="tax_rate" value="#p.tax_rate#"><strong>%</strong></td>
		</cfoutput>
	</tr> 
</table>
<hr>
<a name="instructions">
<h2>Instructions</h2>
<textarea name="instructions" rows="5" cols="80"><cfoutput>#p.instructions#</cfoutput></textarea>
<table width="100%">
<tr>
	<td align="right">
		<input type="submit" name="submit_header" value="Submit">
	</td>
</tr>
</table>
</form>
<hr>
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
					<li><a href="manage_task.cfm?id=#c_task.id#">#c_task.task_name#</a>&nbsp;&nbsp;
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
</table>