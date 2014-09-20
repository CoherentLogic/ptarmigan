<cfset row_id = CreateUUID()>
<cfquery name="set_area" datasource="#session.company.datasource#">
	INSERT INTO temp_shapes 
				(id, 
				session_id,
				geom)
	VALUES		('#row_id#',
				'#session.cfid#',
				ST_SetSRID(ST_GeomFromText('#url.wkt#'), 4326))
</cfquery>
<cfif url.shape_type EQ "polygon">
	<cfquery name="get_area" datasource="#session.company.datasource#">
		SELECT 	ST_Area(ST_SetSRID(geom, 4326)::geography) AS pt_area
		FROM   	temp_shapes
		WHERE	id='#row_id#'
	</cfquery>
	<cfoutput>#get_area.pt_area#</cfoutput>
<cfelse>
	<cfquery name="get_distance" datasource="#session.company.datasource#">
		SELECT 	ST_Length(ST_SetSRID(geom, 4326)::geography) AS pt_length
		FROM 	temp_shapes
		WHERE	id='#row_id#'
	</cfquery>
	<cfoutput>#get_distance.pt_length#</cfoutput>
</cfif>
<cfquery name="delete_temp_shape" datasource="#session.company.datasource#">
	DELETE FROM temp_shapes WHERE id='#row_id#'
</cfquery>