<cfmodule template="security/require.cfm" type="">


<cfinclude template="utility.cfm">

<cfset asgn = session.user.all_open_assignments()>

<h1>My Dashboard</h1>
<p><em><cfoutput>#dateFormat(now(), "full")#</cfoutput></em></p>
<p><a href="time/printable_day.cfm" target="_blank">Workday Guide (PDF)</a></p>
<h2>My Assignments</h2>

<cfoutput>
	<cfif session.user.clocked_in EQ 1>
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
		
		<h3>Clocked In</h3>
		<blockquote>
		<strong>CLOCKED-IN DATE/TIME:</strong> #dateFormat(session.user.clocked_timestamp, "full")# #RoundTo15(session.user.clocked_timestamp)#<br>
		<strong>CURRENT HOURS:</strong> #current_hours#<br>
		<strong>PROJECT:</strong> #project.project_name# [#project.customer().company_name#]<br>
		<strong>MILESTONE:</strong> #milestone.milestone_name#<br>
		<strong>TASK:</strong> #task.task_name#<br>
		<strong>TASK CODE:</strong> #task_code.task_name#<br>
		<strong>PAY RATE:</strong> $#emp_rate#/#task_code.unit_type# [#emp_pct#% OF BILLING RATE]<br>
		<strong>BILLING RATE:</strong> $#bill_rate#/#task_code.unit_type#<br>
		<strong>CURRENT BILLING:</strong> $#current_bill#<br>
		<strong>CURRENT PAY:</strong> $#current_pay#<br>
		<strong>NET PROFIT:</strong> $#company_net#<br>
		<form name="clocko" method="post" action="time/clock_out.cfm">
		<input type="submit" name="submit" value="Clock Out">
		</form>
		</blockquote>
		
		
		
	<cfelse>
		<p><em>You are not clocked in.</em></p>
	</cfif>
</cfoutput>

<table width="100%" border="1">
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
	        <td colspan="2" align="right"><input type="button" name="map" value="View Map"></td>
	    </tr>
		
	</cfoutput>
	
</cfloop>
</table>
<!---
<cfif session.user.is_time_approver() EQ true>
	<h2>Time Cards to Approve</h2>
</cfif>

<cfif session.user.is_billing_manager() EQ true>
	<h2>Invoices Due</h2>
</cfif>
--->