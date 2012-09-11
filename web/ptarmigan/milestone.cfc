<cfcomponent output="false" implements="i_object">

	<cfset this.id = "">
	<cfset this.project_id = "">
	<cfset this.milestone_number = 0>
	<cfset this.milestone_name = "">
	<cfset this.floating = 0>
	<cfset this.start_date = "">
	<cfset this.end_date = "">
	<cfset this.end_date_optimistic = "">
	<cfset this.end_date_pessimistic = "">
	<cfset this.budget = 0>
	<cfset this.color = "">
	<cfset this.completed = 0>
	<cfset this.percent_complete = 0>
	
	<cfset this.members = StructNew()>
	<cfscript>
		this.members['PROJECT_ID'] = StructNew();
		this.members['PROJECT_ID'].type = "object";
		this.members['PROJECT_ID'].class = "OBJ_PROJECT";
		this.members['PROJECT_ID'].label = "Project";
		
		this.members['MILESTONE_NAME'] = StructNew();
		this.members['MILESTONE_NAME'].type = "text";
		this.members['MILESTONE_NAME'].label = "Milestone name";
		
		this.members['FLOATING'] = StructNew();
		this.members['FLOATING'].type = "boolean";
		this.members['FLOATING'].label = "Floating";
		
		this.members['END_DATE_OPTIMISTIC'] = StructNew();
		this.members['END_DATE_OPTIMISTIC'].type = "date";
		this.members['END_DATE_OPTIMISTIC'].label = "End date (optimistic)";
		
		this.members['END_DATE_PESSIMISTIC'] = StructNew();
		this.members['END_DATE_PESSIMISTIC'].type = "date";
		this.members['END_DATE_PESSIMISTIC'].label = "End date (pessimistic)";
		
		this.members['END_DATE'] = StructNew();
		this.members['END_DATE'].type = "date";
		this.members['END_DATE'].label = "End date (normal)";

		this.members['START_DATE'] = StructNew();
		this.members['START_DATE'].type = "date";
		this.members['START_DATE'].label = "Start date";
		
		this.members['COLOR'] = StructNew();
		this.members['COLOR'].type = "color";
		this.members['COLOR'].label = "Color";
		
		this.members['BUDGET'] = StructNew();
		this.members['BUDGET'].type = "money";
		this.members['BUDGET'].label = "Budget";
	
		this.members['COMPLETED'] = StructNew();
		this.members['COMPLETED'].type = "boolean";
		this.members['COMPLETED'].label = "Completed";
		
		this.members['PERCENT_COMPLETE'] = StructNew();
		this.members['PERCENT_COMPLETE'].type = "percentage";
		this.members['PERCENT_COMPLETE'].label = "Percent complete";	
	</cfscript>
	
	<cfset this.written = false>
	
	<cffunction name="member_count" returntype="numeric" access="public" output="false">
		<cfreturn 11>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.milestone_name>
	</cffunction>
	
	<cffunction name="create" returntype="ptarmigan.milestone" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_milestone_create" datasource="#session.company.datasource#">
			INSERT INTO milestones
						(id,
						project_id,
						milestone_number,
						milestone_name,
						floating,
						start_date,
						end_date,
						end_date_pessimistic,
						end_date_optimistic,						
						budget,
						color,
						completed,
						percent_complete)
			VALUES		('#this.id#',
						'#this.project_id#',
						#this.milestone_number#,
						'#UCase(this.milestone_name)#',
						#this.floating#,
						#this.start_date#,
						#this.end_date#,
						#this.end_date_pessimistic#,
						#this.end_date_optimistic#,
						#this.budget#,
						'#this.color#',
						#this.completed#,
						#this.percent_complete#)
		</cfquery>
		
		<cfset session.message = "Milestone #this.milestone_name# added.">
		
		<cfset obj = CreateObject("component", "ptarmigan.object")>
		<cfset obj.id = this.id>
		<cfset obj.parent_id = this.project_id>
		<cfset obj.class_id = "OBJ_MILESTONE">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.milestone" access="public" output="false">
		<cfargument name="id" type="string" required="yes">
		
		<cfquery name="mo" datasource="#session.company.datasource#">
			SELECT * FROM milestones WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.project_id = mo.project_id>
		<cfset this.milestone_number = mo.milestone_number>
		<cfset this.milestone_name = mo.milestone_name>
		<cfset this.floating = mo.floating>
		<cfset this.start_date = mo.start_date>
		<cfset this.end_date = mo.end_date>
		<cfset this.end_date_pessimistic = mo.end_date_pessimistic>
		<cfset this.end_date_optimistic = mo.end_date_optimistic>
		<cfset this.budget = mo.budget>
		<cfset this.color = mo.color>
		<cfset this.completed = mo.completed>
		<cfset this.percent_complete = mo.percent_complete>
				
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.milestone" access="public" output="false">
		
		<cfquery name="mu" datasource="#session.company.datasource#">
			UPDATE milestones
			SET		project_id='#this.project_id#',
					milestone_number=#this.milestone_number#,
					milestone_name='#this.milestone_name#',
					floating=#this.floating#,
					start_date=#this.start_date#,
					end_date=#this.end_date#,
					end_date_pessimistic=#this.end_date_pessimistic#,
					end_date_optimistic=#this.end_date_optimistic#,
					budget=#this.budget#,
					color='#this.color#',
					completed=#this.completed#,
					percent_complete=#this.percent_complete#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset session.message = "Milestone #this.milestone_name# updated.">
		
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>	
		<cfset obj.parent_id = this.project_id>
		<cfset obj.class_id = "OBJ_MILESTONE">
		<cfset obj.deleted = 0>
		
		<cfset obj.update()>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="extend_durations" returntype="ptarmigan.milestone" access="public" output="false">
		<cfargument name="extension_count" type="numeric" required="true">
		<cfargument name="change_order_number" type="string" required="true">
		
			<cfset a = CreateObject("component", "ptarmigan.audit")>
		
			<cfset a.table_name = "milestones">
			<cfset a.table_id = this.id>
			<cfset a.change_order_number = change_order_number>
			<cfset a.employee_id = session.user.id>
			<cfset a.audit_date = CreateODBCDate(Now())>
						
			<cfset a.what_changed = "MILESTONE DURATION EXTENDED BY " & extension_count & " DAYS">
			<cfset a.create()>
			
			<cfset this.end_date = dateAdd("d", extension_count, this.end_date)>						
			<cfset this.end_date_optimistic = dateAdd("d", extension_count, this.end_date_optimistic)>						
			<cfset this.end_date_pessimistic = dateAdd("d", extension_count, this.end_date_pessimistic)>						
			
		<cfreturn this.update()>
	</cffunction>
	
	<cffunction name="increase_budget" returntype="ptarmigan.milestone" access="public" output="false">
		<cfargument name="amount" type="numeric" required="true">
		<cfargument name="change_order_number" type="string" required="true">

			<cfset a = CreateObject("component", "ptarmigan.audit")>
		
			<cfset a.table_name = "milestones">
			<cfset a.table_id = this.id>
			<cfset a.change_order_number = change_order_number>
			<cfset a.employee_id = session.user.id>
			<cfset a.audit_date = CreateODBCDate(Now())>
						
			<cfset a.what_changed = "MILESTONE BUDGET INCREASED BY " & amount & " DAYS">
			<cfset a.create()>
			
			<cfset this.budget = this.budget + amount>
		
		<cfreturn this.update()>		
	</cffunction>	
	
	<cffunction name="last_task_end_date" returntype="date" access="public" output="false">
		<cfquery name="q_last_task_date" datasource="#session.company.datasource#">
			SELECT MAX(end_date) AS last_date FROM tasks WHERE milestone_id='#this.id#'
		</cfquery>
		
		
		<cfif this.floating EQ 0 AND q_last_task_date.recordcount NEQ 0>
			<cfif IsDate(q_last_task_date.last_date)>
				<cfreturn q_last_task_date.last_date>
			<cfelse>
				<cfreturn Now()>
			</cfif>
		<cfelse>
			<cfreturn Now()>
		</cfif>
	</cffunction>

	<cffunction name="tasks" returntype="array" access="public" output="false">
		<cfquery name="q_tasks" datasource="#session.company.datasource#">
			SELECT id FROM tasks WHERE milestone_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_tasks">
			<cfset t = CreateObject("component", "ptarmigan.task").open(id)>
			<cfset tobj = CreateObject("component", "ptarmigan.object").open(id)>
			
			<cfif tobj.deleted EQ 0>
				<cfset ArrayAppend(oa, t)>
			</cfif>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="duration" returntype="numeric" access="public" output="false">
		<cfargument name="type" type="string" required="true">
		
		<cfswitch expression="#type#">
			<cfcase value="normal">
				<cfset d = dateDiff("d", this.start_date, this.end_date) + 1>
			</cfcase>
			<cfcase value="optimistic">
				<cfset d = dateDiff("d", this.start_date, this.end_date_optimistic) + 1>
			</cfcase>
			<cfcase value="pessimistic">
				<cfset d = dateDiff("d", this.start_date, this.end_date_pessimistic) + 1>
			</cfcase>
			<cfcase value="estimated">			
				<cfset d = int((this.duration("optimistic") + (4 * this.duration("normal")) + this.duration("pessimistic")) / 6) + 1>				
			</cfcase>
		</cfswitch>
		
		<cfreturn d>

	</cffunction>
	
	<cffunction name="end_date_estimated" returntype="string" access="public" output="false">		
		<cfset d = DateAdd("d", this.duration("estimated") - 1, this.start_date)>
		
		<cfreturn d>
	</cffunction>
	
	<cffunction name="total_expenses" returntype="numeric" access="public" output="false">
		<cfquery name="te_milestone_exp" datasource="#session.company.datasource#">
			SELECT SUM(amount) AS exp_this_milestone
			FROM	project_expenses
			WHERE	element_table='milestones'
			AND 	element_id='#this.id#'
		</cfquery>
		
		<cfset tsks = this.tasks()>
		<cfset tsks_total = 0>
		
		<cfloop array="#tsks#" index="t">
			<cfset tsks_total = tsks_total + t.total_expenses()>
		</cfloop>
		
		<cfif te_milestone_exp.recordcount gt 0>
			<cfif IsNumeric(te_milestone_exp.exp_this_milestone)>
				<cfreturn te_milestone_exp.exp_this_milestone + tsks_total>
			<cfelse>
				<cfreturn 0>
			</cfif>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="expenses" returntype="array" access="public" output="false">
		<cfquery name="expenses" datasource="#session.company.datasource#">
			SELECT id FROM project_expenses
			WHERE	element_table='milestones'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="expenses">
			<cfset t = CreateObject("component", "ptarmigan.expense").open(expenses.id)>
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="documents" returntype="array" access="public" output="false">
		<cfquery name="q_docs" datasource="#session.company.datasource#">
			SELECT	document_id
			FROM	document_associations
			WHERE	element_table='milestones'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_docs">
			<cfset d = CreateObject("component", "ptarmigan.document").open(document_id)>
			<cfset ArrayAppend(oa, d)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="project" returntype="ptarmigan.project" access="public" output="false">
		<cfreturn CreateObject("component", "ptarmigan.project").open(this.project_id)>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d_m" datasource="#session.company.datasource#">
			DELETE FROM milestones WHERE id='#this.id#'
		</cfquery>
	</cffunction>
</cfcomponent>