<cfquery name="get_classes" datasource="#session.company.datasource#">
	SELECT * FROM object_classes ORDER BY class_name
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Add Report - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	
</head>
<body>
<cfif IsDefined("form.self_post")>
	<cfset data_valid = true>
	
	<cfif form.report_name EQ "">
		<cfset data_valid = false>
		<cfset report_name_error = "Report name is required">
	</cfif>
	
	<cfif len(form.report_name) GT 255>
		<cfset data_valid = false>
		<cfset report_name_error = "Must be 255 characters or fewer">
	</cfif>
	
	<cfif len(form.report_key) GT 20>
		<cfset data_valid = false>
		<cfset report_key_error = "Must be 20 characters or fewer">
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

<div class="form_wrapper">	
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Report" icon="#session.root_url#/images/project_dialog.png">
	
		<cfoutput><form name="add_report" id="add_report" action="#session.root_url#/reports/add_report.cfm" method="post"></cfoutput>
			<div style="padding:20px;">
				<table>
					<tr>
						<td>Report name:</td>
						<td>
								<input type="text" name="report_name" maxlength="255" <cfif isdefined("form.report_name")><cfoutput>	value="#form.report_name#"	</cfoutput></cfif>><br />
								<cfif IsDefined("report_name_error")>
									<cfoutput><span class="form_error">#report_name_error#</span></cfoutput>
								</cfif>
						</td>
					</tr>
					<tr>
						<td>Shortcut:</td>
						<td>
							<input type="text" name="report_key" maxlength="20" <cfif isdefined("form.report_key")><cfoutput>	value="#form.report_key#"	</cfoutput></cfif>><br />
							<cfif IsDefined("report_key_error")>
								<cfoutput><span class="form_error">#report_key_error#</span></cfoutput>
							</cfif>
						</td>
					</tr>
					<tr>
						<td>Using:</td>
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
							<td>Type:</td>
							<td>
								<label><input type="radio" name="system_report" value="0" checked="checked">User</label><br>
								<label><input type="radio" name="system_report" value="1">System</label>
							</td>
						</tr>				
					<cfelse>
						<input type="hidden" name="system_report" value="0">
					</cfif>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</form>
		
		<div class="form_buttonstrip">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_report');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</div> <!--- form_wrapper --->
</body>
</html>
