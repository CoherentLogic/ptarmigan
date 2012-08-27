<cfmodule template="security/require.cfm" type="">

<cfif IsDefined("form.current_pay_period")>
	<cfset pay_period_id = form.current_pay_period>
<cfelseif IsDefined("url.pay_period_id")>
	<cfset pay_period_id = url.pay_period_id>
</cfif>

<cfif NOT IsDefined("url.pay_period_id") AND NOT IsDefined("form.current_pay_period")>
	<cfquery name="get_current_pay_period" datasource="#session.company.datasource#">
		SELECT 	* 
		FROM 	pay_periods 
		WHERE 	start_date<=#CreateODBCDate(Now())#
		AND 	end_date>=#CreateODBCDate(Now())#
	</cfquery>
	<cfset selected_pay_period_id = get_current_pay_period.id>
	<cfset pay_period_id = get_current_pay_period.id>
<cfelse>
	<cfquery name="get_current_pay_period" datasource="#session.company.datasource#">
		SELECT	*
		FROM	pay_periods
		WHERE	id='#pay_period_id#'
	</cfquery>
	
	
	<cfset selected_pay_period_id = pay_period_id>

</cfif>



<cfset open_date = get_current_pay_period.start_date>
<cfset close_date = get_current_pay_period.end_date>
<cfif get_current_pay_period.closed EQ 1>
	<cfset period_status = "CLOSED">
<cfelse>
	<cfset period_status = "OPEN">
</cfif>

<cfset stats = CreateObject("component", "ptarmigan.company.statistics")>

<cfquery name="get_pay_periods" datasource="#session.company.datasource#">
	SELECT 		* 
	FROM 		pay_periods 
	ORDER BY 	start_date
</cfquery>





<cfinclude template="utility.cfm">

<cfset asgn = session.user.all_open_assignments()>

<div id="container">
	<div id="header">
		<h1>Dashboard</h1>
		<p><em><cfoutput>#dateFormat(now(), "full")#</cfoutput></em> | <a href="time/printable_day.cfm" target="_blank">Workday Guide (PDF)</a></p>
	</div>
	
	<div id="navigation">
		<cflayout type="accordion">	
			<cflayoutarea title="PAY PERIOD">
				<form name="change_pay_period" action="dashboard.cfm" method="post">
				<table class="property_dialog">
					<tr>
						<td>Date range</td>
						<td>
							<select name="current_pay_period" onchange="this.form.submit();">
								<cfoutput query="get_pay_periods">
									<option value="#id#" <cfif selected_pay_period_id EQ id>selected</cfif>>#dateFormat(start_date, 'm/dd/yyyy')#-#dateFormat(end_date, 'm/dd/yyyy')#</option>
								</cfoutput>
							</select>
						</td>						
					</tr>
					<tr>
						<td>Status</td>
						<td><cfoutput>#period_status#</cfoutput></td>					
					</tr>
					<tr>
						<td>Hours worked (me)</td>
						<td><cfoutput>#stats.hours_worked(open_date, close_date, session.user.id)#</cfoutput></td>
					</tr>
					<cfif session.user.is_time_approver() EQ true>
					<tr>
						<td>Hours worked (company)</td>
						<td><cfoutput>#stats.hours_worked(open_date, close_date)#</cfoutput></td>
					</tr>
					</cfif>
					<cfif session.user.is_project_manager() EQ true>
					<tr>
						<td>Projects active</td>
						<td>
							<cfoutput>
								#stats.projects_open(open_date, close_date)#
							</cfoutput>	
						</td>
					</tr>
					</cfif>
					<tr>
						<td>Assignments (me)</td>
						<td>
							<cfoutput>
								#stats.assignments_open(open_date, close_date, session.user.id)#
							</cfoutput>
						</td>
					</tr>
					<cfif session.user.is_project_manager() EQ true>
					<tr>
						<td>Assignments (company)</td>
						<td>
							<cfoutput>
								#stats.assignments_open(open_date, close_date)#								
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td>Milestones active</td>
						<td>
							<cfoutput>
								#stats.milestones_open(open_date, close_date)#
							</cfoutput>
						</td>						
					</tr>
					<tr>
						<td>Tasks active</td>
						<td>
							<cfoutput>
								#stats.tasks_open(open_date, close_date)#
							</cfoutput>
						</td>
					</tr>
					</cfif>
				</table>
				<input type="submit" name="change_pay_period" value="Update">
				</form>
			
			</cflayoutarea>
		</cflayout>
		
		<cfif session.user.clocked_in EQ 1>
			<cflayout type="accordion">	
				<cflayoutarea title="CURRENT TIME ENTRY">
				<cfset ctcai = CreateObject("component", "ptarmigan.code_assign").open(session.user.clocked_task_code_asgn_id)>
				<cfset task_code = CreateObject("component", "ptarmigan.task_code").open(ctcai.task_code_id)>
				<cfset asgnm = CreateObject("component", "ptarmigan.assignment").open(ctcai.assignment_id)>
				<cfset task = CreateObject("component", "ptarmigan.task").open(asgnm.task_id)>
				<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(task.milestone_id)>
				<cfset project = CreateObject("component", "ptarmigan.project").open(milestone.project_id)>
				
				
				
				<cfset emp_rate = ctcai.employee_rate>
				<cfset bill_rate = ctcai.rate>
				
				<cfset current_hours = hours_decimal(session.user.clocked_timestamp, Now())>
				<cfset current_pay = emp_rate * current_hours>
				<cfset current_bill = bill_rate * current_hours>
				<cfset company_net = current_bill - current_pay>
				
				<cfset emp_pct = Int((emp_rate * 100) / bill_rate)>
				<cfoutput>
				<table class="property_dialog">
					<tr>
						<td>Clocked-in time</td>
						<td>#dateFormat(session.user.clocked_timestamp, "full")# #RoundTo15(session.user.clocked_timestamp)#</td>
					</tr>
					<tr>
						<td>Current hours</td>
						<td>#current_hours#</td>
					</tr>
					<tr>
						<td>Project</td>
						<td>#project.project_name#</td>
					</tr>
					<tr>
						<td>Customer</td>
						<td>#project.customer().company_name#</td>
					</tr>
					<tr>
						<td>Milestone</td>
						<td>#milestone.milestone_name#</td>
					</tr>
					<tr>
						<td>Task</td>
						<td>#task.task_name#</td>
					</tr>
					<tr>
						<td>Task code</td>
						<td>#task_code.task_name#</td>
					</tr>
					<tr>
						<td>Pay rate</td>
						<td>$#emp_rate#/#task_code.unit_type# [#emp_pct#% OF BILLING RATE]</td>
					</tr>
					<tr>
						<td>Billing rate</td>
						<td>$#bill_rate#/#task_code.unit_type#</td>
					</tr>
					<tr>
						<td>Current billing</td>
						<td>$#current_bill#</td>
					</tr>
					<tr>
						<td>Current pay</td>
						<td>$#current_pay#</td>
					</tr>
					<tr>
						<td>Net profit</td>
						<td>$#company_net#</td>
					</tr>
				</table>
				</cfoutput>
				<form name="clock_out" method="post" action="time/clock_out.cfm">
				<input type="submit" name="submit" value="Clock Out">
				</form>
				</cflayoutarea>
			</cflayout>
		</cfif>
	</div>

	<div id="content">
		<cflayout type="tab">
			<cflayoutarea title="My Assignments">
		
				<table width="100%" border="1" class="pretty-nohover" style="margin:0;">
					<cfloop array="#asgn#" index="ca">
						<cfoutput>
									
						    <tr>
						        <td colspan="2" rowspan="2">
									<h3>#ca.project_name()#: #ca.milestone_name()#</h3>
									<p><em>#ca.task_name()#</em> [#LTrim(ca.customer_name())#]</p>
								</td>
						        <td>START DATE:</td>
						        <td>#dateFormat(ca.start_date, "MM/DD/YYYY")#</td>
						    </tr>
						    <tr>
						        <td>END DATE:</td>
						        <td>#dateFormat(ca.end_date, "MM/DD/YYYY")#</td>
						    </tr>
						    <tr>
						        <td colspan="2">
							        <h4>Instructions</h4>
									<p>#ca.instructions#</p>
								</td>
						        <td colspan="2">
							        <h4>Location</h4>
									<cfswitch expression="#ca.location_preference#">
										<cfcase value="0">
											#ca.address#<br>
											#ca.city#<cfif Len(ca.city) GT 0>,</cfif> #ca.state#  #ca.zip#
										</cfcase>
										<cfcase value="1">
											LATITUDE: #ca.latitude#<br>
											LONGITUDE: #ca.longitude#
										</cfcase>
									</cfswitch>
								</td>
						    </tr>
						    <tr>
						        <td>
							    	<cfif session.user.clocked_in EQ 0>
								        <cfset task_codes = ca.task_codes()>
										<form name="clock" method="post" action="time/clock_in.cfm">
											<select name="tca">
												<cfloop array="#task_codes#" index="tca">
													<option value="#tca.assigned_code_id#">#tca.task_name#</option>
												</cfloop>
											</select>
											<input type="submit" name="clock_in" value="Clock In">					
										</form>
									<cfelse>
										<p><em>You are already clocked in. Clock out to select another task.</em></p>
									</cfif>
										
								</td>
						        <td>
							    	<a href="time/add_time.cfm?assignment_id=#ca.id#">Enter time manually</a>
								</td>
								<cfif ca.location_preference EQ 0>
									<cfset address_string = URLEncodedFormat(ca.address & " " & ca.city & " " & ca.state & "," & ca.zip)>	
								<cfelse>
									<cfset address_string = URLEncodedFormat(ca.latitude & "," & ca.longitude)>
								</cfif>
						        <td colspan="2" align="right"><a href="project/view_map.cfm?address_string=#address_string#" target="_blank">View Map</a></td>
						    </tr>							
						</cfoutput>						
					</cfloop>
				</table>
			</cflayoutarea>
			<cfif session.user.is_project_manager() EQ true>
				<cflayoutarea title="Calendar">
					
					<cfset next_day = open_date>
					<table width="100%">
						<tr>						
							<cfloop from="1" to="7" index="dayNum">
								<td>
									<div style="width:200px;height:200px;overflow:auto;border:1px solid black;">
									<span style="color:gray; text-transform:uppercase; letter-spacing:3px;">
									<cfoutput>#dateFormat(next_day, "dddd, mmm")#</cfoutput>
									</span>
									<cfoutput><h1 style="margin-top:0; padding-top:0;">#dateFormat(next_day, "d")#</cfoutput></h1>
									
									<cfset priority_projects = CreateObject("component", "ptarmigan.company.company").priority_projects(next_day, next_day)>
									<cfloop array="#priority_projects#" index="p">
										<cfoutput><a href="project/edit_project.cfm?id=#p.id#">#p.project_name# DUE</a><br></cfoutput>
									</cfloop>
									</div>
								</td>
								<cfset next_day = dateAdd("d", 1, next_day)>
							</cfloop>
						</tr>
					</table>
					
				</cflayoutarea>
			</cfif>
			<cfif session.user.is_billing_manager() EQ true>
				<cflayoutarea title="Labor">
				
				</cflayoutarea>
				<cflayoutarea title="Expenses">
				
				</cflayoutarea>
			</cfif>
			<cflayoutarea title="In/Out Board">
			
			</cflayoutarea>
		</cflayout>
	</div>
</div>