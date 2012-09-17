<cfmodule template="../security/require.cfm" type="project">
<cfif IsDefined("form.self_post")>	
	<cfset e = CreateObject("component", "ptarmigan.expense")>
	
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
	
	<cfset e.create()>
	
	<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#form.return_to#" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Expense" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="add_expense" id="add_expense" action="#session.root_url#/project/add_expense.cfm?element_table=#url.element_table#&element_id=#url.element_id#" method="post">
			<div style="padding:20px;">
				<table style="margin-top:30px;">
					<tr>
					<cfswitch expression="#url.element_table#">
						<cfcase value="milestones">
							<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(url.element_id)>
							<td>Milestone:</td>
							<cfoutput><td>#milestone.milestone_name#</td></cfoutput>
						</cfcase>
						<cfcase value="tasks">
							<cfset task = CreateObject("component", "ptarmigan.task").open(url.element_id)>
							<td>Task:</td>
							<cfoutput><td>#task.task_name#</td></cfoutput>
						</cfcase>
					</cfswitch>
					</tr>
					<cfoutput><input type="hidden" name="return_to" value="#url.return_to#"></cfoutput>
					<tr>
						<td>Expense date:</td>
						<td><input class="pt_dates" type="text" required="true" name="expense_date" validateat="onblur" validate="date"></td>
					</tr>
					<tr>
						<td>Recipient:</td>
						<td><cfinput type="text" required="true" name="recipient"></td>
					</tr>				
					<tr>
						<td>Amount:</td>
						<td>$<cfinput type="text" required="true" name="amount" validateAt="onblur" validate="float"></td>
					</tr>
					<tr>
						<td>Description:</td>
						<td><textarea name="description"></textarea></td>
					</tr>
					<tr>
						<td>Point of contact:</td>
						<td><cfinput type="text" required="false" name="poc"></td>
					</tr>
					<tr>
						<td>Address:</td>
						<td><cfinput type="text" required="false" name="address"></td>
					</tr>
					<tr>
						<td>City:</td>
						<td><cfinput type="city" required="false" name="city"></td>
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
						<td><cfinput name="zip" type="text" validateAt="onblur" validate="zipcode" required="false"></td>
					</tr>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_expense');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>