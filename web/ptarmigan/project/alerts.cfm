<cfset project = CreateObject("component", "ptarmigan.project").open(attributes.id)>
<cfset milestones = project.milestones()>

<table class="property_dialog">
	<tr>
		<th colspan="2">ALERTS</th>
	</tr>
	<tr>
		<th>Item</th>
		<th>Alert</th>
	</tr>
	<cfloop array="#milestones#" index="ms">
		<cfif ms.floating EQ 0>
			<cfif (CreateODBCDate(Now()) GT ms.end_date) AND ((ms.completed EQ 0) OR (ms.percent_complete LT 100))>
				<cfset days_overdue = DateDiff("d", ms.end_date, Now())>
				<cfoutput>
				<tr>
					<td style="color:#ms.color#;">#ms.milestone_name# [ms]</td>
					<td style="color:#ms.color#;">#days_overdue# DAYS LATE</td>
				</tr>				
				</cfoutput>
			</cfif>
			<cfset tasks = ms.tasks()>
			<cfloop array="#tasks#" index="t">			
				<cfif  (CreateODBCDate(Now()) GT t.end_date) AND ((t.completed EQ 0) OR (t.percent_complete LT 100))>	
					<cfset days_overdue = DateDiff("d", t.end_date, Now())>
					<cfoutput>
					<tr>
						<td style="color:#t.color#;">#t.task_name# [tsk]</td>
						<td style="color:#t.color#;">#days_overdue# DAYS LATE</td>
					</tr>				
					</cfoutput>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
</table>
