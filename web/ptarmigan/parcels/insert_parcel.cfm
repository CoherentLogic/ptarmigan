<cfset p = CreateObject("component", "ptarmigan.parcel")>

<cfset p.parcel_id = form.parcel_id>
<cfset p.area_sq_ft = form.area_sq_ft>
<cfset p.area_sq_yd = form.area_sq_yd>
<cfset p.area_acres = form.area_acres>



<cfset p.create()>

<cfset points_array = ListToArray(form.points)>

<cfloop array="#points_array#" index="pts">
	<cfset lat = left(pts, find(":", pts) - 1)>
	<cfset lon = mid(pts, find(":", pts) + 1, len(pts))>
	
	<cfoutput>
		Latitude: '#lat#' Longitude: '#lon#'<br>
	</cfoutput>
	<cfset p.add_point(lat, lon)>
</cfloop>

<cflocation url="manage_parcel.cfm?id=#p.id#">