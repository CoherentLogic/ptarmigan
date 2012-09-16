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
<cfcomponent displayname="ObjectEventComment" hint="Represents a comment on an object event." extends="OpenHorizon.Framework" output="no">
	
    <cfset this.r_pk = 0>				<!--- database primary key --->
    <cfset this.om_uuid = "">			<!--- ORMS id --->
    
    <cfset this.event_id = 0>
    <cfset this.user_id = 0>
    <cfset this.comment_date = "">
    <cfset this.body_copy = "">
    
    <cfset this.user = 0>

    
    <cfset this.written = false>
    
    <cffunction name="Create" access="public" returntype="OpenHorizon.Storage.ObjectEventComment" output="no">
    	<cfargument name="event" type="OpenHorizon.Storage.ObjectEvent" required="yes">
        <cfargument name="user" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="body_copy" type="string" required="yes">
        
        <cfset this.event_id = event.r_pk>
        <cfset this.user_id = user.r_pk>
        <cfset this.body_copy = body_copy>
        <cfset this.comment_date = CreateODBCDateTime(Now())>
        <cfset this.user = user>       
        
        <cfreturn #this#>
	</cffunction>        
        
    
    <cffunction name="OpenByPK" access="public" returntype="OpenHorizon.Storage.ObjectEventComment" output="no">
		<cfargument name="pk" type="numeric" required="yes">
		
        <cfquery name="c" datasource="#this.BaseDatasource#">
        	SELECT * FROM orms_event_comments WHERE id=#pk#
        </cfquery>
        	
        <cfset this.r_pk = c.id>
        <cfset this.om_uuid = c.om_uuid>
        <cfset this.event_id = c.event_id>
        <cfset this.comment_date = c.comment_date>
        <cfset this.body_copy = c.body_copy>
        <cfset this.user_id = c.user_id>
        
        <cfset this.user = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.user_id)>     
        
        <cfset this.written = true>
        
		<cfreturn #this#>
	</cffunction>
    
    <cffunction name="Open" access="public" returntype="OpenHorizon.Storage.ObjectEventComment" output="no">
    	<cfargument name="pk" type="numeric" required="yes">
    
    	<cfset retval = this.OpenByPK(pk)>
        <cfreturn #retval#>
	</cffunction>
    
    <cffunction name="Save" access="public" output="no" returntype="void">
    	<cfif NOT this.written>
      		<cfset this.WriteAsNewRecord()>
    	</cfif>
    
        <cfset this.written = true>
  	</cffunction>        
    
    <cffunction name="Delete" access="public" output="no" returntype="void">    	
        <cfif this.written>
        	<cfquery name="qryDeleteRecord" datasource="#this.BaseDatasource#">
            	DELETE FROM orms_event_comments 
                WHERE 		id=#this.r_pk#
            </cfquery>
        	
            <cfset this.written = false>
        </cfif>
	</cffunction> 

    <cffunction name="WriteAsNewRecord" access="public" output="no" returntype="void">

		<cfset this.om_uuid = CreateUUID()>
	
    	<cfquery name="qryWriteAsNewRecord" datasource="#this.BaseDatasource#">
			INSERT INTO orms_event_comments
            			(om_uuid,
                        event_id,
                        user_id,
                        comment_date,
                        body_copy)
			VALUES		('#this.om_uuid#',
            			#this.event_id#,
                        #this.user_id#,
                        #this.comment_date#,
                        '#this.body_copy#')                        	        
    	</cfquery>
        
        <cfquery name="qryGetMyPK" datasource="#this.BaseDatasource#">
        	SELECT 	id 
            FROM 	orms_event_comments 
            WHERE 	om_uuid='#this.om_uuid#'
        </cfquery>
        
        <cfset this.r_pk = qryGetMyPK.id> 
	</cffunction>        
        	
</cfcomponent>