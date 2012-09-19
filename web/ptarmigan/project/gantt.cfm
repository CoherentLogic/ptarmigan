<style type="text/css">
	table.gantt {
		border-collapse:collapse;
		font-family:Verdana,Arial,Helvetica,sans-serif;
	}
	table.gantt td, table.gantt th {
		border:1px solid whitesmoke;	
		padding:3px;
	}
	table.gantt th{
		background-color:whitesmoke;
		text-align:left;
	}
		
</style>
<cfif IsDefined("attributes.id")>
	<cfset project_id = attributes.id>
<cfelse>
	<cfset project_id = url.id>
</cfif>

<cfset project = CreateObject("component", "ptarmigan.project").open(project_id)>

<cfset tasks = project.tasks()>
<cfset days_in_project = project.get_duration()>
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
<table class="gantt" border="0" cellspacing="0" width="100%">
	<thead>
		<tr>
			
			<th colspan="9" style="border-top-left-radius:4px;"><cfoutput>#project.project_name#</cfoutput></th>
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
			<th nowrap><cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/information.png"></cfoutput></th>
			<th nowrap style="font-weight:bolder;">
				Task
			</th>	
			<th>Status</th>	
			<th>Duration</th>
			<th>Start</th>
			<th>End</th>
			<th>Predecessor</th>
			<th>Constraint</th>
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
	</thead>
	<tbody>
	<cfloop array="#tasks#" index="t">
				<tr>	
					<td style="background-color:white;">
						<cfif t.start EQ 1>
							<cfoutput><img src="#session.root_url#/images/diamond.jpg"></cfoutput>
						<cfelseif t.critical EQ 1>
							<cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/bullet_red.png"></cfoutput>
						</cfif>
					</td>				
					<td style="background-color:white;"><cfoutput>#t.task_name#</cfoutput></th>
					<td style="background-color:white;">&nbsp;</td>
					<td style="background-color:white;"><cfoutput>#t.duration#d</cfoutput></td>
					<td style="background-color:white;"><cfoutput>#dateFormat(t.start_date, "m/dd/yyyy")#</cfoutput></td>
					<td style="background-color:white;"><cfoutput>#dateFormat(t.end_date, "m/dd/yyyy")#</cfoutput></td>
					<td style="background-color:white;" nowrap>
						<cfset preds = t.predecessors()>
						<cfif ArrayLen(preds) GT 0>
						<cfoutput>
							#preds[1].task_name# [FS]																		
						</cfoutput>
						</cfif>
					</td>				
					<td style="background-color:white;">
						<cfoutput>#t.constraint_id#</cfoutput>
					</td>	
					<td style="background-color:white;"><cfoutput>#t.percent_complete#%</cfoutput></td>
					
					<cfset current_date = project.start_date>
					<cfloop from="0" to="#days_in_project#" index="d">
						<cfif (current_date GE t.start_date) AND (current_date LE t.end_date)>
							<cfif current_date EQ t.start_date>
								<cfset cell_id = t.id & "_start_cell">
							</cfif>
							<cfif current_date EQ t.end_date>
								<cfset cell_id = t.id & "_end_cell">
							</cfif>
							<cfoutput>							
							<cfif t.start EQ 0>
							<td style="background-color:#t.color#;" id="#cell_id#">
							<cfelse>
							<td style="background-color:white;" id="#cell_id#">
							</cfif>
								<cfif current_date EQ t.start_date AND t.start EQ 1>
									<img src="#session.root_url#/images/diamond.jpg">
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							</cfoutput>
						<cfelse>
							<td style="background-color:white;">&nbsp;</td>				
						</cfif>						
						<cfset current_date = dateAdd("d", 1, current_date)>
					</cfloop>
				</tr>				
		</cfloop>
	</tbody>
</table>
