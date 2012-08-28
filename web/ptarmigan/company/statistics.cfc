<cfcomponent output="false">

	<cffunction name="hours_worked" returntype="numeric" access="public" output="false">
		<cfargument name="start_date" datatype="string" required="false">
		<cfargument name="end_date" datatype="string" required="false">
		<cfargument name="employee_id" datatype="string" required="false">

		<cfif NOT IsDefined("start_date")>
			<cfset start_date = CreateODBCDate("1/1/1970")>
		</cfif>
		<cfif NOT IsDefined("end_date")>
			<cfset end_date = DateAdd("yyyy", 50, Now())>
		</cfif>
		
		<cfset start_date = CreateODBCDate(start_date)>
		<cfset end_date = CreateODBCDate(end_date)>
		
		<cfquery name="q_hours_worked" datasource="#session.company.datasource#">
			SELECT id FROM time_entries 
			WHERE	((start_time BETWEEN #start_date# AND #end_date#)
			OR		(end_time BETWEEN #start_date# AND #end_date#))
			<cfif IsDefined("employee_id")>
				AND	employee_id='#employee_id#'
			</cfif>
			
		</cfquery>
				
		<cfset hours = 0>
		<cfoutput query="q_hours_worked">
			<cfset te = CreateObject("component", "ptarmigan.time_entry").open(q_hours_worked.id)>
			<cfset hours = hours + te.hours_decimal()>
		</cfoutput>
						
		<cfreturn hours>
	</cffunction>
	
	<cffunction name="projects_open" returntype="numeric" access="public" output="false">
		<cfargument name="start_date" datatype="string" required="false">
		<cfargument name="end_date" datatype="string" required="false">
		
		<cfif NOT IsDefined("start_date")>
			<cfset start_date = CreateODBCDate("1/1/1970")>
		</cfif>
		<cfif NOT IsDefined("end_date")>
			<cfset end_date = DateAdd("yyyy", 50, Now())>
		</cfif>
		
		<cfset start_date = CreateODBCDate(start_date)>
		<cfset end_date = CreateODBCDate(end_date)>
		
		<cfquery name="q_projects_open" datasource="#session.company.datasource#">
			SELECT 	COUNT(id) AS open_count FROM projects
			WHERE 	due_date BETWEEN #start_date# AND #end_date#
			OR		start_date BETWEEN #start_date# AND #end_date#
			OR		(start_date<=#start_date# AND due_date>=#start_date#)
		</cfquery>
		
		<cfreturn q_projects_open.open_count>
	</cffunction>
	
	<cffunction name="milestones_open" returntype="numeric" access="public" output="false">
		<cfargument name="start_date" datatype="string" required="false">
		<cfargument name="end_date" datatype="string" required="false">
		
		<cfif NOT IsDefined("start_date")>
			<cfset start_date = CreateODBCDate("1/1/1970")>
		</cfif>
		<cfif NOT IsDefined("end_date")>
			<cfset end_date = DateAdd("yyyy", 50, Now())>
		</cfif>
		
		<cfset start_date = CreateODBCDate(start_date)>
		<cfset end_date = CreateODBCDate(end_date)>
		
		<cfquery name="q_milestones_open" datasource="#session.company.datasource#">
			SELECT 		COUNT(id) AS milestone_count
			FROM		milestones
			WHERE 		end_date BETWEEN #start_date# AND #end_date#
			OR			start_date BETWEEN #start_date# AND #end_date#
			OR 			NOW() BETWEEN start_date AND end_date					
		</cfquery>

		<cfreturn q_milestones_open.milestone_count>	
	</cffunction>

	<cffunction name="tasks_open" returntype="numeric" access="public" output="false">
		<cfargument name="start_date" datatype="string" required="false">
		<cfargument name="end_date" datatype="string" required="false">
	
		<cfif NOT IsDefined("start_date")>
			<cfset start_date = CreateODBCDate("1/1/1970")>
		</cfif>
		<cfif NOT IsDefined("end_date")>
			<cfset end_date = DateAdd("yyyy", 50, Now())>
		</cfif>
		
		<cfset start_date = CreateODBCDate(start_date)>
		<cfset end_date = CreateODBCDate(end_date)>
	 
		<cfquery name="q_tasks_open" datasource="#session.company.datasource#">
			SELECT 		COUNT(id) AS task_count
			FROM		tasks
			WHERE 		start_date>=#CreateODBCDate(start_date)#
			AND 		end_date<=#CreateODBCDate(end_date)#
		</cfquery>
		
		<cfreturn q_tasks_open.task_count>	
	</cffunction>
	
	<cffunction name="assignments_open" returntype="numeric" access="public" output="false">
		<cfargument name="start_date" datatype="string" required="false">
		<cfargument name="end_date" datatype="string" required="false">
		<cfargument name="employee_id" datatype="string" required="false">

		<cfif NOT IsDefined("start_date")>
			<cfset start_date = CreateODBCDate("1/1/1970")>
		</cfif>
		<cfif NOT IsDefined("end_date")>
			<cfset end_date = DateAdd("yyyy", 50, Now())>
		</cfif>
		
		<cfset start_date = CreateODBCDate(start_date)>
		<cfset end_date = CreateODBCDate(end_date)>
		
		<cfquery name="q_assignments_open" datasource="#session.company.datasource#">
			SELECT 		COUNT(id) AS assignment_count
			FROM		assignments
			WHERE 		start_date>=#CreateODBCDate(start_date)#
			AND 		end_date<=#CreateODBCDate(end_date)#
			<cfif IsDefined("employee_id")>
			AND			employee_id='#employee_id#'
			</cfif>
		</cfquery>
		
		<cfreturn q_assignments_open.assignment_count>
	
	</cffunction>

</cfcomponent>