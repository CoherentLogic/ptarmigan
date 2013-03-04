<cfset object = CreateObject("component", "ptarmigan.object").open(attributes.id)>
<cfoutput>#object.get().search_result()#</cfoutput>