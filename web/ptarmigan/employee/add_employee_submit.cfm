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


<cflocation url="#session.root_url#/dashboard.cfm">