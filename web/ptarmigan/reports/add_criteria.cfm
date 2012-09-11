<cfset report = CreateObject("component", "ptarmigan.report").open(url.id)>

<cfset report.add_criteria(report.id, form.member_name, form.operator, form.literal_a, form.literal_b)>

<!---
<cffunction name="add_criteria" returntype="string" access="public" output="false">
		<cfargument name="report_id" type="string" required="true">
		<cfargument name="member_name" type="string" required="true">
		<cfargument name="operator" type="string" required="true">
		<cfargument name="literal_a" type="string" required="true">
		<cfargument name="literal_b" type="string" required="true">
--->

<script>
	<cfoutput>parent.refresh_filters('#session.root_url#', '#url.id#');</cfoutput>
</script>

<!---><cflocation url="#session.root_url#/reports/criteria.cfm?mode=add&id=#report.id#" addtoken="no">--->