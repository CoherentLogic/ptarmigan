<html>
<head>
<cfset project = CreateObject("component", "ptarmigan.project").open(url.id)>
<cfset milestones = project.milestones()>
<title><cfoutput>#project.project_name# - Gantt Chart</cfoutput></title>
<link href="../../ptarmigan.css" rel="stylesheet" type="text/css">
</head>
<body>

<cfset days_in_project = dateDiff("d", project.start_date, project.due_date)>
<cfset current_date = project.start_date>


<table class="pretty" border="1" cellpadding="5">
	<tr>
		<th nowrap><cfoutput><strong>#project.project_name#</cfoutput></th>
		
		<cfloop from="0" to="#days_in_project#" index="d">
			<th><cfoutput>#dateFormat(current_date, 'm/dd')#</cfoutput></th>
			
			<cfset current_date = dateAdd("d", 1, current_date)>
		</cfloop>
	</tr>
	<cfif ArrayLen(milestones) GT 0>
		<cfloop array="#milestones#" index="ms">
			<cfif ms.floating EQ 0>
			<tr>
			<th nowrap><cfoutput>#ms.milestone_name#</cfoutput></th>
			<cfset current_date = project.start_date>
			<cfloop from="0" to="#days_in_project#" index="d">
				<cfif (current_date GE ms.start_date) AND (current_date LE ms.end_date)>
					<td style="background-color:green;"></td>
				<cfelse>
					<td style="background-color:white;">&nbsp;</td>				
				</cfif>
				
				<cfset current_date = dateAdd("d", 1, current_date)>
			</cfloop>
			</tr>
			<cfset tasks = ms.tasks()>
				<cfif ArrayLen(tasks) GT 0>
					<cfloop array="#tasks#" index="task">
						<tr>
							<th nowrap>
								<span style="padding-left:20px;">
									<cfoutput>
										#task.task_name#
									</cfoutput>
								</span>
							</th>
							<cfset current_date = project.start_date>
							<cfloop from="0" to="#days_in_project#" index="d">
								<cfif (current_date GE task.start_date) AND (current_date LE task.end_date)>
									<td style="background-color:blue;">&nbsp;</td>
								<cfelse>
									<td style="background-color:white;">&nbsp;</td>				
								</cfif>
								
								<cfset current_date = dateAdd("d", 1, current_date)>	
							</cfloop>
						</tr>
						
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>			
	</cfif>
</table>

</body>
</html>