<cfcomponent output="false">
	<cfset this.id = "">
	<cfset this.type_name = "">
	<cfset this.type_key = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" datatype="ptarmigan.document_type" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_document_type" datasource="#session.company.datasource#">
			INSERT INTO document_types
						(id,
						type_name,
						type_key)
			VALUES		('#this.id#',
						'#ucase(this.type_name)#',
						'#ucase(this.type_key)#')
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>		
	</cffunction>
	
	<cffunction name="open" datatype="ptarmigan.document_type" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="odt" datasource="#session.company.datasource#">
			SELECT * FROM document_types WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.type_name = odt.type_name>
		<cfset this.type_key = odt.type_key>
		
		<cfset this.written = true>
		<cfreturn this>		
	</cffunction>
	
	<cffunction name="update" datatype="ptarmigan.document_type" access="public" output="false">
		
		<cfquery name="q_update_document_type" datasource="#session.company.datasource#">
			UPDATE 	document_types
			SET		type_name='#ucase(this.type_name)#',
					type_key='#ucase(this.type_key)#'
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

</cfcomponent>