<cfquery name="g_parcels" datasource="#session.company.datasource#">
	SELECT id FROM parcels
</cfquery>

<cfoutput query="g_parcels">
	<cfmodule template="parcel_conversion_phase_2.cfm" parcel_id="#id#">
	
</cfoutput>

<cfoutput>Updated #g_parcels.recordcount# parcels</cfoutput>
