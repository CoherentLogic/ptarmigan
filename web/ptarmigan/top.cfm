<html>
<head>
</head>
<body>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<h1>ptarmigan</h1>
				<p><em>Simple Business Management</em></p>
			</td>
			<td align="right">
				<cfif session.logged_in NEQ true>
					<form name="log_in" method="post" action="default.cfm" target="_top">
						<label>Username: <input type="text" name="username"></label><br>
						<label>Password: <input type="password" name="password"></label><br>
						<input type="submit" name="login_submit" value="Submit">
					</form>
				<cfelse>
					<a href="logout.cfm" target="_top">Logout</a> | <a href="about.cfm" target="content">About</a><br>
					<table>
						<tr>
							<td>Employee:</td>
							<td><cfoutput>#session.user.last_name#, #session.user.honorific# #session.user.first_name# #session.user.middle_initial# #session.user.suffix#</cfoutput></td>	
						<tr>
							<td>Username:</td>
							<td><cfoutput>#session.user.username#</cfoutput>
						</tr>
						<tr>
							<td>Roles:</td>
							<td>
								<cfoutput>
									<cfif session.user.is_admin() EQ true>
										[SITE ADMIN]&nbsp;
									</cfif>
									<cfif session.user.is_time_approver() EQ true>
										[TIME MGR]&nbsp;
									</cfif>
									<cfif session.user.is_project_manager() EQ true>
										[PROJECT MGR]&nbsp;
									</cfif>
									<cfif session.user.is_billing_manager() EQ true>
										[BILLING MGR]&nbsp;
									</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td>Message:</td>
							<td><cfoutput>#session.message#</cfoutput></td>
						</tr>
					</table>										
				</cfif>	<!---session.logged-in EQ true --->
			</td>
		</tr>
	</table>
	<cfif session.logged_in NEQ true>
		<center>
		<hr />
		<p><cfoutput>#session.message#</cfoutput></p>
		</center>
	</cfif>
</body>
</html>