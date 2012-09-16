<!---
  Department.cfc
  Version $Revision: 1.2 $
  Implements the class for Departments

  Copyright (C) 2010 Coherent Logic Development LLC

  Created by John Willis
--->

<cfcomponent displayname="Department" hint="Handles business departments in Open Horizon" extends="OpenHorizon.Framework">
	<cfset this.DepartmentName = "">
    	<cfset this.Manager = "">
	<cfset this.Site = "">
    	<cfset this.DBKey = "">

	<cfset this.Written = false>

	<cffunction name="Create" hint="Create a new department object" returntype="OpenHorizon.Identity.Department" access="public">
		    <cfargument name="DepartmentName" type="string" hint="The name of the new department" required="yes">
		    <cfargument name="Site" type="OpenHorizon.Identity.Site" hint="The site object for the new department" required="yes">
		    <cfargument name="Manager" type="OpenHorizon.Identity.User" hint="The user object representing the manager of the department" required="yes">

		    
			<cfscript>
				this.DepartmentName = DepartmentName;
				this.Site = Site;
				this.Manager = Manager;
				this.Written = false;
			</cfscript>
			
			<cfreturn #this#>
	</cffunction>

	<cffunction name="Save" hint="Save this department to the database" returntype="OpenHorizon.Identity.Department" access="public">
		    <cfif this.Written>
		    	<cfset this.UpdateExistingRecord()>
		    <cfelse>
			<cfset this.WriteAsNewRecord()>
		    </cfif>
	</cffunction>

	<cffunction name="WriteAsNewRecord" hint="Write this as new" access="private" returntype="OpenHorizon.Identity.Department">
		    
		    <cfparam name="LocatorUUID" default="">
		    <cfset LocatorUUID = CreateUUID()>
		    
		    
		    <cfquery name="qryWriteAsNew" datasource="#this.SitesDatasource#">
		    	     INSERT INTO departments
			     	    (om_uuid,
				    site_id,
				    manager_id,
				    department_name)
			     VALUES
				    ('#LocatorUUID#',
				    #this.Site.DBKey#,
				    #this.Manager.DBKey#,
				    '#this.DepartmentName#')
		    </cfquery>

		    <cfquery name="qryDBKey" datasource="#this.SitesDatasource#">
		    	     SELECT id FROM departments WHERE om_uuid='#LocatorUUID#'
		    </cfquery>
		    
		    <cfset this.DBKey = qryDBKey.id>
		    <cfset this.Written = true>

		    <cfreturn #this#>
	</cffunction>  
	
	<cffunction name="UpdateExistingRecord" hint="Update record in db" returntype="OpenHorizon.Identity.Department" access="private">
		    <cfquery name="qryUpdate" datasource="#this.SitesDatasource#">
		    	     UPDATE departments
			     SET site_id=#this.Site.DBKey#,
			     manager_id=#this.Manager.DBKey#,
			     department_name='#this.DepartmentName#'
			     WHERE id=#this.DBKey#
		    </cfquery>
		    
		    <cfset this.Written = true>
		    <cfreturn #this#>
	</cffunction>
			
			
    
	<cffunction name="LoadByDBKey" hint="Load a department by its database primary key" returntype="OpenHorizon.Identity.Department" access="public">
    		    <cfargument name="DBKey" type="numeric" required="yes" hint="The PK of the site">
        
		<cfquery name="qryLoadByDBKey" datasource="#this.SitesDatasource#">
        		 SELECT * FROM departments WHERE id=#DBKey#
        	</cfquery>
        
		<cfscript>
			this.DepartmentName = qryLoadByDBKey.department_name;
			this.Manager = createObject("component", "OpenHorizon.Identity.User").OpenByDBKey(qryLoadByDBKey.manager_id);
			this.Site = createObject("component", "OpenHorizon.Identity.Site").OpenByDBKey(qryLoadByDBKey.site_id);
			this.DBKey = qryLoadByDBKey.id;
		</cfscript>
        
        <cfreturn #this#>
    </cffunction>
</cfcomponent>