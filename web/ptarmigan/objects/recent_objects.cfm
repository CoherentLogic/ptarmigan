<cfquery name="get_recent_objects" datasource="#session.company.datasource#">
	SELECT DISTINCT object_id FROM object_access WHERE user_id='#session.user.id#' ORDER BY access_date DESC
</cfquery>

<div style="padding:5px;">
	<strong>Recent Items</strong><br />
	<hr>
<table width="100%" cellpadding="0" cellspacing="20">

	<tbody>
		<cfoutput query="get_recent_objects">
			
			<cftry>
			<cfset obj = CreateObject("component", "ptarmigan.object").open(object_id)>
			<cfset objname = #obj.get().object_name()#>
			<tr>
			
				<td width="20%">
					<span style="display:inline-block;text-align:center;background-color:##367aa5;border-radius:2px;padding:2px; width:40px; color:white;font-weight:bold;">
					#obj.access_count()#
					</span>
				</td>
				<td style="color:##367aa5; font-weight:bold;"><a href="#session.root_url#/objects/dispatch.cfm?id=#object_id#">#obj.get().object_name()#</a></td>
			</tr>
			<cfcatch>
			
			</cfcatch>
			
			</cftry>
				
		</cfoutput>
	</tbody>
</table>
</div>