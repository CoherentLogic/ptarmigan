<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfquery name="update_filter" datasource="#session.company.datasource#">
	UPDATE report_criteria
	SET		member_name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#url.member_name#">,
			operator=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="8" value="#url.operator#">,
			literal_a=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#url.literal_a#">
	WHERE	id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#url.id#">
</cfquery>

