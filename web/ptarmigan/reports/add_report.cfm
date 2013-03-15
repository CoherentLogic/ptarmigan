<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfquery name="get_classes" datasource="#session.company.datasource#">
	SELECT * FROM object_classes ORDER BY class_name
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>	
	<cfoutput>	
		<title>New Report - ptarmigan</title>		
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
		
		<cfif form.report_name EQ "">
			<cfset data_valid = false>
			<cfset report_name_error = "Report name required">
		</cfif>
		
		<cfif len(form.report_name) GT 255>
			<cfset data_valid = false>
			<cfset report_name_error = "Must be 255 or fewer characters">
		</cfif>
		
		<cfif len(form.report_key) GT 20>
			<cfset data_valid = false>
			<cfset report_key_error = "Must be 20 or fewer characters">
		</cfif>
		
		<cfif data_valid EQ true>
			<cfset rep = CreateObject("component", "ptarmigan.report")>
			
			<cfset rep.report_name = left(form.report_name, 255)>
			<cfset rep.class_id = form.class_id>
			<cfset rep.system_report = form.system_report>
			<cfset rep.employee_id = session.user.id>
			<cfset rep.report_key = left(form.report_key, 20)>
			
			<cfset rep.create()>
			
			<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#rep.id#" addtoken="false">
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
					<li><a href="#report-details">Report Details</a></li>					
				</ul>
				<div id="tab1">
					<div style="padding:40px;">
					<div style="position:relative;">
					<cfoutput><form name="add_report" id="add_report" action="#session.root_url#/reports/add_report.cfm" method="post"></cfoutput>						
						<table>
							<tr>
								<td><label>Report name<strong>*</strong></label></td>
								<td>
										<input <cfif isdefined("report_name_error")>class="error_field"</cfif> type="text" name="report_name" maxlength="255" <cfif isdefined("form.report_name")><cfoutput>	value="#form.report_name#"	</cfoutput></cfif>><br />
										<cfif IsDefined("report_name_error")>
											<cfoutput><span class="form_error">#report_name_error#</span></cfoutput>
										</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Shortcut</label></td>
								<td>
									<input <cfif isdefined("report_key_error")>class="error_field"</cfif> type="text" name="report_key" maxlength="20" <cfif isdefined("form.report_key")><cfoutput>	value="#form.report_key#"	</cfoutput></cfif>><br />
									<cfif IsDefined("report_key_error")>
										<cfoutput><span class="form_error">#report_key_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Using<strong>*</strong></label></td>
								<td>
									<select name="class_id">
										<cfoutput query="get_classes">
											<cfif class_name NEQ "Company">
												<option value="#id#">#class_name#s</option>
											<cfelse>
												<option value="#id#">Companies</option>
											</cfif>
										</cfoutput>
									</select>
								</td>
							</tr>
							<cfif session.user.is_admin() EQ true>
								<tr>
									<td><label>Type<strong>*</strong></label></td>
									<td>
										<label><input type="radio" name="system_report" value="0" checked="checked">User</label><br>
										<label><input type="radio" name="system_report" value="1">System</label>
									</td>
								</tr>				
							<cfelse>
								<input type="hidden" name="system_report" value="0">
							</cfif>
						</table>
						<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="1" current_tab="0" tab_selector="##tabs-min">
					</form>
					</div>
					</div>
				</div>
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>