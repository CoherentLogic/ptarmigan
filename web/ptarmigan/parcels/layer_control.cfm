
<cfquery name="get_layers" datasource="#session.company.datasource#">
	SELECT * FROM parcel_layers
</cfquery>

<div style="width:320px;background-color:white;padding:5px;">
<table cellpadding="3">
	
	<cfoutput query="get_layers">
	<tr>		
		<td><input type="checkbox" title="Layer enabled" id="layer_enabled_#id#" checked="checked" onclick="layer_toggle('#id#');"></td>	
		<td>#layer_name#</td>		
	</tr>	
	
	</cfoutput>
</table>
</div>