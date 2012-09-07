<div style="padding:10px; position:relative; height:260px;">
	<cfswitch expression="#url.current_element_table#">
		<cfcase value="projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(url.current_element_id)>
			<h3>Project</h3>
			<hr>
			<p>This is what goes in the project menu.</p>
			<div style="position:absolute; bottom:0px; left:10px; border-top:1px solid gray; padding-top:5px; width:450px;">
				<cfoutput>
			 	<button onclick="add_milestone('#session.root_url#', '#p.id#');">+ Milestone</button> <button onclick="add_change_order('#session.root_url#', '#p.id#')"> + Change Order</button> <button onclick="apply_change_order('#session.root_url#', '#p.id#');">Apply C/O</button>
			 	</cfoutput>
			</div>
			
		</cfcase>
		<cfcase value="milestones">
			<cfset ms = CreateObject("component", "ptarmigan.milestone").open(url.current_element_id)>
			<h3>Milestone (<cfif ms.floating EQ 0>fixed<cfelse>floating</cfif>)</h3>
			<hr>
			<cfoutput>				
				<strong>Schedule cost:</strong>  #dateDiff("d", ms.start_date, ms.end_date_optimistic)#-#dateDiff("d", ms.start_date, ms.end_date_pessimistic)# days<br>
				<strong>Budget:</strong> #numberFormat(ms.budget, ",_$___.__")#<br>
				<strong>Completion:</strong> #ms.percent_complete#%
				
			</cfoutput>
			<div style="position:absolute; bottom:0px; left:10px; border-top:1px solid gray; padding-top:5px; width:450px;">
				<cfoutput>
					<!--- edit_milestone('#session.root_url#', '#ms.id#'); --->
			 	
			 	<button id="edit_ms" onclick="edit_milestone('#session.root_url#', '#ms.id#');">Edit</button> <button id="add_task" onclick="add_task('#session.root_url#', '#ms.project().id#', '#ms.id#');">+ Task</button> <button id="add_expense" onclick="add_expense('#session.root_url#', 'milestones', '#ms.id#');">+ Expense</button> <button id="view_ms_audit_log" onclick="view_audit_log('#session.root_url#', 'milestones', '#ms.id#');">Audit Log</button>
			 	</cfoutput>
			</div>
		</cfcase>
		<cfcase value="tasks">
			<cfset p = CreateObject("component", "ptarmigan.task").open(url.current_element_id)>
			<h3>Task</h3>
			<hr>
			<p>This is what goes in the task menu.</p>
			<div style="position:absolute; bottom:0px; left:10px; border-top:1px solid gray; padding-top:5px; width:450px;">
			 	<button>+ Milestone</button> <button>+ Expense</button> <button> + C/O</button> <button>Apply C/O</button>
			</div>
		</cfcase>
	</cfswitch>
</div>
