<!DOCTYPE html>
<html>
<head>
	<title>Ptarmigan</title>
</head>

<cfif IsDefined("form.login_submit")>
	<cfset t_user = CreateObject("component", "ptarmigan.employee").open_by_username(form.username)>
	
	<cfif t_user.id NEQ 0>
		<!--- good user id --->
		<cfif t_user.password_hash EQ hash(form.password)>
			<cfif t_user.active EQ 1>
				<cfset session.logged_in = true>		
				<cfset session.user = t_user>
				<cfset session.message = "Welcome to ptarmigan">
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
</cfif>

<frameset rows="9%,50%">
  <frame src="top.cfm" name="header"/>
  <frameset cols="20%,80%" frameborder="1">
	<frame src="left.cfm" name="navigation"/>
	<cfif session.logged_in EQ false>
	    <frame src="about.cfm" name="content"/>
	<cfelse>
		<frame src="right.cfm" name="content"/>
	</cfif>
  </frameset>
</frameset>

</html>