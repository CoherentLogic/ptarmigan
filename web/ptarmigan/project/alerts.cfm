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
					<td style="color:#ms.color#;">#ms.milestone_name# [MILESTONE]</td>
					<td style="color:#ms.color#;">IS #days_overdue# DAY(S) BEHIND SCHEDULE</td>
				</tr>				
				</cfoutput>
			</cfif>
			<cfset exps = ms.total_expenses()>
			<cfif exps GT ms.budget>
				<cfset over_budget = exps - ms.budget>
				<cfoutput>
					<tr>
						<td style="color:#ms.color#;">#ms.milestone_name# [MILESTONE]</td>
						<td style="color:#ms.color#;">MILESTONE EXPENSES ARE #numberFormat(over_budget, ",_$___.__")# OVER ALLOCATED MILESTONE BUDGET</td>					
					</tr>
				</cfoutput>
			</cfif>
			<cfif ms.budget GT project.budget>
				<cfset over_alloc = ms.budget - project.budget>
				<cfoutput>
					<tr>
						<td style="color:#ms.color#;">#ms.milestone_name# [MILESTONE]</td>
						<td style="color:#ms.color#;">MILESTONE BUDGET IS #numberFormat(over_alloc, ",_$___.__")# OVER ALLOCATED PROJECT BUDGET</td>					
					</tr>
				</cfoutput>						
			</cfif>			
			<cfset tasks = ms.tasks()>
			<cfloop array="#tasks#" index="t">			
				<cfif  (CreateODBCDate(Now()) GT t.end_date) AND ((t.completed EQ 0) OR (t.percent_complete LT 100))>	
					<cfset days_overdue = DateDiff("d", t.end_date, Now())>
					<cfoutput>
					<tr>
						<td style="color:#t.color#;">#t.task_name# [TASK]</td>
						<td style="color:#t.color#;">IS #days_overdue# DAY(S) BEHIND SCHEDULE</td>
					</tr>				
					</cfoutput>					
				</cfif>
				<cfif t.budget GT ms.budget>
					<cfset over_alloc = t.budget - ms.budget>
					<cfoutput>
						<tr>
							<td style="color:#t.color#;">#t.task_name# [TASK]</td>
							<td style="color:#t.color#;" nowrap>TASK BUDGET IS #numberFormat(over_alloc, ",_$___.__")# OVER ALLOCATED MILESTONE BUDGET</td>					
						</tr>
					</cfoutput>	
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
</table>
