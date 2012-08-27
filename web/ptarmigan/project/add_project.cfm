<cfmodule template="../security/require.cfm" type="project">

<cfif IsDefined("form.submit")>
	<cfset t = CreateObject("component", "ptarmigan.project")>

	<cfset t.project_name = UCase(form.project_name)>
	<cfset t.instructions = UCase(form.instructions)>
	<cfset t.due_date = CreateODBCDate(form.due_date)>
	<cfset t.due_date_pessimistic = CreateODBCDate(form.due_date_pessimistic)>
	<cfset t.due_date_optimistic = CreateODBCDate(form.due_date_optimistic)>
	
	<cfset t.customer_id = form.customer_id>
	<cfset t.current_milestone = 1>
	<cfset t.created_by = session.user.id>
	<cfset t.tax_rate = form.tax_rate>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.budget = form.budget>
	
	<cfset t.create()>
	
	<cfset session.message = "Created project " & t.project_number>
	
	<cfoutput>
		<center>
		<h1>Project Created</h1>
		<a href="view_project.cfm?id=#t.id#">View</a> | <a href="edit_project.cfm?id=#t.id#">Edit</a>
		</center>
	</cfoutput>
	
	

<cfelse>

<cfquery name="customers" datasource="#session.company.datasource#">
	SELECT company_name,id FROM customers ORDER BY company_name
</cfquery>

<h1>Add Project</h1>

<form name="add_project" id="add_project" action="add_project.cfm" method="post">
<table width="100%">
	<tr>
		<td>Project name:</td>
		<td><input type="text" maxlength="255" name="project_name"></td>
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
		<td>Budget:</td>
		<td><input type="text" name="budget"></td>
	</tr>
	<tr>
		<td>Tax rate:</td>
		<td><input type="text" name="tax_rate" size="4"><strong>%</strong></td>
	</tr>
	<tr>
		<td>Instructions:</td>
		<td><textarea name="instructions" cols="80" rows="10"></textarea>
	</tr>
	<tr>
		<td>Start date (MM/DD/YYYY):</td>
		<td><input type="text" name="start_date">
	</tr>
	<tr>
		<td>End date (normal) (MM/DD/YYYY):</td>
		<td><input type="text" name="due_date"></td>
	</tr>
	<tr>
		<td>End date (pessimistic) (MM/DD/YYYY):</td>
		<td><input type="text" name="due_date_pessimistic"></td>
	</tr>
	<tr>
		<td>End date (optimistic) (MM/DD/YYYY):</td>
		<td><input type="text" name="due_date_optimistic"></td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
		<td align="right"><input type="submit" name="submit" value="Submit"></td>
	</tr>
</table>
</form>

</cfif>