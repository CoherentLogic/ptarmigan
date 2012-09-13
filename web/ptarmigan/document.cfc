<cfcomponent output="false" implements="ptarmigan.i_object">
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
	
	<cfset this.members = StructNew()>
	
	
	<cfscript>
		this.members['DOCUMENT_NAME'] = StructNew();
		this.members['DOCUMENT_NAME'].type = "text";
		this.members['DOCUMENT_NAME'].label = "Document name";	
		
		this.members['DESCRIPTION'] = StructNew();
		this.members['DESCRIPTION'].type = "text";
		this.members['DESCRIPTION'].label = "Description";
		
		this.members['DOCUMENT_NUMBER'] = StructNew();
		this.members['DOCUMENT_NUMBER'].type = "text";
		this.members['DOCUMENT_NUMBER'].label = "Document number";
		
		this.members['MIME_TYPE'] = StructNew();
		this.members['MIME_TYPE'].type = "text";
		this.members['MIME_TYPE'].label = "MIME type";
		
		this.members['FILING_CATEGORY'] = StructNew();
		this.members['FILING_CATEGORY'].type = "text";
		this.members['FILING_CATEGORY'].label = "Filing category";
		
		this.members['FILING_CONTAINER'] = StructNew();
		this.members['FILING_CONTAINER'].type = "text";
		this.members['FILING_CONTAINER'].label = "Filing container";
		
		this.members['FILING_DIVISION'] = StructNew();
		this.members['FILING_DIVISION'].type = "text";
		this.members['FILING_DIVISION'].label = "Filing division";
		
		this.members['FILING_MATERIAL_TYPE'] = StructNew();
		this.members['FILING_MATERIAL_TYPE'].type = "text";
		this.members['FILING_MATERIAL_TYPE'].label = "Filing material type";
		
		this.members['FILING_NUMBER'] = StructNew();
		this.members['FILING_NUMBER'].type = "text";
		this.members['FILING_NUMBER'].label = "Filing number";
		
		this.members['FILING_DATE'] = StructNew();
		this.members['FILING_DATE'].type = "date";
		this.members['FILING_DATE'].label = "Filing date";
		
	</cfscript>
	
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

		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_DOCUMENT">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
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
		
		<cfset session.message = "Document #this.document_name# opened.">

				
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

		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>	
		<cfset obj.deleted = 0>
		
		<cfset obj.update()>		

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
	
	<cffunction name="parcels" returntype="array" access="public" output="false">
		<cfquery name="doc_parcels" datasource="#session.company.datasource#">
			SELECT element_id FROM document_associations WHERE element_table='parcels' AND document_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="doc_parcels">
			<cfset p = CreateObject("component", "ptarmigan.parcel").open(doc_parcels.element_id)>
			<cfset ArrayAppend(oa, p)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM documents WHERE id='#this.id#'
		</cfquery>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.document_name>
	</cffunction>
</cfcomponent>