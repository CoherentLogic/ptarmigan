<cfcomponent output="true" implements="ptarmigan.i_object">
	<cfset this.id = "">
	<cfset this.path = "">
	<cfset this.document_name = "">
	<cfset this.description = "">
	<cfset this.document_number = "">
	<cfset this.document_revision = "">
	<cfset this.mime_type = "">
	<cfset this.filing_category = "FILE">
	<cfset this.filing_container = "CABINET">
	<cfset this.filing_division = "">
	<cfset this.filing_material_type = "FOLDER">
	<cfset this.filing_number = "">
	<cfset this.filing_date = CreateODBCDate(Now())>
	<cfset this.thumbnail_url = "">	
	<cfset this.section = "">
	<cfset this.township = "">
	<cfset this.range = "">
	<cfset this.subdivision = "">
	<cfset this.lot = "">
	<cfset this.block = "">
	<cfset this.usrs_parcel = "">
	<cfset this.usrs_sheet = "">
	<cfset this.owner_name = "">
	<cfset this.address = "">
	<cfset this.city = "">
	<cfset this.state = "">
	<cfset this.zip = "">


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
		this.members['FILING_CATEGORY'].type = "enum";
		this.members['FILING_CATEGORY'].values = "FILE,STORAGE,DEED,SUBDIVISION";
		this.members['FILING_CATEGORY'].label = "Filing category";
		
		this.members['FILING_CONTAINER'] = StructNew();
		this.members['FILING_CONTAINER'].type = "enum";
		this.members['FILING_CONTAINER'].values = "CABINET,SHELF,BOOK,PLAT";
		this.members['FILING_CONTAINER'].label = "Filing container";
		
		this.members['FILING_DIVISION'] = StructNew();
		this.members['FILING_DIVISION'].type = "text";
		this.members['FILING_DIVISION'].label = "Filing division";
		
		this.members['FILING_MATERIAL_TYPE'] = StructNew();
		this.members['FILING_MATERIAL_TYPE'].type = "enum";
		this.members['FILING_MATERIAL_TYPE'].values = "FOLDER,BOX,PAGE,SLIDE";
		this.members['FILING_MATERIAL_TYPE'].label = "Filing material type";
		
		this.members['FILING_NUMBER'] = StructNew();
		this.members['FILING_NUMBER'].type = "text";
		this.members['FILING_NUMBER'].label = "Filing number";
		
		this.members['FILING_DATE'] = StructNew();
		this.members['FILING_DATE'].type = "date";
		this.members['FILING_DATE'].label = "Filing date";
		
		this.members['DOCUMENT_REVISION'] = StructNew();
		this.members['DOCUMENT_REVISION'].type = "text";
		this.members['DOCUMENT_REVISION'].label = "Document revision";
		
		this.members['SECTION'] = StructNew();
		this.members['SECTION'].type = "text";
		this.members['SECTION'].label = "Section";
		
		this.members['TOWNSHIP'] = StructNew();
		this.members['TOWNSHIP'].type = "township";
		this.members['TOWNSHIP'].label = "Township";
			
		this.members['RANGE'] = StructNew();
		this.members['RANGE'].type = "range";
		this.members['RANGE'].label = "Range";
		
		this.members['SUBDIVISION'] = StructNew();
		this.members['SUBDIVISION'].type = "text";
		this.members['SUBDIVISION'].label = "Subdivision";
		
		this.members['LOT'] = StructNew();
		this.members['LOT'].type = "text";
		this.members['LOT'].label = "Lot";
		
		this.members['BLOCK'] = StructNew();
		this.members['BLOCK'].type = "text";
		this.members['BLOCK'].label = "Block";
		
		this.members['USRS_PARCEL'] = StructNew();
		this.members['USRS_PARCEL'].type = "text";
		this.members['USRS_PARCEL'].label = "USRS parcel"
		
		this.members['USRS_SHEET'] = StructNew();
		this.members['USRS_SHEET'].type = "text";
		this.members['USRS_SHEET'].label = "USRS sheet";
		
		this.members['OWNER_NAME'] = StructNew();
		this.members['OWNER_NAME'].type = "text";
		this.members['OWNER_NAME'].label = "Owner name";
		
		this.members['ADDRESS'] = StructNew();
		this.members['ADDRESS'].type = "text";
		this.members['ADDRESS'].label = "Street address";
		
		this.members['CITY'] = StructNew();
		this.members['CITY'].type = "text";
		this.members['CITY'].label = "City";
		
		this.members['STATE'] = StructNew();
		this.members['STATE'].type = "usstate";
		this.members['STATE'].label = "State";
		
		this.members['ZIP'] = StructNew();
		this.members['ZIP'].type = "text";
		this.members['ZIP'].label = "ZIP code";
		
		
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
							filing_date,
							thumbnail_url,
							document_revision,
							section,
							township,
							`range`,
							subdivision,
							lot,
							block,
							usrs_parcel,
							usrs_sheet,
							owner_name,
							address,
							city,
							state,
							zip)
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
							#this.filing_date#,
							'#this.thumbnail_url#',
							'#this.document_revision#',
							'#this.section#',
							'#this.township#',
							'#this.range#',
							'#this.subdivision#',
							'#this.lot#',
							'#this.block#',
							'#this.usrs_parcel#',
							'#this.usrs_sheet#',
							'#this.owner_name#',
							'#this.address#',
							'#this.city#',
							'#this.state#',
							'#this.zip#')
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
		<cfset this.thumbnail_url = od.thumbnail_url>
		
		<cfset this.document_revision = od.document_revision>
		<cfset this.section = od.section>
		<cfset this.township = od.township>
		<cfset this.range = od.range>
		<cfset this.subdivision = od.subdivision>
		<cfset this.lot = od.lot>
		<cfset this.block = od.block>
		<cfset this.usrs_parcel = od.usrs_parcel>
		<cfset this.usrs_sheet = od.usrs_sheet>		
		
		<cfset this.address = od.address>
		<cfset this.city = od.city>
		<cfset this.state = od.state>
		<cfset this.zip = od.zip>
		<cfset this.owner_name = od.owner_name>
		
		
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
					filing_date=#this.filing_date#,
					thumbnail_url='#this.thumbnail_url#',
					document_revision='#this.document_revision#',
					section='#this.section#',
					township='#this.township#',
					`range`='#this.range#',
					subdivision='#this.subdivision#',
					lot='#this.lot#',
					block='#this.block#',
					usrs_parcel='#this.usrs_parcel#',
					usrs_sheet='#this.usrs_sheet#',
					address='#this.address#',
					city='#this.city#',
					state='#this.state#',
					zip='#this.zip#',
					owner_name='#this.owner_name#'
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
 
	<cffunction name="generate_thumbnail" returntype="void" access="public" output="false">		
		<cfswitch expression="#this.content_type()#">
			<cfcase value="image">
				<cfset has_preview = true>
				<cfoutput>
					<cfset the_url = session.root_url & "/uploads/" & this.path>
					<cfset this.thumbnail_url = CreateObject("component", "OpenHorizon.Graphics.Image").Create(the_url, 200, 200)>
					<cfset this.update()>
				</cfoutput>
			</cfcase>		
			<cfcase value="application">
				<cfswitch expression="#this.content_sub_type()#">
					<cfcase value="pdf,vnd.pdf" delimiters=",">
						<cfpdf action="getInfo" source="#session.upload_path#/#this.path#" name="pdf_info">
						<cfset page_count = pdf_info.TotalPages>
						<cfpdf 	action="thumbnail" 
								source="#session.upload_path#/#this.path#"
								destination="#session.upload_path#"
								overwrite="true"
								format="jpg"
								scale="100"
								pages="1">
						<cfset base_file_name = left(this.path, len(this.path) - 4)>
								
						<cfset current_file = base_file_name & "_page_1.jpg">
						<cfset the_url = session.root_url & "/uploads/" & current_file>
						<cfset this.thumbnail_url = CreateObject("component", "OpenHorizon.Graphics.Image").Create(the_url, 200, 200)>
						<cfset this.update()>	
					</cfcase>
				</cfswitch>
			</cfcase>
		</cfswitch>
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
	
	
	<cffunction name="search_result" returntype="void" access="public" output="true">
		
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>
		<div class="search_result">
			<cfoutput>
				<a href="#session.root_url#/objects/dispatch.cfm?id=#this.id#">#this.object_name()#</a><br/>
				<div class="search_class">Document <cfif this.document_number NEQ "">###this.document_number#</cfif></div>
					
					<cfif this.description NEQ "">
					#this.description#<br/>
					<cfelse>
					<em>No description</em><br/>
					</cfif>
								
					Filed #dateformat(this.filing_date, "mm/dd/yyyy")# 
					<cfif this.filing_division NEQ "">
						in #ucase(this.filing_category)# #ucase(this.filing_container)# #this.filing_division#
					</cfif>
					<cfif this.filing_number NEQ "">
						#ucase(this.filing_material_type)# #this.filing_number#
					</cfif>									
			</cfoutput>
		</div>
		
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.document_name>
	</cffunction>
</cfcomponent>