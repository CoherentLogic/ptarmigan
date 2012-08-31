<cfcontent type="application/json">

<cfset a = CreateObject("component", "ptarmigan.parcels.area")>
<cfset a.center_latitude = url.center_latitude>
<cfset a.center_longitude = url.center_longitude>
<cfset a.radius = url.radius>

<cfset a.create()>
<cfoutput>#a.get_json()#</cfoutput>
