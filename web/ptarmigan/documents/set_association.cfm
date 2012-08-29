<!---function associate_file(root_url, ctl_id, document_id, element_table, element_id)--->

<cfset document = CreateObject("component", "ptarmigan.document").open(url.document_id)>

<cfif url.assoc EQ 1>
	<cfset document.associate(url.element_table, url.element_id)>
<cfelse>
	<cfset document.disassociate(url.element_table, url.element_id)>
</cfif>