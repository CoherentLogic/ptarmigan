<cfset requestBody = toString(getHttpRequestData().content)>
<cfset search_obj = deserializejson(requestBody)>
<cfset layer = createobject("component", "ptarmigan.gis.layer").open(search_obj.layer_id)>
<cfset result = layer.feature_search(search_obj)>
<cfoutput>#result#</cfoutput>