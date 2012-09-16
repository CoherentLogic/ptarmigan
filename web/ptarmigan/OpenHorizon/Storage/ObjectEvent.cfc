<!---

$Id$

Copyright (C) 2011 John Willis
 
This file is part of Prefiniti.

Prefiniti is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Prefiniti is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.

--->
<cfcomponent displayname="ObjectEvent" extends="OpenHorizon.Framework" hint="Represents an event that may occur on an ORMS record." output="no">

	<cfset this.r_pk = 0>						<!--- id --->
    <cfset this.object_record = "">				<!--- target_uuid --->
    <cfset this.event_user = "">				<!--- user_id --->
    <cfset this.event_date = "">			 	<!--- event_date --->
    <cfset this.om_uuid = "">					<!--- om_uuid --->
    <cfset this.event_name = "">				<!--- event_name --->
    <cfset this.body_copy = "">					<!--- body_copy --->
    <cfset this.file_uuid = "NO FILE">			<!--- file_uuid --->
    <cfset this.orms_file = "">
    <cfset this.gis_location = "">
    
	<cfset this.written = false>
	    
	<cffunction name="Create" access="public" returntype="OpenHorizon.Storage.ObjectEvent" output="no">
		<cfargument name="object_record" type="OpenHorizon.Storage.ObjectRecord" required="yes">
        <cfargument name="event_user" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="event_name" type="string" required="yes">
        <cfargument name="body_copy" type="string" required="yes">        
        <cfargument name="orms_file_rec" type="OpenHorizon.Storage.File" required="no">
        
        <cfset this.object_record = object_record>
        <cfset this.event_user = event_user>
        <cfset this.event_name = event_name>
        <cfset this.body_copy = body_copy>
        <cfif IsDefined("orms_file_rec")>
        	<cfset this.orms_file = orms_file_rec>
            <cfset this.file_uuid = this.orms_file.file_uuid>
        </cfif>
        <cfset this.event_date = CreateODBCDateTime(Now())>    
          
        
        <cfset this.written = false>

		<cfreturn #this#>
	</cffunction>

    <cffunction name="OpenByPK" access="public" returntype="OpenHorizon.Storage.ObjectEvent" output="no">
		<cfargument name="pk" type="numeric" required="yes">
		
        <cfquery name="e" datasource="#this.BaseDatasource#">
        	SELECT * FROM orms_events WHERE id=#pk#
        </cfquery>
        
        <cfset this.object_record = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").Get(e.target_uuid)>
        <cfset this.event_user = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(e.user_id)>
        <cfset this.event_date = e.event_date>
        <cfset this.om_uuid = e.om_uuid>
        <cfset this.event_name = e.event_name>
        <cfset this.body_copy = e.body_copy>
        <cfset this.file_uuid = e.file_uuid>
        <cfset this.r_pk = e.id>
        
        <cfif this.file_uuid NEQ "NO FILE">
        	<cfset this.orms_file = CreateObject("component", "OpenHorizon.Storage.File").Open(this.file_uuid)>
		</cfif>
                            
        <cfset this.written = true>
        
		<cfreturn #this#>
	</cffunction>
    
    <cffunction name="Open" access="public" returntype="OpenHorizon.Storage.ObjectEvent" output="no">
    
    
    	<cfset this.written = true>
        <cfreturn #this#>
	</cffunction>    
    
    <cffunction name="Save" access="public" output="no" returntype="void">
    	<cfif NOT this.written>      	
      		<cfset this.WriteAsNewRecord()>
           	<cfset this.DispatchNotifications()>
    	</cfif>

        <cfset this.written = true>
  	</cffunction>
    
    <cffunction name="Delete" access="public" output="no" returntype="void">
    	
        <cfif this.written>
        	<cfquery name="qryDeleteRecord" datasource="#this.BaseDatasource#">
            	DELETE FROM orms_events 
                WHERE 		id=#this.r_pk#
            </cfquery>
            
            <cfquery name="qryDeleteComments" datasource="#this.BaseDatasource#">
            	DELETE FROM orms_event_comments
                WHERE		event_id=#this.r_pk#
        	</cfquery>
            
            <cfset this.written = false>
        </cfif>
	</cffunction>      
            
    
    <cffunction name="WriteAsNewRecord" access="public" output="no" returntype="void">
    
    	<cfset this.om_uuid = CreateUUID()>
    
    	<cfquery name="wanr" datasource="#this.BaseDatasource#">
        	INSERT INTO	orms_events
            			(target_uuid,
                        user_id,
                        event_date,
                        om_uuid,
                        event_name,
                        body_copy,
                        file_uuid)
			VALUES
            			('#this.object_record.r_id#',
                        #this.event_user.r_pk#,
                        #this.event_date#,
                        '#this.om_uuid#',
                        '#this.event_name#',
                        '#this.body_copy#',
                        '#this.file_uuid#')
                                             
        </cfquery>
        
        <cfquery name="wanr_r_pk" datasource="#this.BaseDatasource#">
        	SELECT id FROM orms_events WHERE om_uuid='#this.om_uuid#'
        </cfquery>
        
        <cfset this.r_pk = wanr_r_pk.id>        
    </cffunction>
    
    <cffunction name="DispatchNotifications" access="public" output="no" returntype="void">
    	<cfset task_guid = CreateUUID()>
    	<cfschedule task="#task_guid#"
        			action="update"
        			url="#this.URLBase#orms/deliver_subscriptions.cfm?event_id=#this.r_pk#"
                    operation="httprequest"
                    interval="once"
                    startdate="1/1/1999"
                    starttime="12:00 AM"
                    resolveurl="yes">
                    
    </cffunction>
    
    <cffunction name="Comments" returntype="array" output="no" access="public">
    	<cfargument name="starting_with" type="numeric" required="yes">
        <cfargument name="max_count" type="numeric" required="yes">
        
        <cfset ret_val = ArrayNew(1)>
        
        <cfquery name="qryComments" datasource="#this.BaseDatasource#">
        	SELECT id FROM orms_event_comments WHERE event_id=#this.r_pk# ORDER BY comment_date DESC
        </cfquery>	
        
        <cfoutput query="qryComments" startrow="#starting_with#" maxrows="#max_count#">
        	<cfset t = CreateObject("component", "OpenHorizon.Storage.ObjectEventComment").OpenByPK(id)>
            <cfset ArrayAppend(ret_val, t)>
		</cfoutput>
        
        <cfreturn #ret_val#>            
    </cffunction>
    
    <cffunction name="PostComment" returntype="void" output="no" access="public">
    	<cfargument name="user" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="body_copy" type="string" required="yes">
		
        <cfset c = CreateObject("component", "OpenHorizon.Storage.ObjectEventComment")>
        <cfset c.Create(this, user, body_copy)>
	</cffunction>            
</cfcomponent>