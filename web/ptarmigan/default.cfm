<!DOCTYPE html>
<html>
<head>
	<title>Ptarmigan</title>
</head>
<body>


<cfif session.logged_in EQ true>
	<cflocation url="dashboard.cfm">
<cfelse>
	<cflocation url="login.cfm">
</cfif>



</body>
</html>