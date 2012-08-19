<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.milestone_id = "">
	<cfset this.task_name = "">
	<cfset this.description = "">
	<cfset this.completed = 0>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.task" access="public" output="false">
	
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_task_create" datasource="ptarmigan">
			INSERT INTO tasks
						(id,
						milestone_id,
						task_name,
						description,
						completed)
			VALUES		('#this.id#',
						'#this.milestone_id#',
						'#UCase(this.task_name)#',
						'#UCase(this.description)#',
						#this.completed#)
		</cfquery>
		
		<cfset this.written = true>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.task" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="t" datasource="ptarmigan">
			SELECT * FROM tasks WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.milestone_id = t.milestone_id>
		<cfset this.task_name = t.task_name>
		<cfset this.description = t.description>
		<cfset this.completed = t.completed>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.task" access="public" output="false">
		
		<cfquery name="q_task_update" datasource="ptarmigan">
			UPDATE tasks
			SET		milestone_id='#this.milestone_id#',
					task_name='#UCase(this.task_name)#',
					description='#UCase(this.description)#',
					completed=#this.completed#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
	
		<cfreturn this>
	</cffunction>

</cfcomponent>