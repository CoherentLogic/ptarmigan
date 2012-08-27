<cfcomponent output="false">
	
	<cfset this.id = "">
	<cfset this.project_number = "">
	<cfset this.project_name = "">
	<cfset this.instructions = "">
	<cfset this.due_date = "">
	<cfset this.current_milestone = 1>
	<cfset this.customer_id = "">
	<cfset this.created_by = "">
	<cfset this.tax_rate = 0>
	<cfset this.start_date = "">
	<cfset this.budget = 0>
	
	<cfset this.written = false>
	
	
	<cffunction name="create" returntype="ptarmigan.project" access="public" output="false">
		
		<cflock scope="application" throwontimeout="true" timeout="40">
			<cfset this.id = CreateUUID()>
			<cfset this.project_number = this.next_project_number()>
			
			<cfquery name="q_project_create" datasource="#session.company.datasource#">
				INSERT INTO projects 
							(id,
							project_number,
							project_name,
							instructions,
							due_date,
							current_milestone,
							customer_id,
							created_by,
							tax_rate,
							start_date,
							budget)
				VALUES		('#this.id#',
							'#this.project_number#',
							'#this.project_name#',
							'#this.instructions#',
							#this.due_date#,
							#this.current_milestone#,
							'#this.customer_id#',
							'#this.created_by#',
							#this.tax_rate#,
							#this.start_date#,
							#this.budget#)
			</cfquery>
		</cflock>
		
		<cfset t = CreateObject("component", "ptarmigan.milestone")>
		
		<cfset t.project_id = this.id>
		<cfset t.milestone_number = 1000>
		<cfset t.milestone_name = "MISCELLANEOUS TASKS">
		<cfset t.floating = 1>
		<cfset t.start_date = CreateODBCDate(Now())>
		<cfset t.end_date = CreateODBCDate(Now())>
		
		<cfset t.create()>
		
		

		<cfreturn this>
		
	</cffunction>
	
	<cffunction name="next_project_number" returntype="string" access="public" output="false">
	
		<cfquery name="gpn" datasource="#session.company.datasource#">
			SELECT MAX(LEFT(project_number, 3)) AS max_pn FROM projects
		</cfquery>
		
		
		
		<cfif gpn.RecordCount GT 0>
			<cfif gpn.max_pn NEQ "">
				<cfset max_current = gpn.max_pn + 1>
			<cfelse>
				<cfset max_current = 100>
			</cfif>
		<cfelse>
			<cfset max_current = 100>
		</cfif>
		
	
		<cfset retval = "#max_current#-#dateFormat(now(), 'YYYYMMDD')#">

		<cfreturn retval>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.project" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="op" datasource="#session.company.datasource#">
			SELECT * FROM projects WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.project_number = op.project_number>
		<cfset this.project_name = op.project_name>		
		<cfset this.instructions = op.instructions>
		<cfset this.due_date = op.due_date>
		<cfset this.current_milestone = op.current_milestone>
		<cfset this.customer_id = op.customer_id>
		<cfset this.created_by = op.created_by>
		<cfset this.start_date = op.start_date>
		<cfset this.budget = op.budget>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.project" access="public" output="false">
		
		<cfquery name="q_update_project" datasource="#session.company.datasource#">
			UPDATE projects
			SET		project_number='#this.project_number#',
					project_name='#this.project_name#',
					instructions='#this.instructions#',
					due_date=#this.due_date#,
					current_milestone=#this.current_milestone#,
					customer_id='#this.customer_id#',
					tax_rate=#this.tax_rate#,
					start_date=#this.start_date#,
					budget=#this.budget#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="customer" returntype="ptarmigan.customer" access="public" output="false">
		<cfset t = CreateObject("component", "ptarmigan.customer").open(this.customer_id)>
		
		<cfreturn t>
	</cffunction>
	
	<cffunction name="milestones" returntype="array" access="public" output="false">		
		
		<cfquery name="gm" datasource="#session.company.datasource#">
			SELECT * FROM milestones WHERE project_id='#this.id#' ORDER BY milestone_number
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="gm">
			<cfset t = CreateObject("component", "ptarmigan.milestone").open(id)>
			<cfset arrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
</cfcomponent>