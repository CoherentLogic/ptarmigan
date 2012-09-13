<cfapplication name="ptarmigan" sessionmanagement="true">

<cfparam name="session.user" default="">
<cfparam name="session.logged_in" default="false">
<cfparam name="session.message" default="">
<cfparam name="session.company" default="">
<cfparam name="session.current_object" default="">
<cfparam name="session.ui_theme" default="smoothness">

<cfparam name="session.root_url" default="/ptarmigan">
<cfparam name="session.upload_path" default="/var/www/html/ptarmigan/uploads">
<cfset session.company = CreateObject("component", "ptarmigan.company.company").open()>
<cfset session.current_object = CreateObject("component", "ptarmigan.object").open(session.company.object_name())>
<cfif IsDefined("url.set_theme")>
	<cfset session.ui_theme = url.set_theme>
</cfif>