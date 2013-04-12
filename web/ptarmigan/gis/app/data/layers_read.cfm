<cfcontent type="application/json">
<cfsilent><cfset layers_json = createobject("component", "ptarmigan.gis.core").layers_json()></cfsilent>
<cfoutput>#layers_json#</cfoutput>