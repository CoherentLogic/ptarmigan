<cfquery name="get_classes" datasource="#session.company.datasource#">
	SELECT * FROM object_classes ORDER BY class_name
</cfquery>

<cfif IsDefined("form.self_post")>
	
	<cfset rep = CreateObject("component", "ptarmigan.report")>
	
	<cfset rep.report_name = form.report_name>
	<cfset rep.class_id = form.class_id>
	<cfset rep.system_report = form.system_report>
	<cfset rep.employee_id = session.user.id>
	
	<cfset rep.create()>
	
<!---
<cffunction name="add_criteria" returntype="string" access="public" output="false">
		<cfargument name="report_id" type="string" required="true">
		<cfargument name="member_name" type="string" required="true">
		<cfargument name="operator" type="string" required="true">
		<cfargument name="literal_a" type="string" required="true">
		<cfargument name="literal_b" type="string" required="true">
--->
	
	<cflocation url="#session.root_url#/reports/edit_report.cfm?id=#rep.id#" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Report" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="add_report" id="add_report" action="#session.root_url#/reports/add_report.cfm" method="post">
			<div style="padding:20px;">
				<table>
					<tr>
						<td>Report name:</td>
						<td><input type="text" name="report_name"></td>
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
					<tr>
						<td>Type:</td>
						<td>
							<label><input type="radio" name="system_report" value="0" checked="checked">User</label><br>
							<label><input type="radio" name="system_report" value="1">System</label>
						</td>
					</tr>				
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_report');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>