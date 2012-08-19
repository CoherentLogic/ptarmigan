<cfmodule template="../security/require.cfm" type="">

<cfif IsDefined("url.id")>
	<cfset t = CreateObject("component", "ptarmigan.customer").open(url.id)>
<cfelse>
	<cfset t = CreateObject("component", "ptarmigan.customer").open(form.id)>
</cfif>

<html>
<head>
</head>
<body>
	<h1>View Customer</h1>
	<cfoutput>
	<table>
		<tr>
			<td>Name:</td>
			<td>#t.company_name#</td>
		</tr>
		<tr>
			<td>Point of contact:</td>
			<td>#t.poc#</td>
		</tr>
		<tr>
			<td>Phone number:</td>
			<td>#t.phone_number#</td>
		</tr>
		<tr>
			<td>E-mail:</td>
			<td>
				<a href="mailto:#t.email#">#t.email#</a>
				<cfif t.electronic_billing EQ 1>
				[ELECTRONIC BILLING]
				<cfelse>
				[PAPER BILLING]
				</cfif>
			</td>
		</tr>
	</table>
	</cfoutput>
</body>
</html>