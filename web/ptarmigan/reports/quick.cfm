<cfquery name="g_repid" datasource="#session.company.datasource#">
	SELECT id FROM reports WHERE report_key=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.key#">
</cfquery>
<cfset rep_id = g_repid.id>
<cfset report = CreateObject("component", "ptarmigan.report").open(rep_id)>
<cfset c = CreateObject("component", "ptarmigan.collection")>
<cfset c.class_id = report.class_id>
<cfset c.filters = report.get_criteria_string()>

<cfset report_data = c.get()>
<cfset cols = report.get_columns()>


<table class="quick_report_viewer">
	<thead>
		<tr>
			<th>Name</th>
			<cfif ArrayLen(report_data) GT 0>
			<cfloop array="#cols#" index="col">
				<cfoutput>
					<th>#report_data[1].member_label(col)#</th>
				</cfoutput>
			</cfloop>
			</cfif>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#report_data#" index="row">
			<tr>
			<cfoutput><td><a href="#row.opener#">#row.get().object_name()#</a></td></cfoutput>
			<cfloop array="#cols#" index="col">
				<cfoutput>
				<td>#row.member_value(col)#</td>
				</cfoutput>
			</cfloop>
			</tr>
		</cfloop>
	</tbody>
</table>
