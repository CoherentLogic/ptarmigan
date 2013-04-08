<cfcontent type="application/json">
<cfset layer = createobject("component", "ptarmigan.gis.layer").open(url.layer_id)>
<cfset gs = layer.parcels_in_rect_geojson(url.nw_latitude, url.nw_longitude, url.se_latitude, url.se_longitude)>
<cfoutput>#gs#</cfoutput>