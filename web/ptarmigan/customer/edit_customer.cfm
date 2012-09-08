<cfmodule template="../security/require.cfm" type="admin">

<cfset t = CreateObject("component", "ptarmigan.customer")>

<cfif IsDefined("form.self_post")>		
	<cfset t.company_name = UCase(form.company_name)>
	<cfset t.poc = UCase(form.poc)>
	<cfset t.email = form.email>
	<cfif IsDefined("form.electronic_billing")>
		<cfset t.electronic_billing = 1>
	<cfelse>
		<cfset t.electronic_billing = 0>
	</cfif>
	<cfset t.phone_number = form.phone_number>
	
	<cfset t.update()>
	

	
	<cflocation url="#session.root_url#/dashboard.cfm">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
	<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Edit Customer" icon="#session.root_url#/images/project_dialog.png">
	<div style="padding:20px;">
	<cfform name="new_customer" id="new_customer" action="#session.root_url#/customer/add_customer.cfm" method="post" onsubmit="window.location.reload();">
	<cfoutput>
	<table width="100%">
		<tr>
			<td>Customer Name:</td>
			<td>
				<input type="text" name="company_name" value="#t.company_name#"><br>
				<label><input type="checkbox" name="electronic_billing" <cfif t.electronic_billing EQ 1>selected="selected"</cfif>>Electronic billing</label>
			</td>
		</tr>
		<tr>
			<td>Point of contact:</td>
			<td><input type="text" name="poc" value="#t.poc#"></td>
		</tr>
		<tr>
			<td>E-mail:</td>
			<td><input type="text" name="email" value="#t.email#"></td>
		</tr>
		<tr>
			<td>Phone number:</td>
			<td><input type="text" maxlength="50" name="phone_number" value="#t.phone_number#"></td>
		</tr>
		
	</table>
	</cfoutput>	
	<input type="hidden" name="self_post" id="self_post" value="">		
	</cfform>
	</div>
	<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
    	<div style="padding:8px; float:right;">
        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>
			<a class="button" href="##" onclick="form_submit('new_customer');"><span>Apply</span></a>
		</div>
	</div>
	

</cfif>