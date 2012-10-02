<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.task_id = "">
	<cfset this.employee_id = "">
	<cfset this.start_date = "">
	<cfset this.end_date = "">
	<cfset this.instructions = "">
	<cfset this.address = "">
	<cfset this.city = "">
	<cfset this.state = "">
	<cfset this.zip = "">
	<cfset this.latitude = "">
	<cfset this.longitude = "">
	<cfset this.location_preference = 0>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.assignment" access="public" output="false">
	
		<cfset this.id = CreateUUID()>
	
		<cfquery name="q_create_assignment" datasource="#session.company.datasource#">
			INSERT INTO assignments
						(id,
						task_id,
						employee_id,
						start_date,
						end_date,
						instructions,
						address,
						city,
						state,
						zip,
						latitude,
						longitude,
						location_preference)
			VALUES		('#this.id#',
						'#this.task_id#',
						'#this.employee_id#',
						#this.start_date#,
						#this.end_date#,
						'#UCase(this.instructions)#',
						'#UCase(this.address)#',
						'#UCase(this.city)#',
						'#UCase(this.state)#',
						'#this.zip#',
						'#this.latitude#',
						'#this.longitude#',
						#this.location_preference#)
		</cfquery>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.assignment" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="ao" datasource="#session.company.datasource#">
			SELECT * FROM assignments WHERE id='#id#'
		</cfquery>
	
		<cfset this.id = id>
		<cfset this.task_id = ao.task_id>
		<cfset this.employee_id = ao.employee_id>
		<cfset this.start_date = ao.start_date>
		<cfset this.end_date = ao.end_date>
		<cfset this.instructions = ao.instructions>
		<cfset this.address = ao.address>
		<cfset this.city = ao.city>
		<cfset this.state = ao.state>
		<cfset this.zip = ao.zip>
		<cfset this.latitude = ao.latitude>
		<cfset this.longitude = ao.longitude>
		<cfset this.location_preference = ao.location_preference>
			
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.assignment" access="public" output="false">
	
		<cfquery name="q_update_assignment" datasource="#session.company.datasource#">
			UPDATE assignments
			SET		task_id='#this.task_id#',
					employee_id='#this.employee_id#',
					start_date=#this.start_date#,
					end_date=#this.end_date#,
					instructions='#ucase(this.instructions)#',
					address='#ucase(this.address)#',
					city='#ucase(this.city)#',
					state='#ucase(this.state)#',
					zip='#ucase(this.zip)#',
					latitude='#this.latitude#',
					longitude='#this.longitude#',
					location_preference=#this.location_preference#
			WHERE	id='#this.id#'
		</cfquery>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="task_name" returntype="string" access="public">
		<cfset t = CreateObject("component", "ptarmigan.task").open(this.task_id)>
		<cfset m = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
		<cfset p = CreateObject("component", "ptarmigan.project").open(m.project_id)>
		
		<cfreturn t.task_name>
	</cffunction>

	<cffunction name="milestone_name" returntype="string" access="public">
		<cfset t = CreateObject("component", "ptarmigan.task").open(this.task_id)>
		<cfset m = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
		<cfset p = CreateObject("component", "ptarmigan.project").open(m.project_id)>
		
		<cfreturn m.milestone_name>
	</cffunction>
	
	<cffunction name="project_name" returntype="string" access="public">
		<cfset t = CreateObject("component", "ptarmigan.task").open(this.task_id)>
		<cfset m = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
		<cfset p = CreateObject("component", "ptarmigan.project").open(m.project_id)>
		
		<cfreturn p.project_name>
	</cffunction>
	
	<cffunction name="customer_name" returntype="string" access="public">
		<cfset t = CreateObject("component", "ptarmigan.task").open(this.task_id)>
		<cfset m = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
		<cfset p = CreateObject("component", "ptarmigan.project").open(m.project_id)>
		<cfset c = CreateObject("component", "ptarmigan.customer").open(p.customer_id)>
		
		<cfreturn c.company_name>
	</cffunction>
	
	<cffunction name="task_codes" returntype="array" access="public">
		
		<cfquery name="gtc" datasource="#session.company.datasource#">
			SELECT 		task_codes.id, 
						task_codes.task_name,
						task_code_assignments.id AS shit
			FROM		task_codes
			INNER JOIN 	task_code_assignments
			ON			task_code_assignments.task_code_id=task_codes.id
			WHERE		task_code_assignments.assignment_id='#this.id#'
			ORDER BY	task_codes.task_name
		</cfquery>
		
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="gtc">
			<cfset t = CreateObject("component", "ptarmigan.task_code").open(gtc.id)>
			<cfset t.assigned_code_id = gtc.shit>
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>

</cfcomponent>