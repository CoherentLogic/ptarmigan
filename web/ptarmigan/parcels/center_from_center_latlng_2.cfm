<cfquery name="u_parcels" datasource="#session.company.datasource#">
	UPDATE parcels
	SET center=GeomFromText('POINT(#attributes.center_latitude# #attributes.center_longitude#)')
	WHERE id='#attributes.id#'
</cfquery>