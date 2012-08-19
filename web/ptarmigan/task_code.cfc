<cfcomponent output="false">
	
	<cfset this.id = "">
	<cfset this.task_code = "">
	<cfset this.task_name = "">
	<cfset this.unit_type = "">
	
	<cfset this.assigned_code_id = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.task_code" access="public">
	
		<cfset this.id = CreateUUID()>
		<cfquery name="q_create_task_code" datasource="ptarmigan">
			INSERT INTO	task_codes
						(id,
						task_code,
						task_name,
						unit_type)
			VALUES		('#this.id#',
						'#this.task_code#',
						'#UCase(this.task_name)#',
						'#UCase(this.unit_type)#')
		</cfquery>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.task_code" access="public">
		<cfargument name="id" type="string" required="true">
	
		<cfquery name="otc" datasource="ptarmigan">
			SELECT * FROM task_codes WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.task_code = otc.task_code>
		<cfset this.task_name = otc.task_name>
		<cfset this.unit_type = otc.unit_type>	
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.task_code" access="public">

		<cfquery name="q_update_task_code" datasource="ptarmigan">
			UPDATE task_codes
			SET		task_code='#this.task_code#',
					task_name='#UCase(this.task_name)#',
					unit_type='#UCase(this.unit_type)#'
			WHERE	id='#this.id#'		
		</cfquery>

		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>