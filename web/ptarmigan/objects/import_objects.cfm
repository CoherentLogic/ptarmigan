
<cfabort>
<cfquery name="itc" datasource="#session.company.datasource#">
	SELECT id FROM task_constraints
</cfquery>
<cfoutput query="itc">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = itc.id>
	<cfset tmp.class_id = "OBJ_TASK_CONSTRAINT">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>
<cfabort>

<!--- IMPORT MILESTONES (OBJ_MILESTONE) --->
<cfquery name="ims" datasource="#session.company.datasource#">
	SELECT id, project_id FROM milestones
</cfquery>
<cfoutput query="ims">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = ims.id>
	<cfset tmp.class_id = "OBJ_MILESTONE">
	<cfset tmp.parent_id = ims.project_id>
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<cfquery name="irep" datasource="#session.company.datasource#">
	SELECT id FROM reports
</cfquery>
<cfoutput query="irep">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = irep.id>
	<cfset tmp.class_id = "OBJ_REPORT">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>	
</cfoutput>

<!--- IMPORT PROJECTS (OBJ_PROJECT) --->
<cfquery name="iprj" datasource="#session.company.datasource#">
	SELECT id FROM projects
</cfquery>
<cfoutput query="iprj">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = iprj.id>
	<cfset tmp.class_id = "OBJ_PROJECT">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT MILESTONES (OBJ_MILESTONE) --->
<cfquery name="ims" datasource="#session.company.datasource#">
	SELECT id, project_id FROM milestones
</cfquery>
<cfoutput query="ims">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = ims.id>
	<cfset tmp.class_id = "OBJ_MILESTONE">
	<cfset tmp.parent_id = ims.project_id>
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT TASKS (OBJ_TASK) --->
<cfquery name="it" datasource="#session.company.datasource#">
	SELECT id, milestone_id FROM tasks
</cfquery>
<cfoutput query="it">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = it.id>
	<cfset tmp.class_id = "OBJ_TASK">
	<cfset tmp.parent_id = it.milestone_id>
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT EXPENSES (OBJ_EXPENSE) --->
<cfquery name="iexp" datasource="#session.company.datasource#">
	SELECT id, element_id FROM project_expenses
</cfquery>

<cfoutput query="iexp">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.parent_id = iexp.element_id>
	<cfset tmp.id = iexp.id>
	<cfset tmp.class_id = "OBJ_EXPENSE">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT AUDITS (OBJ_AUDIT) --->
<cfquery name="iaud" datasource="#session.company.datasource#">
	SELECT id, table_id FROM audits
</cfquery>
<cfoutput query="iaud">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	
	<cfset tmp.parent_id = iaud.table_id>
	<cfset tmp.id = iaud.id>
	<cfset tmp.class_id = "OBJ_AUDIT">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT CHANGE ORDERS (OBJ_CHANGE_ORDER) --->
<cfquery name="ico" datasource="#session.company.datasource#">
	SELECT id, project_id FROM change_orders
</cfquery>
<cfoutput query="ico">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = ico.id>
	<cfset tmp.class_id = "OBJ_CHANGE_ORDER">
	<cfset tmp.parent_id = ico.project_id>
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT DOCUMENTS (OBJ_DOCUMENT) --->
<cfquery name="idoc" datasource="#session.company.datasource#">
	SELECT id FROM documents
</cfquery>
<cfoutput query="idoc">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = idoc.id>
	<cfset tmp.class_id = "OBJ_DOCUMENT">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT PARCELS (OBJ_PARCEL) --->
<cfquery name="ipar" datasource="#session.company.datasource#">
	SELECT id FROM parcels
</cfquery>
<cfoutput query="ipar">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = ipar.id>
	<cfset tmp.class_id = "OBJ_PARCEL">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT EMPLOYEES (OBJ_EMPLOYEE) --->
<cfquery name="iemp" datasource="#session.company.datasource#">
	SELECT id FROM employees
</cfquery>
<cfoutput query="iemp">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = iemp.id>
	<cfset tmp.class_id = "OBJ_EMPLOYEE">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>

<!--- IMPORT CUSTOMERS (OBJ_CUSTOMER) --->
<cfquery name="icst" datasource="#session.company.datasource#">
	SELECT id FROM customers
</cfquery>
<cfoutput query="icst">
	<cfset tmp = CreateObject("component", "ptarmigan.object")>
	<cfset tmp.id = icst.id>
	<cfset tmp.class_id = "OBJ_CUSTOMER">
	<cfset tmp.deleted = 0>
	<cfset tmp.create()>
</cfoutput>


