<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	<cfset this.company_name = "">
	<cfset this.poc = "">
	<cfset this.email = "">
	<cfset this.electronic_billing = 0>
	<cfset this.phone_number = "">
	
	<cfset this.members = StructNew()>		
	<cfscript>
		this.members['COMPANY_NAME'] = StructNew();
		this.members['COMPANY_NAME'].type = "text";
		this.members['COMPANY_NAME'].label = "Company name";

		this.members['POC'] = StructNew();
		this.members['POC'].type = "text";
		this.members['POC'].label = "Point of contact";

		this.members['EMAIL'] = StructNew();
		this.members['EMAIL'].type = "text";
		this.members['EMAIL'].label = "E-mail address";

		this.members['ELECTRONIC_BILLING'] = StructNew();
		this.members['ELECTRONIC_BILLING'].type = "boolean";
		this.members['ELECTRONIC_BILLING'].label = "Electronic billing";

		this.members['PHONE_NUMBER'] = StructNew();
		this.members['PHONE_NUMBER'].type = "text";
		this.members['PHONE_NUMBER'].label = "Phone number";								
	</cfscript>
	
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
		<cfset session.message = "Customer #this.company_name# added.">
		<cfset this.written = true>

		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_CUSTOMER">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
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
		<cfset session.message = "Customer #this.company_name# updated.">
		
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>			
		<cfset obj.deleted = 0>
		
		<cfset obj.update()>		
		
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
	
	<cffunction name="projects" returntype="array" access="public" output="false">
		<cfquery name="q_projects" datasource="#session.company.datasource#">
			SELECT id FROM projects WHERE customer_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_projects">
			<cfset p = CreateObject("component", "ptarmigan.project").open(id)>
			<cfset ArrayAppend(oa, p)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM customers WHERE id='#this.id#'
		</cfquery>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.company_name>
	</cffunction>
	<cffunction name="search_result" returntype="void" access="public" output="true">
	</cffunction>
</cfcomponent>