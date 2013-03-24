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
					AsText(boundary) AS boundary_text
			FROM 	parcels 
			WHERE 	MBRWITHIN(center, GeomFromText('MULTIPOINT(#this.nw_latitude# #this.nw_longitude#, #this.se_latitude# #this.se_longitude#)'))	
		</cfquery>
					
		<cfset this.query_time = cfquery.ExecutionTime>
		
		<cfset this.parcels = ArrayNew(1)>
		<cfoutput query="get_parcels">
			<cfset ts = StructNew()>
			
			<cfset ts.id = id>
			<cfset ts.parcel_id = parcel_id>
					
			<cfset ts.polygons = ArrayNew(1)>
						
			<cfif len(boundary_text) GT 0>
				<cfset tmpPoly = mid(boundary_text, 10)>
				<cfset tmpPoly = left(tmpPoly, find(")", tmpPoly) - 1)>
				
				<cfset tmpArray = ListToArray(tmpPoly, ",")>
				
				
				<cfloop array="#tmpArray#" index="item">
					<cfset tmpStruct = StructNew()>
					<cfset tLng = val(trim(left(item, find(" ", item))))>
					<cfset tLat = val(trim(mid(item, find(" ", item))))>
					
					
					<cfset tmpStruct.latitude = tLat>
					<cfset tmpStruct.longitude = tLng>
					
					<cfset ArrayAppend(ts.polygons, tmpStruct)>				
				</cfloop>						
			</cfif>
			
			
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
