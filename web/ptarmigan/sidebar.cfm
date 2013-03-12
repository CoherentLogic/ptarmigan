<cfif isdefined("url.id")>
	<cftry>
		<cfset current_object = CreateObject("component", "ptarmigan.object").open(url.id)>
		<cfif current_object.id EQ url.id>
			<cfset object_loaded = true>
		<cfelse>
			<cfset object_loaded = false>
		</cfif>
		<cfcatch type="any">
			<cfset object_loaded = false>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset object_loaded = false>
</cfif>
<cfmodule template="#session.root_url#/objects/recent_objects.cfm">
<cfinclude template="#session.root_url#/objects/item_basket.cfm">