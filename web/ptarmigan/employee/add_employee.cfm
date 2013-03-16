<cfmodule template="#session.root_url#/security/require.cfm" type="admin">
<!DOCTYPE html>
<html lang="en">
<head>	
	<cfoutput>	
		<title>New Employee - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   											
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">												
   		 });
	</script>
</head>
<body>
	<cfif isdefined("form.submit")>
		<cfset data_valid = true>
		
		<cfquery name="check_duplicate_username" datasource="#session.company.datasource#">
			SELECT * FROM employees WHERE username='#form.t_username#'
		</cfquery>
		
		<cfquery name="check_duplicate_email" datasource="#session.company.datasource#">
			SELECT * FROM employees WHERE email='#form.email#'
		</cfquery>
		
		<cfset authentication_errors = 0>
		<cfset identity_errors = 0>
		<cfset employment_errors = 0>
		<cfset contact_info_errors = 0>
		
		<cfif form.t_username EQ "">
			<cfset authentication_errors = authentication_errors + 1>
			<cfset username_error = "Username is required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.t_username) GT 8>
			<cfset authentication_errors = authentication_errors + 1>
			<cfset username_error = "Must be 8 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif check_duplicate_username.recordcount GT 0>
			<cfset authentication_errors = authentication_errors + 1>
			<cfset username_error = "This username is taken. Please choose another.">
			<cfset data_valid = false>
		</cfif>
		
		
		
		<cfif form.t_password EQ "">
			<cfset authentication_errors = authentication_errors + 1>
			<cfset password_error = "Password is required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.t_password) GT 16>
			<cfset authentication_errors = authentication_errors + 1>
			<cfset password_error = "Must be 16 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.first_name EQ "">
			<cfset identity_errors = identity_errors + 1>
			<cfset first_name_error = "First name required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.first_name) GT 50>
			<cfset identity_errors = identity_errors + 1>
			<cfset first_name_error = "Must be 50 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.middle_initial) GT 1>
			<cfset identity_errors = identity_errors + 1>
			<cfset middle_initial_error = "Must be 1 character">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.last_name EQ "">
			<cfset identity_errors = identity_errors + 1>
			<cfset last_name_error = "Last name required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.last_name) GT 50>
			<cfset identity_errors = identity_errors + 1>
			<cfset last_name_error = "Must be 50 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.suffix) GT 10>
			<cfset identity_errors = identity_errors + 1>
			<cfset suffix_error = "Must be 10 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.title EQ "">
			<cfset employment_errors = employment_errors + 1>
			<cfset title_error = "Title required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.title) GT 255>
			<cfset employment_errors = employment_errors + 1>
			<cfset title_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>			
			
		<cfif len(form.hire_date) GT 0>
			<cfif not isdate(form.hire_date)>
				<cfset employment_errors = employment_errors + 1>
				<cfset hire_date_error = "Must be a valid date">
				<cfset data_valid = false>
			</cfif>
		</cfif>
		
		<cfif len(form.term_date) GT 0>
			<cfif not isdate(form.term_date)>
				<cfset employment_errors = employment_errors + 1>
				<cfset term_date_error = "Must be a valid date">
				<cfset data_valid = false>
			</cfif>
		</cfif>
		
		<cfif form.mail_address EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_address_error = "Mailing address required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mail_address) GT 255>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_address_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.mail_city EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_city_error = "City required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mail_city) GT 255>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_city_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.mail_state EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_state_error = "State required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mail_state) NEQ 2>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_state_error = "Must be 2 characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.mail_zip EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_zip_error = "ZIP code required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mail_zip) GT 5>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mail_zip_error = "Must be 5 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.email EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset email_error = "E-mail address required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.email) GT 255>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset email_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif check_duplicate_email.recordcount GT 0>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset email_error = "This e-mail address is already associated with another account">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.work_phone EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset work_phone_error = "Work phone required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.work_phone) GT 255>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset work_phone_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.home_phone) GT 255>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset home_phone_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.mobile_phone EQ "">
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mobile_phone_error = "Mobile phone required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.mobile_phone) GT 255>
			<cfset contact_info_errors = contact_info_errors + 1>
			<cfset mobile_phone_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>								
		
		<cfif data_valid EQ true>
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
						
			<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#t.id#">
		</cfif> <!--- data_valid EQ true --->
	</cfif> <!--- isdefined("form.submit") --->
	<cfinclude template="#session.root_url#/navigation.cfm">
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="inner-tube">
		<div id="content-right">
			<cfinclude template="#session.root_url#/sidebar.cfm">
		</div> <!--- content-right --->
		<div id="content" style="margin:0px;width:80%;">		
			<cfmodule template="#session.root_url#/navigation-tabs.cfm">							
				<cfoutput><form name="add_employee" id="add_employee" action="#session.root_url#/employee/add_employee.cfm" method="post"></cfoutput>
					<div class="form_instructions">
						<p>Required fields marked with *</p>
					</div>
					<cfset tab_count = 6>
					<div id="tabs-min">
						<ul>						
							<li><a href="#t_introduction">Introduction</a></li>							
							<li><a href="#t_authentication">Authentication</a></li>
							<li><a href="#t_roles">Roles</a></li>
							<li><a href="#t_identity">Identity</a></li>
							<li><a href="#t_employment">Employment</a></li>
							<li><a href="#t_contact">Contact Info</a></li>										
						</ul>					
						<div id="t_introduction">
							<div style="height:500px; width:100%; position:relative;">
							<cfif not isdefined("form.submit")>
								<h1>Add Employee Wizard</h1>
								<p>This wizard will guide you through adding a new employee. Required fields are marked with the asterisk character (<strong>*</strong>).</p>
								<p>Please press <strong>Next</strong> to continue.</p>
							<cfelse>
								<cfif data_valid EQ false>							
									<h1>Oops...</h1>
									<p>You have the following errors in your data entry:</p>
									<table width="100%">
									<tr>
									<td valign="top">
									<blockquote>
										<!---
										<cfset authentication_errors = 0>
										<cfset identity_errors = 0>
										<cfset employment_errors = 0>
										<cfset contact_info_errors = 0>
										--->
										<cfoutput>
										<cfif authentication_errors GT 0>										
											<em>#authentication_errors# errors in <strong>Authentication</strong></em>										
										</cfif>
										<cfif identity_errors GT 0>										
											<em>#identity_errors# errors in <strong>Identity</strong></em>							
										</cfif>
										<cfif employment_errors GT 0>										
											<em>#employment_errors# errors in <strong>Employment</strong></em>							
										</cfif>
										</cfoutput>
									</blockquote>
									</td>
									<td valign="top">
										<blockquote>
										<cfoutput>
										<cfif contact_info_errors GT 0>										
											<em>#contact_info_errors# errors in <strong>Contact Info</strong></em>
										</cfif>
										</cfoutput>
										</blockquote>
									</td>
									</tr>
									</table>								
								</cfif>
							</cfif>
							<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="0" tab_selector="##tabs-min">
							</div>
						</div>						
						<div id="t_authentication">
							<div style="height:500px; width:100%; position:relative;">
								<table width="100%">
								<tr>
								<td><label>Username<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("username_error")>class="error_field"</cfif> min="3" type="text" placeholder="8 or fewer characters" name="t_username" autocomplete="off" <cfif isdefined("form.t_username")><cfoutput>value="#form.t_username#"</cfoutput></cfif> maxlength="8">
									<cfif isdefined("username_error")>
										<cfoutput><span class="form_error">#username_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Password<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("password_error")>class="error_field"</cfif> min="3" placeholder="16 or fewer characters" type="password" name="t_password" autocomplete="off" value="" maxlength="16">
									<cfif isdefined("password_error")>
										<cfoutput><span class="form_error">#password_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td>&nbsp;</td>
								<td><label><input type="checkbox" name="active">Make account active</label></td>
								</tr>
								</table>
								<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="1" tab_selector="##tabs-min">
							</div>
						</div>
						<div id="t_roles">
							<div style="height:500px; width:100%; position:relative;">
								<table width="100%">
								<tr>
								<td>
								<label><input type="checkbox" name="admin">Site administrator</label><br>
								<label><input type="checkbox" name="time_approver">Time collection manager</label><br>
								<label><input type="checkbox" name="project_manager">Project manager</label><br>
								<label><input type="checkbox" name="billing_manager">Billing manager</label>
								</td>
								</tr>
								</table>
								<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="2" tab_selector="##tabs-min">
							</div>
						</div>
						<div id="t_identity">
							<div style="height:500px; width:100%; position:relative;">
								<table>
								<tr>
								<td><label>Gender<strong>*</strong></label></td>
								<td>
									<cfif not isdefined("form.gender")>
										<select name="gender">
											<option value="M">Male</option>
											<option value="F">Female</option>
										</select>
									<cfelse>
										<select name="gender">
											<option value="M" <cfif form.gender EQ "M">selected</cfif>>Male</option>
											<option value="F" <cfif form.gender EQ "F">selected</cfif>>Female</option>
										</select>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Honorific<strong>*</strong></label></td>
								<td>
									<cfif not isdefined("form.honorific")>
										<select name="honorific">
											<option value="MR.">Mr.</option>
											<option value="MASTER">Master</option>
											<option value="MRS.">Mrs.</option>
											<option value="MS.">Ms.</option>
											<option value="MISS">Miss</option>
											<option value="DR.">Dr.</option>
											<option value="FR.">Fr.</option>
											<option value="SR.">Sr.</option>
											<option value="REV.">Rev.</option>
											<option value="MX.">Mx.</option>
										</select>
									<cfelse>
										<select name="honorific">
											<option value="MR." <cfif form.honorific EQ "MR.">selected</cfif>>Mr.</option>
											<option value="MASTER" <cfif form.honorific EQ "MASTER">selected</cfif>>Master</option>
											<option value="MRS." <cfif form.honorific EQ "MRS.">selected</cfif>>Mrs.</option>
											<option value="MS." <cfif form.honorific EQ "MS.">selected</cfif>>Ms.</option>
											<option value="MISS" <cfif form.honorific EQ "MISS">selected</cfif>>Miss</option>
											<option value="DR." <cfif form.honorific EQ "DR.">selected</cfif>>Dr.</option>
											<option value="FR." <cfif form.honorific EQ "FR.">selected</cfif>>Fr.</option>
											<option value="SR." <cfif form.honorific EQ "SR.">selected</cfif>>Sr.</option>
											<option value="REV." <cfif form.honorific EQ "REV.">selected</cfif>>Rev.</option>
											<option value="MX." <cfif form.honorific EQ "MX.">selected</cfif>>Mx.</option>
										</select>									
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>First name<strong>*</strong></label></td>		
								<td>
									<input <cfif isdefined("first_name_error")>class="error_field"</cfif> placeholder="50 or fewer characters"  type="text" name="first_name" maxlength="50" <cfif isdefined("form.first_name")><cfoutput>value="#form.first_name#"</cfoutput></cfif>>
									<cfif isdefined("first_name_error")>
										<span class="form_error"><cfoutput>#first_name_error#</cfoutput></span>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Middle initial</label></td>
								<td>
									<input <cfif isdefined("middle_initial_error")>class="error_field"</cfif>  type="text" name="middle_initial" size="1" maxlength="1" <cfif isdefined("form.middle_initial")><cfoutput>value="#form.middle_initial#"</cfoutput></cfif>>
									<cfif isdefined("middle_initial_error")>
										<span class="form_error"><cfoutput>#middle_initial_error#</cfoutput></span>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Last name<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("last_name_error")>class="error_field"</cfif>  placeholder="50 or fewer characters"  type="text" name="last_name" maxlength="50" <cfif isdefined("form.last_name")><cfoutput>value="#form.last_name#"</cfoutput></cfif>>
									<cfif isdefined("last_name_error")>
										<cfoutput><span class="form_error">#last_name_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Suffix</label></td>
								<td>
									<input <cfif isdefined("suffix_error")>class="error_field"</cfif>  type="text" name="suffix" size="3" maxlength="10" <cfif isdefined("form.suffix")><cfoutput>value="#form.suffix#"</cfoutput></cfif>>
									<cfif isdefined("suffix_error")>
										<cfoutput><span class="form_error">#suffix_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								</table>
								<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="3" tab_selector="##tabs-min">
							</div>
						</div>
						<div id="t_employment">
							<div style="height:500px; width:100%; position:relative;">					
								<table width="90%">
								<tr>
								<td><label>Job title<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("title_error")>class="error_field"</cfif>  placeholder="255 or fewer characters"  type="text" name="title" maxlength="255" <cfif isdefined("form.title")><cfoutput>value="#form.title#"</cfoutput></cfif>>
									<cfif isdefined("title_error")>
										<cfoutput><span class="form_error">#title_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Hire date</label></td>
								<td>
									<input <cfif isdefined("hire_date_error")>class="error_field"</cfif> class="pt_dates" type="date" placeholder="MM/DD/YYYY" name="hire_date" <cfif isdefined("form.hire_date")><cfoutput>value="#form.hire_date#"</cfoutput></cfif>>
									<cfif isdefined("hire_date_error")>
										<cfoutput><span class="form_error">#hire_date_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Termination date</label></td>
								<td>
									<input <cfif isdefined("term_date_error")>class="error_field"</cfif> class="pt_dates" type="date" placeholder="MM/DD/YYYY" name="term_date" <cfif isdefined("form.term_date")><cfoutput>value="#form.term_date#"</cfoutput></cfif>>
									<cfif isdefined("term_date_error")>
										<cfoutput><span class="form_error">#term_date_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								</table>
								<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="4" tab_selector="##tabs-min">
							</div>
						</div>
						<div id="t_contact">
							<div style="height:500px; width:100%; position:relative;">					
								<table>
								<tr>
								<td><label>Mailing address<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("mail_address_error")>class="error_field"</cfif> type="text" placeholder="255 or fewer characters" required name="mail_address" maxlength="255" <cfif isdefined("form.mail_address")><cfoutput>value="#form.mail_address#"</cfoutput></cfif>>
									<cfif isdefined("mail_address_error")>
										<cfoutput><span class="form_error">#mail_address_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>City<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("mail_city_error")>class="error_field"</cfif> type="text" name="mail_city" placeholder="255 or fewer characters"  maxlength="255" <cfif isdefined("form.mail_city")><cfoutput>value="#form.mail_city#"</cfoutput></cfif>>
									<cfif isdefined("mail_city_error")>
										<cfoutput><span class="form_error">#mail_city_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>State<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("mail_state_error")>class="error_field"</cfif> placeholder="XX"  type="text" size="2" maxlength="2" name="mail_state" <cfif isdefined("form.mail_state")><cfoutput>value="#form.mail_state#"</cfoutput></cfif>>
									<cfif isdefined("mail_state_error")>
										<cfoutput><span class="form_error">#mail_state_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>ZIP code<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("mail_zip_error")>class="error_field"</cfif> placeholder="XXXXX"  type="text" size="5" maxlength="5" name="mail_zip" <cfif isdefined("form.mail_zip")><cfoutput>value="#form.mail_zip#"</cfoutput></cfif>>
									<cfif isdefined("mail_zip_error")>
										<cfoutput><span class="form_error">#mail_zip_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>E-mail address<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("email_error")>class="error_field"</cfif> type="email"  placeholder="myname@mydomain.com" name="email" maxlength="255" <cfif isdefined("form.email")><cfoutput>value="#form.email#"</cfoutput></cfif>>
									<cfif isdefined("email_error")>
										<cfoutput><span class="form_error">#email_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Work phone<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("work_phone_error")>class="error_field"</cfif> type="tel"  placeholder="(XXX) XXX-XXXX" name="work_phone" maxlength="255" <cfif isdefined("form.work_phone")><cfoutput>value="#form.work_phone#"</cfoutput></cfif>>
									<cfif isdefined("work_phone_error")>
										<cfoutput><span class="form_error">#work_phone_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Home phone</label></td>
								<td>
									<input <cfif isdefined("home_phone_error")>class="error_field"</cfif> type="tel" placeholder="(XXX) XXX-XXXX" name="home_phone" maxlength="255" <cfif isdefined("form.home_phone")><cfoutput>value="#form.home_phone#"</cfoutput></cfif>>
									<cfif isdefined("home_phone_error")>
										<cfoutput><span class="form_error">#home_phone_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								<tr>
								<td><label>Mobile phone<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("mobile_phone_error")>class="error_field"</cfif> type="tel" placeholder="(XXX) XXX-XXXX"  name="mobile_phone" maxlength="255" <cfif isdefined("form.mobile_phone")><cfoutput>value="#form.mobile_phone#"</cfoutput></cfif>>
									<cfif isdefined("mobile_phone_error")>
										<cfoutput><span class="form_error">#mobile_phone_error#</span></cfoutput>
									</cfif>
								</td>
								</tr>
								</table>
								<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="#tab_count#" current_tab="5" tab_selector="##tabs-min">
							</div>
						</div>
					</div> <!--- tabs --->
					
				</form>
		</div> <!--- content --->
	</div> <!--- inner-tube --->			
</div> <!--- container --->
</body>
</html>