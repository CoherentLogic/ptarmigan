<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.milestone_id = "">
	<cfset this.task_name = "">
	<cfset this.description = "">
	<cfset this.completed = 0>
	<cfset this.start_date = "">
	<cfset this.end_date = "">
	<cfset this.budget = "">
	
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.task" access="public" output="false">
	
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_task_create" datasource="#session.company.datasource#">
			INSERT INTO tasks
						(id,
						milestone_id,
						task_name,
						description,
						completed,
						start_date,
						end_date,
						budget)
			VALUES		('#this.id#',
						'#this.milestone_id#',
						'#UCase(this.task_name)#',
						'#UCase(this.description)#',
						#this.completed#,
						#this.start_date#,
						#this.end_date#,
						#this.budget#)
		</cfquery>
		
		<cfset this.written = true>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.task" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="t" datasource="#session.company.datasource#">
			SELECT * FROM tasks WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.milestone_id = t.milestone_id>
		<cfset this.task_name = t.task_name>
		<cfset this.description = t.description>
		<cfset this.completed = t.completed>
		<cfset this.start_date = t.start_date>
		<cfset this.end_date = t.end_date>
		<cfset this.budget = t.budget>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.task" access="public" output="false">
		
		<cfquery name="q_task_update" datasource="#session.company.datasource#">
			UPDATE tasks
			SET		milestone_id='#this.milestone_id#',
					task_name='#UCase(this.task_name)#',
					description='#UCase(this.description)#',
					completed=#this.completed#,
					start_date=#this.start_date#,
					end_date=#this.end_date#,
					budget=#this.budget#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
	
		<cfreturn this>
	</cffunction>

</cfcomponent>