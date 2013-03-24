<cfquery name="g_points" datasource="#session.company.datasource#">
	SELECT latitude AS y, longitude AS x, parcel_id  FROM parcel_points WHERE parcel_id='#attributes.parcel_id#'
</cfquery>

<cfif g_points.recordcount GT 0>
	<cfset poly_pairs = ArrayNew(1)>
	
	<cfoutput query="g_points">
		<cfset ArrayAppend(poly_pairs, x & " " & y)>
	</cfoutput>
	
	
	<cfset wkt = "POLYGON((">
	
	<cfloop array="#poly_pairs#" index="onepair">
		<cfset wkt = wkt & onepair & ",">
	</cfloop>
	
	<cfset wkt = left(wkt, len(wkt) - 1) & "))">
	
	<cfmodule template="parcel_conversion_phase_3.cfm" parcel_id="#attributes.parcel_id#" wkt="#wkt#">
</cfif>