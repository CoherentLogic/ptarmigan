<cfmodule template="../security/require.cfm" type="admin">

<div style="position:relative; height:100%; width:100%; background-color:white;">
	<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Employee" icon="#session.root_url#/images/project_dialog.png">

	<div style="padding:20px; margin-top:20px;">
		<cfoutput><form name="add_employee" id="add_employee" action="#session.root_url#/employee/add_employee_submit.cfm" method="post" onsubmit="window.location.reload();"></cfoutput>
			<div class="pt_tabs">
				<ul>
					<li><a href="#t_authentication">Authentication</a></li>
					<li><a href="#t_roles">Roles</a></li>
					<li><a href="#t_identity">Identity</a></li>
					<li><a href="#t_employment">Employment</a></li>
					<li><a href="#t_contact">Contact Info</a></li>										
				</ul>
				<div id="t_authentication">
					<div style="height:300px; width:450px;">
						<table width="100%">
						<tr>
						<td>Username:</td>
						<td><input type="text" name="t_username" value=""></td>
						</tr>
						<tr>
						<td>Password:</td>
						<td><input type="password" name="t_password" value=""></td>
						</tr>
						<tr>
						<td>&nbsp;</td>
						<td><input type="checkbox" name="active">Active</td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_roles">
					<div style="height:300px; width:450px;">
						<table width="100%">
						<tr>
						<td>
						<label><input type="checkbox" name="admin">Site administrator</label><br>
						<label><input type="checkbox" name="time_approver">Time collection manager</label><br>
						<label><input type="checkbox" name="project_manager">Project manager</label><br>
						<label><input type="checkbox" name="billing_manager">Billing manager</label>
						</td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_identity">
					<div style="height:300px; width:450px;">
						<table>
						<tr>
						<td>Gender:</td>
						<td>
							<select name="gender">
								<option value="M">Male</option>
								<option value="F">Female</option>
							</select>
						</td>
						</tr>
						<tr>
						<td>Honorific:</td>
						<td><select name="honorific">
								<option value="MR.">Mr.</option>
								<option value="MASTER">Master</option>
								<option value="MRS.">Mrs.</option>
								<option value="MS.">Ms.</option>
								<option value="MISS">Miss</option>
								<option value="DR.">Dr.</option>
								<option value="FR.">Fr.</option>
								<option value="SR.">Sr.</option>
								<option value="REV.">Rev.</option>
							</select>
						</td>
						</tr>
						<tr>
						<td>First name:</td>		
						<td>
						<input type="text" name="first_name">
						</td>
						</tr>
						<tr>
						<td>Middle initial:</td>
						<td><input type="text" name="middle_initial" size="1"></td>
						</tr>
						<tr>
						<td>Last name:</td>
						<td><input type="text" name="last_name"></td>
						</tr>
						<tr>
						<td>Suffix:</td>
						<td><input type="text" name="suffix" size="3"></td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_employment">
					<div style="height:300px; width:450px;">					
						<table>
						<tr>
						<td>Title:</td>
						<td><input type="text" name="title"></td>
						</tr>
						<tr>
						<td>Hire date (MM/DD/YYYY):</td>
						<td><input class="pt_dates" type="text" name="hire_date"></td>
						</tr>
						<tr>
						<td>Termination date (MM/DD/YYYY):</td>
						<td><input class="pt_dates" type="text" name="term_date"></td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_contact">
					<div style="height:300px; width:450px;">					
						<table>
						<tr>
						<td>Mailing Address:</td>
						<td><input type="text" name="mail_address"></td>
						</tr>
						<tr>
						<td>City:</td>
						<td><input type="text" name="mail_city"></td>
						</tr>
						<tr>
						<td>State:</td>
						<td><input type="text" size="2" maxlength="2" name="mail_state"></td>
						</tr>
						<tr>
						<td>ZIP:</td>
						<td><input type="text" size="5" maxlength="5" name="mail_zip"></td>
						</tr>
						<tr>
						<td>E-Mail Address:</td>
						<td><input type="text" name="email"></td>
						</tr>
						<tr>
						<td>Work Phone:</td>
						<td><input type="text" name="work_phone"></td>
						</tr>
						<tr>
						<td>Home Phone:</td>
						<td><input type="text" name="home_phone"></td>
						</tr>
						<tr>
						<td>Mobile Phone:</td>
						<td><input type="text" name="mobile_phone"></td>
						</tr>
						</table>
					</div>
				</div>
			</div> <!--- tabs --->
			<!---<input type="submit" name="submit" value="Apply">		
			<input type="button" name="cancel" value="Cancel" onclick="window.location.reload();">--->
			
		</form>
		</div>
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;" id="add_employee_buttons" >
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>
				<cfoutput>
				<a class="button" href="##" onclick="document.forms['add_employee'].submit();"><span>Apply</span></a>
			    </cfoutput>       	
			</div>
		</div>	
</div>
