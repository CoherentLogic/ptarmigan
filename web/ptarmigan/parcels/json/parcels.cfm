<cfcontent type="application/json"><cfsilent>
<cfset a = CreateObject("component", "parcels.area")>
<cfset a.nw_latitude = url.nw_latitude>
<cfset a.nw_longitude = url.nw_longitude>
<cfset a.se_latitude = url.se_latitude>
<cfset a.se_longitude = url.se_longitude>
<cfset a.create()>
</cfsilent><cfoutput>#a.get_json()#</cfoutput>
