<link rel="stylesheet" href="/css/gecko.css"/>
<cflayout type="tab">
	<cflayoutarea title="Basic Information">
	
		<div class="OH_PREFERENCE_PANEL">
		
			<table width="100%" cellpadding="3" cellspacing="0" class="orms_dialog">
			<tr>
				<td align="right" width="30%"><strong>Username</strong></td>
				<td align="left" width="70%"><input type="text" name="device_name" id="device_name" /></td>	
			</tr>
			<tr>
				<td align="right" width="30%"><strong>First name</strong></td>
				<td align="left" width="70%"><input type="text" name="device_name" id="device_name" /></td>	
			</tr>
			<tr>
				<td align="right" width="30%"><strong>Middle initial</strong></td>
				<td align="left" width="70%"><input type="text" name="device_name" id="device_name" /></td>	
			</tr>
			
			<tr>
				<td align="right" width="30%"><strong>Last name</strong></td>
				<td align="left" width="70%"><input type="text" name="phone_number" id="phone_number" /></td>
			</tr>		
			
			<tr>
				<td align="right" width="30%"><strong>E-mail address</strong></td>
				<td align="left" width="70%"><input type="text" name="phone_number" id="phone_number" /></td>
			</tr>
			   		    		    
			</table>
			<hr />
			<table width="100%" cellpadding="3" cellspacing="0" class="orms_dialog">
			<tr>
				<td align="right" width="30%"><strong>Birthday</strong></td>
				<td align="left" width="70%"><cfmodule template="/controls/date_picker.cfm" startdate="#DateAdd('yyyy', -13, Now())#" ctlname="birthday"></td>	
			</tr>
			<tr>
				<td align="right" width="30%"><strong>Nickname</strong></td>
				<td align="left" width="70%"><input type="text" name="device_name" id="device_name" /></td>	
			</tr>
			   		    		    
			</table>
			<hr />
			<table width="100%" cellpadding="3" cellspacing="0" class="orms_dialog">

			<tr>
				<td align="right" width="30%"><strong>ZIP Code</strong></td>
				<td align="left" width="70%"><input type="text" name="device_name" id="device_name" /></td>	
			</tr>
			   		    		    
			</table>
			
		</div>
	
	</cflayoutarea>

	<cflayoutarea title="Privacy">	
		<div class="OH_PREFERENCE_PANEL">
			
			<table width="100%" cellpadding="3" cellspacing="0" class="orms_dialog">
			<tr>
				<td align="right" width="30%"><strong>Password</strong></td>
				<td align="left" width="70%"><input type="password" name="device_name" id="device_name" /></td>					
			</tr>
			<tr>
				<td align="right" width="30%"><strong>Re-Enter Password</strong></td>
				<td align="left" width="70%"><input type="password" name="device_name" id="device_name" /></td>					
			</tr>
			<tr>
            	<td align="right" width="30%"><strong>Password Question</strong></td>
                <td align="left" width="70%">
                    <select name="password_question" id="password_question">
                                <option value="What is your mother's maiden name?" selected>What is your mother's maiden name?</option>
                                <option value="What is the name of your favorite pet?">What is the name of your favorite pet?</option>
                                <option value="What street did you grow up on?">What street did you grow up on?</option>
                                <option value="What city were you born in?">What city were you born in?</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" width="30%"><strong>Password Answer</strong></td>
                        <td align="left" width="70%">
                        	<input type="text" name="password_answer" />                        	
                        </td>
                    </tr>
			</table>
			<hr />
					
			<p>
				<label><input type="checkbox">Allow others to search for me</label>
			</p>
			
			<p>
				<cfoutput>
				<a class="button" href="##" onclick="ORMSDialog('/OpenHorizon/Objects/Users/DeleteAccount.cfm?user_id=#URL.user_id#');"><span>Delete Account</span></a>
		
				</cfoutput>
			</p>
			
		</div>
	</cflayoutarea>

	<cflayoutarea title="Notifications">
		<div class="OH_PREFERENCE_PANEL">
		
		</div>
	</cflayoutarea>
	
</cflayout>