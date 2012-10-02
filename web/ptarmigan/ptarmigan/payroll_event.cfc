<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.employee_id = "">
	<cfset this.charged = "">
	<cfset this.amount = 0.0>
	<cfset this.paid = 0>
	<cfset this.time_entry_date = "">
	<cfset this.description = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.payroll_event" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_payroll_event" datasource="#session.company.datasource#">
			INSERT INTO payroll_event
						(id,
						employee_id,
						charged,
						amount,
						paid,
						time_entry_date,
						description)
			VALUES		('#this.id#',
						'#this.employee_id#',
						#this.charged#,
						#this.amount#,
						#this.paid#,
						#this.time_entry_date#,
						'#this.description#')
		</cfquery>
		
		<cfset this.written = true>		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.payroll_event" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="ope" datasource="#session.company.datasource#">
			SELECT * FROM payroll_event WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.employee_id = ope.employee_id>
		<cfset this.charged = ope.charged>
		<cfset this.amount = ope.amount>
		<cfset this.paid = ope.paid>
		<cfset this.time_entry_date = ope.time_entry_date>
		<cfset this.description = ope.description>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.payroll_event" access="public" output="false">
		
		<cfquery name="q_update_payroll_event" datasource="#session.company.datasource#">
			UPDATE	payroll_event
			SET		employee_id='#this.employee_id#',
					charged=#this.charged#,
					amount=#this.amount#,
					paid=#this.paid#,
					time_entry_date=#this.time_entry_date#,
					description='#this.description#'
			WHERE	id='#this.id#'		
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

</cfcomponent>