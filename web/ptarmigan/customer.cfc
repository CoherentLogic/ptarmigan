<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.company_name = "">
	<cfset this.poc = "">
	<cfset this.email = "">
	<cfset this.electronic_billing = 0>
	<cfset this.phone_number = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.customer" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_customer" datasource="#session.company.datasource#">
			INSERT INTO customers
						(id,
						company_name,
						poc,
						email,
						electronic_billing,
						phone_number)
			VALUES		('#this.id#',
						'#this.company_name#',
						'#this.poc#',
						'#this.email#',
						#this.electronic_billing#,
						'#this.phone_number#')
		</cfquery>
		
		<cfset this.written = true>
		
		<cfreturn this>
		
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.customer" access="public" output="false">
	
		<cfquery name="q_update_customer" datasource="#session.company.datasource#">
			UPDATE customers
			SET		company_name='#this.company_name#',
					poc='#this.poc#',
					email='#this.email#',
					electronic_billing=#this.electronic_billing#,
					phone_number='#this.phone_number#'
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
		
		<cfreturn this>
			
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.customer" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="qoc" datasource="#session.company.datasource#">
			SELECT * FROM customers WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.company_name = qoc.company_name>
		<cfset this.poc = qoc.poc>
		<cfset this.email = qoc.email>
		<cfset this.electronic_billing = qoc.electronic_billing>
		<cfset this.phone_number = qoc.phone_number>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="documents" returntype="array" access="public" output="false">
		<cfquery name="q_docs" datasource="#session.company.datasource#">
			SELECT	document_id
			FROM	document_associations
			WHERE	element_table='customers'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_docs">
			<cfset d = CreateObject("component", "ptarmigan.document").open(document_id)>
			<cfset ArrayAppend(oa, d)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
</cfcomponent>