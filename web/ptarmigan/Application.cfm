<cfapplication name="ptarmigan" sessionmanagement="true">

<cfparam name="session.user" default="">
<cfparam name="session.logged_in" default="false">
<cfparam name="session.message" default="">


<cfparam name="session.root_url" default="/ptarmigan">


<html>
<head>
	<title>ptarmigan</title>
	<cfoutput>
	<link rel="stylesheet" href="#session.root_url#/ptarmigan.css" type="text/css">
	</cfoutput>
</head>
<cfif NOT IsDefined("url.suppress_headers")>
<body>

<cfinclude template="top.cfm">
<cfinclude template="navigation.cfm">

<div style="width:100%;">
</cfif>