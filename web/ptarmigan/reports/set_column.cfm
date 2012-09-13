<cfset rep = CreateObject("component", "ptarmigan.report").open(url.report_id)>

<cfif url.included EQ 1>
	<cfset rep.include_column(url.member_name)>
<cfelse>
	<cfset rep.exclude_column(url.member_name)>
</cfif>
