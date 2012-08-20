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