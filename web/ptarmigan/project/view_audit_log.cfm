
<cfquery name="get_audit_logs" datasource="#session.company.datasource#">
	SELECT id FROM audits WHERE table_name='#url.table_name#' AND table_id='#url.table_id#' 
	ORDER BY audit_date DESC
</cfquery>

<cfset oa = ArrayNew(1)>
<cfoutput query="get_audit_logs">
	<cfset t = CreateObject("component", "ptarmigan.audit").open(get_audit_logs.id)>
	<cfset ArrayAppend(oa, t)>
</cfoutput>

<div style="margin:20px; height:370px; overflow:auto; border:1px solid gray; ">
<table class="pretty" width="100%" style="margin:0px;">
	<tr>
		<th>DATE</th>
		<th>EMPLOYEE</th>
		<th>CHANGE ORDER #</th>
		
	</tr>
	<cfloop array="#oa#" index="audit">
		<cfset e = CreateObject("component", "ptarmigan.employee").open(audit.employee_id)>		
			<cfoutput>
			<tr>
				<td>#dateFormat(audit.audit_date, "mm/dd/yyyy")# #timeFormat(audit.audit_date, "h:mm tt")#</td>
				<td>#e.full_name()#</td>
				<td>#audit.change_order_number#</td>
			</tr>
			<tr>				
				<td colspan="3">
					#audit.what_changed#<br><hr>
					#audit.comment#
				</td>			
			</tr>
			</cfoutput>		
	</cfloop>
</table>	
</div>
<div style="padding:20px;">
	<input type="button" onclick="window.location.reload();" value="Close">
</div>