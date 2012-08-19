<cfcomponent output="false">
	
	<cfset this.id = "">
	<cfset this.task_code_id = "">
	<cfset this.assignment_id = "">
	<cfset this.rate = 0.0>
	<cfset this.employee_rate = 0.0>
	<cfset this.billable = 1>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.code_assign" access="public">
	
		<cfset this.id = CreateUUID()>
		<cfquery name="q_create_code_assign" datasource="ptarmigan">
			INSERT INTO task_code_assignments
						(id,
						task_code_id,
						assignment_id,
						rate,
						employee_rate,
						billable)
			VALUES		('#this.id#',
						'#this.task_code_id#',
						'#this.assignment_id#',
						#this.rate#,
						#this.employee_rate#,
						#this.billable#)
		</cfquery>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.code_assign" access="public">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="oca" datasource="ptarmigan">
			SELECT * FROM task_code_assignments WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.task_code_id = oca.task_code_id>
		<cfset this.assignment_id = oca.assignment_id>
		<cfset this.rate = oca.rate>
		<cfset this.billable = oca.billable>
		<cfset this.employee_rate = oca.employee_rate>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.code_assign" access="public">

		<cfquery name="q_update_code_assign" datasource="ptarmigan">
			UPDATE task_code_assignments
			SET		task_code_id='#this.task_code_id#',
					assignment_id='#this.assignment_id#',
					rate=#this.rate#,
					employee_rate=#this.employee_rate#,
					billable=#this.billable#
			WHERE	id='#this.id#'
		</cfquery>
	
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>