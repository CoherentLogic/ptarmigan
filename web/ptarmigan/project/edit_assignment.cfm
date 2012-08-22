<cfset a = CreateObject("component", "ptarmigan.assignment").open(url.id)>

<cfset e = CreateObject("component", "ptarmigan.employee").open(a.employee_id)>
<cfset t = CreateObject("component", "ptarmigan.task").open(a.task_id)>




<cfquery name="get_task_codes" datasource="ptarmigan">
	SELECT id FROM task_codes ORDER BY task_name
</cfquery>
	
<cfset tc = ArrayNew(1)>

<cfoutput query="get_task_codes">
	<cfset d = CreateObject("component", "ptarmigan.task_code").open(id)>
	<cfset ArrayAppend(tc, d)>
</cfoutput>

<cfif IsDefined("form.submit_assignment")>
	<cfset a.start_date = CreateODBCDate(form.start_date)>
	<cfset a.end_date = CreateODBCDate(form.end_date)>
	<cfset a.instructions = form.instructions>
	<cfset a.address = form.address>
	<cfset a.city = form.city>
	<cfset a.state = form.state>
	<cfset a.zip = form.zip>
	<cfset a.latitude = form.latitude>
	<cfset a.longitude = form.longitude>
	<cfset a.location_preference = form.location_preference>
	
	<cfset a.update()>
	<cfset a.open(url.id)>
	<cfset session.message = "Assignment updated">
	

</cfif>

<cfif IsDefined("form.submit_codes")>
	
	<h3>Codes Modified</h3>
	
	
	<cfif IsDefined("form.modify")>
		<cfset modify_codes = ListToArray(form.modify)>
		<cfset mod_count = ArrayLen(modify_codes)>
	<cfelse>
		<cfset mod_count = 0>
	</cfif>
	
	<cfif mod_count EQ 0>
		<p><em>No codes to modify.</em></p>
	<cfelse>
		<ul>
		<cfloop array="#modify_codes#" index="code">
	
			
			<cfset real_code = replace(code, "_", "-", "all")>

			<cfset cmod = CreateObject("component", "ptarmigan.code_assign").open(real_code)>
			<!--- <cfdump var="#cmod#"> --->
			<cfset ctask = CreateObject("component", "ptarmigan.task_code").open(cmod.task_code_id)>
			<cfoutput>
				<li>#ctask.task_code#: #ctask.task_name#</li>
			</cfoutput>
								
			<cfset rate_field = "form.rate_#code#">
			<cfset rate_value = evaluate(rate_field)>			
			
			<cfset employee_rate_field = "form.employee_rate_#code#">	
			<cfset employee_rate_value = evaluate(employee_rate_field)>
			
			<cfif IsDefined("form.billable")>
				<cfset bill = ListToArray(form.billable)>				
				
				<cfloop array="#bill#" index="b">
					<cfif b EQ code>
						<cfset billable = 1>
						<cfbreak>
					<cfelse>
						<cfset billable = 0>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset billable = 0>
			</cfif>
				
			
			
						
			<cfset cmod.rate = rate_value>
			<cfset cmod.employee_rate = employee_rate_value>
			<cfset cmod.billable = billable>
			
			
			<!--- <cfdump var="#cmod#"> --->
			
			<cfset cmod.update()>
			
			
			<cfset billable = 1>
					
			
		</cfloop>
		</ul>
	</cfif> <!--- ArrayLen(modify_codes) EQ 0 --->
	
	<h3>Codes Removed</h3>
	
	<cfif IsDefined("form.remove")>
		<cfset remove_codes = ListToArray(form.remove)>
		<cfset remove_count = ArrayLen(remove_codes)>
	<cfelse>
		<cfset remove_count = 0>
	</cfif>		
	<cfif remove_count EQ 0>
		<p><em>No codes to remove.</em></p>
	<cfelse>
		<ul>
		<cfloop array="#remove_codes#" index="code">
			<cfset real_code = replace(code, "_", "-", "all")>
			
			<cfquery name="time_interlock" datasource="ptarmigan">
				SELECT id FROM time_entries WHERE task_code_assignment_id='#real_code#'
			</cfquery>
			
			<cfif time_interlock.recordcount EQ 0>
				<cfset cdel = CreateObject("component", "ptarmigan.code_assign").open(real_code)>
				<cfset ctask = CreateObject("component", "ptarmigan.task_code").open(cdel.task_code_id)>
				<li><span style="color:green;">REMOVING</span> <cfoutput>[#ctask.task_code#: #ctask.task_name#]</cfoutput></li>
				<cfquery name="remove_code" datasource="ptarmigan">
					DELETE FROM task_code_assignments WHERE id='#real_code#'
				</cfquery>
			<cfelse>
				<cfset cdel = CreateObject("component", "ptarmigan.code_assign").open(real_code)>
				<cfset ctask = CreateObject("component", "ptarmigan.task_code").open(cdel.task_code_id)>
				<li><span style="color:red;">CANNOT REMOVE</span> <cfoutput>[#ctask.task_code#: #ctask.task_name#]: USED BY #time_interlock.recordcount# TIME COLLECTION ENTRIES</cfoutput></li>
				
			</cfif>
		</cfloop>
		</ul>
	</cfif>
	
</cfif> <!--- submit code assignment mods/removals --->

<cfquery name="get_task_assigns" datasource="ptarmigan">
	SELECT id FROM task_code_assignments WHERE assignment_id='#url.id#'
</cfquery>

<cfset ca = ArrayNew(1)>

<cfoutput query="get_task_assigns">
	<cfset ca_tmp = CreateObject("component", "ptarmigan.code_assign").open(id)>
	<cfset ArrayAppend(ca, ca_tmp)>
</cfoutput>

<h1>Edit Assignment</h1>

<cfif IsDefined("form.submit_assignment")>
	<p><em>Assignment updated</em></p>
</cfif>

<cfoutput>
	<form name="edit_assignment" action="edit_assignment.cfm?id=#url.id#" method="post">	
		<table>
			<tr>
				<td>Employee:</td>
				<td>#e.last_name#, #e.honorific# #e.first_name# #e.middle_initial# #e.suffix# (#e.title#)</td>
			</tr>
			<tr>
				<td>Task:</td>
				<td>#t.task_name#</td>
			</tr>
			<tr>
				<td>Start date (MM/DD/YYYY):</td>
				<td><input type="text" name="start_date" value="#dateFormat(a.start_date, 'mm/dd/yyyy')#"></td>
			</tr>
			<tr>
				<td>End date (MM/DD/YYYY):</td>
				<td><input type="text" name="end_date" value="#dateFormat(a.end_date, 'mm/dd/yyyy')#"></td>
			</tr>
			<tr>
				<td>Instructions to employee:</td>
				<td><textarea name="instructions" rows="10" cols="50">#a.instructions#</textarea></td>
			</tr>
			<tr>
				<td>Street address:</td>
				<td><input type="text" name="address" value="#a.address#"></td>
			</tr>
			<tr>
				<td>City:</td>
				<td><input type="text" name="city" value="#a.city#"></td>
			</tr>
			<tr>
				<td>State:</td>
				<td><input type="text" name="state" size="2" maxlength="2" value="#a.state#"></td>
			</tr>
			<tr>
				<td>ZIP:</td>
				<td><input type="text" name="zip" size="5" maxlength="5" value="#a.zip#"></td>
			</tr>
			<tr>
				<td>Latitude:</td>
				<td><input type="text" name="latitude" value="#a.latitude#"></td>
			</tr>
			<tr>
				<td>Longitude:</td>
				<td><input type="text" name="longitude" value="#a.longitude#"></td>
			</tr>
			<tr>
				<td>Location preference:</td>
				<td>
					<select name="location_preference">
						<option value="0" <cfif a.location_preference EQ 0>selected</cfif>>Street address</option>
						<option value="1" <cfif a.location_preference EQ 1>selected</cfif>>Latitude, Longitude</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td align="right">
					<input type="submit" name="submit_assignment" value="Submit">
				</td>
			</tr>
		</table>				
	</form>
</cfoutput>

<hr>

<h2>Current Task Codes for This Assignment</h2>

<cfoutput>
<form name="select_task_codes" action="edit_assignment.cfm?id=#url.id#" method="post">
</cfoutput>
<table border="1" width="100%" class="pretty">
		<tr>		
			<th>REMOVE</th>	
			<th>MODIFY</th>
			<th>TASK CODE</th>
			<th>NAME</th>
			<th>RATE</th>
			<th>UNIT TYPE</th>
			<th>BILLABLE</th>
						
		</tr>
		<cfloop array="#ca#" index="c">
			<cfset field_name = Replace(c.id, "-", "_", "all")>
			<cfset task_code = CreateObject("component", "ptarmigan.task_code").open(c.task_code_id)>
			<cfoutput>
			<tr>
				<td><input type="checkbox" name="remove" value="#field_name#"></td>
				<td><input type="checkbox" name="modify" value="#field_name#"></td>
				<td>#task_code.task_code#&nbsp;</td>
				<td>#task_code.task_name#&nbsp;</td>
				<td>
					<label>BILLING RATE: $<input type="text" name="rate_#field_name#" value="#c.rate#"></label><br>
					<label>EMPLOYEE RATE: $<input type="text" name="employee_rate_#field_name#" value="#c.employee_rate#"></label>
				</td>
				<td>#task_code.unit_type#</td>
				<td><input type="checkbox" name="billable" value="#field_name#" <cfif c.billable EQ 1>checked</cfif>></td>			
			</tr>
			</cfoutput>
		</cfloop>
</table>	
<input type="submit" name="submit_codes" value="Submit">	
</form>