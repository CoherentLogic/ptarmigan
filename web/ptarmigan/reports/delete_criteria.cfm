<cfmodule template="#session.root_url#/security/require.cfm" type="">

<cfset report = CreateObject("component", "ptarmigan.report").open(url.report_id)>

<cfif (session.user.id EQ report.employee_id) OR (session.user.is_admin() EQ true)>
	<cfquery name="q_dc" datasource="#session.company.datasource#">
		DELETE FROM report_criteria WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
	</cfquery>
</cfif>