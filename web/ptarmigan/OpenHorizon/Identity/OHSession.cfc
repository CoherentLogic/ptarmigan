<!--- 
	Open Horizon
	
	OHSession.cfc
	 The Open Horizon Session object
	
	Created by J Willis
	Created on 1/16/2010
	
	Version $Revision: 1.3 $
 
 	Copyright (C) 2010 Coherent Logic Development LLC
 --->
 

<cfcomponent displayName="OHSession" hint="The Open Horizon session object" extends="OpenHorizon.Framework">

    <cfset this.Username = "">
    <cfset this.HashedPassword = "">
    	
    <cfset this.NetAddress = "">
    <cfset this.NetHostname = "">
    <cfset this.NetBrowser = "">
    <cfset this.SessionToken = "">
    <cfset this.DateOpened = "">
    <cfset this.DateClosed = "">

    <cfset this.Authenticated = false>
    <cfset this.Active = 0>
    <cfset this.ActiveMembership = "">
    
    <cfset this.CurrentApp = "">
    <cfset this.CurrentView = "">
    <cfset this.CurrentParams = "">
    
    <cfset this.DBKey = "">
    	
    <cffunction name="Open" displayName="Open" hint="Open an Open Horizon session" access="public" returnType="OpenHorizon.Identity.OHSession" output="false">
		<cfargument name="Username" displayName="Username" hint="The username of the user" type="string" required="true">
		<cfargument name="HashedPassword" displayName="HashedPassword" hint="The MD5 hash of the user's password" type="string" required="true">
		<cfargument name="NetAddress" displayName="NetAddress" hint="The user's IP address" type="string" required="true">
		<cfargument name="NetHostname" displayName="NetHostname" hint="The user's hostname" type="string" required="true">
		<cfargument name="NetBrowser" displayName="NetBrowser" hint="The user's web browser" type="string" required="true">
		
        <cfset this.Username = Username>
        <cfset this.HashedPassword = HashedPassword>
        <cfset this.NetAddress = NetAddress>
        <cfset this.NetHostname = NetHostname>
        <cfset this.NetBrowser = NetBrowser>
        <cfset this.DateOpened = CreateODBCDateTime(Now())>
        <cfset this.SessionToken = "">
        
        <cfquery name="qryChkCred" datasource="#this.BaseDatasource#">
        	SELECT * FROM users WHERE username='#this.Username#'           
        </cfquery>
        
        <cfif qryChkCred.password EQ this.HashedPassword>
        	<cfset this.Authenticated = true>
		
        	
            <cfquery name="qryCloseOldSessions" datasource="#this.BaseDatasource#">
            	UPDATE sessions 
                SET DateClosed=#CreateODBCDateTime(Now())#,
                Active=0,
                SessionToken='#this.SessionToken#' 
                WHERE Username='#Username#'
            </cfquery>
            
            <cfparam name="LocatorUUID" default="">
            <cfset LocatorUUID = CreateUUID()>
            
            <cfset this.SessionToken = CreateUUID()>
            <cfset this.Active = 1>
            
            <cfquery name="qryCreateNewSession" datasource="#this.BaseDatasource#">
            	INSERT INTO sessions
                	(om_uuid,
                    Username,
                    HashedPassword,
                    NetAddress,
                    NetHostname,
                    NetBrowser,
                    SessionToken,
                    DateOpened,
                    Active)
				VALUES
                	('#LocatorUUID#',
                    '#this.Username#',
                    '#this.HashedPassword#',
                    '#this.NetAddress#',
                    '#this.NetHostname#',
                    '#this.NetBrowser#',
                    '#this.SessionToken#',
                    #this.DateOpened#,
                    #this.Active#)
			</cfquery> 
            
            <cfquery name="qryRetrieveSession" datasource="#this.BaseDatasource#">
				SELECT * FROM sessions WHERE om_uuid='#LocatorUUID#'
			</cfquery>
            
            <cfset this.ActiveMembership = createObject("component", "OpenHorizon.Identity.SiteMembership").LoadByID(qryChkCred.last_site_id)>
            
            <cfset this.DBKey = qryRetrieveSession.id>   
            
            <cflog file="OpenHorizon.Identity.OHSession" type="information" text="#this.Username#:SecurityAudit:Success:#this.NetAddress#:#this.SessionToken#">                                       
                                        
        <cfelse>
        	<cfset this.Authenticated = false>
		</cfif>
        
		<cfreturn #this#>
	</cffunction>
    
    
	<cffunction name="Close" displayName="Close" hint="Close the session, releasing the session token." access="public" returnType="OpenHorizon.Identity.OHSession" output="false">
    	<cfset this.SessionToken = "">
        <cfset this.Active = 0>
        <cfset this.Authenticated = false>
        
        <cfquery name="qryCloseSession" datasource="#this.BaseDatasource#">
        	UPDATE sessions 
            SET Active=#this.Active#, 
            	SessionToken='#this.SessionToken#' 
            WHERE id=#this.DBKey#
		</cfquery>
                
		<cfreturn #this#>
	</cffunction>
    
    <cffunction name="Authorize" displayname="Authorize" hint="Authorize a permission within this session." access="public" returntype="boolean" output="no">
    
    </cffunction> 
</cfcomponent>