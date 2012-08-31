<cfset p = CreateObject("component", "ptarmigan.parcel")>

<cfset p.parcel_id = form.parcel_id>
<cfset p.area_sq_ft = form.area_sq_ft>
<cfset p.area_sq_yd = form.area_sq_yd>
<cfset p.area_acres = form.area_acres>
<cfset p.owner_name = form.owner_name>
<cfset p.account_number = form.account_number>
<cfset p.mailing_address = form.mailing_address>
<cfset p.mailing_city = form.mailing_city>
<cfset p.mailing_state = form.mailing_state>
<cfset p.mailing_zip = form.mailing_zip>
<cfset p.physical_address = form.physical_address>
<cfset p.physical_city = form.physical_city>
<cfset p.physical_state = form.physical_state>
<cfset p.physical_zip = form.physical_zip>
<cfset p.subdivision = form.subdivision>
<cfset p.lot = form.lot>
<cfset p.block = form.block>
<cfset p.assessed_land_value = form.assessed_land_value>
<cfset p.assessed_building_value = form.assessed_building_value>
<cfset p.section = form.section>
<cfset p.township = form.township & form.township_direction>
<cfset p.range = form.range & form.range_direction>
<cfset p.reception_number = form.reception_number>
<cfset p.ground_survey = form.ground_survey>
<cfset p.metes_and_bounds = form.metes_and_bounds>
<cfset p.center_latitude = form.center_latitude>
<cfset p.center_longitude = form.center_longitude>

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