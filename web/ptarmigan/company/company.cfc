<cfcomponent output="false" implements="ptarmigan.i_object">
	
	<cfset this.datasource = "">
	<cfset this.company_name = "">	
	<cfset this.address1 = "">
	<cfset this.address2 = "">
	<cfset this.city = "">
	<cfset this.state = "">
	<cfset this.zip = "">
	<cfset this.phone = "">
	<cfset this.fax = "">
	<cfset this.ini_path = "">
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.company_name>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.company.company" access="public" output="false">
		<cfset this.ini_path = ExpandPath(session.root_url & "/ptarmigan.ini")>	
		<cfset this.datasource = GetProfileString(this.ini_path, "Database", "datasource")>
		<cfset this.company_name = GetProfileString(this.ini_path, "Company", "name")>
		<cfset this.address1 = GetProfileString(this.ini_path, "Company", "address1")>
		<cfset this.address2 = GetProfileString(this.ini_path, "Company", "address2")>
		<cfset this.city = GetProfileString(this.ini_path, "Company", "city")>
		<cfset this.state = GetProfileString(this.ini_path, "Company", "state")>
		<cfset this.zip = GetProfileString(this.ini_path, "Company", "zip")>
		<cfset this.phone = GetProfileString(this.ini_path, "Company", "phone")>
		<cfset this.fax = GetProfileString(this.ini_path, "Company", "fax")>
		<cfset this.logo = GetProfileString(this.ini_path, "Company", "logo")>

		<cfreturn this>
	</cffunction>	
	
	<cffunction name="projects" returntype="array" output="false" access="public">
		<cfquery name="q_projects" datasource="#session.company.datasource#">
			SELECT id FROM projects ORDER BY project_number
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="q_projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(q_projects.id)>
			<cfset pobj = CreateObject("component", "ptarmigan.object").open(q_projects.id)>

			<cfif pobj.deleted EQ 0>
				<cfset ArrayAppend(oa, p)>
			</cfif>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="employees" returntype="array" output="false" access="public">
		<cfquery name="q_employees" datasource="#session.company.datasource#">
			SELECT id FROM employees ORDER BY last_name, first_name			
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="q_employees">
			<cfset e = CreateObject("component", "ptarmigan.employee").open(q_employees.id)>
			<cfset ArrayAppend(oa, e)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="priority_projects" returntype="array" output="false" access="public">
		<cfargument name="start_date" datatype="string" required="true">
		<cfargument name="end_date" datatype="string" required="true">
		
		<cfset start_date = CreateODBCDate(start_date)>
		<cfset end_date = CreateODBCDate(end_date)>
		
		<cfquery name="q_priority_projects" datasource="#session.company.datasource#">
			SELECT 		id 
			FROM 		projects 
			WHERE 		due_date BETWEEN #start_date# AND #end_date#
			ORDER BY	due_date DESC
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_priority_projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(q_priority_projects.id)>
			<cfset ArrayAppend(oa, p)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="active_milestones" returntype="array" output="false" access="public">
		<cfquery name="q_active_milestones" datasource="#session.company.datasource#">
			SELECT id FROM milestones WHERE (NOW() BETWEEN start_date AND end_date) 
			AND completed=0
		</cfquery>

		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_active_milestones">
			<cfset ms = CreateObject("component", "ptarmigan.milestone").open(q_active_milestones.id)>
			<cfset msobj = CreateObject("component", "ptarmigan.object").open(q_active_milestones.id)>
			
			<cfif msobj.deleted EQ 0>
				<cfset ArrayAppend(oa, ms)>
			</cfif>
		</cfoutput>
	
		<cfreturn oa>
	</cffunction>
	<cffunction name="active_tasks" returntype="array" output="false" access="public">
		<cfquery name="q_active_tasks" datasource="#session.company.datasource#">
			SELECT id FROM tasks WHERE (NOW() BETWEEN start_date AND end_date) 
			AND completed=0
		</cfquery>

		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_active_tasks">
			<cfset t = CreateObject("component", "ptarmigan.task").open(q_active_tasks.id)>
			<cfset tobj = CreateObject("component", "ptarmigan.object").open(q_active_tasks.id)>
			
			<cfif tobj.deleted EQ 0>
				<cfset ArrayAppend(oa, t)>
			</cfif>
		</cfoutput>
	
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="active_projects" returntype="array" output="false" access="public">
		<cfquery name="q_active_projects" datasource="#session.company.datasource#">
			SELECT id FROM projects WHERE (NOW() BETWEEN start_date AND due_date) 
		</cfquery>

		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_active_projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(q_active_projects.id)>
			<cfset pobj = CreateObject("component", "ptarmigan.object").open(q_active_projects.id)>
			
			<cfif pobj.deleted EQ 0>
				<cfset ArrayAppend(oa, p)>
			</cfif>
		</cfoutput>
	
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="trashcan_events" returntype="array" output="false" access="public">
		<cfquery name="te" datasource="#session.company.datasource#">
			SELECT DISTINCT trashcan_handle FROM objects WHERE deleted=1
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="te">
			<cfset t = CreateObject("component", "ptarmigan.trashcan_event").open(te.trashcan_handle)>			
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>				
	</cffunction>
	
</cfcomponent>