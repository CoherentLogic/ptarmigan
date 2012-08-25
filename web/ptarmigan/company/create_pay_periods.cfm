<cfmodule template="../security/require.cfm" type="admin">

<cfif IsDefined("form.submit")>
	
	<cfset current_day = DayOfWeek(Now())>	
	<cfset days_in_period = ((form.repeat_every * 7) - 1)>
	<cfif form.payday GE current_day>
		<cfset days_until_first_payday = form.payday - current_day>
	<cfelse>
		<cfset days_until_first_payday = current_day - form.payday>
	</cfif>
	<cfoutput>
		current_day: #current_day#<br>
		days_in_period: #days_in_period#<br>		
		days_until_first_payday: #days_until_first_payday#<br>
	</cfoutput>
	
	<cfset period_start = dateadd("d", days_until_first_payday, Now())>
	<cfset period_end = dateadd("d", days_in_period, period_start)>

	<cfloop from="1" to="52" index="ppcount">
		<cfset ppid = CreateUUID()>
		<cfoutput>
		 #ppcount#:	#dateFormat(period_start, "full")#-#dateFormat(period_end, "full")#<br>
		</cfoutput>
		
		<cfquery name="add_pp" datasource="ptarmigan">			
			INSERT INTO pay_periods
				(id,
				start_date,
				end_date,
				closed)
			VALUES
				('#ppid#',
				#CreateODBCDate(period_start)#,
				#CreateODBCDate(period_end)#,
				0)
		</cfquery>
		<cfset period_start = dateadd("d", days_in_period + 1, period_start)>
		<cfset period_end = dateadd("d", days_in_period, period_start)>
		
	</cfloop>
	
	<cflocation url="../default.cfm">
	
<cfelse>
	<div id="container">
		<div id="header">
			<h1>Set Pay Periods</h1>
			<p><em>Allows you to establish the schedule on which pay periods occur.</em></p>
		</div>
		
		<div id="navigation">
		
			<div class="help_box">
				<h3><img src="/ptarmigan/images/leaf.png" align="absmiddle"> Tip</h3>
				<p><em>You must establish pay periods in order to use the dashboard, time approval, some types of reminders, and many other features of the ptarmigan suite.</em></p>
				<p><em>Once you have established pay periods, you will be able to select a pay period in the Dashboard and view pertinent information for the current pay period or any that you select.</em></p>
				<p><em>Pay periods will need to be established once every 365 days during which your company conducts business, starting from the day on which you first established pay periods.</em></p>
			</div>
		</div>
		
		<div id="content">
		
			<form name="establish_pay_periods" action="create_pay_periods.cfm" method="post">
				<table>
					<tr>
						<td>Pay frequency:</td>
						<td>
							<select name="frequency">
								<option value="weekly">Weekly</option>
							</select>
						</td>				
					</tr>
					<tr>
						<td>Repeat every:</td>
						<td>
							<select name="repeat_every">
								<option value="1" selected>1</option>
								<!--- <option value="2">2</option> --->
							</select>
							weeks
						</td>
					</tr>
					<tr>
						<td>Payday is on:</td>
						<td>
							<select name="payday">
								<option value="1">Sundays</option>
								<option value="2">Mondays</option>
								<option value="3">Tuesdays</option>
								<option value="4">Wednesdays</option>
								<option value="5">Thursdays</option>
								<option value="6" selected>Fridays</option>
								<option value="7">Saturdays</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="right"><input type="submit" name="submit" value="Submit"></td>
					</tr>
					
				</table>
			</form>		
		</div>
	</div>
</cfif>
