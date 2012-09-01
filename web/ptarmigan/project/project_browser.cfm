<cfset project = CreateObject("component", "ptarmigan.project").open(attributes.id)>
<cfset milestones = project.milestones()>
<cfset parcels = project.parcels()>

<cfform>
	<cftree format="html" name="all_objects" width="400">
		<cftreeitem display="Milestones" value="milestones_parent" expand="true" img="folder">
		<cfloop array="#milestones#" index="ms">
			<cftreeitem display="#ms.milestone_name#" value="#ms.id#_ms_parent" parent="milestones_parent" expand="false" img="../images/milestone.png" href="javascript:edit_milestone('#session.root_url#', '#ms.id#');">
			<cftreeitem display="Tasks" value="#ms.id#_tasks_parent" parent="#ms.id#_ms_parent" expand="false" img="folder">
			<cfset tasks = ms.tasks()>
			<cfloop array="#tasks#" index="t">
				<cftreeitem display="#t.task_name#" value="#t.id#_parent" parent="#ms.id#_tasks_parent" expand="false" img="../images/task.png" href="javascript:edit_task('#session.root_url#', '#t.id#', '#t.id#');">
				
				<cftreeitem display="Documents" value="#t.id#_documents" parent="#t.id#_parent" expand="false" img="folder">
				<cfset documents = t.documents()>
				<cfloop array="#documents#" index="d">
					<cftreeitem value="#d.id#" parent="#t.id#_documents" display="#d.document_number#: #d.document_name#" img="../images/document.png" href="#session.root_url#/documents/manage_document.cfm?id=#d.id#">
				</cfloop> <!--- documents within task --->
				
				<cftreeitem display="Expenses" value="#t.id#_expenses" parent="#t.id#_parent" expand="false" img="folder">
				<cfset expenses = t.expenses()>
				<cfloop array="#expenses#" index="e">
					<cftreeitem value="#e.id#" href="javascript:edit_expense('#session.root_url#', '#e.id#');" parent="#t.id#_expenses" display="#dateFormat(e.expense_date, 'm/dd/yyyy')#: #e.recipient# (#numberFormat(e.amount, ',_$___.__')#)" img="../images/expense.png">
				</cfloop> <!--- expenses within task --->
				
			</cfloop> <!--- tasks within milestone --->
			
			<cftreeitem display="Documents" value="#ms.id#_ms_documents" parent="#ms.id#_ms_parent" expand="false" img="folder">
			<cfset documents = ms.documents()>
			<cfloop array="#documents#" index="d">
				<cftreeitem value="#d.id#" parent="#ms.id#_ms_documents" display="#d.document_number#: #d.document_name#" img="../images/document.png" href="#session.root_url#/documents/manage_document.cfm?id=#d.id#">
			</cfloop> <!--- documents within milestone --->
			
			<cftreeitem display="Expenses" value="#ms.id#_ms_expenses" parent="#ms.id#_ms_parent" expand="false" img="folder">
			<cfset expenses = ms.expenses()>
			<cfloop array="#expenses#" index="e">
				<cftreeitem value="#e.id#"  href="javascript:edit_expense('#session.root_url#', '#e.id#');"  parent="#ms.id#_ms_expenses" display="#dateFormat(e.expense_date, 'm/dd/yyyy')#: #e.recipient# (#numberFormat(e.amount, ',_$___.__')#)" img="../images/expense.png">
			</cfloop> <!--- expenses within milestone --->			
		</cfloop> <!--- milestones within project --->
		
		<cftreeitem display="Documents" value="documents_parent" img="folder">
		<cfset documents = project.documents()>
		<cfloop array="#documents#" index="d">
			<cftreeitem value="#d.id#" parent="documents_parent" display="#d.document_number#: #d.document_name#" img="../images/document.png" href="#session.root_url#/documents/manage_document.cfm?id=#d.id#">
		</cfloop> <!--- documents within project --->
		<cftreeitem display="Parcels" value="parcels_parent" img="folder">
		<cfloop array="#parcels#" index="parc">
			<cftreeitem value="#parc.id#" parent="parcels_parent" display="#parc.parcel_id#" img="../images/parcel.png" href="#session.root_url#/parcels/manage_parcel.cfm?id=#parc.id#">
		</cfloop>
	</cftree>
</cfform>