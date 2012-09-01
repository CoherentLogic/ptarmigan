<cfcomponent output="false">
	<cfset this.id = "">
	<cfset this.parcel_id = "">
	<cfset this.area_sq_ft = 0>
	<cfset this.area_sq_yd = 0>
	<cfset this.area_acres = 0>
	<cfset this.owner_name = "">	
	<cfset this.metes_and_bounds = "">
	<cfset this.ground_survey = 0>
	<cfset this.account_number = "">
	<cfset this.mailing_address = "">
	<cfset this.mailing_city = "">
	<cfset this.mailing_state = "">
	<cfset this.mailing_zip = "">
	<cfset this.physical_address = "">
	<cfset this.physical_city = "">
	<cfset this.physical_state = "">
	<cfset this.physical_zip = "">
	<cfset this.subdivision = "">
	<cfset this.lot = "">
	<cfset this.block = "">
	<cfset this.assessed_land_value = 0>
	<cfset this.assessed_building_value = 0>
	<cfset this.section = "">
	<cfset this.township = "">
	<cfset this.range = "">
	<cfset this.reception_number = "">
	<cfset this.center_latitude = 0.0>
	<cfset this.center_longitude = 0.0>
	
	<cfset this.polygons = ArrayNew(1)>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.parcel" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_parcel" datasource="#session.company.datasource#">
			INSERT INTO	parcels
							(id,
							parcel_id,
							area_sq_ft,
							area_sq_yd,
							area_acres,
							owner_name,
							metes_and_bounds,
							ground_survey,
							account_number,
							mailing_address,
							mailing_city,
							mailing_state,
							mailing_zip,
							physical_address,
							physical_city,
							physical_state,
							physical_zip,
							subdivision,
							lot,
							block,
							assessed_land_value,
							assessed_building_value,
							`section`,
							township,
							`range`,
							reception_number,
							center_latitude,
							center_longitude,
							center)
			VALUES			('#this.id#',
							'#this.parcel_id#',
							#this.area_sq_ft#,
							#this.area_sq_yd#,
							#this.area_acres#,
							'#this.owner_name#',
							'#this.metes_and_bounds#',
							#this.ground_survey#,
							'#this.account_number#',
							'#this.mailing_address#',
							'#this.mailing_city#',
							'#this.mailing_state#',
							'#this.mailing_zip#',
							'#this.physical_address#',
							'#this.physical_city#',
							'#this.physical_state#',
							'#this.physical_zip#',
							'#this.subdivision#',
							'#this.lot#',
							'#this.block#',
							#this.assessed_land_value#,
							#this.assessed_building_value#,
							'#this.section#',
							'#this.township#',
							'#this.range#',
							'#this.reception_number#',
							#this.center_latitude#,
							#this.center_longitude#,
							POINT(#this.center_latitude#, #this.center_longitude#))
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>		

	<cffunction name="open_by_apn" returntype="ptarmigan.parcel" access="public" output="false">
		<cfargument name="apn" type="string" required="true">
		
		<cfquery name="q_open_by_apn" datasource="#session.company.datasource#">
			SELECT id FROM parcels WHERE parcel_id='#apn#'
		</cfquery>
		
		<cfreturn this.open(q_open_by_apn.id)>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.parcel" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="p" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.parcel_id = p.parcel_id>
		<cfset this.area_sq_ft = p.area_sq_ft>
		<cfset this.area_sq_yd = p.area_sq_yd>
		<cfset this.area_acres = p.area_acres>
		<cfset this.owner_name = p.owner_name>
		<cfset this.account_number = p.account_number>
		<cfset this.mailing_address = p.mailing_address>
		<cfset this.mailing_city = p.mailing_city>
		<cfset this.mailing_state = p.mailing_state>
		<cfset this.mailing_zip = p.mailing_zip>
		<cfset this.physical_address = p.physical_address>
		<cfset this.physical_city = p.physical_city>
		<cfset this.physical_state = p.physical_state>
		<cfset this.physical_zip = p.physical_zip>
		<cfset this.subdivision = p.subdivision>
		<cfset this.lot = p.lot>
		<cfset this.block = p.block>
		<cfset this.assessed_land_value = p.assessed_land_value>
		<cfset this.assessed_building_value = p.assessed_building_value>
		<cfset this.section = p.section>
		<cfset this.township = p.township>
		<cfset this.range = p.range>
		<cfset this.reception_number = p.reception_number>
		<cfset this.metes_and_bounds = p.metes_and_bounds>
		<cfset this.ground_survey = p.ground_survey>
		<cfset this.center_latitude = p.center_latitude>
		<cfset this.center_longitude = p.center_longitude>
		
		<cfquery name="get_polygons" datasource="#session.company.datasource#">
			SELECT * FROM parcel_points WHERE parcel_id='#this.id#'
		</cfquery>
		
		<cfoutput query="get_polygons">
			<cfset t = StructNew()>
			<cfset t.latitude = latitude>
			<cfset t.longitude = longitude>
			<cfset ArrayAppend(this.polygons, t)>
		</cfoutput>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.parcel" access="public" output="false">
		
		<cfquery name="q_update_parcel" datasource="#session.company.datasource#">
			UPDATE parcels
			SET		parcel_id='#this.parcel_id#',
					area_sq_ft=#this.area_sq_ft#,
					area_sq_yd=#this.area_sq_yd#,
					area_acres=#this.area_acres#,
					owner_name='#this.owner_name#',
					account_number='#this.account_number#',
					mailing_address='#this.mailing_address#',
					mailing_city='#this.mailing_city#',
					mailing_state='#this.mailing_state#',
					mailing_zip='#this.mailing_zip#',
					physical_address='#this.physical_address#',
					physical_city='#this.physical_city#',
					physical_state='#this.physical_state#',
					physical_zip='#this.physical_zip#',
					subdivision='#this.subdivision#',
					lot='#this.lot#',
					block='#this.block#',
					assessed_land_value=#this.assessed_land_value#,
					assessed_building_value=#this.assessed_building_value#,
					section='#this.section#',
					township='#this.township#',
					`range`='#this.range#',
					reception_number='#this.reception_number#',
					metes_and_bounds='#this.metes_and_bounds#',
					ground_survey=#this.ground_survey#,
					center_latitude=#this.center_latitude#,
					center_longitude=#this.center_longitude#,
					center=GeomFromText('POINT(#this.center_latitude# #this.center_longitude#)')
			WHERE	id='#this.id#'			
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add_point" returntype="void" access="public" output="false"> 
		<cfargument name="latitude" type="numeric" required="true">
		<cfargument name="longitude" type="numeric" required="true">
		
		<cfset point_id = CreateUUID()>
		<cfquery name="add_point" datasource="#session.company.datasource#">
			INSERT INTO	parcel_points
							(id,
							parcel_id,
							latitude,
							longitude)
			VALUES			('#point_id#',
							'#this.id#',
							#latitude#,
							#longitude#)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="get_points" returntype="query" access="public" output="false">
		<cfquery name="q_get_points" datasource="#session.company.datasource#">
			SELECT * FROM parcel_points WHERE parcel_id='#this.id#'
		</cfquery>
		
		<cfreturn q_get_points>
	</cffunction>
	
	<cffunction name="associate" returntype="void" access="public" output="false">
		<cfargument name="element_table" type="string" required="true">
		<cfargument name="element_id" type="string" required="true">
	
		<cfset assoc_id = CreateUUID()>
		<cfquery name="assoc" datasource="#session.company.datasource#">
			INSERT INTO	parcel_associations
							(id,
							element_table,
							element_id,
							parcel_id)
			VALUES			('#assoc_id#',
							'#element_table#',
							'#element_id#',
							'#this.id#')
		</cfquery>
		
	</cffunction>

	<cffunction name="associated" returntype="boolean" access="public" output="false">
		<cfargument name="element_table" type="string" required="true">
		<cfargument name="element_id" type="string" required="true">
	
		<cfquery name="is_assoc" datasource="#session.company.datasource#">
			SELECT 	id FROM parcel_associations
			WHERE		parcel_id='#this.id#'
			AND			element_table='#element_table#'
			AND			element_id='#element_id#'
		</cfquery>
		
		<cfif is_assoc.recordcount EQ 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	<cffunction name="disassociate" returntype="void" access="public" output="false">
		<cfargument name="element_table" type="string" required="true">
		<cfargument name="element_id" type="string" required="true">
	
		<cfquery name="da" datasource="#session.company.datasource#">
			DELETE 	FROM parcel_associations
			WHERE		parcel_id='#this.id#'
			AND			element_table='#element_table#'
			AND			element_id='#element_id#'
		</cfquery>
	</cffunction>
	
	<cffunction name="documents" returntype="array" access="public" output="false">
		
		<cfquery name="gda" datasource="#session.company.datasource#">
			SELECT document_id FROM document_associations
			WHERE	element_table='parcels'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="gda">
			<cfset t = CreateObject("component", "ptarmigan.document").open(document_id)>
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
</cfcomponent>