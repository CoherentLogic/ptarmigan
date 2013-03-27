<cfquery name="g_parcels" datasource="#session.company.datasource#">
	SELECT center_latitude, center_longitude, id FROM parcels
</cfquery>

<cfoutput query="g_parcels">
	<cfmodule template="center_from_center_latlng_2.cfm" center_latitude="#center_latitude#" center_longitude="#center_longitude#" id="#id#">
</cfoutput>