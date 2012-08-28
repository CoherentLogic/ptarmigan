<cfmodule template="../security/require.cfm" type="project">

<cfset project_id = attributes.id>

<cfset project = CreateObject("component", "ptarmigan.project").open(project_id)>
<cfset milestones = project.milestones()>

<table width="100%" class="pretty" style="margin:0;">
	<tr>
		<th colspan="8">
			<cfoutput>
				<h3>#project.project_name# EXPENSE RECORD</h3>
				<p>Total budget: #numberFormat(project.budget, ",_$___.__")#</p>						
			</cfoutput>
		</th>
	</tr>
	<tr>
		<th>TYPE</th>
		<th>MILESTONE/TASK</th>
		<th>DATE</th>
		<th>RECIPIENT</th>
		<th>PT. OF CONTACT</th>
		<th>ADDRESS</th>
		<th>AMOUNT</th>
		<th>BUDGET IMPACT</th>
	</tr>
	<cfloop array="#milestones#" index="ms">
		<cfset type = "MILESTONE">
		<cfset exps = ms.expenses()>
		<cfloop array="#exps#" index="e">
			<cfset ms_percent = int((e.amount * 100) / ms.budget)>
			<cfset p_percent = int((e.amount * 100) / project.budget)>
			<cfoutput>
				<tr>
					<td style="color:#ms.color#;">#type#</td>
					<td style="color:#ms.color#;">#ms.milestone_name#</td>
					<td style="color:#ms.color#;">#DateFormat(e.expense_date, "m/dd/yyyy")#</td>
					<td style="color:#ms.color#;">#e.recipient#</td>
					<td style="color:#ms.color#;">#e.poc#</td>
					<td style="color:#ms.color#;">
						#e.address#<br>
						#e.city# #e.state# #e.zip#
					</td>
					<td style="color:#ms.color#;">#numberFormat(e.amount, ",_$___.__")#</td>
					<td style="color:#ms.color#;">
						#ms_percent#%/MILESTONE<br>
						#p_percent#%/PROJECT
					</td>
				</tr>
				<tr>
					<td colspan="8">#e.description#</td>
				</tr>
			</cfoutput>
		</cfloop>
		<cfset tasks = ms.tasks()>
		<cfset type = "TASK">
		<cfloop array="#tasks#" index="t">
			<cfset exps = t.expenses()>
			<cfloop array="#exps#" index="e">
				<cfset ms_percent = int((e.amount * 100) / ms.budget)>
				<cfset t_percent = int((e.amount * 100) / t.budget)>
				<cfset p_percent = int((e.amount * 100) / project.budget)>
				<cfoutput>
					<tr>
						<td style="color:#t.color#;">#type#</td>
						<td style="color:#t.color#;">#t.task_name#</td>
						<td style="color:#t.color#;">#DateFormat(e.expense_date, "m/dd/yyyy")#</td>
						<td style="color:#t.color#;">#e.recipient#</td>
						<td style="color:#t.color#;">#e.poc#</td>
						<td style="color:#t.color#;">
							#e.address#<br>
							#e.city# #e.state# #e.zip#
						</td>
						<td style="color:#t.color#;">#numberFormat(e.amount, ",_$___.__")#</td>
						<td style="color:#t.color#;">
							#t_percent#%/TASK<br>
							#ms_percent#%/MILESTONE<br>
							#p_percent#%/PROJECT
						</td>
					</tr>
					<tr>
						<td colspan="8">#e.description#</td>
					</tr>
				</cfoutput>
			</cfloop>
		</cfloop>
	</cfloop>
		
</table>