<cfmodule template="../security/require.cfm" type="admin">


<cfif IsDefined("form.submit")>
	<cfset t = CreateObject("component", "ptarmigan.employee").open_by_username(form.username)>
	
	<cfset t.username = UCase(form.username)>
	<cfset t.password_hash = hash(form.password)>
	
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
	
	<cfset emp_id = t.update()> 
	
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
		<h1>Employee Updated</h1>
		<cfoutput><a href="view_employee.cfm?id=#t.id#" target="content">View Employee</a></cfoutput>
	</center>	
<cfelse>
<cfset t = CreateObject("component", "ptarmigan.employee").open(form.id)>
<h1>Edit Employee</h1>
<cfoutput>
	<form name="edit_employee" id="edit_employee" action="edit_employee.cfm" method="post">
		
		
		<table>
		<tr>
		<td><h2>Authentication</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Username:</td>
		<td><input type="text" name="username" value="#t.username#"></td>
		</tr>
		<tr>
		<td>Password:</td>
		<td><input type="password" name="password"></td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		<td><input type="checkbox" name="active" <cfif t.active EQ 1>checked</cfif>>Active</td>
		</tr>
		<tr>		
		<td><h2>Roles</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>&nbsp</td>
		<td>
			<label><input type="checkbox" name="admin" <cfif t.is_admin() EQ true>checked</cfif>>Site administrator</label><br>
			<label><input type="checkbox" name="time_approver" <cfif t.is_time_approver() EQ true>checked</cfif>>Time collection manager</label><br>
			<label><input type="checkbox" name="project_manager" <cfif t.is_project_manager() EQ true>checked</cfif>>Project manager</label><br>
			<label><input type="checkbox" name="billing_manager" <cfif t.is_billing_manager() EQ true>checked</cfif>>Billing manager</label>
		</td>
		<tr>
		<td><h2>Identity</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Gender:</td>
		<td>
			<select name="gender">
				<option value="M" <cfif t.gender EQ "M">selected</cfif>>Male</option>
				<option value="F" <cfif t.gender EQ "F">selected</cfif>>Female</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>Honorific:</td>
		<td><select name="honorific">
				<option value="MR." <cfif t.honorific EQ "MR.">selected</cfif>>Mr.</option>
				<option value="MASTER" <cfif t.honorific EQ "MASTER">selected</cfif>>Master</option>
				<option value="MRS." <cfif t.honorific EQ "MRS.">selected</cfif>>Mrs.</option>
				<option value="MS." <cfif t.honorific EQ "MS.">selected</cfif>>Ms.</option>
				<option value="MISS" <cfif t.honorific EQ "MISS">selected</cfif>>Miss</option>
				<option value="DR." <cfif t.honorific EQ "DR.">selected</cfif>>Dr.</option>
				<option value="FR." <cfif t.honorific EQ "FR.">selected</cfif>>Fr.</option>
				<option value="SR." <cfif t.honorific EQ "SR.">selected</cfif>>Sr.</option>
				<option value="REV." <cfif t.honorific EQ "REV.">selected</cfif>>Rev.</option>
			</select>
		</td>
		</tr>
		<tr>
		<td>Name:</td>		
		<td>
		<label>First:<input type="text" name="first_name" value="#t.first_name#"></label>
		<label>Middle Initial:<input type="text" name="middle_initial" size="1" value="#t.middle_initial#"></label>
		<label>Last:<input type="text" name="last_name" value="#t.last_name#"></label>
		<label>Suffix:<input type="text" name="suffix" size="3" value="#t.suffix#"></label>
		</td>
		</tr>
		<tr>
		<td><h2>Employment</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Title:</td>
		<td><input type="text" name="title" value="#t.title#"></td>
		</tr>
		<tr>
		<td>Hire date (MM/DD/YYYY):</td>
		<td><input type="text" name="hire_date" value="#dateFormat(t.hire_date, 'mm/dd/yyyy')#"></td>
		</tr>
		<tr>
		<td>Termination date (MM/DD/YYYY):</td>
		<td><input type="text" name="term_date" value="#dateFormat(t.term_date, 'mm/dd/yyyy')#"></td>
		</tr>
		<tr>
		<td><h2>Contact Information</h2></td>
		<td>&nbsp;</td>
		</tr>
		<tr>
		<td>Mailing Address:</td>
		<td><input type="text" name="mail_address" value="#t.mail_address#"></td>
		</tr>
		<tr>
		<td>City:</td>
		<td><input type="text" name="mail_city" value="#t.mail_city#"></td>
		</tr>
		<tr>
		<td>State:</td>
		<td><input type="text" size="2" maxlength="2" name="mail_state" value="#t.mail_state#"></td>
		</tr>
		<tr>
		<td>ZIP:</td>
		<td><input type="text" size="5" maxlength="5" name="mail_zip" value="#t.mail_zip#"></td>
		</tr>
		<tr>
		<td>E-Mail Address:</td>
		<td><input type="text" name="email" value="#t.email#"></td>
		</tr>
		<tr>
		<td>Work Phone:</td>
		<td><input type="text" name="work_phone" value="#t.work_phone#"></td>
		</tr>
		<tr>
		<td>Home Phone:</td>
		<td><input type="text" name="home_phone" value="#t.home_phone#"></td>
		</tr>
		<tr>
		<td>Mobile Phone:</td>
		<td><input type="text" name="mobile_phone" value="#t.mobile_phone#"></td>
		</tr>
		<tr>
		<td>&nbsp;</td>
		<td align="right"><input type="submit" name="submit" value="Submit"></td>
		</tr>
		</table>
	</form>
	</cfoutput>
</cfif>