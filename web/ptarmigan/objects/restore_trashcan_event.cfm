<cfmodule template="#session.root_url#/security/require.cfm" type="admin">

<cfset te = CreateObject("component", "ptarmigan.trashcan_event").open(url.id)>

<cfloop array="#te.objects#" index="obj">
	<cfset obj.unmark_deleted()>
</cfloop>

<cfset session.message = "Items restored from trash can.">