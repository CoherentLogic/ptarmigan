<cfmodule template="../security/require.cfm" type="">
<cfif IsDefined("url.id")>
	<cfif url.id NEQ session.user.id>
		<cfmodule template="../security/require.cfm" type="admin">
	</cfif>
<cfelse>
	<cfif form.id NEQ session.user.id>
		<cfmodule template="../security/require.cfm" type="admin">
	</cfif>
</cfif>

<cfif IsDefined("url.id")>
	<cfset t = CreateObject("component", "ptarmigan.employee").open(url.id)>
<cfelse>
	<cfset t = CreateObject("component", "ptarmigan.employee").open(form.id)>
</cfif>
<html>
<head>
</head>
<body>
	<h1>View Employee</h1>
	<cfoutput>
		<table>
			<tr>
				<td>Username:</td>
				<td>
					#t.username# 
					<cfif t.active EQ 1>
					&nbsp;[ACTIVE]
					<cfelse>
					&nbsp;[INACTIVE]
					</cfif>
				</td>
			</tr>
			<tr>
				<td>Full name:</td>
				<td>#t.last_name#, #t.honorific# #t.first_name# #t.middle_initial# #t.suffix#</td>
			</tr>
			<tr>
				<td>Roles:</td>
				<td>
					<cfif t.is_admin() EQ true>
						[SITE ADMIN]&nbsp;
					</cfif>
					<cfif t.is_time_approver() EQ true>
						[TIME MGR]&nbsp;
					</cfif>
					<cfif t.is_project_manager() EQ true>
						[PROJECT MGR]&nbsp;
					</cfif>
					<cfif t.is_billing_manager() EQ true>
						[BILLING MGR]&nbsp;
					</cfif>
				</td>
			</tr>
			<tr>
				<td>Title:</td>
				<td>#t.title#</td>
			</tr>
			<tr>
				<td>Hire date:</td>
				<td>#dateFormat(t.hire_date, "mm/dd/yyyy")#</td>
			</tr>
			<tr>
				<td>Termination date:</td>
				<td>#dateFormat(t.term_date, "mm/dd/yyyy")#</td>
			</tr>
			<tr>
				<td>Mailing address:</td>
				<td>
					#t.mail_address#<br>
					#t.mail_city#, #t.mail_state# #t.mail_zip#
				</td>
			</tr>
			<tr>
				<td>E-mail address:</td>
				<td><a href="mailto:#t.email#">#t.email#</a></td>
			</tr>
			<tr>
				<td>Work phone:</td>
				<td>#t.work_phone#</td>
			</tr>
			<tr>
				<td>Home phone:</td>
				<td>#t.home_phone#</td>
			</tr>
			<tr>
				<td>Mobile phone:</td>
				<td>#t.mobile_phone#</td>
			</tr>
		</table>
	</cfoutput>
</body>
</html>
