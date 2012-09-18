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
	
	
	
	<cflocation url="#session.root_url#/project/edit_project.cfm?id=#t.id#" addtoken="false">