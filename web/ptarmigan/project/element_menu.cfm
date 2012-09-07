<div style="padding:10px; position:relative; height:260px;">
	<cfswitch expression="#url.current_element_table#">
		<cfcase value="projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(url.current_element_id)>
			<h3>Project</h3>
			<hr>
			<p>This is what goes in the project menu.</p>
			<div style="position:absolute; bottom:0px; left:10px; border-top:1px solid gray; padding-top:5px; width:450px;">
			 	<button>+ Milestone</button> <button>+ Expense</button> <button> + C/O</button> <button>Apply C/O</button>
			</div>
			
		</cfcase>
		<cfcase value="milestones">
			<cfset ms = CreateObject("component", "ptarmigan.milestone").open(url.current_element_id)>
			<h3>Milestone (<cfif ms.floating EQ 0>fixed<cfelse>floating</cfif>)</h3>
			<hr>
			<p>This is what goes in the project menu.</p>
			<div style="position:absolute; bottom:0px; left:10px; border-top:1px solid gray; padding-top:5px; width:450px;">
			 	<button>Edit</button> <button>+ Task</button> <button>+ Expense</button> <button>Audit Log</button>
			</div>
		</cfcase>
		<cfcase value="tasks">
			tasks
		</cfcase>
	</cfswitch>
</div>
