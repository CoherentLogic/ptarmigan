<cfmodule template="../security/require.cfm" type="project">
<cfset document = CreateObject("component", "ptarmigan.document").open(attributes.id)>
<cfswitch expression="#attributes.type#">
	<cfcase value="parcels">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, parcel_id AS field_name FROM parcels ORDER BY parcel_id
		</cfquery>
	</cfcase>
	<cfcase value="customers">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, company_name AS field_name FROM customers ORDER BY company_name
		</cfquery>
	</cfcase>
	<cfcase value="employees">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, CONCAT(last_name,', ',honorific,' ',first_name,' ',middle_initial,' ',suffix) AS field_name FROM employees ORDER BY last_name, first_name
		</cfquery>	
	</cfcase>
	<cfcase value="projects">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, project_name AS field_name FROM projects ORDER BY project_name
		</cfquery>
	</cfcase>
	<cfcase value="milestones">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, milestone_name AS field_name FROM milestones ORDER BY milestone_name
		</cfquery>	
	</cfcase>
	<cfcase value="tasks">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, task_name AS field_name FROM tasks ORDER BY task_name
		</cfquery>			
	</cfcase>
	<cfcase value="expenses">
		<cfquery name="q" datasource="#session.company.datasource#">
			SELECT id, recipient AS field_name FROM project_expenses ORDER BY expense_date
		</cfquery>	
	</cfcase>
</cfswitch>

<div style="width:100%;height:400px;overflow:auto;">
<table width="100%" style="margin:0;" class="pretty">
	<tr>
		<th>&nbsp;</th>
		<th>NAME</th>
		<th>
			<cfif attributes.type EQ "milestones">
				PROJECT
			</cfif>
			<cfif attributes.type EQ "projects">
				CUSTOMER
			</cfif>
			<cfif attributes.type EQ "tasks">			
				PROJECT
			</cfif>
			<cfif attributes.type EQ "expenses">			
				PROJECT
			</cfif>
			<cfif attributes.type EQ "parcels">
				PHYSICAL ADDRESS
			</cfif>

		</th>
		<th>
			<cfif attributes.type EQ "tasks">
				MILESTONE
			</cfif>
			<cfif attributes.type EQ "expenses">
				MILESTONE/TASK
			</cfif>
			<cfif attributes.type EQ "parcels">
				LINK
			</cfif>
		</th>
	</tr>
	<cfoutput query="q">
		<cfset c_id = CreateUUID()>
		<tr>
			<td><input type="checkbox" id="#c_id#" <cfif document.associated(attributes.type, q.id) EQ true>checked</cfif> 
			onclick="associate_file('#session.root_url#', '#c_id#', '#document.id#', '#attributes.type#', '#id#');">
			</td>
			<td>
				
				#q.field_name#&nbsp;
				<cfif attributes.type EQ "expenses">
					<cfset e = CreateObject("component", "ptarmigan.expense").open(id)>
					[#numberFormat(e.amount, ",_$___.__")#]
				</cfif>
			</td>
			<td>
				<cfif attributes.type EQ "milestones">
					<cfset ms = CreateObject("component", "ptarmigan.milestone").open(id)>
					<cfset p = CreateObject("component", "ptarmigan.project").open(ms.project_id)>
					#p.project_name#
				</cfif>
				<cfif attributes.type EQ "projects">
					<cfset p = CreateObject("component", "ptarmigan.project").open(id)>					
					#p.customer().company_name#
				</cfif>
				<cfif attributes.type EQ "tasks">
					<cfset t = CreateObject("component", "ptarmigan.task").open(id)>
					<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
					<cfset p = CreateObject("component", "ptarmigan.project").open(ms.project_id)>
					#p.project_name#
				</cfif>	
				
				<cfif attributes.type EQ "expenses">
					<cfset e = CreateObject("component", "ptarmigan.expense").open(id)>
					<cfif e.element_table EQ "milestones">
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(e.element_id)>
						<cfset p = CreateObject("component", "ptarmigan.project").open(ms.project_id)>
						#p.project_name# [MILESTONE EXPENSE]
					<cfelse>
						<cfset t = CreateObject("component", "ptarmigan.task").open(e.element_id)>
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
						<cfset p = CreateObject("component", "ptarmigan.project").open(ms.project_id)>
						#p.project_name# [TASK EXPENSE]												
					</cfif>
				</cfif>
				<cfif attributes.type EQ "parcels">
					<cfset p = CreateObject("component", "ptarmigan.parcel").open(id)>
					#p.owner_name#<br>
					#p.physical_address#<br>#p.physical_city# #p.physical_state# #p.physical_zip#
				</cfif>
			</td>
			<td>
				<cfif attributes.type EQ "tasks">
					<cfset t = CreateObject("component", "ptarmigan.task").open(id)>
					<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
					#ms.milestone_name#
				</cfif>	
				<cfif attributes.type EQ "expenses">
					<cfset e = CreateObject("component", "ptarmigan.expense").open(id)>
					<cfif e.element_table EQ "milestones">
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(e.element_id)>
						<cfset p = CreateObject("component", "ptarmigan.project").open(ms.project_id)>
						#ms.milestone_name# [MILESTONE]
					<cfelse>
						<cfset t = CreateObject("component", "ptarmigan.task").open(e.element_id)>
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
						<cfset p = CreateObject("component", "ptarmigan.project").open(ms.project_id)>
						#t.task_name# [TASK]												
					</cfif>
				</cfif>			
				<cfif attributes.type EQ "parcels">
					<a href="#session.root_url#/parcels/manage_parcel.cfm?id=#id#">View parcel</a>
				</cfif>
			</td>
		</tr>
	</cfoutput>
</table>
</div>