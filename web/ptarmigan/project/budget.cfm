<cfmodule template="../security/require.cfm" type="project">

<cfset project_id = attributes.id>

<cfset project = CreateObject("component", "ptarmigan.project").open(project_id)>
<cfset milestones = project.milestones()>



<table width="100%" class="pretty-nohover" style="margin:0;">
	<tr>
		<td width="20%" style="background-color:white" valign="top">
			<cfset total_budgeted_milestones = 0>
			<cfloop array="#milestones#" index="ms">
				<cfset total_budgeted_milestones = total_budgeted_milestones + ms.budget>
			</cfloop>
			<cfset ms_unbudgeted = project.budget - total_budgeted_milestones>
			<cfset ms_unbudgeted_percent = int((ms_unbudgeted * 100) / project.budget) / 100>
			<cfset color_list = "">
			<cfloop array="#milestones#" index="ms">
				<cfset color_list = listAppend(color_list, ms.color)>				
			</cfloop>
			<cfset color_list = ListAppend(color_list, "##FFB6C1")>
			<cfchart title="Milestone Budgets vs. Project Budget" labelformat="percent" pieslicestyle="sliced" backgroundcolor="white" format="png" showlegend="false" show3d="true" seriesplacement="percent">
				<cfchartseries type="pie" colorlist="#color_list#">
					<cfloop array="#milestones#" index="ms">
						<cfchartdata item="#ms.milestone_name#" value="#int((ms.budget * 100) / project.budget) / 100#">						
					</cfloop>
					<cfchartdata item="Unbudgeted" value="#ms_unbudgeted_percent#">
				</cfchartseries>
			</cfchart>
			
			<cfset total_budgeted_tasks = 0>
			<cfloop array="#milestones#" index="ms">
				<cfset tasks = ms.tasks()>
				<cfloop array="#tasks#" index="t">
					<cfset total_budgeted_tasks = total_budgeted_tasks + t.budget>
				</cfloop>
			</cfloop>
			<cfset t_unbudgeted = project.budget - total_budgeted_tasks>
			<cfset t_unbudgeted_percent = int((t_unbudgeted * 100) / project.budget) / 100>
			<cfset color_list = "">
			<cfloop array="#milestones#" index="ms">
				<cfset tasks = ms.tasks()>
				<cfloop array="#tasks#" index="t">
					<cfset color_list = listAppend(color_list, t.color)>				
				</cfloop>
			</cfloop>
			<cfset color_list = ListAppend(color_list, "##FFB6C1")>
			<cfchart title="Task Budgets vs. Project Budget" labelformat="percent" pieslicestyle="sliced" backgroundcolor="white" format="png" showlegend="false" show3d="true" seriesplacement="percent">
				<cfchartseries type="pie" colorlist="#color_list#">
					<cfloop array="#milestones#" index="ms">
						<cfset tasks = ms.tasks()>
						<cfloop array="#tasks#" index="t">
							<cfchartdata item="#t.task_name#" value="#int((t.budget * 100) / project.budget) / 100#">						
						</cfloop>
					</cfloop>
					<cfchartdata item="Unbudgeted" value="#t_unbudgeted_percent#">
				</cfchartseries>
			</cfchart>
			
				
			
			<!--- chart ---><br><hr>
			<!--- overages --->
		</td>
		<td valign="top">
			<table width="100%" class="pretty-nohover" style="margin:0;">
			<tr>
				<th colspan="4" style="font-weight:bolder;">
					<cfoutput>
						<h3>#project.project_name# BUDGET ALLOCATION</h3>
						<p>Total budget: #numberFormat(project.budget, ",_$___.__")#</p>						
					</cfoutput>
				</th>
			</tr>	
			<tr>				
				<th>MILESTONE/TASK</th>
				<th>BUDGET</th>
				<th>% PROJECT</th>
				<th>% MILESTONE</th>
				
			</tr>
			<cfloop array="#milestones#" index="ms">
				<tr>
				<cfoutput>
					<td style="color:#ms.color#;">
						<strong>#ms.milestone_name#</strong>
					</td>
					<td style="color:#ms.color#;">
						#numberFormat(ms.budget, ",_$___.__")#
					</td>
					<td style="color:#ms.color#;">
						#int((ms.budget * 100) / project.budget)#%
					</td>
					<td style="color:#ms.color#;">
						100%
					</td>					
				</cfoutput>
				</tr>
				<cfset tasks = ms.tasks()>
				<cfloop array="#tasks#" index="t">
						<tr>
							<cfoutput>
								<td style="padding-left:8px; color:#t.color#;">
									#t.task_name#
								</td>
								<td style="color:#t.color#;">
									#numberFormat(t.budget, ",_$___.__")#	
								</td>
								<td style="color:#t.color#;">
									#int((t.budget * 100) / project.budget)#%
								</td>
								<td style="color:#t.color#;">
									#int((t.budget * 100) / ms.budget)#%
								</td>
								
							</cfoutput>
						</tr>
				</cfloop>
			</cfloop>
			</table>
		</td>
	</tr>
</table>