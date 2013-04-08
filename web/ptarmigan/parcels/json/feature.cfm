<cfcontent type="application/json">
<cfset layer = createobject("component", "ptarmigan.gis.layer").open(url.layer_id)>
<cfset feature_data = layer.feature(url.feature_id)>
<cfoutput>#feature_data#</cfoutput>