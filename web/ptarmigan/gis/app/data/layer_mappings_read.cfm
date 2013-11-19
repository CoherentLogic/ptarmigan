<cfcontent type="application/json">
<cfset layer = createobject("component", "ptarmigan.gis.layer").open(url.layer_id)>
<cfoutput>#layer.mappings_json()#</cfoutput>