<cfmodule template="../security/require.cfm" type="project">

<cfset project_id = attributes.id>

<cfset project = CreateObject("component", "ptarmigan.project").open(project_id)>
<cfset tasks = project.tasks()>



<table width="100%" class="pretty-nohover" style="margin:0;">
	<tr>
		<td width="20%" style="background-color:white" valign="top">
			<cfset total_budgeted_tasks = 0>
			<cfloop array="#tasks#" index="t">
				<cfset total_budgeted_tasks = total_budgeted_tasks + t.budget>
			</cfloop>
			<cfset t_unbudgeted = project.budget - total_budgeted_tasks>
			<cfset t_unbudgeted_percent = int((t_unbudgeted * 100) / project.budget) / 100>
			<cfset color_list = "">
			<cfloop array="#tasks#" index="t">
				<cfset color_list = listAppend(color_list, t.color)>				
			</cfloop>
			<cfset color_list = ListAppend(color_list, "##FFB6C1")>
			<cfsavecontent variable="sChartOutput">
				<cfchart title="Task Budgets vs. Project Budget" labelformat="percent" pieslicestyle="sliced" backgroundcolor="white" format="png" showlegend="false" show3d="true" seriesplacement="percent">
					<cfchartseries type="pie" colorlist="#color_list#">
						<cfloop array="#tasks#" index="t">
							<cfchartdata item="#t.task_name#" value="#int((t.budget * 100) / project.budget) / 100#">						
						</cfloop>
						<cfchartdata item="Unbudgeted" value="#t_unbudgeted_percent#">
					</cfchartseries>
				</cfchart>
			</cfsavecontent>

			<cfoutput>#reReplace(trim(sChartOutput), "<script[^>]+></script>", "", "all")#</cfoutput>
												
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
				<th>TASK</th>
				<th>BUDGET</th>
				<th>% PROJECT</th>
				
			</tr>
			<cfloop array="#tasks#" index="t">
				<tr>
				<cfoutput>
					<td style="color:#t.color#;">
						<strong>#t.task_name#</strong>
					</td>
					<td style="color:#t.color#;">
						#numberFormat(t.budget, ",_$___.__")#
					</td>
					<td style="color:#t.color#;">
						#int((t.budget * 100) / project.budget)#%
					</td>
				</cfoutput>
				</tr>
			</cfloop>
			</table>
		</td>
	</tr>
</table>