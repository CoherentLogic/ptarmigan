<cfmodule template="#session.root_url#/security/require.cfm" type="admin">

<cfset events = session.company.trashcan_events()>


<div style="width:100%;height:100%; overflow:auto;">
	<div style="width:100%; height:35px; padding-top:10px; padding-left:20px; border-bottom:1px solid gray; background-color:#efefef">
		<cfoutput>
			<a class="button" href="##" onclick="empty_trash('#session.root_url#');"><span>Empty Trash</span></a>
		</cfoutput>
	</div>
	<cfloop array="#events#" index="e">
		
		<cfset objs = e.objects>
		<table width="100%" class="pretty" style="margin-left:0;margin-right:0;margin-bottom:20px; margin-top:5px;">
		<tr>
			<th width="20%">Type</th>
			<th width="80%">Name</th>
		</tr>
		<cfloop array="#objs#" index="obj">
			<cfoutput>
			<tr>
				<td>#obj.class_name#</td>
				<td>#obj.get().object_name()#</td>
			</tr>	
			</cfoutput>
		</cfloop>
		</table>
		<p><a class="button" href="##" onclick="restore_trashcan_event('#session.root_url#', '#e.id#');"><span>Restore</span></a></p>
		
	</cfloop>
</div>