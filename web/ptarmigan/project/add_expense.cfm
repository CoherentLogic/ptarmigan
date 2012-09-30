<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Add Expense - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		<script type="text/javascript">
			$(document).ready(function() {   
				init_page();
			});
		</script>
	</cfoutput>		
	
</head>
<body>
<cfmodule template="../security/require.cfm" type="project">
<cfif IsDefined("form.self_post")>	
	<cfset data_valid = true>
	
	<cfif not isdate(form.expense_date)>
		<cfset data_valid = false>
		<cfset expense_date_error = "Must be a valid date in the format MM/DD/YYYY">
	</cfif>
	
	<cfif form.recipient EQ "">
		<cfset data_valid = false>
		<cfset recipient_error = "Recipient is required">
	</cfif>
	
	<cfif len(form.recipient) GT 255>
		<cfset data_valid = false>
		<cfset recipient_error = "Must be 255 or fewer characters">
	</cfif>
	
	<cfif not isnumeric(form.amount)>
		<cfset data_valid = false>
		<cfset amount_error = "Must specify a valid dollar amount">
	</cfif>
	
	<cfif len(form.description) GT 255>
		<cfset data_valid = false>
		<cfset description_error = "Must be 255 or fewer characters">
	</cfif>
	
	<cfif len(form.address) GT 255>
		<cfset data_valid = false>
		<cfset address_error = "Must be 255 or fewer characters">
	</cfif>
	
	<cfif len(form.city) GT 255>
		<cfset data_valid = false>
		<cfset city_error = "Must be 255 or fewer characters">
	</cfif>

	<cfif form.zip NEQ "">
		<cfif not isnumeric(form.zip)>
			<cfset data_valid = false>
			<cfset zip_error = "Must be a valid 5-digit ZIP code">
		</cfif>
		<cfif len(form.zip) NEQ 5>
			<cfset data_valid = false>
			<cfset zip_error = "Must be a valid 5-digit ZIP code">
		</cfif>
	</cfif>
	
	<cfif len(form.poc) GT 255>
		<cfset data_valid = false>
		<cfset poc_error = "Must be 255 or fewer characters">
	</cfif>
	
	<cfif data_valid EQ true>
		<cfset e = CreateObject("component", "ptarmigan.expense")>
		
		<cfset e.element_table = "tasks">
		<cfset e.element_id = url.element_id>
		<cfset e.expense_date = CreateODBCDate(form.expense_date)>
		<cfset e.description = UCase(form.description)>
		<cfset e.recipient = UCase(form.recipient)>
		<cfset e.address = UCase(form.address)>
		<cfset e.city = UCase(form.city)>
		<cfset e.state = form.state>
		<cfset e.zip = form.zip>
		<cfset e.poc = UCase(form.poc)>
		<cfset e.amount = form.amount>
		
		<cfset e.create()>
		
		<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#url.element_id#" addtoken="false">
	</cfif>
</cfif>

<div class="form_wrapper">
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Expense" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="add_expense" id="add_expense" action="#session.root_url#/project/add_expense.cfm?element_table=#url.element_table#&element_id=#url.element_id#" method="post"></cfoutput>
			<div style="padding:20px;">
				<table style="margin-top:30px;">
					<tr>
						<cfset task = CreateObject("component", "ptarmigan.task").open(url.element_id)>
						<td>Task:</td>
						<cfoutput><td>#task.task_name#</td></cfoutput>
					</tr>
					
					<tr>
						<td>Expense date:</td>
						<td>
							<input class="pt_dates" type="text"  name="expense_date" maxlength="10" <cfif isdefined("form.expense_date")><cfoutput>	value="#form.expense_date#"	</cfoutput></cfif>><br />
								<cfif IsDefined("expense_date_error")>
									<cfoutput><span class="form_error">#expense_date_error#</span></cfoutput>
								</cfif>												
						</td>
					</tr>
					<tr>
						<td>Recipient:</td>
						<td>
							<input type="text" name="recipient" maxlength="255" <cfif isdefined("form.recipient")><cfoutput>	value="#form.recipient#"	</cfoutput></cfif>><br />
								<cfif IsDefined("recipient_error")>
									<cfoutput><span class="form_error">#recipient_error#</span></cfoutput>
								</cfif>						
						</td>
					</tr>				
					<tr>
						<td>Amount:</td>
						<td>
							$<input type="text"  name="amount" <cfif isdefined("form.amount")><cfoutput>	value="#form.amount#"	</cfoutput></cfif>><br />
								<cfif IsDefined("amount_error")>
									<cfoutput><span class="form_error">#amount_error#</span></cfoutput>
								</cfif>						
						</td>
					</tr>
					<tr>
						<td>Description:</td>
						<td>
							<textarea name="description" maxlength="255"><cfif isdefined("form.description")><cfoutput>#form.description#</cfoutput></cfif></textarea><br />
								<cfif IsDefined("description_error")>
									<cfoutput><span class="form_error">#description_error#</span></cfoutput>
								</cfif>						
						</td>
					</tr>
					<tr>
						<td>Point of contact:</td>
						<td>
							<input type="text" name="poc" maxlength="255" <cfif isdefined("form.poc")><cfoutput>	value="#form.poc#"	</cfoutput></cfif>><br />
								<cfif IsDefined("poc_error")>
									<cfoutput><span class="form_error">#poc_error#</span></cfoutput>
								</cfif>						
						</td>
					</tr>
					<tr>
						<td>Address:</td>
						<td>
							<input type="text" name="address" maxlength="255" <cfif isdefined("form.address")><cfoutput>	value="#form.address#"	</cfoutput></cfif>><br />
								<cfif IsDefined("address_error")>
									<cfoutput><span class="form_error">#address_error#</span></cfoutput>
								</cfif>						
						</td>
					</tr>
					<tr>
						<td>City:</td>
						<td>
							<input type="city" name="city" maxlength="255" <cfif isdefined("form.city")><cfoutput>	value="#form.city#"	</cfoutput></cfif>><br />
								<cfif IsDefined("city_error")>
									<cfoutput><span class="form_error">#city_error#</span></cfoutput>
								</cfif>
						</td>
					</tr>
					<tr>
						<td>State:</td>
						<td>
							<select name="state"> 
								<option value="" selected="selected">Select a State</option> 
								<option value="AL">Alabama</option> 
								<option value="AK">Alaska</option> 
								<option value="AZ">Arizona</option> 
								<option value="AR">Arkansas</option> 
								<option value="CA">California</option> 
								<option value="CO">Colorado</option> 
								<option value="CT">Connecticut</option> 
								<option value="DE">Delaware</option> 
								<option value="DC">District Of Columbia</option> 
								<option value="FL">Florida</option> 
								<option value="GA">Georgia</option> 
								<option value="HI">Hawaii</option> 
								<option value="ID">Idaho</option> 
								<option value="IL">Illinois</option> 
								<option value="IN">Indiana</option> 
								<option value="IA">Iowa</option> 
								<option value="KS">Kansas</option> 
								<option value="KY">Kentucky</option> 
								<option value="LA">Louisiana</option> 
								<option value="ME">Maine</option> 
								<option value="MD">Maryland</option> 
								<option value="MA">Massachusetts</option> 
								<option value="MI">Michigan</option> 
								<option value="MN">Minnesota</option> 
								<option value="MS">Mississippi</option> 
								<option value="MO">Missouri</option> 
								<option value="MT">Montana</option> 
								<option value="NE">Nebraska</option> 
								<option value="NV">Nevada</option> 
								<option value="NH">New Hampshire</option> 
								<option value="NJ">New Jersey</option> 
								<option value="NM">New Mexico</option> 
								<option value="NY">New York</option> 
								<option value="NC">North Carolina</option> 
								<option value="ND">North Dakota</option> 
								<option value="OH">Ohio</option> 
								<option value="OK">Oklahoma</option> 
								<option value="OR">Oregon</option> 
								<option value="PA">Pennsylvania</option> 
								<option value="RI">Rhode Island</option> 
								<option value="SC">South Carolina</option> 
								<option value="SD">South Dakota</option> 
								<option value="TN">Tennessee</option> 
								<option value="TX">Texas</option> 
								<option value="UT">Utah</option> 
								<option value="VT">Vermont</option> 
								<option value="VA">Virginia</option> 
								<option value="WA">Washington</option> 
								<option value="WV">West Virginia</option> 
								<option value="WI">Wisconsin</option> 
								<option value="WY">Wyoming</option>
							</select>
						</td>				
					</tr>
					<tr>
						<td>ZIP:</td>
						<td>
							<input name="zip" maxlength="5" type="text" <cfif isdefined("form.zip")><cfoutput>	value="#form.zip#"	</cfoutput></cfif>><br />
								<cfif IsDefined("zip_error")>
									<cfoutput><span class="form_error">#zip_error#</span></cfoutput>
								</cfif>
						</td>
					</tr>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</form>
		
		<div class="form_buttonstrip">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_expense');"><span>Apply</span></a>
			</div>
		</div> <!--- form_buttonstrip --->
	</div> <!--- padding --->
</div> <!--- form_wrapper --->
</body>
</html>