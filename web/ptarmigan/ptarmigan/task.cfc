<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	<cfset this.project_id = "">
	<cfset this.task_name = "">
	<cfset this.description = "">
	<cfset this.completed = 0>
	<cfset this.start_date = CreateODBCDate(Now())>
	<cfset this.end_date = CreateODBCDate(Now())>
	<cfset this.budget = "">
	<cfset this.color = "">
	<cfset this.percent_complete = 0>
	<cfset this.earliest_start = 0>
	<cfset this.earliest_end = 0>
	<cfset this.latest_start = 0>
	<cfset this.latest_end = 0>
	<cfset this.start = 0>
	<cfset this.stop = 0>
	<cfset this.duration = 0>
	<cfset this.constraint_date = CreateODBCDate(Now())>
	<cfset this.deadline = CreateODBCDate(Now())>
	<cfset this.constraint_id = "SASAP">
	<cfset this.task_group = "">
	<cfset this.scheduled = 0>
	<cfset this.critical = 0>
	
	<cfset this.fields = ArrayNew(1)>
	<cfset field = StructNew()>
	<cfscript>
		this.members['PROJECT_ID'] = StructNew();
		this.members['PROJECT_ID'].type = "object";
		this.members['PROJECT_ID'].class = "OBJ_PROJECT";
		this.members['PROJECT_ID'].label = "Project";
		
		this.members['TASK_NAME'] = StructNew();
		this.members['TASK_NAME'].type = "text";
		this.members['TASK_NAME'].label = "Task name";
				
		this.members['END_DATE'] = StructNew();
		this.members['END_DATE'].type = "date";
		this.members['END_DATE'].label = "End date (normal)";

		this.members['START_DATE'] = StructNew();
		this.members['START_DATE'].type = "date";
		this.members['START_DATE'].label = "Start date";
		
		this.members['COLOR'] = StructNew();
		this.members['COLOR'].type = "color";
		this.members['COLOR'].label = "Chart color";
		
		this.members['BUDGET'] = StructNew();
		this.members['BUDGET'].type = "money";
		this.members['BUDGET'].label = "Budget";					
		
		this.members['COMPLETED'] = StructNew();
		this.members['COMPLETED'].type = "boolean";
		this.members['COMPLETED'].label = "Complete";
		
		this.members['SCHEDULED'] = StructNew();
		this.members['SCHEDULED'].type = "boolean";
		this.members['SCHEDULED'].label = "Scheduled";
		
		this.members['DESCRIPTION'] = StructNew();
		this.members['DESCRIPTION'].type = "text";
		this.members['DESCRIPTION'].label = "Description";

		this.members['PERCENT_COMPLETE'] = StructNew();
		this.members['PERCENT_COMPLETE'].type = "percentage";
		this.members['PERCENT_COMPLETE'].label = "Description";		
		
		this.members['DURATION'] = StructNew();
		this.members['DURATION'].type = "number";
		this.members['DURATION'].label = "Task duration";		

		this.members['CONSTRAINT_ID'] = StructNew();
		this.members['CONSTRAINT_ID'].type = "object";
		this.members['CONSTRAINT_ID'].label = "Constraint";		
		this.members['CONSTRAINT_ID'].class = "OBJ_TASK_CONSTRAINT";		

		this.members['DEADLINE'] = StructNew();
		this.members['DEADLINE'].type = "date";
		this.members['DEADLINE'].label = "Description";		

		this.members['CONSTRAINT_DATE'] = StructNew();
		this.members['CONSTRAINT_DATE'].type = "date";
		this.members['CONSTRAINT_DATE'].label = "Constraint date";		
		
		this.members['TASK_GROUP'] = StructNew();
		this.members['TASK_GROUP'].type = "text";
		this.members['TASK_GROUP'].label = "Task group";		
		
		
	</cfscript>
	<cfloop array="#this.fields#" index="field">
		<cfset field.name = UCase(field.name)>
	</cfloop>
	
	<cfset this.written = false>
	
	<cffunction name="member_count" returntype="numeric" access="public" output="false">
		<cfreturn 9>
	</cffunction>
	
	<cffunction name="create" returntype="ptarmigan.task" access="public" output="false">
	
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_task_create" datasource="#session.company.datasource#">
			INSERT INTO tasks
						(id,
						project_id,
						task_name,
						description,
						completed,
						percent_complete,
						start_date,
						end_date,
						budget,
						color,
						task_group,
						duration,
						constraint_id,
						deadline,
						constraint_date,
						scheduled,
						earliest_start,
						earliest_end,
						latest_start,
						latest_end, 
						start,
						stop,
						critical)
			VALUES		('#this.id#',
						'#this.project_id#',
						'#UCase(this.task_name)#',
						'#UCase(this.description)#',
						#this.completed#,
						#this.percent_complete#,
						#this.start_date#,
						#this.end_date#,
						#this.budget#,
						'#this.color#',
						'#this.task_group#',
						#this.duration#,
						'#this.constraint_id#',
						#CreateODBCDate(this.deadline)#,
						#CreateODBCDate(this.constraint_date)#,
						#this.scheduled#,
						#this.earliest_start#,
						#this.earliest_end#,
						#this.latest_start#,
						#this.latest_end#,
						#this.start#,
						#this.stop#,
						#this.critical#)
		</cfquery>
		<cfset session.message = "Task #this.task_name# added.">
		
		<cfset obj = CreateObject("component", "ptarmigan.object")>
		<cfset obj.id = this.id>
		<cfset obj.parent_id = this.project_id>
		<cfset obj.class_id = "OBJ_TASK">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.task" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="t" datasource="#session.company.datasource#">
			SELECT * FROM tasks WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#id#">
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.project_id = t.project_id>
		<cfset this.task_name = t.task_name>
		<cfset this.description = t.description>
		<cfset this.completed = t.completed>
		<cfset this.percent_complete = t.percent_complete>
		<cfset this.start_date = t.start_date>
		<cfset this.end_date = t.end_date>
		<cfset this.budget = t.budget>
		<cfset this.color = t.color>
		<cfset this.task_group = t.task_group>
		<cfset this.duration = t.duration>
		<cfset this.constraint_id = t.constraint_id>
		<cfset this.deadline = t.deadline>
		<cfset this.constraint_date = t.constraint_date>		
		<cfset this.scheduled = t.scheduled>
		<cfset this.earliest_start = t.earliest_start>
		<cfset this.earliest_end = t.earliest_end>
		<cfset this.latest_start = t.latest_start>
		<cfset this.latest_end = t.latest_end>
		<cfset this.start = t.start>
		<cfset this.stop = t.stop>
		<cfset this.critical = t.critical>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.task" access="public" output="false">
		
		<cfquery name="q_task_update" datasource="#session.company.datasource#">
			UPDATE tasks
			SET		project_id='#this.project_id#',
					task_name='#UCase(this.task_name)#',
					description='#UCase(this.description)#',
					completed=#this.completed#,
					percent_complete=#this.percent_complete#,
					start_date=#this.start_date#,
					end_date=#this.end_date#,
					budget=#this.budget#,
					color='#this.color#',
					task_group='#this.task_group#',
					duration=#this.duration#,
					constraint_id='#this.constraint_id#',
					deadline=#CreateODBCDate(this.deadline)#,
					constraint_date=#CreateODBCDate(this.constraint_date)#,
					scheduled=#this.scheduled#,
					earliest_start=#this.earliest_start#,
					earliest_end=#this.earliest_end#,
					latest_start=#this.latest_start#,
					latest_end=#this.latest_end#,
					start=#this.start#,
					stop=#this.stop#,
					critical=#this.critical#
			WHERE	id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset session.message = "Task #this.task_name# updated.">
		
		<cfset this.written = true>
	
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>
		<cfset obj.parent_id = this.project_id>	
		<cfset obj.deleted = 0>
		
		<cfset obj.update()>
	
		<cfreturn this>
	</cffunction>
	
	<cffunction name="extend_durations" returntype="ptarmigan.task" access="public" output="false">
		<cfargument name="extension_count" type="numeric" required="true">
		<cfargument name="change_order_number" type="string" required="true">
		
			<cfset a = CreateObject("component", "ptarmigan.audit")>
		
			<cfset a.table_name = "tasks">
			<cfset a.table_id = this.id>
			<cfset a.change_order_number = change_order_number>
			<cfset a.employee_id = session.user.id>
			<cfset a.audit_date = CreateODBCDate(Now())>
						
			<cfset a.what_changed = "TASK DURATION EXTENDED BY " & extension_count & " DAYS">
			<cfset a.create()>
			
			<cfset this.end_date = dateAdd("d", extension_count, this.end_date)>						
			
		<cfreturn this.update()>
	</cffunction>
	
	<cffunction name="increase_budget" returntype="ptarmigan.task" access="public" output="false">
		<cfargument name="amount" type="numeric" required="true">
		<cfargument name="change_order_number" type="string" required="true">

			<cfset a = CreateObject("component", "ptarmigan.audit")>
		
			<cfset a.table_name = "tasks">
			<cfset a.table_id = this.id>
			<cfset a.change_order_number = change_order_number>
			<cfset a.employee_id = session.user.id>
			<cfset a.audit_date = CreateODBCDate(Now())>
						
			<cfset a.what_changed = "TASK BUDGET INCREASED BY " & amount & " DAYS">
			<cfset a.create()>
			
			<cfset this.budget = this.budget + amount>
		
		<cfreturn this.update()>		
	</cffunction>
	
	<cffunction name="predecessors" returntype="array" access="public" output="false">
		<cfquery name="get_pred" datasource="#session.company.datasource#">
			SELECT predecessor_id FROM task_dependencies 
			WHERE successor_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">			
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="get_pred">
			<cfset t = CreateObject("component", "ptarmigan.task").open(get_pred.predecessor_id)>
			<cfif t.task_name NEQ "">
				<cfset ArrayAppend(oa, t)>
			</cfif>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="add_predecessor" returntype="void" output="false" access="public">
		<cfargument name="task_id" type="string" required="true">
		
		<cfset dep_id = CreateUUID()>
		<cfquery name="q_add_pred" datasource="#session.company.datasource#">
			INSERT INTO task_dependencies
							(id,
							successor_id,
							predecessor_id)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#dep_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#task_id#">)
		</cfquery>
	</cffunction>
	
	<cffunction name="delete_predecessor" returntype="void" output="false" access="public">
		<cfargument name="task_id" type="string" required="true">
		
		<cfquery name="q_del_pred" datasource="#session.company.datasource#">
			DELETE FROM task_dependencies
			WHERE	successor_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
			AND		predecessor_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#task_id#">
		</cfquery>
	</cffunction>

	<cffunction name="successors" returntype="array" access="public" output="false">
		<cfquery name="get_suc" datasource="#session.company.datasource#">
			SELECT successor_id FROM task_dependencies 
			WHERE predecessor_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">			
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="get_suc">
			<cfset t = CreateObject("component", "ptarmigan.task").open(get_suc.successor_id)>
			<cfif t.task_name NEQ "">
				<cfset ArrayAppend(oa, t)>
			</cfif>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="duration" returntype="numeric" access="public" output="false">	
		<cfreturn this.duration>
	</cffunction>
		
	<cffunction name="total_expenses" returntype="numeric" access="public" output="false">
	
		<cfquery name="te" datasource="#session.company.datasource#">
			SELECT	SUM(amount) AS task_total
			FROM	project_expenses
			WHERE	element_table='tasks'
			AND		element_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfif te.recordcount GT 0>
			<cfif IsNumeric(te.task_total)>
				<cfreturn te.task_total>
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
			WHERE	element_table='tasks'
			AND		element_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="expenses">
			<cfset t = CreateObject("component", "ptarmigan.expense").open(expenses.id)>
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
		
	
	<cffunction name="project" returntype="ptarmigan.project" access="public" output="false">		
		<cfset obj = CreateObject("component", "ptarmigan.project").open(this.project_id)>
		<cfreturn obj>
	</cffunction>
	
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.task_name>
	</cffunction>

	<cffunction name="search_result" returntype="void" access="public" output="true"></cffunction>

	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM tasks WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
	</cffunction>
</cfcomponent>