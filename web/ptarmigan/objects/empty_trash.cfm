<cfmodule template="#session.root_url#/security/require.cfm" type="admin">

<cfset events = session.company.trashcan_events()>

<cfloop array="#events#" index="e">
	<cfset te = CreateObject("component", "ptarmigan.trashcan_event").open(e.trashcan_handle)>

	<cfloop array="#te.objects#" index="obj">
		<cfset obj.delete()>
	</cfloop>
</cfloop>

<cfset session.message = "Trash can emptied.">