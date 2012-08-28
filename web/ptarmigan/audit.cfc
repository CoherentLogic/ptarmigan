<cfcomponent output="false">
	<cfset this.id = "">
	<cfset this.table_name = "">
	<cfset this.table_id = "">
	<cfset this.change_order_number = "">
	<cfset this.audit_date = "">
	<cfset this.employee_id = "">
	<cfset this.comment = "">
	<cfset this.what_changed = "">
	
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.audit" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_audit" datasource="#session.company.datasource#">
			INSERT INTO audits
							(id,
							table_name,
							table_id,
							change_order_number,
							employee_id,
							comment,
							what_changed)
			VALUES			('#this.id#',
							'#this.table_name#',
							'#this.table_id#',
							'#this.change_order_number#',
							'#this.employee_id#',
							'#this.comment#',
							'#this.what_changed#')
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.audit" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="oa" datasource="#session.company.datasource#">
			SELECT * FROM audits WHERE id='#id#'
		</cfquery>
		
		<cfif oa.recordcount EQ 0>
			<cfthrow>
		</cfif>
		
		<cfset this.id = id>
		<cfset this.table_name = oa.table_name>
		<cfset this.table_id = oa.table_id>
		<cfset this.change_order_number = oa.change_order_number>
		<cfset this.employee_id = oa.employee_id>
		<cfset this.comment = oa.comment>
		<cfset this.what_changed = oa.what_changed>
		<cfset this.audit_date = oa.audit_date>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>