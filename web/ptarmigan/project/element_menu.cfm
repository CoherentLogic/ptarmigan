<div style="padding:10px; position:relative; height:260px;">
	<cfswitch expression="#url.current_element_table#">
		<cfcase value="projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(url.current_element_id)>
			<h3>Project QuickEdit</h3>
			<hr>
			<cfoutput>				
				<strong>Scheduled Duration:</strong>  #dateDiff("d", p.start_date, p.due_date_optimistic)#-#dateDiff("d", p.start_date, p.due_date_pessimistic)# days<br>
				<strong>Budget:</strong> #numberFormat(p.budget, ",_$___.__")#<br>								
			</cfoutput>
			<div style="position:absolute; bottom:0px; left:10px; padding-top:5px; width:450px;">
				<cfoutput>
			 	<button id="edit_proj" onclick="edit_project('#session.root_url#', '#p.id#');">Edit</button> <button onclick="add_milestone('#session.root_url#', '#p.id#');" id="add_ms">+ Milestone</button> <button id="add_co" onclick="add_change_order('#session.root_url#', '#p.id#')"> + C/O</button> <button id="apply_co" onclick="apply_change_order('#session.root_url#', '#p.id#');">Apply C/O</button>
			 	<button id="delete_project" onclick="trash_object('#session.root_url#', '#p.id#');">Trash</button>
				</cfoutput>
			</div>
			
		</cfcase>
		<cfcase value="milestones">
			<cfset ms = CreateObject("component", "ptarmigan.milestone").open(url.current_element_id)>
			<h3>Milestone QuickEdit (<cfif ms.floating EQ 0>Fixed Duration<cfelse>Floating Duration</cfif>)</h3>
			<hr>
			<cfoutput>				
				<cfif ms.floating EQ 0>
				<strong>Schedule cost:</strong>  #dateDiff("d", ms.start_date, ms.end_date_optimistic)#-#dateDiff("d", ms.start_date, ms.end_date_pessimistic)# days<br>
				</cfif>
				<strong>Budget:</strong> #numberFormat(ms.budget, ",_$___.__")#<br>
				<strong>Completion:</strong> #ms.percent_complete#%				
			</cfoutput>
			<div style="position:absolute; bottom:0px; left:10px; padding-top:5px; width:450px;">
				<cfoutput>
					<!--- edit_milestone('#session.root_url#', '#ms.id#'); --->
			 	
			 	<button id="edit_ms" onclick="edit_milestone('#session.root_url#', '#ms.id#');">Edit</button> <button id="add_task" onclick="add_task('#session.root_url#', '#ms.project().id#', '#ms.id#');">+ Task</button> <button id="add_expense" onclick="add_expense('#session.root_url#', 'milestones', '#ms.id#');">+ Expense</button> <button id="view_ms_audit_log" onclick="view_audit_log('#session.root_url#', 'milestones', '#ms.id#');">Audit Log</button>
			 	<button id="delete_ms" onclick="trash_object('#session.root_url#', '#ms.id#')">Trash</button>
				</cfoutput>
			</div>
		</cfcase>
		<cfcase value="tasks">
			<cfset t = CreateObject("component", "ptarmigan.task").open(url.current_element_id)>
			<h3>Task QuickEdit</h3>
			<hr>
			<cfoutput>				
				<strong>Schedule cost:</strong>  #dateDiff("d", t.start_date, t.end_date_optimistic)#-#dateDiff("d", t.start_date, t.end_date_pessimistic)# days<br>
				<strong>Budget:</strong> #numberFormat(t.budget, ",_$___.__")#<br>
				<strong>Completion:</strong> #t.percent_complete#%				
			
			<div style="position:absolute; bottom:0px; left:10px; padding-top:5px; width:450px;">
			 	<button id="edit_task" onclick="window.location.replace('#session.root_url#/project/manage_task.cfm?id=#t.id#');">Manage</button> <button id="add_expense_task" onclick="add_expense('#session.root_url#', 'tasks', '#t.id#');">+ Expense</button> <button id="view_task_audit_log" onclick="view_audit_log('#session.root_url#', 'tasks', '#t.id#');">Audit Log</button>
				<button id="delete_task" onclick="trash_object('#session.root_url#', '#t.id#')">Trash</button>
			</div>
			</cfoutput>
		</cfcase>
	</cfswitch>
</div>
