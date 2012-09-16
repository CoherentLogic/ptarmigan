<div style="height:100%;position:relative;">
	<cfquery name="get_providers" datasource="#session.framework.BaseDatasource#">
		SELECT id, carrier FROM mobile_providers ORDER BY carrier
	</cfquery>
	
	<cfmodule template="/orms/dialog_header.cfm" icon="/graphics/navicons/mobile_device.png" caption="Create Mobile Device">
	
	<div style="padding-left:30px; margin-top:10px; font-size:14px;" id="mobile_device_form">
	
	<form name="create_mobile_device" id="create_mobile_device">
	
	<table width="100%" cellpadding="10" cellspacing="0" class="orms_dialog">
	<tr>
		<td align="right" width="30%"><strong>Device Name</strong></td>
		<td align="left" width="70%"><input type="text" name="device_name" id="device_name" /></td>	
	</tr>
	<tr>
		<td align="right" width="30%"><strong>Phone Number</strong></td>
		<td align="left" width="70%"><input type="text" name="phone_number" id="phone_number" /></td>
	</tr>
    <tr>
		<td align="right" width="30%"><strong>Provider</strong></td>
		<td align="left" width="70%">
        	<select name="carrier" id="carrier" size="1">
            	<cfoutput query="get_providers">
                	<option value="#id#">#carrier#</option>                    
                </cfoutput>
			</select>                
        </td>
	</tr>
    
    
	</table>
	</form>
	
	</div>
	
	<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
		<div style="padding:8px; float:right;" id="create_mobile_device_buttons" >
			<a class="button" href="##" onclick="CloseORMSDialog();"><span>Cancel</span></a>
			<a class="button" href="##" onclick="CreateMobileDevice();"><span><strong>Create Device</strong></span></a>
			
		</div>
	</div>
</div>
