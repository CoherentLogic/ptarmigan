
<cfquery name="get_layers" datasource="#session.company.datasource#">
	SELECT * FROM parcel_layers
</cfquery>

<div style="width:100%;">
<table cellpadding="3">
	
	<cfoutput query="get_layers">
	<tr>		
		<td title="Show/hide layer"><input type="checkbox" title="Layer enabled" id="layer_enabled_#id#" checked="checked" onclick="layer_toggle('#id#');"></td>	
		<td title="Layer color"><div style="width:16px;height:16px;background-color:#layer_color#"></td>
		<td title="Layer name">#layer_name#</td>		
	</tr>	
	
	</cfoutput>
</table>
</div>