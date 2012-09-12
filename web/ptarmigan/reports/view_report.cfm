<cfset report = CreateObject("component", "ptarmigan.report").open(url.id)>
<cfset c = CreateObject("component", "ptarmigan.collection")>
<cfset c.class_id = report.class_id>
<cfset c.filters = report.get_criteria_string()>

<cfset report_data = c.get()>
<cfset cols = report.get_columns()>

<table class="report_viewer">
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
			<cfoutput><td>#row.get().object_name()#</td></cfoutput>
			<cfloop array="#cols#" index="col">
				<cfoutput>
				<td>#row.member_value(col)#</td>
				</cfoutput>
			</cfloop>
			</tr>
		</cfloop>
	</tbody>
</table>
