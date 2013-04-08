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
			<cfset this.layer_enabled = layer_enabled_default>
		</cfoutput>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="features_in_rect" returntype="struct" output="false" access="public">
		<cfargument name="nw_latitude" type="numeric" required="true">
		<cfargument name="nw_longitude" type="numeric" required="true">
		<cfargument name="se_latitude" type="numeric" required="true">
		<cfargument name="se_longitude" type="numeric" required="true">

		<cfset wgs84_geographic_srid = 4326>

				
		

		<cfquery name="q_features_in_rect" datasource="#session.company.datasource#">		
			SELECT  #this.layer_key_field# AS pt_parcel_key,
					ST_AsText(ST_Transform(#this.layer_geom_field#, #wgs84_geographic_srid#)) AS pt_parcel_boundary,
					ST_AsGeoJSON(ST_Transform(#this.layer_geom_field#, #wgs84_geographic_srid#)) AS pt_geo_json	
			FROM 	#this.layer_table# 
			WHERE  ST_Transform(#this.layer_geom_field#, #wgs84_geographic_srid#) && ST_SetSRID('BOX3D(#nw_longitude# #nw_latitude#,#se_longitude# #se_latitude#)'::box3d, 4326);
		</cfquery>		
		
		<cfset pstr = StructNew()>
		<cfset pstr.layer_id = this.id>
		<cfset pstr.layer_name = this.layer_name>
		<cfset pstr.layer_key_name = this.layer_key_name>
		<cfset pstr.layer_key_abbreviation = this.layer_key_abbreviation>
		<cfset pstr.layer_projection = this.layer_projection>
		<cfset pstr.layer_projection_name = this.layer_projection_name>		
		<cfset pstr.parcels = ArrayNew(1)>
		
		
		
		<cfoutput query="q_features_in_rect">
			<cfset ts = StructNew()>

			<cfset ts.parcel_key = q_parcels_in_rect.pt_parcel_key>
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
						
			<cfset ArrayAppend(pstr.parcels, ts)>
		</cfoutput>
		
		<cfreturn pstr>
	</cffunction>
	
	<cffunction name="features_in_rect_geojson" returntype="string" access="public" output="false">
		<cfargument name="nw_latitude" type="numeric" required="true">
		<cfargument name="nw_longitude" type="numeric" required="true">
		<cfargument name="se_latitude" type="numeric" required="true">
		<cfargument name="se_longitude" type="numeric" required="true">

		<cfset wgs84_geographic_srid = 4326>
						
		<cfquery name="q_features_in_rect_geojson" datasource="#session.company.datasource#">	
			SELECT row_to_json(fc)::VARCHAR
			 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
			 FROM (SELECT 'Feature' As type
			    , ST_AsGeoJSON(ST_Transform(lg.#this.layer_geom_field#, #wgs84_geographic_srid#))::json As geometry
			    , row_to_json((SELECT l FROM (SELECT #this.layer_key_field# AS feature_id, '#this.id#' AS layer_id) As l
			      )) As properties
			   FROM #this.layer_table# As lg WHERE ST_Transform(lg.#this.layer_geom_field#, #wgs84_geographic_srid#) && ST_SetSRID('BOX3D(#nw_longitude# #nw_latitude#,#se_longitude# #se_latitude#)'::box3d, 4326)) As f)  As fc
		</cfquery>						
		
		<cfreturn q_features_in_rect_geojson.row_to_json>
	</cffunction>
	
	<cffunction name="feature" returntype="string" access="public" output="false">
		<cfargument name="feature_key" type="string" required="true">
		
		<cfquery name="q_feature" datasource="#session.company.datasource#">
			SELECT * FROM #this.layer_table#
			WHERE #this.layer_key_field#='#feature_key#'
		</cfquery>
		
		<cfset ts = structnew()>
		<cfset ts.aoColumns = arraynew(1)>
		<cfset ts.aoColumns[1] = structnew()>
		<cfset ts.aoColumns[1].sTitle = "Attribute">
		<cfset ts.aoColumns[2] = structnew()>
		<cfset ts.aoColumns[2].sTitle = "Value">
		
		<cfset column_array = arraynew(1)>
		<cfset column_array = ListToArray(q_feature.ColumnList)>
				
		<cfset arr_index = 1>
		
		<cfset ts.aaData = arraynew(1)>
		<cfloop array="#column_array#" index="col">
			<cfset tAttrib = this.attribute_mapping(col)>
			<cfset tValue = evaluate("q_feature.#col#")> 
			
			
			<cfif tAttrib NEQ "">
			<cfset ts.aaData[arr_index] = arraynew(1)>
			<cfset ts.aaData[arr_index][1] = tAttrib>
			<cfset ts.aaData[arr_index][2] = tValue>
			<cfset arr_index = arr_index + 1>
			</cfif>
			
			
		</cfloop>
	
		<cfreturn serializejson(ts)>
	</cffunction>
	
	<cffunction name="attribute_mapping" returntype="string" access="public" output="false">
		<cfargument name="attribute_key" type="string" required="true">
		
		<cfquery name="q_amap" datasource="#session.company.datasource#">
			SELECT attribute_name FROM parcel_layer_mappings WHERE source_layer_id='#this.id#' AND source_attribute='#lcase(attribute_key)#'
		</cfquery>
		
		<cfreturn q_amap.attribute_name>
	</cffunction>

</cfcomponent>