<cfcomponent output="false">
	<cfset this.id = "">
	<cfset this.path = "">
	<cfset this.document_name = "">
	<cfset this.description = "">
	<cfset this.document_number = "">
	<cfset this.mime_type = "">
	<cfset this.filing_category = "FILE">
	<cfset this.filing_container = "CABINET">
	<cfset this.filing_division = "">
	<cfset this.filing_material_type = "FOLDER">
	<cfset this.filing_number = "">
	<cfset this.filing_date = CreateODBCDate(Now())>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.document" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_document" datasource="#session.company.datasource#">
			INSERT INTO	documents
							(id,
							path,
							document_name,
							description,
							document_number,
							mime_type,
							filing_category,
							filing_container,
							filing_division,
							filing_material_type,
							filing_number,
							filing_date)
			VALUES			('#this.id#',
							'#this.path#',
							'#this.document_name#',
							'#this.description#',
							'#this.document_number#',
							'#this.mime_type#',
							'#this.filing_category#',
							'#this.filing_container#',
							'#this.filing_division#',
							'#this.filing_material_type#',
							'#this.filing_number#',
							#this.filing_date#)
		</cfquery>
		
		<cfset session.message = "Document #this.document_name# added.">

		
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
		<cfset this.document_name = od.document_name>
		<cfset this.description = od.description>
		<cfset this.document_number = od.document_number>
		<cfset this.mime_type = od.mime_type>
		<cfset this.filing_category = od.filing_category>
		<cfset this.filing_container = od.filing_container>
		<cfset this.filing_division = od.filing_division>
		<cfset this.filing_material_type = od.filing_material_type>
		<cfset this.filing_number = od.filing_number>
		<cfset this.filing_date = od.filing_date>
				
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.document" access="public" output="false">
		
		<cfquery name="q_update_document" datasource="#session.company.datasource#">
			UPDATE	documents
			SET		path='#this.path#',
					document_name='#this.document_name#',
					description='#this.description#',
					document_number='#this.document_number#',
					mime_type='#this.mime_type#',
					filing_category='#this.filing_category#',
					filing_container='#this.filing_container#',
					filing_division='#this.filing_division#',
					filing_material_type='#this.filing_material_type#',
					filing_number='#this.filing_number#',
					filing_date=#this.filing_date#
			WHERE	id='#this.id#'
		</cfquery>
		<cfset session.message = "Document #this.document_name# updated.">

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

	<cffunction name="content_type" returntype="string" access="public" output="false">	
		<cfif find("/", this.mime_type) NEQ 0>
			<cfset ctype = left(this.mime_type, find("/", this.mime_type) - 1)>
		<cfelse>
			<cfset ctype = "">
		</cfif>
				
		<cfreturn ctype>
	</cffunction>
	
	<cffunction name="content_sub_type" returntype="string" access="public" output="false">	
		<cfif find("/", this.mime_type) NEQ 0>
			<cfset ctype = mid(this.mime_type, find("/", this.mime_type) + 1, len(this.mime_type))>
		<cfelse>
			<cfset ctype = "">
		</cfif>
		
		<cfreturn ctype>
	</cffunction>
</cfcomponent>