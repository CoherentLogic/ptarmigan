<cfmodule template="../security/require.cfm" type="admin">


<cfif IsDefined("form.submit")>
	<cfset t = CreateObject("component", "ptarmigan.employee")>
	
	<cfset t.username = UCase(form.t_username)>
	<cfset t.password_hash = hash(form.t_password)>
	
	<cfif IsDefined("form.active")>
		<cfset t.active = 1>
	<cfelse>
		<cfset t.active = 0>
	</cfif>
	
	<cfset t.honorific = form.honorific>
	<cfset t.first_name = UCase(form.first_name)>
	<cfset t.middle_initial = UCase(form.middle_initial)>
	<cfset t.last_name = UCase(form.last_name)>
	<cfset t.suffix = UCase(form.suffix)>
	
	<cfset t.title = UCase(form.title)>
	<cfset t.hire_date = CreateODBCDate(form.hire_date)>
	<cfif trim(form.term_date) NEQ "">
		<cfset t.term_date = CreateODBCDate(form.term_date)>
	<cfelse>
		<cfset t.term_date = 0>
	</cfif>
	
	<cfset t.mail_address = UCase(form.mail_address)>
	<cfset t.mail_city = UCase(form.mail_city)>
	<cfset t.mail_state = UCase(form.mail_state)>
	<cfset t.mail_zip = UCase(form.mail_zip)>
	
	<cfset t.email = form.email>
	<cfset t.work_phone = UCase(form.work_phone)>
	<cfset t.home_phone = UCase(form.home_phone)>
	<cfset t.mobile_phone = UCase(form.mobile_phone)>
	
	<cfset emp_id = t.create()> 
	
	<cfif IsDefined("form.admin")>
		<cfset t.admin(true)>
	<cfelse>
		<cfset t.admin(false)>
	</cfif>
	
	<cfif IsDefined("form.time_approver")>
		<cfset t.time_approver(true)>
	<cfelse>
		<cfset t.time_approver(false)>
	</cfif>
	
	<cfif IsDefined("form.project_manager")>
		<cfset t.project_manager(true)>
	<cfelse>
		<cfset t.project_manager(false)>
	</cfif>
	
	<cfif IsDefined("form.billing_manager")>
		<cfset t.billing_manager(true)>
	<cfelse>
		<cfset t.billing_manager(false)>
	</cfif>
		
	<center>
		<h1>Employee Created</h1>
		<cfoutput><a href="view_employee.cfm?id=#t.id#" target="content">View Employee</a></cfoutput>
	</center>	
<cfelse>
<h1>New Employee</h1>

	<form name="add_employee" id="add_employee" action="add_employee.cfm" method="post">
		
		
		<table width="100%">
		<tr>
		<td><h2>Authentication</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Username:</td>
		<td><input type="text" name="t_username" value=""></td>
		</tr>
		<tr>
		<td>Password:</td>
		<td><input type="password" name="t_password" value=""></td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		<td><input type="checkbox" name="active">Active</td>
		</tr>
		<tr>		
		<td><h2>Roles</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>&nbsp</td>
		<td>
			<label><input type="checkbox" name="admin">Site administrator</label><br>
			<label><input type="checkbox" name="time_approver">Time collection manager</label><br>
			<label><input type="checkbox" name="project_manager">Project manager</label><br>
			<label><input type="checkbox" name="billing_manager">Billing manager</label>
		</td>
		<tr>
		<td><h2>Identity</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Gender:</td>
		<td>
			<select name="gender">
				<option value="M">Male</option>
				<option value="F">Female</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>Honorific:</td>
		<td><select name="honorific">
				<option value="MR.">Mr.</option>
				<option value="MASTER">Master</option>
				<option value="MRS.">Mrs.</option>
				<option value="MS.">Ms.</option>
				<option value="MISS">Miss</option>
				<option value="DR.">Dr.</option>
				<option value="FR.">Fr.</option>
				<option value="SR.">Sr.</option>
				<option value="REV.">Rev.</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>Name:</td>		
		<td>
		<label>First:<input type="text" name="first_name"></label>
		<label>Middle Initial:<input type="text" name="middle_initial" size="1"></label>
		<label>Last:<input type="text" name="last_name"></label>
		<label>Suffix:<input type="text" name="suffix" size="3"></label>
		</td>
		</tr>
		<tr>
		<td><h2>Employment</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Title:</td>
		<td><input type="text" name="title"></td>
		</tr>
		<tr>
		<td>Hire date (MM/DD/YYYY):</td>
		<td><input type="text" name="hire_date"></td>
		</tr>
		<tr>
		<td>Termination date (MM/DD/YYYY):</td>
		<td><input type="text" name="term_date"></td>
		</tr>
		<tr>
		<td><h2>Contact Information</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Mailing Address:</td>
		<td><input type="text" name="mail_address"></td>
		</tr>
		<tr>
		<td>City:</td>
		<td><input type="text" name="mail_city"></td>
		</tr>
		<tr>
		<td>State:</td>
		<td><input type="text" size="2" maxlength="2" name="mail_state"></td>
		</tr>
		<tr>
		<td>ZIP:</td>
		<td><input type="text" size="5" maxlength="5" name="mail_zip"></td>
		</tr>
		<tr>
		<td>E-Mail Address:</td>
		<td><input type="text" name="email"></td>
		</tr>
		<tr>
		<td>Work Phone:</td>
		<td><input type="text" name="work_phone"></td>
		</tr>
		<tr>
		<td>Home Phone:</td>
		<td><input type="text" name="home_phone"></td>
		</tr>
		<tr>
		<td>Mobile Phone:</td>
		<td><input type="text" name="mobile_phone"></td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		<td align="right"><input type="submit" name="submit" value="Submit"></td>
		</tr>
		</table>
	</form>
</cfif>