<cfcontent type="application/json">

<cfset a = CreateObject("component", "ptarmigan.parcels.area")>
<cfset a.nw_latitude = url.nw_latitude>
<cfset a.nw_longitude = url.nw_longitude>
<cfset a.se_latitude = url.se_latitude>
<cfset a.se_longitude = url.se_longitude>

<cfset a.create()>
<cfoutput>#a.get_json()#</cfoutput>
