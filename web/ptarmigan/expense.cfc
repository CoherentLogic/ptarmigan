<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.element_table = "">
	<cfset this.element_id = "">
	<cfset this.expense_date = CreateODBCDate(Now())>
	<cfset this.description = "">
	<cfset this.recipient = "">
	<cfset this.address = "">
	<cfset this.city = "">
	<cfset this.state = "">
	<cfset this.zip = "">
	<cfset this.poc = "">
	<cfset this.amount = 0>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.expense" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_expense" datasource="#session.company.datasource#">
			INSERT INTO	project_expenses
							(id,
							element_table,
							element_id,
							expense_date,
							description,
							recipient,
							address,
							city,
							state,
							zip,
							poc,
							amount)
			VALUES			('#this.id#',
							'#this.element_table#',
							'#this.element_id#',
							#this.expense_date#,
							'#this.description#',
							'#this.recipient#',
							'#this.address#',
							'#this.city#',
							'#this.state#',
							'#this.zip#',
							'#this.poc#',
							#this.amount#)
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.expense" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="x" datasource="#session.company.datasource#">
			SELECT * FROM project_expenses WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.element_table = x.element_table>
		<cfset this.element_id = x.element_id>
		<cfset this.expense_date = x.expense_date>
		<cfset this.description = x.description>
		<cfset this.recipient = x.recipient>
		<cfset this.address = x.address>
		<cfset this.city = x.city>
		<cfset this.state = x.state>
		<cfset this.zip = x.zip>
		<cfset this.poc = x.poc>
		<cfset this.amount = x.amount>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.expense" access="public" output="false">
		
		<cfquery name="q_update_expense" datasource="#session.company.datasource#">
			UPDATE		project_expenses
			SET			expense_date=#this.expense_date#,
						description='#this.description#',
						recipient='#this.recipient#',
						address='#this.address#',
						city='#this.city#',
						state='#this.state#',
						zip='#this.zip#',
						poc='#this.poc#',
						amount=#this.amount#
			WHERE		id='#this.id#'			
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="documents" returntype="array" access="public" output="false">
		<cfquery name="q_docs" datasource="#session.company.datasource#">
			SELECT	document_id
			FROM	document_associations
			WHERE	element_table='project_expenses'
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