<cfapplication name="ptarmigan" sessionmanagement="true">

<cfparam name="session.user" default="">
<cfparam name="session.logged_in" default="false">
<cfparam name="session.message" default="">
<cfparam name="session.company" default="">



<cfparam name="session.root_url" default="/ptarmigan">
<cfparam name="session.upload_path" default="/var/www/html/ptarmigan/uploads">
<cfset session.company = CreateObject("component", "ptarmigan.company.company").open()>

<html>
<head>
	<title>ptarmigan</title>
	<cfoutput>
	<link rel="stylesheet" href="#session.root_url#/ptarmigan.css" type="text/css">
	<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
	
	</cfoutput>
	

</head>
<cfif NOT IsDefined("url.suppress_headers")>
<body>
<cfoutput>
<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
</cfoutput>
<div id="header_bar">
<cfinclude template="top.cfm">
<cfinclude template="navigation.cfm">
</div>

<div style="width:100%;">
</cfif>