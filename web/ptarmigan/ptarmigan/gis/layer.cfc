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
	<cfset this.layer_enabled = true>
	<cfset this.layer_extents = "">
	<cfset this.layer_boundary = "">
	<cfset this.success = true>
	
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
		
		<cfquery name="q_layer_geometry" datasource="#session.company.datasource#">
			SELECT ST_AsText(ST_extent(ST_Transform(#this.layer_geom_field#, 4326))) AS layer_boundary,
				   st_astext(st_makepoint(st_xmin(st_extent(ST_Transform(#this.layer_geom_field#, 4326))), st_ymin(st_extent(ST_Transform(#this.layer_geom_field#, 4326))))) AS southwest_extent,
				   st_astext(st_makepoint(st_xmax(st_extent(ST_Transform(#this.layer_geom_field#, 4326))), st_ymax(st_extent(ST_Transform(#this.layer_geom_field#, 4326))))) AS northeast_extent
				   		   
			FROM	#this.layer_table#			
		</cfquery>
		
		<cfset this.layer_boundary = q_layer_geometry.layer_boundary>
		<cfset this.layer_southwest_extent = mid(q_layer_geometry.southwest_extent, 7, len(q_layer_geometry.southwest_extent) - 7)>
		<cfset this.layer_northeast_extent = mid(q_layer_geometry.northeast_extent, 7, len(q_layer_geometry.northeast_extent) - 7)>
		
		<cfset this.southwest_coordinates = listtoarray(this.layer_southwest_extent, " ")>
		<cfset this.northeast_coordinates = listtoarray(this.layer_northeast_extent, " ")>
		
		
		
		
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
			WHERE  ST_Transform(#this.layer_geom_field#, #wgs84_geographic_srid#) && ST_SetSRID('BOX3D(#nw_longitude# #nw_latitude#,#se_longitude# #se_latitude#)'::box3d, #wgs84_geographic_srid#);
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
		
		<cfquery name="q_feature_attributes" datasource="#session.company.datasource#">
			SELECT * FROM #this.layer_table#
			WHERE #this.layer_key_field#='#feature_key#'
		</cfquery>
		
		<cfquery name="q_derived_attributes" datasource="#session.company.datasource#">
			SELECT ST_AsText(ST_Transform(ST_Centroid(#this.layer_geom_field#), 4326)) AS feature_centroid,
				   ST_Area(ST_Transform(#this.layer_geom_field#, 4326)) AS feature_area
			FROM   #this.layer_table#
			WHERE  #this.layer_key_field#='#feature_key#'				 				   
		</cfquery>
		
		
				
		<cfset column_array = arraynew(1)>
		<cfset column_array = ListToArray(q_feature_attributes.ColumnList)>
				
		<cfset arr_index = 1>
		
		<cfset ts = structnew()>
		<cfset ts.layer_id = this.id>
		<cfset ts.layer_name = this.layer_name>
		<cfset ts.layer_table = this.layer_table>
		<cfset ts.layer_key_name = this.layer_key_name>
		<cfset ts.layer_key_field = this.layer_key_field>
		<cfset ts.layer_color = this.layer_color>
		<cfset ts.layer_public = this.layer_public>
		<cfset ts.layer_projection = this.layer_projection>
		<cfset ts.layer_projection_name = this.layer_projection_name>
		<cfset ts.layer_enabled = this.layer_enabled>
		<cfset ts.layer_geom_field = this.layer_geom_field>
				
		<cfset ts.feature_attributes = arraynew(1)>
		<cfloop array="#column_array#" index="col">
			<cfset tAttrib = this.attribute_mapping(col)>
			<cfset tType = this.attribute_type(col)>
			<cfset tValue = evaluate("q_feature_attributes.#col#")> 
			<cfset tCol = col>
			
			
			<cfif tAttrib NEQ "">
				<cfset ts.feature_attributes[arr_index] = structnew()>
				<cfset ts.feature_attributes[arr_index].attribute = tAttrib>
				<cfset ts.feature_attributes[arr_index].value = tValue>
				<cfset ts.feature_attributes[arr_index].column_name = tCol>
				<cfset ts.feature_attributes[arr_index].attribute_type = tType>
				<cfset ts.feature_attributes[arr_index].derived = false>
				<cfset arr_index = arr_index + 1>
			</cfif>						
		</cfloop>
		
		<cfset ts.feature_attributes[arr_index] = structnew()>
		<cfset ts.feature_attributes[arr_index].attribute = "Area">
		<cfset ts.feature_attributes[arr_index].value = q_derived_attributes.feature_area>
		<cfset ts.feature_attributes[arr_index].column_name = "derived_attributes_area">
		<cfset ts.feature_attributes[arr_index].derived = true>
		<cfset arr_index = arr_index + 1>
		<cfset ts.feature_attributes[arr_index] = structnew()>
		<cfset ts.feature_attributes[arr_index].attribute = "Centroid">
		<cfset ts.feature_attributes[arr_index].value = q_derived_attributes.feature_centroid>
		<cfset ts.feature_attributes[arr_index].column_name = "derived_attributes_centroid">
		<cfset ts.feature_attributes[arr_index].derived = true>
		
	
		<cfreturn serializejson(ts)>
	</cffunction>
	
	<cffunction name="attribute_mapping" returntype="string" access="public" output="false">
		<cfargument name="attribute_key" type="string" required="true">
		
		<cfquery name="q_amap" datasource="#session.company.datasource#">
			SELECT attribute_name FROM parcel_layer_mappings WHERE source_layer_id='#this.id#' AND source_attribute='#lcase(attribute_key)#'
		</cfquery>
		
		<cfreturn q_amap.attribute_name>
	</cffunction>
	
	<cffunction name="attribute_type" returntype="string" access="public" output="false">
		<cfargument name="attribute_key" type="string" required="true">
		
		<cfquery name="q_at" datasource="#session.company.datasource#">
			SELECT data_type::VARCHAR AS d_type
			FROM information_schema.columns
			WHERE table_name='#this.layer_table#'
			AND column_name='#lcase(attribute_key)#'
		</cfquery>
		
		<cfreturn q_at.d_type>
	</cffunction>

	<cffunction name="mappings_json" returntype="string" access="public" output="false">
		<cfquery name="q_mappings_json" datasource="#session.company.datasource#">
			SELECT * FROM parcel_layer_mappings WHERE source_layer_id='#this.id#'
		</cfquery>
		
		<cfset oa = arraynew(1)>

		<cfoutput query="q_mappings_json">
			<cfset ts = structnew()>
			<cfset ts.source_layer_id = source_layer_id>
			<cfset ts.source_attribute = source_attribute>
			<cfset ts.attribute_name = attribute_name>
			<cfset ts.column_type = this.attribute_type(source_attribute)>
			<cfset ts.operator = "BEGINS WITH">
			<cfset ts.value = "">
			<cfset ts.use_in_search = false>
			<cfset ts.id = id>
			<cfset arrayappend(oa, ts)>
		</cfoutput>
		
		<cfreturn serializejson(oa)>
	</cffunction>
	
	<cffunction name="feature_search" returntype="string" access="public" output="false">
		<cfargument name="s" type="struct" required="true">
		
		<cfset qual = " WHERE ">
		
		<cfsavecontent variable="sql_query">
			<cfoutput>
				SELECT #this.layer_key_field# AS feature_key,
						ST_AsText(ST_Centroid(ST_Transform(#this.layer_geom_field#, 4326))) AS result_centroid
				FROM #this.layer_table#
			</cfoutput>
		</cfsavecontent>

		
		<cfloop array="#s.columns#" index="col">
			<cfswitch expression="#col.operator#">
				<cfcase value="BEGINS WITH">
					<cfset t_op = " LIKE ">
					<cfset t_open_value = "%">
					<cfset t_close_value = "">
				</cfcase>
				<cfcase value="CONTAINS">
					<cfset t_op = " LIKE ">
					<cfset t_open_value = "%">
					<cfset t_close_value = "%">
				</cfcase>
				<cfcase value="IS EQUAL TO">
					<cfset t_op = "=">
					<cfset t_open_value = "">
					<cfset t_close_value = "">
				</cfcase>
			</cfswitch>
			<cfif col.column_type EQ "character varying">
				<cfset quot = "'">
			<cfelse>
				<cfset quot = "">
			</cfif>
			<cfset sql_query = sql_query & qual & col.src_attribute & t_op & quot & t_open_value & col.search_value & t_close_value & quot>
		    
			<cfswitch expression="#s.search_type#">
				<cfcase value="any">
					<cfset qual = " OR ">
				</cfcase>
				<cfcase value="all">
					<cfset qual = " AND ">
				</cfcase>
			</cfswitch>
		</cfloop>
		
		<cfset sql_query = REReplace(sql_query,"''","'","ALL")>
		
		<cfquery name="q_feature_search" datasource="#session.company.datasource#">
			#preservesinglequotes(sql_query)#
		</cfquery>
		
		<cfset oa = arraynew(1)>
		
		<cfoutput query="q_feature_search">
			<cfset ts = structnew()>
			<cfset ts.feature_id = feature_key>
			<cfset tmp = mid(result_centroid, 7, len(result_centroid) - 7)>
			<cfset tmp_coords = listtoarray(tmp, " ")>		
			<cfset ts.center_longitude = tmp_coords[1]>
			<cfset ts.center_latitude = tmp_coords[2]>
			<cfset arrayappend(oa, ts)>
		</cfoutput>
		
		<cfreturn #serializejson(oa)#>
	</cffunction>

</cfcomponent>