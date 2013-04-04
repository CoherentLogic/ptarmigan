<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.layer_name = "">
	<cfset this.layer_table = "">
	<cfset this.layer_key_name = "">
	<cfset this.layer_key_abbreviation = "">
	<cfset this.layer_key_field = "">
	<cfset this.layer_color = "">
	<cfset this.layer_public = 1>
	<cfset this.layer_projection = "">
	<cfset this.layer_projection_name = "">
	<cfset this.layer_geom_field = "">
	
	<cfset this.written = false>
	
	<cffunction name="open" returntype="ptarmigan.gis.layer" output="false" access="public">
		<cfargument name="layer_id" type="string" required="true">
		
		<cfquery name="q_open" datasource="#session.company.datasource#">
			SELECT * FROM parcel_layers WHERE id='#layer_id#'
		</cfquery>
		
		<cfoutput query="q_open">
			<cfset this.id = id>
			<cfset this.layer_name = layer_name>		
			<cfset this.layer_table = layer_table>
			<cfset this.layer_key_name = layer_key_name>
			<cfset this.layer_key_abbreviation = layer_key_abbreviation>
			<cfset this.layer_key_field = layer_key_Field>
			<cfset this.layer_color = layer_color>
			<cfset this.layer_public = layer_public>
			<cfset this.layer_projection = layer_projection>
			<cfset this.layer_projection_name = layer_projection_name>
			<cfset this.layer_geom_field = layer_geom_field>
		</cfoutput>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="parcels_in_rect" returntype="struct" output="false" access="public">
		<cfargument name="nw_latitude" type="numeric" required="true">
		<cfargument name="nw_longitude" type="numeric" required="true">
		<cfargument name="se_latitude" type="numeric" required="true">
		<cfargument name="se_longitude" type="numeric" required="true">

		<cfset wgs84_geographic_srid = 4326>

		<cfquery name="q_parcels_in_rect" datasource="#session.company.datasource#">
			SELECT  #this.layer_key_field# AS pt_parcel_key,
					ST_AsText(ST_Transform(#this.layer_geom_field#, #wgs84_geographic_srid#)) AS pt_parcel_boundary
			FROM 	#this.layer_table# 
			WHERE 	ST_Within(ST_Transform(#this.layer_geom_field#, #wgs84_geographic_srid#), ST_GeomFromText('MULTIPOINT(#nw_latitude# #nw_longitude#, #se_latitude# #se_longitude#)'))	
		</cfquery>		

		<cfset parcels = ArrayNew(1)>
		
		<cfoutput query="q_parcels_in_rect">
			<cfset ts = StructNew()>
						
			<cfset ts.parcel_key = pt_parcel_key>
			<cfset ts.fill_color = this.layer_color>
					
			<cfset ts.polygons = ArrayNew(1)>
						
			<cfif len(pt_parcel_boundary) GT 0>
				<cfset tmpPoly = mid(pt_parcel_boundary, 10)>
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
						
			<cfset ArrayAppend(parcels, ts)>
		</cfoutput>
		
		<cfreturn ts>
	</cffunction>

</cfcomponent>