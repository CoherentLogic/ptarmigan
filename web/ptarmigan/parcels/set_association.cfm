<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(url.parcel_id)>

<cfif url.assoc EQ 1>
	<cfset parcel.associate(url.element_table, url.element_id)>
<cfelse>
	<cfset parcel.disassociate(url.element_table, url.element_id)>
</cfif>