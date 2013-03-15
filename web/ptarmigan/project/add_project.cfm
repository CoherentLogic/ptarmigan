<cfmodule template="#session.root_url#/security/require.cfm" type="project">
<cfquery name="customers" datasource="#session.company.datasource#">
	SELECT company_name,id FROM customers ORDER BY company_name
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>	
	<cfoutput>	
		<title>New Project - ptarmigan</title>		
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
					<li><a href="#project-details">Project Details</a></li>
				</ul>
				<div id="project-details">
					<div style="position:relative;">
					<cfoutput><form name="add_project" id="add_project" action="#session.root_url#/project/add_project.cfm" method="post"></cfoutput>	
						<table width="100%" class="ptarmigan_form">
							<tr>
								<td><label>Project name<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("project_name_error")>class="error_field"</cfif> type="text" maxlength="255" name="project_name" <cfif isdefined("form.project_name")><cfoutput>	value="#form.project_name#"	</cfoutput></cfif>><br />
									<cfif IsDefined("project_name_error")>
										<cfoutput><span class="form_error">#project_name_error#</span></cfoutput>
									</cfif>
									
								</td>
							</tr>
							<tr>
								<td><label>Customer<strong>*</strong></label></td>
								<td>
									<select name="customer_id">
										<cfoutput query="customers">
											<option value="#id#">#company_name#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<tr>
								<td><label>Start date<strong>*</strong></label></td>
								<td>
									<input <cfif isdefined("start_date_error")>class="error_field"</cfif> class="pt_dates" type="text" name="start_date"  <cfif isdefined("form.start_date")><cfoutput>	value="#form.start_date#"</cfoutput></cfif>><br />
									<cfif IsDefined("start_date_error")>
										<cfoutput><span class="form_error">#start_date_error#</span></cfoutput>
									</cfif>
					
								</td>
							</tr>
							<tr>
								<td><label>Due date<strong>*</strong></label></td>
								<td>					
									<input <cfif isdefined("due_date_error")>class="error_field"</cfif> class="pt_dates" type="text" name="due_date" <cfif isdefined("form.due_date")><cfoutput>value="#form.due_date#"</cfoutput></cfif>><br />
									<cfif IsDefined("due_date_error")>
										<cfoutput><span class="form_error">#due_date_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Budget<strong>*</strong></label></td>
								<td>					
									<input <cfif isdefined("budget_error")>class="error_field"</cfif> type="text" name="budget" <cfif isdefined("form.budget")><cfoutput>	value="#form.budget#"	</cfoutput></cfif>><br />
									<cfif IsDefined("budget_error")>
										<cfoutput><span class="form_error">#budget_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Tax rate<strong>*</strong></label></td>
								<td>					
									<input <cfif isdefined("tax_rate_error")>class="error_field"</cfif> type="text" name="tax_rate" size="4" <cfif isdefined("form.tax_rate")><cfoutput>	value="#form.tax_rate#"	</cfoutput></cfif>><strong>%</strong><br />
									<cfif IsDefined("tax_rate_error")>
										<cfoutput><span class="form_error">#tax_rate_error#</span></cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><label>Instructions<strong>*</strong></label></td>
								<td>
									
									<textarea <cfif isdefined("instructions_error")>class="error_field"</cfif> name="instructions" cols="40" rows="3"> <cfif isdefined("form.instructions")><cfoutput>#form.instructions#</cfoutput></cfif></textarea><br />
									<cfif IsDefined("instructions_error")>
										<cfoutput><span class="form_error">#instructions_error#</span></cfoutput><br/>
									</cfif>
								</td>
							</tr>						
						</table>		
						<cfmodule template="#session.root_url#/utilities/wizard_widget.cfm" tab_count="1" current_tab="0" tab_selector="##tabs-min">	
					</form>	
					</div>
				</div>
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>




