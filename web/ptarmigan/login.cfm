<cfif IsDefined("form.login_submit")>
	<cfset t_user = CreateObject("component", "ptarmigan.employee").open_by_username(form.username)>
	
	<cfif t_user.id NEQ 0>
		<!--- good user id --->
		<cfif t_user.password_hash EQ hash(form.password)>
			<cfif t_user.active EQ 1>
				<cfset session.logged_in = true>		
				<cfset session.user = t_user>
				<cfset session.message = "Welcome to ptarmigan">
				<cflocation url="dashboard.cfm">
			<cfelse>
				<cfset session.logged_in = false>
				<cfset session.message = "This account is not active">
			</cfif>
		<cfelse>
			<cfset session.logged_in = false>
			<cfset session.message = "Invalid username or password">
		</cfif>
		
	<cfelse>
		<cfset session.logged_in = false>
		<cfset session.message = "Invalid username or password">
	</cfif>	
<cfelse>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Ptarmigan Login</title>
	<cfoutput>
	<link rel="stylesheet" href="#session.root_url#/ptarmigan.css">
	</cfoutput>
</head>
<body>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<div style="height:100%;">
		<div style="margin-left:auto; margin-right:auto; margin-top:50px; height:auto; width:800px; border:none; border-radius:2px; background-color:white; box-shadow:2px 2px 2px black;">		
			<div style="padding:40px;">
				<table width="100%" cellpadding="20">
					<tr>
					<td valign="top" width="80%">
					<cfoutput>
						<img src="#session.root_url#/sign-in.png">
						<p>#session.message#</p>
					</cfoutput>
					
					<blockquote>
					<p style="font-size:10pt;">Ptarmigan provides project, document, employee, customer, and parcel management.</p>
					<p style="font-size:10pt;">Please enter your login details to continue.</p>
					</blockquote>
					</td>
					<td valign="top" width="20%">
					<cfoutput><form name="log_in" method="post" action="#session.root_url#/login.cfm" style="margin-top:50px;"></cfoutput>
					<table>
						<tr>
							<td>
								<label>Username <br/><input type="text" name="username"></label>
							</td>
						</tr>
						<tr>
							<td>
								<label>Password <br/><input type="password" name="password"></label>
								
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="submit" name="login_submit" value="Submit" style="margin-top:20px;">
							</td>
						</tr>
					</table>
					</form>
					</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
</cfif>
