<!--- Open Horizon Framework.cfc $Revision: 1.2 $ --->

<cfcomponent displayName="Framework" hint="Open Horizon Base">
	<cfset PAF = CreateObject("component", "Prefiniti")>
	
	<cfset this.BaseDatasource = PAF.Config("Instance", "datasource")>
    <cfset this.SitesDatasource = PAF.Config("Instance", "datasource")>    		
	<cfset this.URLBase = PAF.Config("Instance", "rooturl")>
	<cfset this.ServerPort = PAF.Config("Instance", "serverport")>
    <cfset this.OHRootDir = PAF.Config("Instance", "ohrootdir")>
	<cfset this.StorageRoot =  PAF.Config("ORMS", "filestorage")>
	<cfset this.ServerPlatform =  PAF.Config("Instance", "platform")>
	<cfset this.PathDelimiter =  PAF.Config("Instance", "pathdelimiter")>
	<cfset this.PrefinitiRoot =  PAF.Config("Instance", "rootpath")>
	<cfset this.Staging = PAF.Config("Instance", "staging")>
	<cfset this.ThumbnailCache = PAF.Config("Instance", "thumbnailcache")>
   	<cfset this.CMSURL = PAF.Config("ORMS", "cmsurl")>    
	<cfset this.main_site_id = PAF.Config("Instance", "mainsite")>   
    <cfset this.notification_sender_id = PAF.Config("Instance", "notification_sender")>
    <cfset this.InstanceMode = PAF.Config("Instance", "mode")>
    <cfset this.LockToIP = PAF.Config("Security", "lock_ip")>
    <cfset this.FirstUser = PAF.Config("Instance", "first_user")>
	<cfset this.MapsAPIKey = PAF.Config("Instance", "maps_api_key")>
    <cffunction name="PermissionSet" access="public" returntype="string" output="no">
    	<cfargument name="set_key" type="string" required="yes">
        
        <cfquery name="ps" datasource="#this.SitesDatasource#">
        	SELECT permission_list FROM permission_sets WHERE id='#set_key#'
        </cfquery>
        
        <cfreturn #ps.permission_list#>
    </cffunction>
    
    <cffunction name="MainSite" access="public" returntype="OpenHorizon.Identity.Site" output="no">
    	 <cfset ret_val = CreateObject("component", "OpenHorizon.Identity.Site").Open(this.main_site_id)>
         
         <cfreturn #ret_val#>
    </cffunction>
    
    <cffunction name="NotificationSender" access="public" returntype="OpenHorizon.Identity.User" output="no">
    	<cfset ret_val = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.notification_sender_id)>
        
        <cfreturn #ret_val#>
    </cffunction>
    
    <cffunction name="Err" access="public" returntype="void" output="no">
    	<cfargument name="error_code" type="string" required="yes">
        <cfargument name="extended_info" type="string" required="no">
        
        <cfif IsDefined("extended_info")>
        	<cfset c = extended_info>
        <cfelse>
        	<cfset c = "">
        </cfif>
        
        <cfquery name="ge" datasource="#this.BaseDatasource#">
        	SELECT * FROM error_codes WHERE error_code='#error_code#'
        </cfquery>
        
        <cfthrow errorcode="#error_code#" message="#ge.error_summary#" detail="#ge.error_description#" extendedinfo="#c#">                    
    </cffunction>
    
    <cffunction name="Ping" access="public" returntype="void" output="no">
    
    	<!---
		<cfset Authenticator = CreateObject("webservice", "http://hephaestus-orms.clogic-int.com/Authentication.cfc?wsdl")>
        <cfset Authenticator.Ping(session.authentication_key)>
    	--->
	
    </cffunction>
</cfcomponent>
