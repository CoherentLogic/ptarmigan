<cfmodule template="../security/require.cfm" type="admin">

<cfif IsDefined("form.submit")>
	<cfset t = CreateObject("component", "ptarmigan.customer")>
	
	<cfset t.company_name = UCase(form.company_name)>
	<cfset t.poc = UCase(form.poc)>
	<cfset t.email = form.email>
	<cfif IsDefined("form.electronic_billing")>
		<cfset t.electronic_billing = 1>
	<cfelse>
		<cfset t.electronic_billing = 0>
	</cfif>
	<cfset t.phone_number = form.phone_number>
	
	<cfset t.create()>
	
	<center>
		<h1>Customer Created</h1>
		<cfoutput><a href="view_customer.cfm?id=#t.id#" target="content">View Customer</a></cfoutput>
	</center>
	
	
<cfelse>
	<h1>New Customer</h1>
	<form name="new_customer" id="new_customer" action="add_customer.cfm" method="post" target="content">
	<table width="100%">
		<tr>
			<td>Customer Name:</td>
			<td>
				<input type="text" name="company_name"><br>
				<label><input type="checkbox" name="electronic_billing">Electronic billing</label>
			</td>
		</tr>
		<tr>
			<td>Point of contact:</td>
			<td><input type="text" name="poc"></td>
		</tr>
		<tr>
			<td>E-mail:</td>
			<td><input type="text" name="email"></td>
		</tr>
		<tr>
			<td>Phone number:</td>
			<td><input type="text" maxlength="50" name="phone_number"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right">
				<input type="submit" name="submit" value="Submit">
			</td>
		</tr>
	</table>		
	</form>

</cfif>