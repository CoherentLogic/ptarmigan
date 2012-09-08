<cfmodule template="../security/require.cfm" type="project">
<cfset e = CreateObject("component", "ptarmigan.expense").open(url.id)>
<cfif IsDefined("form.self_post")>	
	<cfset e.element_table = url.element_table>
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
	
	<cfset e.update()>
	
	<cflocation url="#session.root_url#/dashboard.cfm" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Dialog Caption" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="edit_expense" id="edit_expense" action="#session.root_url#/project/edit_expense.cfm?id=#url.id#" method="post">
			<div style="padding:20px;">
				<cfoutput>
					<table>
						<tr>
							<td>Expense date:</td>
							<td><input class="pt_dates" type="text" value="#dateFormat(e.expense_date, 'm/dd/yyyy')#" required="true" name="expense_date" validateat="onblur" validate="date"></td>
						</tr>
						<tr>
							<td>Recipient:</td>
							<td><cfinput type="text" required="true" name="recipient" value="#e.recipient#"></td>
						</tr>				
						<tr>
							<td>Amount:</td>
							<td>$<cfinput type="text" required="true" name="amount" value="#e.recipient#" validateAt="onblur" validate="float"></td>
						</tr>
						<tr>
							<td>Description:</td>
							<td><textarea name="description">#e.description#</textarea></td>
						</tr>
						<tr>
							<td>Point of contact:</td>
							<td><cfinput type="text" value="#e.poc#" required="false" name="poc"></td>
						</tr>
						<tr>
							<td>Address:</td>
							<td><cfinput type="text" value="#e.address#" required="false" name="address"></td>
						</tr>
						<tr>
							<td>City:</td>
							<td><cfinput type="city" value="#e.city#" required="false" name="city"></td>
						</tr>
						<tr>
							<td>State:</td>
							<td>
								<select name="state"> 
									<option value="" <cfif e.state EQ "">selected="selected"</cfif>>Select a State</option> 
									<option value="AL" <cfif e.state EQ "AL">selected="selected"</cfif>>Alabama</option> 
									<option value="AK" <cfif e.state EQ "AK">selected="selected"</cfif>>Alaska</option> 
									<option value="AZ" <cfif e.state EQ "AZ">selected="selected"</cfif>>Arizona</option> 
									<option value="AR" <cfif e.state EQ "AR">selected="selected"</cfif>>Arkansas</option> 
									<option value="CA" <cfif e.state EQ "CA">selected="selected"</cfif>>California</option> 
									<option value="CO" <cfif e.state EQ "CO">selected="selected"</cfif>>Colorado</option> 
									<option value="CT" <cfif e.state EQ "CT">selected="selected"</cfif>>Connecticut</option> 
									<option value="DE" <cfif e.state EQ "DE">selected="selected"</cfif>>Delaware</option> 
									<option value="DC" <cfif e.state EQ "DC">selected="selected"</cfif>>District Of Columbia</option> 
									<option value="FL" <cfif e.state EQ "FL">selected="selected"</cfif>>Florida</option> 
									<option value="GA" <cfif e.state EQ "GA">selected="selected"</cfif>>Georgia</option> 
									<option value="HI" <cfif e.state EQ "HI">selected="selected"</cfif>>Hawaii</option> 
									<option value="ID" <cfif e.state EQ "ID">selected="selected"</cfif>>Idaho</option> 
									<option value="IL" <cfif e.state EQ "IL">selected="selected"</cfif>>Illinois</option> 
									<option value="IN" <cfif e.state EQ "IN">selected="selected"</cfif>>Indiana</option> 
									<option value="IA" <cfif e.state EQ "IA">selected="selected"</cfif>>Iowa</option> 
									<option value="KS" <cfif e.state EQ "KS">selected="selected"</cfif>>Kansas</option> 
									<option value="KY" <cfif e.state EQ "KY">selected="selected"</cfif>>Kentucky</option> 
									<option value="LA" <cfif e.state EQ "LA">selected="selected"</cfif>>Louisiana</option> 
									<option value="ME" <cfif e.state EQ "ME">selected="selected"</cfif>>Maine</option> 
									<option value="MD" <cfif e.state EQ "MD">selected="selected"</cfif>>Maryland</option> 
									<option value="MA" <cfif e.state EQ "MA">selected="selected"</cfif>>Massachusetts</option> 
									<option value="MI" <cfif e.state EQ "MI">selected="selected"</cfif>>Michigan</option> 
									<option value="MN" <cfif e.state EQ "MN">selected="selected"</cfif>>Minnesota</option> 
									<option value="MS" <cfif e.state EQ "MS">selected="selected"</cfif>>Mississippi</option> 
									<option value="MO" <cfif e.state EQ "MO">selected="selected"</cfif>>Missouri</option> 
									<option value="MT" <cfif e.state EQ "MT">selected="selected"</cfif>>Montana</option> 
									<option value="NE" <cfif e.state EQ "NE">selected="selected"</cfif>>Nebraska</option> 
									<option value="NV" <cfif e.state EQ "NV">selected="selected"</cfif>>Nevada</option> 
									<option value="NH" <cfif e.state EQ "NH">selected="selected"</cfif>>New Hampshire</option> 
									<option value="NJ" <cfif e.state EQ "NJ">selected="selected"</cfif>>New Jersey</option> 
									<option value="NM" <cfif e.state EQ "NM">selected="selected"</cfif>>New Mexico</option> 
									<option value="NY" <cfif e.state EQ "NY">selected="selected"</cfif>>New York</option> 
									<option value="NC" <cfif e.state EQ "NC">selected="selected"</cfif>>North Carolina</option> 
									<option value="ND" <cfif e.state EQ "ND">selected="selected"</cfif>>North Dakota</option> 
									<option value="OH" <cfif e.state EQ "OH">selected="selected"</cfif>>Ohio</option> 
									<option value="OK" <cfif e.state EQ "OK">selected="selected"</cfif>>Oklahoma</option> 
									<option value="OR" <cfif e.state EQ "OR">selected="selected"</cfif>>Oregon</option> 
									<option value="PA" <cfif e.state EQ "PA">selected="selected"</cfif>>Pennsylvania</option> 
									<option value="RI" <cfif e.state EQ "RI">selected="selected"</cfif>>Rhode Island</option> 
									<option value="SC" <cfif e.state EQ "SC">selected="selected"</cfif>>South Carolina</option> 
									<option value="SD" <cfif e.state EQ "SD">selected="selected"</cfif>>South Dakota</option> 
									<option value="TN" <cfif e.state EQ "TN">selected="selected"</cfif>>Tennessee</option> 
									<option value="TX" <cfif e.state EQ "TX">selected="selected"</cfif>>Texas</option> 
									<option value="UT" <cfif e.state EQ "UT">selected="selected"</cfif>>Utah</option> 
									<option value="VT" <cfif e.state EQ "VT">selected="selected"</cfif>>Vermont</option> 
									<option value="VA" <cfif e.state EQ "VA">selected="selected"</cfif>>Virginia</option> 
									<option value="WA" <cfif e.state EQ "WA">selected="selected"</cfif>>Washington</option> 
									<option value="WV" <cfif e.state EQ "WV">selected="selected"</cfif>>West Virginia</option> 
									<option value="WI" <cfif e.state EQ "WI">selected="selected"</cfif>>Wisconsin</option> 
									<option value="WY" <cfif e.state EQ "WY">selected="selected"</cfif>>Wyoming</option>
								</select>
							</td>				
						</tr>
						<tr>
							<td>ZIP:</td>
							<td><cfinput name="zip" value="#e.zip#" type="text" validateAt="onblur" validate="zipcode" required="false"></td>
						</tr>
					</table>
				</cfoutput>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('form_id');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>