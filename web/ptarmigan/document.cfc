<cfcomponent output="false">
	<cfset this.id = "">
	<cfset this.path = "">
	<cfset this.name = "">
	<cfset this.description = "">
	<cfset this.document_number = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.document" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_document" datasource="#session.company.datasource#">
			INSERT INTO	documents
							(id,
							path,
							name,
							description,
							document_number)
			VALUES			('#this.id#',
							'#this.path#',
							'#this.name#',
							'#this.description#',
							'#this.document_number#')
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.document" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="od" datasource="#session.company.datasource#">
			SELECT 	*
			FROM		documents
			WHERE		id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.path = od.path>
		<cfset this.name = od.name>
		<cfset this.description = od.description>
		<cfset this.document_number = od.document_number>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.document" access="public" output="false">
		
		<cfquery name="q_update_document" datasource="#session.company.datasource#">
			UPDATE	documents
			SET		path='#this.path#',
					name='#this.name#',
					description='#this.description#',
					document_number='#this.document_number#'
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="associated" returntype="boolean" access="public" output="false">
		<cfargument name="element_table" type="string" required="true">
		<cfargument name="element_id" type="string" required="true">
 
		<cfquery name="q_associated" datasource="#session.company.datasource#">
			SELECT	* 
			FROM 	document_associations 
			WHERE	element_table='#element_table#'
			AND		element_id='#element_id#'
			AND		document_id='#this.id#'
		</cfquery>
		
		<cfif q_associated.recordcount NEQ 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="associate" returntype="void" access="public" output="false">
		<cfargument name="element_table" type="string" required="true">
		<cfargument name="element_id" type="string" required="true">

		<cfset a_id = CreateUUID()>
		
		<cfquery name="q_associate" datasource="#session.company.datasource#">
			INSERT INTO	document_associations
							(id,
							element_table,
							element_id,
							document_id)
			VALUES			('#a_id#',
							'#element_table#',
							'#element_id#',
							'#this.id#')
		</cfquery>

	</cffunction>
	
	<cffunction name="disassociate" returntype="void" access="public" output="false">
		<cfargument name="element_table" type="string" required="true">
		<cfargument name="element_id" type="string" required="true">

		<cfquery name="q_disassociate" datasource="#session.company.datasource#">
			DELETE FROM	document_associations
			WHERE			element_table='#element_table#'
			AND				element_id='#element_id#'
			AND				document_id='#this.id#'
		</cfquery>

	</cffunction>	
</cfcomponent>