<cfcomponent output="true">

	<cfset this.nw_latitude = 0>
	<cfset this.nw_longitude = 0>
	<cfset this.se_latitude = 0>
	<cfset this.se_longitude = 0>
	
	<cfset this.query_time = 0>
	
	<cfset this.parcels = ArrayNew(1)>
	
	<cffunction name="create" returntype="parcels.area" access="public" output="false">
		
		
		
		<cfquery name="get_parcels" datasource="#session.company.datasource#" >
			SELECT 	id,
					parcel_id,
					area_sq_ft,
					area_sq_yd,
					area_acres,
					account_number,
					mailing_address,
					mailing_city,
					mailing_state,
					mailing_zip,
					subdivision,
					lot,
					block,
					physical_address,
					physical_city,
					physical_state,
					physical_zip,
					assessed_land_value,
					assessed_building_value,
					`section`,
					township,
					`range`,
					reception_number,
					owner_name,
					metes_and_bounds,
					ground_survey,
					center_latitude,
					center_longitude,
					AsText(boundary) AS boundary_text
			FROM 	parcels 
			WHERE 	MBRWITHIN(center, GeomFromText('MULTIPOINT(#this.nw_latitude# #this.nw_longitude#, #this.se_latitude# #this.se_longitude#)'))	
		</cfquery>
					
		<cfset this.query_time = cfquery.ExecutionTime>
		
		<cfset this.parcels = ArrayNew(1)>
		<cfoutput query="get_parcels">
			<cfset ts = StructNew()>
			
			<cfset ts.subdivision = subdivision>
			<cfset ts.township = township>
			<cfset ts.owner_name = owner_name>
			<cfset ts.range = range>
			<cfset ts.mailing_zip = mailing_zip>		
			<cfset ts.center_latitude = center_latitude>
			<cfset ts.block = block>
			<cfset ts.area_acres = area_acres>
			<cfset ts.physical_zip = physical_zip>
			<cfset ts.assessed_building_value = assessed_building_value>
			<cfset ts.id = id>
			<cfset ts.physical_city = physical_city>
			<cfset ts.ground_survey = ground_survey>
			<cfset ts.area_sq_yd = area_sq_yd>
			<cfset ts.mailing_state = mailing_state>
			<cfset ts.physical_address = physical_address>
			<cfset ts.assessed_land_value = assessed_land_value>	
			<cfset ts.center_longitude = center_longitude>
			<cfset ts.physical_state = physical_state>
			<cfset ts.parcel_id = parcel_id>
			<cfset ts.account_number = account_number>
			<cfset ts.mailing_address = mailing_address>
			<cfset ts.section = section>
			<cfset ts.reception_number = reception_number>
			<cfset ts.lot = lot>
			<cfset ts.mailing_city = mailing_city>
			<cfset ts.metes_and_bounds = metes_and_bounds>
			<cfset ts.area_sq_ft = area_sq_ft>
					
			<cfset ts.polygons = ArrayNew(1)>
			
			<cfset tmpPoly = mid(boundary_text, 10)>
			<cfset tmpPoly = left(tmpPoly, len(tmpPoly) - 2)>
			
			<cfset tmpArray = ListToArray(tmpPoly, ",")>
			<cfset tmpStruct = StructNew(1)>
			
			<cfloop array="#tmpArray#" index="item">
				<cfset tLat = left(item, find(" ", item) - 1)>
				<cfset tLng = mid(item, find(" "), item) + 1>
				
				
				<cfset tmpStruct.latitude = tLat>
				<cfset tmpStruct.longitude = tLng>
				
				<cfset ArrayAppend(ts.polygons, tt)>				
			</cfloop>						
			
			
			<cfset ArrayAppend(this.parcels, ts)>
		</cfoutput>
		
		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_json" returntype="void" access="public" output="true">		
		<cfoutput>#serializeJSON(this)#</cfoutput>
	</cffunction>

</cfcomponent>

		<!--->	SELECT ((ACOS(SIN(#this.center_latitude# * PI() / 180) * SIN(`center_latitude` * PI() / 180) + COS(#this.center_latitude# * PI() / 180) * COS(`center_latitude` * PI() / 180) * COS((#this.center_longitude# - `center_longitude`) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS distance,
	            parcels.id 		AS parcel_id
	            FROM			parcels              
			WHERE			parcels.center_latitude!=0
			AND				parcels.center_longitude!=0
	            HAVING             distance<=#this.radius# 			
	            ORDER BY    		distance 
	            ASC--->
