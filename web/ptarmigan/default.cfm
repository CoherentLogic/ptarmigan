<!DOCTYPE html>
<html>
<head>
	<title>Ptarmigan</title>
</head>




<cfif session.logged_in EQ true>
	<cfinclude template="dashboard.cfm">
<cfelse>
	<cfinclude template="about.cfm">
</cfif>




</html>