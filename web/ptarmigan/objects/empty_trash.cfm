<cfmodule template="#session.root_url#/security/require.cfm" type="admin">

<cfset te = CreateObject("component", "ptarmigan.trashcan_event").open(url.id)>

<cfloop array="#te.objects#" index="obj">
	<cfset obj.delete()>
</cfloop>

<cfset session.message = "Trash can emptied.">