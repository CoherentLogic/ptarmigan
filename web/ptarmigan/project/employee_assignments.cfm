<cfset e = CreateObject("component", "ptarmigan.employee").open(attributes.employee_id)>
<cfset t = CreateObject("component", "ptarmigan.task").open(attributes.task_id)>

<cfset assignments = e.assignments(attributes.task_id)>

<cfif ArrayLen(assignments) LT 1>
	<em>Employee has no assignments for <cfoutput>#t.task_name#</cfoutput>.</em>
<cfelse>
	<ol>
	<cfloop array="#assignments#" index="a">
		<cfoutput>
			<li>#dateFormat(a.start_date, "MM/DD/YYYY")#-#dateFormat(a.end_date, "MM/DD/YYYY")#</li>
		</cfoutput>
	</cfloop>
	</ol>
</cfif>

<cfoutput>
	<cfif t.completed EQ 0>
	<hr>
	<a href="add_assignment.cfm?task_id=#attributes.task_id#&employee_id=#attributes.employee_id#">Add Assignment</a>
	</cfif>
</cfoutput>