<cfmodule template="../security/require.cfm" type="project">

<cfquery name="customers" datasource="#session.company.datasource#">
	SELECT company_name,id FROM customers ORDER BY company_name
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Add Project - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	
</head>
<body>

<cfif IsDefined("form.self_post")>

	<cfset data_valid = true>
	
	<cfif form.project_name EQ "">
		<cfset data_valid = false>
		<cfset project_name_error = "Project name is required">
	</cfif>
	
	<cfif form.start_date EQ "">
		<cfset data_valid = false>
		<cfset start_date_error = "Start date is required">
	</cfif>
	
	<cfif form.due_date EQ "">
		<cfset data_valid = false>
		<cfset due_date_error = "Due date is required">
	</cfif>
	
	<cfif form.budget EQ "">
		<cfset data_valid = false>
		<cfset budget_error = "Budget is required">
	</cfif>
	
	<cfif form.tax_rate EQ "">
		<cfset data_valid = false>
		<cfset tax_rate_error = "Tax rate is required">
	</cfif>
	
	<cfif len(form.project_name) GT 255>
		<cfset data_valid = false>
		<cfset project_name_error = "Must not be longer than 255 characters">
	</cfif>
	
	<cfif len(instructions) GT 1600>
		<cfset data_valid = false>
		<cfset instructions_error = "Must not be longer than 255 characters">
	</cfif>
	

	<cfif not isdate(form.start_date)>
		<cfset data_valid = false>
		<cfset start_date_error = "Must be a date entered in MM/DD/YYYY format">
	</cfif>
	
	<cfif not isdate(form.due_date)>
		<cfset data_valid = false>
		<cfset due_date_error = "Must be a date entered in MM/DD/YYYY format">
	</cfif>
	
	<cfif isdate(form.start_date) AND isdate(form.due_date)>
		<cfif createodbcdate(form.due_date) LT createodbcdate(form.start_date)>
			<cfset data_valid = false>
			<cfset start_date_error = "Start date must be earlier than due date">
			<cfset due_date_error = "Due date must be later than start date">
		</cfif>
	</cfif>
	
	<cfif not isnumeric(form.tax_rate)>
		<cfset data_valid = false>
		<cfset tax_rate_error = "Must be a numeric value between 0 and 100">
	</cfif>
	
	<cfif isnumeric(form.tax_rate)>
		<cfif form.tax_rate GT 100>
			<cfset data_valid = false>
			<cfset tax_rate_error = "Must be a numeric value between 0 and 100">
		</cfif>
	</cfif>
	
	<cfif not isnumeric(form.budget)>
		<cfset data_valid = false>
		<cfset budget_error = "Must be a numeric value greater than zero without commas or dollar signs">
	</cfif>
	
	<cfif isnumeric(form.budget)>
		<cfif form.budget LT 0.01>
			<cfset data_valid = false>
			<cfset budget_error = "Must be a numeric value greater than zero without commas or dollar signs">
		</cfif>
	</cfif>
	
	<cfif data_valid EQ true>
		<cfset t = CreateObject("component", "ptarmigan.project")>
		<cfset t.project_name = UCase(form.project_name)>
		<cfset t.instructions = UCase(form.instructions)>
		<cfset t.due_date = CreateODBCDate(form.due_date)>
		<cfset t.customer_id = form.customer_id>
		<cfset t.current_milestone = 1>
		<cfset t.created_by = session.user.id>
		<cfset t.tax_rate = form.tax_rate>
		<cfset t.start_date = CreateODBCDate(form.start_date)>
		<cfset t.budget = form.budget>		
		
		<cfset t.create()>				
		
		<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#t.id#">
		
		<cfabort>
	</cfif>
</cfif>

<div class="form_wrapper">
	<div style="position:relative; height:100%; width:100%; background-color:white;">
	<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Project" icon="#session.root_url#/images/project_dialog.png">
		<cfoutput><form name="add_project" id="add_project" action="#session.root_url#/project/add_project.cfm" method="post"></cfoutput>	
			<table width="100%" class="ptarmigan_form">
				<tr>
					<td>Project name:</td>
					<td>
						<input type="text" maxlength="255" name="project_name" <cfif isdefined("form.project_name")><cfoutput>	value="#form.project_name#"	</cfoutput></cfif>><br />
						<cfif IsDefined("project_name_error")>
							<cfoutput><span class="form_error">#project_name_error#</span></cfoutput>
						</cfif>
						
					</td>
				</tr>
				<tr>
					<td>Customer:</td>
					<td>
						<select name="customer_id">
							<cfoutput query="customers">
								<option value="#id#">#company_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td>Start date:</td>
					<td>
						<input class="pt_dates" type="text" name="start_date"  <cfif isdefined("form.start_date")><cfoutput>	value="#form.start_date#"</cfoutput></cfif>><br />
						<cfif IsDefined("start_date_error")>
							<cfoutput><span class="form_error">#start_date_error#</span></cfoutput>
						</cfif>
		
					</td>
				</tr>
				<tr>
					<td>Due date:</td>
					<td>					
						<input class="pt_dates" type="text" name="due_date" <cfif isdefined("form.due_date")><cfoutput>value="#form.due_date#"</cfoutput></cfif>><br />
						<cfif IsDefined("due_date_error")>
							<cfoutput><span class="form_error">#due_date_error#</span></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Budget:</td>
					<td>					
						<input type="text" name="budget" <cfif isdefined("form.budget")><cfoutput>	value="#form.budget#"	</cfoutput></cfif>><br />
						<cfif IsDefined("budget_error")>
							<cfoutput><span class="form_error">#budget_error#</span></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Tax rate:</td>
					<td>					
						<input type="text" name="tax_rate" size="4" <cfif isdefined("form.tax_rate")><cfoutput>	value="#form.tax_rate#"	</cfoutput></cfif>><strong>%</strong><br />
						<cfif IsDefined("tax_rate_error")>
							<cfoutput><span class="form_error">#tax_rate_error#</span></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Instructions:</td>
					<td>
						
						<textarea name="instructions" cols="40" rows="3"> <cfif isdefined("form.instructions")><cfoutput>#form.instructions#</cfoutput></cfif></textarea><br />
						<cfif IsDefined("instructions_error")>
							<cfoutput><span class="form_error">#instructions_error#</span></cfoutput><br/>
						</cfif>
					</td>
				</tr>						
			</table>
			<input type="hidden" id="self_post" name="self_post" value="false">
		</form>	
		<div class="form_buttonstrip">
	    	<div style="padding:8px; float:right;" id="create_project_buttons" >
	        	<a class="button" href="##" onclick="window.history.go(-1);"><span>Cancel</span></a>
				<cfoutput>
				<a class="button" href="##" onclick="form_submit('add_project');"><span>Add Project</span></a>
			    </cfoutput>       	
			</div>
		</div>	
	</div>
</div>
</body>
</html>