<cfcontent type="application/json">
<cfsilent>
<cfquery name="rk" datasource="#session.company.datasource#">
	SELECT report_key FROM reports 
	WHERE report_key!=''
	AND (system_report=1 OR employee_id='#session.user.id#')
	ORDER BY report_key 	
</cfquery>
<cfset oa = ArrayNew(1)>
<cfoutput query="rk">
	<cfset ArrayAppend(oa, rk.report_key)>
</cfoutput>
</cfsilent>
<cfoutput>#SerializeJSON(oa)#</cfoutput>
