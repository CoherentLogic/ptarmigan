<cfmodule template="#session.root_url#/security/require.cfm" type="admin">
<!DOCTYPE html>
<html lang="en">
<head>	
	<cfoutput>	
		<title>New Customer - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   											
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">												
   		 });
	</script>
</head>
<body>
	<cfif IsDefined("form.submit")>
		
		<cfset data_valid = true>
		
		<cfif form.company_name EQ "">
			<cfset company_name_error = "Company name required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.company_name) GT 255>
			<cfset company_name_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.poc EQ "">
			<cfset poc_error = "Point of contact required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.poc) GT 255>
			<cfset poc_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.email EQ "">
			<cfset email_error = "E-mail address required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.email) GT 255>
			<cfset email_error = "Must be 255 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif form.phone_number EQ "">
			<cfset phone_number_error = "Phone number required">
			<cfset data_valid = false>
		</cfif>
		
		<cfif len(form.phone_number) GT 50>
			<cfset phone_number_error = "Must be 50 or fewer characters">
			<cfset data_valid = false>
		</cfif>
		
		<cfif data_valid EQ true>
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
						
			<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#t.id#">
		</cfif>
	</cfif>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="inner-tube">
		<div id="content-right">
			<cfinclude template="#session.root_url#/sidebar.cfm">
		</div> <!--- content-right --->
		<div id="content" style="margin:0px;width:80%;">		
			<cfmodule template="#session.root_url#/navigation-tabs.cfm">							
			<div class="form_instructions">
				<p>Required fields marked with *</p>
			</div>
			<div id="tabs-min">
				<ul>
					<li><a href="#customer-details">Customer Details</a></li>
				</ul>
				<div id="customer-details">
					<div style="position:relative;">
					<form name="new_customer" id="new_customer" action="#session.root_url#/customer/add_customer.cfm" method="post" onsubmit="window.location.reload();">
						<table width="100%">
							<tr>
								<td valign="top"><label>Customer name<strong>*</strong></label></td>
								<td valign="top">
									<input <cfif isdefined("company_name_error")>class="error_field"</cfif> type="text" name="company_name" placeholder="1-255 characters" required <cfif isdefined("form.company_name")><cfoutput>value="#form.company_name#"</cfoutput></cfif>><br>
									<label><input type="checkbox" name="electronic_billing">Electronic billing</label>
									<cfif isdefined("company_name_error")>
										<cfoutput><span class="form_error">#company_name_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Point of contact<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("poc_error")>class="error_field"</cfif> type="text" placeholder="1-255 characters" required name="poc" <cfif isdefined("form.poc")><cfoutput>value="#form.poc#"</cfoutput></cfif>>
									<cfif isdefined("poc_error")>
										<cfoutput><span class="form_error">#poc_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>E-mail address<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("email_error")>class="error_field"</cfif> type="email" name="email" placeholder="255 or fewer characters" required  <cfif isdefined("form.email")><cfoutput>value="#form.email#"</cfoutput></cfif>>
									<cfif isdefined("email_error")>
										<cfoutput><span class="form_error">#email_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Phone number<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("phone_number_error")>class="error_field"</cfif> placeholder="50 or fewer characters" required type="text" maxlength="50" name="phone_number"  <cfif isdefined("form.phone_number")><cfoutput>value="#form.phone_number#"</cfoutput></cfif>>
									<cfif isdefined("phone_number_error")>
										<cfoutput><span class="form_error">#phone_number_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>							
						</table>								
						<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="1" current_tab="0" tab_selector="##tabs-min">
					</form>
					</div>
				</div>
				
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>





