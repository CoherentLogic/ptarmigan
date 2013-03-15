<cfapplication name="ptarmigan" sessionmanagement="true">
<!---s--->
<cfparam name="session.user" default="">
<cfparam name="session.logged_in" default="false">
<cfparam name="session.message" default="">
<cfparam name="session.company" default="">
<cfparam name="session.current_object" default="">
<cfparam name="session.ui_theme" default="redmond">
<cfparam name="session.basket" default="#ArrayNew(1)#">
<cfparam name="session.root_url" default="">
<cfparam name="session.upload_path" default="">
<cfparam name="session.thumbnail_cache" default="">
<cfparam name="session.system" default="">

<cfset session.system = CreateObject("component", "ptarmigan.system").init()>

<cfset session.company = CreateObject("component", "ptarmigan.company").open()>
<cfset session.current_object = CreateObject("component", "ptarmigan.object").open(session.company.object_name())>
<cfif IsDefined("url.set_theme")>
	<cfset session.ui_theme = url.set_theme>
</cfif>
<!--- 
<cferror type="exception" template="#session.root_url#/utilities/error_dispatch.cfm">
<cferror type="request" template="#session.root_url#/utilities/error_dispatch.cfm">
--->