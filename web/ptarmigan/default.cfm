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

<cfif session.logged_in EQ true>
	<cfinclude template="dashboard.cfm">
<cfelse>
	<cfinclude template="about.cfm">
</cfif>

<!--- 
<frameset rows="15%,50%" frameborder="0">
  <frame src="top.cfm" name="header" noresize="true"/>
  <frameset cols="20%,80%" frameborder="0" noresize="true">
	<frame src="left.cfm" name="navigation" noresize="noresize"/>
	<cfif session.logged_in EQ false>
	    <frame src="about.cfm" name="content" noresize="noresize"/>
	<cfelse>
		<frame src="right.cfm" name="content" noresize="noresize"/>
	</cfif>
  </frameset>
</frameset>
 --->

</html>