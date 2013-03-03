<cfoutput>
	<cfset obj = CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset ArrayAppend(session.basket, obj)>
</cfoutput>

<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#url.id#" addtoken="false">