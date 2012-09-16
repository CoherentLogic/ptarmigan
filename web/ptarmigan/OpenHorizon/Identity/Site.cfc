<!---

$Id: site.cfc 47 2011-06-09 22:05:49Z chocolatejollis38@gmail.com $

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

<cfcomponent displayname="site" hint="Represents a Prefiniti site" output="no" extends="OpenHorizon.Framework">
	<cfset this.r_pk = 0>    
    <cfset this.site_name = "">
    <cfset this.admin_id = 0>
    <cfset this.enabled = true>
    <cfset this.summary = "">
    <cfset this.about = "">
    <cfset this.industry = 0>
    <cfset this.industry_name = "">
    <cfset this.logo = "">
    <cfset this.mission_statement = "">
    <cfset this.vision_statement = "">
    <cfset this.slogan = "">
    <cfset this.om_uuid = ""> 					<!--- conf_id --->
    <cfset this.salestax_rate = 0>
    <cfset this.logo_invoice = "">
    <cfset this.object_record = "">
    
	<cfset this.owner = "">
	
    <cfset this.written = false>


  

    <cffunction name="Picture" access="public" returntype="string" output="no">
    	<cfargument name="width" type="numeric" required="yes">
        <cfargument name="height" type="numeric" required="yes">
        
    	<cfset po = CreateObject("component", "OpenHorizon.Graphics.Image")>
        <cfset pic = po.Create(this.object_record.r_thumb, width, height)> 
        
		<cfreturn #pic#>    
    </cffunction>
    
    <cffunction name="OpenByPK" access="public" returntype="OpenHorizon.Identity.Site">
    	<cfargument name="id" type="numeric" required="yes">
        
        <cfset ret_val = this.Open(id)>
        <cfreturn #ret_val#>
    </cffunction>
    
	<cffunction name="Open" access="public" returntype="OpenHorizon.Identity.Site">
		<cfargument name="id" type="numeric" required="yes">

		<cfquery name="s" datasource="#session.framework.SitesDatasource#">
        	SELECT * FROM sites WHERE SiteID=#id#
        </cfquery>
        
        <cfif s.RecordCount EQ 0>
        	<cfthrow message="OpenHorizon Framework Error" detail="Site ID #id# does not exist.">
        </cfif>
        
        <cfset this.r_pk = s.SiteID>
        <cfset this.site_name = s.SiteName>
        <cfset this.admin_id = s.admin_id>
        <cfif s.enabled EQ 1>
			<cfset this.enabled = true>
        <cfelse>
        	<cfset this.enabled = false>
        </cfif>
        <cfset this.summary = s.summary>
        <cfset this.about = s.about>
        <cfset this.industry = s.industry>
        <cfset this.logo = s.logo>
        <cfset this.mission_statement = s.mission_statement>
        <cfset this.vision_statement = s.vision_statement>
        <cfset this.slogan = s.slogan>
        <cfset this.om_uuid = s.conf_id>
        <cfset this.salestax_rate = s.salestax_rate>
        <cfset this.logo_invoice = s.logo_invoice>
        
        <cfquery name="g_ind" datasource="#session.framework.SitesDatasource#">
        	SELECT industry_name FROM industries WHERE id=#this.industry#
        </cfquery>
        
        <cfset this.object_record = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").GetByTypeAndPK("Site", this.r_pk)>
        <cfset this.industry_name = g_ind.industry_name>
        
        <cfset this.written = true>
        
        <cfreturn #this#>
	</cffunction>
    
    <cffunction name="OpenByMembershipID" access="public" returntype="OpenHorizon.Identity.Site" output="no">
    	<cfargument name="membership_id" type="numeric" required="yes">
        
        <cfquery name="g_site" datasource="#session.framework.SitesDatasource#">
        	SELECT site_id FROM site_associations WHERE id=#membership_id#
        </cfquery>
        
        <cfset retval = this.Open(g_site.site_id)>
        
        <cfreturn #this#>
    </cffunction>
    
    
    <cffunction name="Save" access="public" output="no" returntype="void">
    	<cfif this.written>
      		<cfset this.UpdateExistingRecord()>
    	<cfelse>
      		<cfset this.WriteAsNewRecord()>
    	</cfif>
	
    	<cfmodule template="/authentication/Sites/orms_do.cfm" id="#this.r_pk#">
		<cfset this.object_record = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").GetByTypeAndPK("Site", this.r_pk)>
		
        <cfset this.written = true>
  	</cffunction>
    
    <cffunction name="UpdateExistingRecord" access="public" output="no" returntype="void">
    	<cfquery name="uer" datasource="#session.framework.SitesDatasource#">
			UPDATE	sites
            SET		SiteName='#this.site_name#',
            		<cfif this.enabled EQ true>
                    	enabled=1,
                    <cfelse>
                    	enabled=0,
                    </cfif>
                    summary='#this.summary#',
                    about='#this.about#',
                    industry=#this.industry#,
                    logo='#this.logo#',
                    mission_statement='#this.mission_statement#',
                    vision_statement='#this.vision_statement#',
                    slogan='#this.slogan#',
                    salestax_rate=#this.salestax_rate#,
                    logo_invoice='#this.logo_invoice#',
                    admin_id=#this.admin_id#
			WHERE	id=#this.r_pk#                    
		</cfquery>        
	</cffunction>        
    
    <cffunction name="WriteAsNewRecord" access="public" output="no" returntype="void">
    	<cfset this.om_uuid = CreateUUID()>
    
    	<cfquery name="wanr" datasource="#session.framework.SitesDatasource#">
        	INSERT INTO	sites
            			(SiteName,
                        enabled,
                        summary,
                        about,
                        industry,
                        logo,
                        mission_statement,
                        vision_statement,
                        slogan,
                        salestax_rate,
                        logo_invoice,
                        admin_id,
                        conf_id)
			VALUES		('#this.site_name#',
            			<cfif this.enabled EQ true>
                        	1,
                        <cfelse>
                        	0,
                        </cfif>
                        '#this.summary#',
                        '#this.about#',
                        #this.industry#,
                        '#this.logo#',
                        '#this.mission_statement#',
                        '#this.vision_statement#',
                        '#this.slogan#',
                        #this.salestax_rate#,
                        '#this.logo_invoice#',
                        #this.admin_id#,
                        '#this.om_uuid#')                        
        </cfquery>    
        
        <cfquery name="gwanr" datasource="#session.framework.SitesDatasource#">
        	SELECT SiteID FROM sites WHERE conf_id='#this.om_uuid#'
        </cfquery>
        
        <cfset this.r_pk = gwanr.SiteID>     
		
		
	</cffunction>
    
    <cffunction name="Create" access="public" output="no" returntype="OpenHorizon.Identity.Site">
    	<cfargument name="site_name" type="string" required="yes">
        <cfargument name="industry" type="string" required="yes">
        <cfargument name="salestax_rate" type="numeric" required="yes">
        
        <cfquery name="get_industry" datasource="#session.framework.SitesDatasource#">
        	SELECT id FROM industries WHERE industry_name='#industry#'
        </cfquery>
        
		<cftry>
			<cfif IsDefined("session.userid")>
				<cfset this.admin_id = session.userid>
				<cfset this.owner = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.admin_id)>
			<cfelse>
				<cfset this.admin_id = 1>
			</cfif>
			<cfcatch type="any">
			
			</cfcatch>
		</cftry>
		
		<cfif this.admin_id EQ "">
			<cfset this.admin_id = 1>
		</cfif>
		
        <cfset this.site_name = site_name>
        <cfset this.industry = get_industry.id>
        <cfset this.salestax_rate = salestax_rate>
        
        <cfreturn #this#>        
    </cffunction>

    <cffunction name="Memberships" access="public" returntype="array" output="no">
    	<cfargument name="user" type="OpenHorizon.Identity.User" required="yes">
    	
        <cfset ret = ArrayNew(1)>
        
    
    </cffunction>
    
    <cffunction name="Employees" access="public" returntype="array" output="no">
    	<cfset ret = ArrayNew(1)>
        
        <cfquery name="qryEmployees" datasource="#session.framework.SitesDatasource#">
        	SELECT user_id FROM site_associations WHERE site_id=#this.r_pk# and assoc_type=1    
		</cfquery>            
        
        <cfoutput query="qryEmployees">
        	<cfset t_emp = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(user_id)>
        	<cfset ArrayAppend(ret, t_emp)>
        </cfoutput>
    
    	<cfreturn #ret#>
    </cffunction>
    
    <cffunction name="Customers" access="public" returntype="array" output="no">
    	<cfset ret = ArrayNew(1)>
        
        <cfquery name="qryCustomers" datasource="#session.framework.SitesDatasource#">
        	SELECT user_id FROM site_associations WHERE site_id=#this.r_pk# and assoc_type=0    
		</cfquery>            
        
        <cfoutput query="qryCustomers">
        	<cfset t_cust = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(user_id)>
        	<cfset ArrayAppend(ret, t_cust)>
        </cfoutput>
    
    	<cfreturn #ret#>
    </cffunction>
    
    <cffunction name="Friends" access="public" returntype="array" output="no">
    	<cfset ret = ArrayNew(1)>
        
        <cfquery name="qryFriends" datasource="#session.framework.SitesDatasource#">
        	SELECT user_id FROM site_associations WHERE site_id=#this.r_pk# and assoc_type=2   
		</cfquery>            
        
        <cfoutput query="qryFriends">
        	<cfset t_friend = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(user_id)>
        	<cfset ArrayAppend(ret, t_friend)>
        </cfoutput>
    
    	<cfreturn #ret#>
    </cffunction>    
    
    <cffunction name="ObjectRecord" access="public" returntype="OpenHorizon.Storage.ObjectRecord" output="no">
    	<cfreturn #this.object_record#>
    </cffunction>
       	           
</cfcomponent>