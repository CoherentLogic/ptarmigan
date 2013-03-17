<cfmodule template="#session.root_url#/security/require.cfm" type="admin">
<cfsilent>
	<cfset object =  CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset employee = object.get()>
</cfsilent>
<!DOCTYPE html>
<html lang="en">
<head>	
	<cfoutput>	
		<title>#object.get().object_name()# - ptarmigan</title>		
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
			<div id="tabs-min">				
				<ul>																			
					<li><a href="#t_authentication">Authentication</a></li>
					<li><a href="#t_roles">Roles</a></li>
					<li><a href="#t_identity">Identity</a></li>
					<li><a href="#t_employment">Employment</a></li>
					<li><a href="#t_contact">Contact Info</a></li>										
				</ul>																
				<div id="t_authentication">
					<div style="height:500px; width:100%; position:relative;">
						<table width="100%">
						<tr>
						<td><label>Username<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="username" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<!--- <tr>
						<td><label>Password<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="password" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr> --->
						<tr>
						<td><label>Account active</label></td>
						<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="active" width="auto" show_label="false" full_refresh="false"></td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_roles">
					<div style="height:500px; width:100%; position:relative;">
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
					<div style="height:500px; width:100%; position:relative;">
						<table>
						<tr>
						<td><label>Gender<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="gender" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Honorific<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="honorific" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>First name<strong>*</strong></label></td>		
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="first_name" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Middle initial</label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="middle_initial" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Last name<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="last_name" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Suffix</label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="suffix" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_employment">
					<div style="height:500px; width:100%; position:relative;">					
						<table width="90%">
						<tr>
						<td><label>Job title<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="title" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Hire date</label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="hire_date" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Termination date</label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="term_date" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						</table>
					</div>
				</div>
				<div id="t_contact">
					<div style="height:500px; width:100%; position:relative;">					
						<table>
						<tr>
						<td><label>Mailing address<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mail_address" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>City<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mail_city" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>State<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mail_state" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>ZIP code<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mail_zip" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>E-mail address<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="email" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Work phone<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="work_phone" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Home phone</label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="home_phone" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						<tr>
						<td><label>Mobile phone<strong>*</strong></label></td>
						<td>
							<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="mobile_phone" width="auto" show_label="false" full_refresh="false">
						</td>
						</tr>
						</table>
					</div>
				</div>
			</div> <!--- tabs-min --->			
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>

