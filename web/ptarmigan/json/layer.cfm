<cfcontent type="application/json">
<cfset layer = createobject("component", "ptarmigan.gis.layer").open(url.layer_id)>
<cfset parcels_struct = layer.parcels_in_rect(url.nw_latitude, url.nw_longitude, url.se_latitude, url.se_longitude)>
<cfoutput>#serializejson(parcels_struct)#</cfoutput>