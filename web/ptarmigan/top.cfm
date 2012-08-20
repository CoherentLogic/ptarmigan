
	<table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:20px;">
		<tr>
			<td>				
				<img src="/ptarmigan/ptarmigan.png">
			</td>
			<td align="right" valign="bottom">
				<cfif session.logged_in NEQ true>
					<form name="log_in" method="post" action="login.cfm">
						<table>
						<tr>
						<td>
						<label>Username: <br/><input type="text" name="username"></label>
						</td>
						<td>
						<label>Password: <br/><input type="password" name="password"></label>
						<input type="submit" name="login_submit" value="Submit">
						</td>
						</tr>
						</table>
					</form>
				<cfelse>
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
		
		<p><cfoutput>#session.message#</cfoutput></p>
		</center>
	<cfelse>
		
	</cfif>
