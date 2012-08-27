<cfset project = CreateObject("component", "ptarmigan.project").open(attributes.id)>
<cfset milestones = project.milestones()>

<cfset days_in_project = dateDiff("d", project.start_date, project.due_date)>
<cfset current_date = project.start_date>
<cfset today_date = dateFormat(now(), "mm/dd/yyyy")>



<cfset start_project_day = DateFormat(project.start_date, "ddd")>


<cfswitch expression="#start_project_day#">
	<cfcase value="Mon">
		<cfset pre = 0>
	</cfcase>
	<cfcase value="Tue">
		<cfset pre = 6>
	</cfcase>
	<cfcase value="Wed">
		<cfset pre = 5>
	</cfcase>
	<cfcase value="Thu">
		<cfset pre = 4>
	</cfcase>
	<cfcase value="Fri">
		<cfset pre = 3>
	</cfcase>
	<cfcase value="Sat">
		<cfset pre = 2>
	</cfcase>
	<cfcase value="Sun">
		<cfset pre = 1>
	</cfcase>
		
</cfswitch>

<table class="pretty" border="1" cellpadding="5" style="width:100%;margin:0px;">
	<tr>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<th>&nbsp;</th>
		<cfif pre GT 0>
			<cfoutput>
			<th colspan="#pre#">&nbsp;</th>
			</cfoutput>
		</cfif>
		<cfloop from="0" to="#days_in_project#" index="d">
			
				
				<cfif dateFormat(current_date, 'ddd') EQ "MON">
					<th valign="top" colspan="7">
					<cfoutput>
						#dateFormat(current_date, "mmm d, ''yy")#
					</cfoutput>
					</th>
				</cfif>
			
			<cfset current_date = dateAdd("d", 1, current_date)>
		</cfloop>
	</tr>
	<tr>
		<th nowrap><cfoutput><strong style="font-weight:bolder;">#project.project_name# <cfmodule template="/ptarmigan/link_box.cfm" text="Milestone" symbol="+" href="add_milestone.cfm?id=#attributes.id#"></cfoutput></th>
		<th>START</th>
		<th>END</th>
		<th>DAYS</th>
		<cfset current_date = project.start_date>
		<cfloop from="0" to="#days_in_project#" index="d">
			<cfset date_working = dateFormat(current_date, "mm/dd/yyyy")>
			<th valign="top" <cfif date_working EQ today_date>style="background-color:navy;color:white;font-weight:bold;width:30px;"<cfelse>style="width:30px;"</cfif>>
				
				<cfoutput>#left(dateFormat(current_date, 'ddd'),1)#</cfoutput>
				
			</th>
				
				
			<cfset current_date = dateAdd("d", 1, current_date)>
		</cfloop>
	</tr>
	<cfif ArrayLen(milestones) GT 0>
		<cfloop array="#milestones#" index="ms">
			<cfset days_in_milestone = dateDiff("d", ms.start_date, ms.end_date) + 1>
			<cfif ms.floating EQ 0>
				<tr>					
				<th nowrap style="font-weight:bold;"><cfoutput>#ms.milestone_number#: <a href="edit_milestone.cfm?id=#ms.id#">#ms.milestone_name#</a> 
				<cfmodule template="/ptarmigan/link_box.cfm" text="Task" symbol="+" href="add_task.cfm?id=#attributes.id#&milestone_id=#ms.id#"> 
				<cfmodule template="/ptarmigan/link_box.cfm" text="Expense" symbol="+" href="##">
				<cfmodule template="/ptarmigan/link_box.cfm" text="Document" symbol="+" href="##"></cfoutput>
				
				</th>
				
				<td style="background-color:white;"><cfoutput>#dateFormat(ms.start_date, "m/dd/yyyy")#</cfoutput></td>
				<td style="background-color:white;"><cfoutput>#dateFormat(ms.end_date, "m/dd/yyyy")#</cfoutput></td>
				<td style="background-color:white;"><cfoutput>#days_in_milestone#</cfoutput></td>
				
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
						<cfset days_in_task = dateDiff("d", task.start_date, task.end_date)>
							<tr>
								<th nowrap>
									<span style="padding-left:20px;">
										<cfoutput>
											<a href="manage_task.cfm?id=#task.id#">#task.task_name#</a>
										</cfoutput>
									</span>
								</th>
								<td style="background-color:white;"><cfoutput>#dateFormat(task.start_date, "m/dd/yyyy")#</cfoutput></td>
								<td style="background-color:white;"><cfoutput>#dateFormat(task.end_date, "m/dd/yyyy")#</cfoutput></td>
								<td style="background-color:white;"><cfoutput>#days_in_task#</cfoutput></td>
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
			<cfelse><!--- ms.floating EQ 1 --->
				<tr>					
					<th nowrap><cfoutput><em style="font-style:italic;"><a href="edit_milestone.cfm?id=#ms.id#&suppress_headers">#ms.milestone_name#</a></em></cfoutput> [FLOATING] <cfmodule template="/ptarmigan/link_box.cfm" text="Task" symbol="+" href="add_task.cfm?id=#attributes.id#&milestone_id=#ms.id#"></th>
					<th style="background-color:white;" colspan="<cfoutput>#days_in_project+4#</cfoutput>"></th>
					
				</tr>
			</cfif> <!--- ms.floating EQ 0 --->
		</cfloop>			
	</cfif>
</table>

</body>
</html>