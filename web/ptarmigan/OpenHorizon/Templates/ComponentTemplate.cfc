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
<cfcomponent displayname="ComponentTemplate" hint="Enter the component's description here." extends="OpenHorizon.Framework" output="no">
	
    <cfset this.r_pk = 0>				<!--- database primary key --->
    <cfset this.om_uuid = "">			<!--- ORMS id --->
    <cfset this.object_record = "">		<!--- ORMS record --->
    
    <cfset this.written = false>
    
    <cffunction name="Create" access="public" returntype="[should return this component's type]" output="no">
    
    </cffunction>
        
    <cffunction name="OpenByPK" access="public" returntype="[should return this component's type]" output="no">
		<cfargument name="pk" type="numeric" required="yes">
		
        <cfset this.written = true>
        
		<cfreturn #this#>
	</cffunction>
    
    <cffunction name="Open" access="public" returntype="[should return this component's type]" output="no">
    
    
    	<cfset this.written = true>
        <cfreturn #this#>
	</cffunction>
    
    <cffunction name="Save" access="public" output="no" returntype="void">
    	<cfif this.written>
      		<cfset this.UpdateExistingRecord()>
    	<cfelse>
      		<cfset this.WriteAsNewRecord()>
    	</cfif>
    
    	<!--- update the ORMS record here --->
    
        <cfset this.written = true>
  	</cffunction>        
    
    <cffunction name="Delete" access="public" output="no" returntype="void">
    	
        <cfif this.written>
        	<cfquery name="qryDeleteRecord" datasource="#this.BaseDatasource#">
            	DELETE FROM foo 
                WHERE 		id=#this.r_pk#
            </cfquery>
        	
            <cfset this.written = false>
        </cfif>
	</cffunction> 
    
    <cffunction name="UpdateExistingRecord" access="public" output="no" returntype="void">
    	<cfquery name="qryUpdateExistingRecord" datasource="#this.BaseDatasource#">
        	UPDATE 	foo 
            SET 	field=#this.field#
            WHERE	id=#this.r_pk#
        </cfquery>       
	</cffunction>
    
    <cffunction name="WriteAsNewRecord" access="public" output="no" returntype="void">

		<cfset this.om_uuid = CreateUUID()>
	
    	<cfquery name="qryWriteAsNewRecord" datasource="#this.BaseDatasource#">
			INSERT INTO foo
            			(om_uuid)
			VALUES		('#this.om_uuid#')                        	        
    	</cfquery>
        
        <cfquery name="qryGetMyPK" datasource="#this.BaseDatasource#">
        	SELECT 	id 
            FROM 	foo 
            WHERE 	om_uuid='#this.om_uuid#'
        </cfquery>
        
        <cfset this.r_pk = qryGetMyPK.id> 
	</cffunction>        
        
	<cffunction name="ObjectRecord" access="public" returntype="OpenHorizon.Storage.ObjectRecord" output="no">
    	<cfreturn #this.object_record#>
    </cffunction>
</cfcomponent>