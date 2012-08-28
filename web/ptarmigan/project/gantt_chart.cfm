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
		<th nowrap style="font-weight:bolder;">
			<cfoutput>
				<cfif attributes.mode EQ "edit">
					<cfmenu type="horizontal" bgcolor="gainsboro">
						<cfmenuitem display="#project.project_name#">
							<cfmenuitem display="Add milestone" href="add_milestone.cfm?id=#attributes.id#"/>
						</cfmenuitem>
					</cfmenu>
				<cfelse>
					#project.project_name#
				</cfif>
			</cfoutput>
		</th>
		<th>START</th>
		<th>END</th>
		<th>DAYS</th>
		<th>%</th>
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
			<cfif ms.floating EQ 0>
				<tr>					
				<th nowrap style="font-weight:bold;">
					<cfoutput>
						<cfif attributes.mode EQ "edit">
							<cfmenu type="horizontal" bgcolor="gainsboro">
							<cfmenuitem display="#ms.milestone_number#: #ms.milestone_name#">
								<cfmenuitem display="Edit milestone" href="javascript:edit_milestone('#session.root_url#', '#ms.id#');"/>								
								<cfmenuitem divider />
								<cfmenuitem display="Add task" href="javascript:add_task('#session.root_url#', '#attributes.id#', '#ms.id#');"/> 
								<cfmenuitem display="Add expense" href="##"/>
								<cfmenuitem display="Add document" href="##"/>
								<cfmenuitem divider />
								<cfmenuitem display="View audit log" href="javascript:view_audit_log('#session.root_url#', 'milestones', '#ms.id#')"/>
							</cfmenuitem>
							</cfmenu>
						<cfelse>
							#ms.milestone_number#: #ms.milestone_name#
						</cfif>
					</cfoutput>
				
				</th>
				
				<td style="background-color:white;"><cfoutput>#dateFormat(ms.start_date, "m/dd/yyyy")#</cfoutput></td>
				<td style="background-color:white;"><cfoutput>#dateFormat(ms.end_date, "m/dd/yyyy")#</cfoutput></td>
				<td style="background-color:white;" nowrap><cfoutput>#ms.duration(attributes.durations)#</cfoutput></td>
				<td style="background-color:white;"><cfoutput>#ms.percent_complete#%</cfoutput></td>
				<cfswitch expression="#attributes.durations#">
					<cfcase value="normal">
						<cfset ms_end_date = ms.end_date>
					</cfcase>
					<cfcase value="pessimistic">
						<cfset ms_end_date = ms.end_date_pessimistic>
					</cfcase>
					<cfcase value="optimistic">
						<cfset ms_end_date = ms.end_date_optimistic>
					</cfcase>
					<cfcase value="estimated">
						<cfset ms_end_date = ms.end_date_estimated()>
					</cfcase>
				</cfswitch>
				<cfset current_date = project.start_date>
				<cfloop from="0" to="#days_in_project#" index="d">
					<cfif (current_date GE ms.start_date) AND (current_date LE ms_end_date)>
						<cfoutput>
						<td style="background-color:#ms.color#;">&nbsp;</td>
						</cfoutput>
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
									
										<cfoutput>
											<cfif attributes.mode EQ "edit">
												<cfmenu type="horizontal" bgcolor="gainsboro">
													<cfmenuitem display="#task.task_name#">
														<cfmenuitem display="Edit task" href="manage_task.cfm?id=#task.id#"/>
														<cfmenuitem divider/>
														<cfmenuitem display="Add expense" href="##"/>
														<cfmenuitem display="Add document" href="##"/>
														<cfmenuitem divider />
														<cfmenuitem display="View audit log" href="javascript:view_audit_log('#session.root_url#', 'tasks', '#task.id#')"/>
													</cfmenuitem>
												</cfmenu>
											<cfelse>
												#task.task_name#
											</cfif>
										</cfoutput>
									
								</th>
								<td style="background-color:white;"><cfoutput>#dateFormat(task.start_date, "m/dd/yyyy")#</cfoutput></td>
								<td style="background-color:white;"><cfoutput>#dateFormat(task.end_date, "m/dd/yyyy")#</cfoutput></td>
								<td style="background-color:white;" nowrap><cfoutput>#task.duration(attributes.durations)#</cfoutput></td>
								<td style="background-color:white;"><cfoutput>#task.percent_complete#%</cfoutput></td>
								<cfswitch expression="#attributes.durations#">
									<cfcase value="normal">
										<cfset t_end_date = task.end_date>
									</cfcase>
									<cfcase value="pessimistic">
										<cfset t_end_date = task.end_date_pessimistic>
									</cfcase>
									<cfcase value="optimistic">
										<cfset t_end_date = task.end_date_optimistic>
									</cfcase>
									<cfcase value="estimated">
										<cfset t_end_date = task.end_date_estimated()>
									</cfcase>
								</cfswitch>
								<cfset current_date = project.start_date>
								<cfloop from="0" to="#days_in_project#" index="d">
									<cfif (current_date GE task.start_date) AND (current_date LE t_end_date)>
										<cfoutput>
										<td style="background-color:#task.color#;">&nbsp;</td>
										</cfoutput>
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