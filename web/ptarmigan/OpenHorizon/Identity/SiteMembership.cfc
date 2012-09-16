<!---

$Id: site_membership.cfc 47 2011-06-09 22:05:49Z chocolatejollis38@gmail.com $

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
<cfcomponent displayname="site_membership" output="no" extends="OpenHorizon.Framework">
	<cfset this.site = "">
    <cfset this.user = "">
    <cfset this.membership_type = "">
    <cfset this.r_pk = 0>
    
    <cfset this.written = false>
    
    <cffunction name="Create" access="public" returntype="OpenHorizon.Identity.SiteMembership" output="no">
		<cfargument name="site" type="OpenHorizon.Identity.Site" required="yes">
    	<cfargument name="user" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="membership_type" type="string" required="yes">
        
        <cfset this.site = site>
        <cfset this.user = user>
        <cfset this.membership_type = membership_type>
                                        
		<cfreturn #this#>                                        
    </cffunction>
    
    <cffunction name="Open" access="public" returntype="OpenHorizon.Identity.SiteMembership" output="no">
    	<cfargument name="site" type="OpenHorizon.Identity.Site" required="yes">
    	<cfargument name="user" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="membership_type" type="string" required="yes">
        
        <cfquery name="oid" datasource="#this.SitesDatasource#">
        	SELECT association_type FROM association_types WHERE association_type_name='#membership_type#'
        </cfquery>
        
        <cfquery name="open" datasource="#this.SitesDatasource#">
        	SELECT 	* 
            FROM 	site_associations 
            WHERE 	site_id=#site.r_pk# 
            AND		user_id=#user.r_pk#
            AND		assoc_type=#oid.association_type#
        </cfquery>
        
        <cfset this.site = site>
        <cfset this.user = user>
        <cfset this.membership_type = membership_type>
        <cfset this.r_pk = open.id>                	
        
        <cfset this.written = true>
        
        <cfreturn #this#>
    </cffunction>
    
    <cffunction name="OpenByPK" access="public" returntype="OpenHorizon.Identity.SiteMembership" output="no">
    	<cfargument name="r_pk" type="numeric" required="yes">
        
        <cfquery name="opk" datasource="#this.SitesDatasource#">
        	SELECT  *
            FROM	site_associations
            WHERE	id=#r_pk#
		</cfquery>            
        
        <cfset this.site = CreateObject("component", "OpenHorizon.Identity.Site").OpenByMembershipID(opk.id)>
        <cfset this.user = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(opk.user_id)>    
        
		<cfquery name="gmt" datasource="#this.SitesDatasource#">
        	SELECT association_type_name FROM association_types WHERE association_type=#opk.assoc_type#
        </cfquery>
        
		<cfset this.membership_type = gmt.association_type_name>
        <cfset this.r_pk = opk.id>
        
        <cfset this.written = true>
        
    	<cfreturn #this#>
    </cffunction>
    
    
    <cffunction name="Delete" access="public" returntype="void" output="no">
    	<cfargument name="site" type="OpenHorizon.Identity.Site" required="yes">
    	<cfargument name="user" type="OpenHorizon.Identity.User" required="yes">
    	<cfargument name="membership_type" type="string" required="yes">
        
     
        <cfquery name="delete_member" datasource="#this.SitesDatasource#">
        	DELETE FROM site_associations
            WHERE		id=#this.r_pk#
        </cfquery>        
    </cffunction>
    
    <cffunction name="Save" access="public" output="no" returntype="void">
    	<cfif NOT this.written>      	
      		<cfset this.WriteAsNewRecord()>
    	</cfif>
    	<cfmodule template="/authentication/Sites/orms_do.cfm" id="#this.site.r_pk#">
		<cfset ObjRec = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").GetByTypeAndPK("Site", this.site.r_pk)>
		<cfset ObjRec.Subscribe(this.user)>
        <cfset this.written = true>
  	</cffunction>
    
    <cffunction name="WriteAsNewRecord" access="public" output="no" returntype="void">
    	<cfset this.om_uuid = CreateUUID()>       
        
        <cfquery name="mt" datasource="#this.SitesDatasource#">
        	SELECT association_type FROM association_types WHERE association_type_name='#this.membership_type#'
        </cfquery>
        
        <cfquery name="wanr" datasource="#this.SitesDatasource#">
        	INSERT INTO site_associations
            			(user_id,
                        site_id,
                        assoc_type,
                        conf_id)
			VALUES		(#this.user.r_pk#,
            			#this.site.r_pk#,
                        #mt.association_type#,
                        '#this.om_uuid#')                                                
        </cfquery>
        
        <cfquery name="wanr_id" datasource="#this.SitesDatasource#">
        	SELECT id FROM site_associations WHERE conf_id='#this.om_uuid#'
        </cfquery>
        
        <cfset this.r_pk = wanr_id.id>
    </cffunction>        
    
    <cffunction name="Grant" access="public" output="no" returntype="void">
    	<cfargument name="permission_key" type="string" required="yes">
                  
        <cfparam name="tperm_id" default="">
        
        <cfquery name="get_perm_id" datasource="#this.SitesDatasource#">
            SELECT * FROM permissions WHERE perm_key='#permission_key#'
        </cfquery>
        
        <cfset tperm_id = get_perm_id.id>
 		
        <cfif NOT this.Examine(permission_key)>   
            <cfquery name="set_perm" datasource="#this.SitesDatasource#">
                INSERT INTO permission_entries
                    (assoc_id,
                    perm_id)
                VALUES
                    (#this.r_pk#,
                    #tperm_id#)
            </cfquery>                        
        </cfif>
    </cffunction>        
    
    <cffunction name="Revoke" access="public" output="no" returntype="void">
    	<cfargument name="permission_key" type="string" required="yes">
        
        <cfparam name="tperm_id" default="">
        
        <cfquery name="get_perm_id" datasource="#this.SitesDatasource#">
            SELECT id FROM permissions WHERE perm_key='#permission_key#'
        </cfquery>
        
        <cfset tperm_id = get_perm_id.id>  
        
        <cfquery name="rev_perm" datasource="site">
        	DELETE FROM	permission_entries
            WHERE		assoc_id=#this.r_pk#
            AND			perm_id=#tperm_id#
        </cfquery>              
    </cffunction>


    <cffunction name="Examine" access="public" output="no" returntype="boolean">
    	<cfargument name="permission_key" type="string" required="yes">
		
        <cfparam name="tperm_id" default="">
    
        <cfquery name="get_perm_id" datasource="#this.SitesDatasource#">
            SELECT * FROM permissions WHERE perm_key='#permission_key#'
        </cfquery>
        
        <cfset tperm_id = get_perm_id.id>
        
        <cfif tperm_id EQ "">
        	<cfreturn false>
        </cfif>
        
        <cfquery name="get_entry" datasource="#this.SitesDatasource#">
            SELECT * FROM permission_entries WHERE perm_id=#tperm_id# AND assoc_id=#this.r_pk#
        </cfquery>
        
        <cfif get_entry.RecordCount EQ 0>
            <cfreturn "false">
        <cfelse>
            <cfreturn "true" > 
        </cfif>                           
    </cffunction>
	
    
    <cffunction name="GrantSet" access="public" output="no" returntype="void">
    	<cfargument name="permission_keys" type="string" required="yes">    
        	        
        <cfset perm_array = ListToArray(permission_keys, ",")>
            
    	<cfloop array="#perm_array#" index="cp">
        	<cfset this.Grant(cp)>
        </cfloop>  
    </cffunction>
    
    <cffunction name="RevokeSet" access="public" output="no" returntype="void">
    	<cfargument name="permission_keys" type="string" required="yes">    
        
		<cfset perm_array = ListToArray(permission_keys, ",")>
            
    	<cfloop array="#perm_array#" index="cp">
        	<cfset this.Revoke(cp)>
        </cfloop>      
    </cffunction>    
    
    <cffunction name="ExamineSet" access="public" output="no" returntype="boolean">
    	<cfargument name="permission_keys" type="string" required="yes">    
    
    	<cfset perm_array = ListToArray(permission_keys, ",")>
            
    	<cfloop array="#perm_array#" index="cp">
        	<cfif NOT this.Examine(cp)>
            	<cfreturn false>
            </cfif>
        </cfloop>  
        
        <cfreturn true>
    </cffunction>
</cfcomponent> 