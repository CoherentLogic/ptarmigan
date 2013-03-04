<cfcomponent output="false" implements="ptarmigan.i_object">
	
	<cfset this.id = "">
	<cfset this.project_number = "">
	<cfset this.project_name = "">
	<cfset this.instructions = "">
	<cfset this.due_date = CreateODBCDate(Now())>
	<cfset this.current_milestone = 1>
	<cfset this.customer_id = "">
	<cfset this.created_by = "">
	<cfset this.tax_rate = 0>
	<cfset this.start_date = CreateODBCDate(Now())>
	<cfset this.budget = 0>
	
	<cfset this.members = StructNew()>
	
	
	<cfscript>
		this.members['PROJECT_NUMBER'] = StructNew();
		this.members['PROJECT_NUMBER'].type = "text";
		this.members['PROJECT_NUMBER'].label = "Project number";
		
		this.members['PROJECT_NAME'] = StructNew();
		this.members['PROJECT_NAME'].type = "text";
		this.members['PROJECT_NAME'].label = "Project name";
		
		this.members['INSTRUCTIONS'] = StructNew();
		this.members['INSTRUCTIONS'].type = "text";
		this.members['INSTRUCTIONS'].label ="Instructions";
			
		this.members['DUE_DATE'] = StructNew();
		this.members['DUE_DATE'].type = "date";
		this.members['DUE_DATE'].label = "End date (normal)";
		
		this.members['CUSTOMER_ID'] = StructNew();
		this.members['CUSTOMER_ID'].type = "object";
		this.members['CUSTOMER_ID'].class = "OBJ_CUSTOMER";
		this.members['CUSTOMER_ID'].label = "Customer";		

		this.members['CREATED_BY'] = StructNew();
		this.members['CREATED_BY'].type = "object";
		this.members['CREATED_BY'].class = "OBJ_EMPLOYEE";
		this.members['CREATED_BY'].label = "Created by";		
		
		this.members['TAX_RATE'] = StructNew();
		this.members['TAX_RATE'].type = "percentage";
		this.members['TAX_RATE'].label = "Tax rate";

		this.members['START_DATE'] = StructNew();
		this.members['START_DATE'].type = "date";
		this.members['START_DATE'].label = "Start date";

		this.members['BUDGET'] = StructNew();
		this.members['BUDGET'].type = "money";
		this.members['BUDGET'].label = "Budget";
	</cfscript>

	<cfset this.written = false>
	
	<cffunction name="member_count" returntype="numeric" access="public" output="false">
		<cfreturn 11>
	</cffunction>
	
	<cffunction name="schedule" returntype="void" access="public" output="false">
		<cfset tsks = this.tasks()>
		<cfloop array="#tsks#" index="t">
			<cfset t.earliest_start = 0>
			<cfset t.earliest_end = 0>
			<cfset t.latest_start = 0>
			<cfset t.latest_end = 0>
			<cfset t.update()>
		</cfloop>
		
		<cfset this.calc_critical_path()>
		
		<cfloop array="#this.tasks()#" index="t">
			<cfswitch expression="#t.constraint_id#">
				<cfcase value="SASAP">
					<cfset t.start_date = dateAdd("d", t.earliest_start, this.start_date)>
					<cfset t.end_date = dateAdd("d", t.earliest_end - 1, this.start_date)>
				</cfcase>
				<cfcase value="SALAP">
					<cfset t.start_date = dateAdd("d", t.latest_start, this.start_date)>
					<cfset t.end_date = dateAdd("d", t.latest_end - 1, this.start_date)>				
				</cfcase>
				<cfcase value="FNET">
					<cfset t.end_date = t.constraint_date>
					<cfset t.start_date = dateAdd("d", -t.duration + 1, t.end_date)>
				</cfcase>
				<cfcase value="FNLT">
					<cfset t.end_date = t.constraint_date>
					<cfset t.start_date = dateAdd("d", -t.duration, t.end_date)>				
				</cfcase>
				<cfcase value="MF">
					<cfset t.end_date = t.constraint_date>
					<cfset t.start_date = dateAdd("d", -t.duration, t.end_date)>
				</cfcase>
				<cfcase value="MS">
					<cfset t.start_date = t.constraint_date>
					<cfset t.end_date = dateAdd("d", t.duration, t.start_date)>				
				</cfcase>
				<cfcase value="SNET">
					<cfset t.start_date = t.constraint_date>
					<cfset t.end_date = dateAdd("d", t.duration, t.start_date)>								
				</cfcase>
				<cfcase value="SNLT">
					<cfset t.start_date = t.constraint_date>
					<cfset t.end_date = dateAdd("d", t.duration, t.start_date)>				
				</cfcase>
			</cfswitch>
			<cfset t.update()>
		</cfloop>
	</cffunction>
	
	<cffunction name="calc_earliest_times" returntype="void" access="public">
		<cfargument name="position" type="ptarmigan.task" required="true">

		<cfset position.earliest_end = position.earliest_start + position.duration>		
		<cfset position.update()>
		
		<cfloop array="#position.successors()#" index="successor">
			<cfif successor.earliest_start LT position.earliest_end>
				<cfset successor.earliest_start = position.earliest_end>
				<cfset successor.update()>
			</cfif>
			<cfset this.calc_earliest_times(successor)>
		</cfloop>
				
	</cffunction>

	<cffunction name="calc_latest_times" returntype="void" access="public">
		<cfargument name="position" type="ptarmigan.task" required="true">
		
		<cfloop array="#position.predecessors()#" index="predecessor">
			<cfif predecessor.latest_end EQ 0>			
				<cfset predecessor.latest_end = position.latest_start>
				<cfset predecessor.latest_start = predecessor.latest_end - predecessor.duration>
				
				<cfset predecessor.update()>
			</cfif>
			<cfset this.calc_latest_times(predecessor)>
		</cfloop>
		
	</cffunction>

	<cffunction name="calc_critical_path" returntype="void" access="public" output="false">
		<cfset this.calc_earliest_times(this.start_task())>
		<cfset stoptask = this.stop_task()>
		<cfset stoptask.latest_end = stoptask.earliest_end>
		<cfset stoptask.latest_start = stoptask.latest_end - stoptask.duration>
		<cfset stoptask.update()>
		
		<cfset this.calc_latest_times(this.stop_task())>

		<cfloop array="#this.tasks()#" index="activity">
			<cfif (activity.earliest_end EQ activity.latest_end) AND (activity.earliest_start EQ activity.latest_start)>
				<cfset activity.critical = 1>
			<cfelse>
				<cfset activity.critical = 0>
			</cfif>
			<cfset activity.update()>
		</cfloop>
	</cffunction>

	<cffunction name="start_task" returntype="ptarmigan.task" access="public" output="false">
		<cfloop array="#this.tasks()#" index="tsk">
			<cfif tsk.start EQ 1>
				<cfreturn tsk>
			</cfif>
		</cfloop>
		<cfthrow message="No start task defined.">
	</cffunction>

	<cffunction name="stop_task" returntype="ptarmigan.task" access="public" output="false">
		<cfloop array="#this.tasks()#" index="tsk">
			<cfif tsk.stop EQ 1>
				<cfreturn tsk>
			</cfif>
		</cfloop>
		<cfthrow message="No stop task defined.">
	</cffunction>
	
	<cffunction name="get_duration" returntype="numeric" access="public" output="false">
		<cfreturn  dateDiff("d", this.start_date, this.stop_task().end_date)>
	</cffunction>
	
	<cffunction name="create" returntype="ptarmigan.project" access="public" output="false">
		
		<cflock scope="application" throwontimeout="true" timeout="40">
			<cfset this.id = CreateUUID()>
			<cfset this.project_number = this.next_project_number()>
			
			<cfquery name="q_project_create" datasource="#session.company.datasource#">
				INSERT INTO projects 
							(id,
							project_number,
							project_name,
							instructions,
							due_date,														
							customer_id,
							created_by,
							tax_rate,
							start_date,
							budget)
				VALUES		(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="12" value="#this.project_number#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.project_name#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" maxlength="5000" value="#this.instructions#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#this.due_date#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.customer_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.created_by#">,
							<cfqueryparam cfsqltype="cf_sql_real" value="#this.tax_rate#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#this.start_date#">,
							<cfqueryparam cfsqltype="cf_sql_real" value="#this.budget#">)
			</cfquery>
		</cflock>
				
		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_PROJECT">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
		<cfset starttask = CreateObject("component", "ptarmigan.task")>

		<cfset starttask.project_id = this.id>
		<cfset starttask.task_name = "Start Project">
		<cfset starttask.description = "Starting task for this project">
		<cfset starttask.completed = 0>
		<cfset starttask.start_date = CreateODBCDate(this.start_date)>
		<cfset starttask.end_date = CreateODBCDate(dateAdd("d", 1, this.start_date))>
		<cfset starttask.budget = 1>
		<cfset starttask.color = "gray">
		<cfset starttask.percent_complete = 0>
		<cfset starttask.earliest_start = 0>
		<cfset starttask.earliest_end = 1>
		<cfset starttask.latest_start = 0>
		<cfset starttask.latest_end = 1>
		<cfset starttask.start = 1>
		<cfset starttask.stop = 0>
		<cfset starttask.duration = 1>
		<cfset starttask.constraint_date = CreateODBCDate(this.start_date)>
		<cfset starttask.deadline = CreateODBCDate(dateadd("d", 1, this.start_date))>
		<cfset starttask.constraint_id = "SASAP">
		<cfset starttask.task_group = "">
		<cfset starttask.scheduled = 0>
		<cfset starttask.critical = 1>
		
		<cfset starttask.create()>
		
		<cfset stoptask = CreateObject("component", "ptarmigan.task")>

		<cfset stoptask.project_id = this.id>
		<cfset stoptask.task_name = "Stop Project">
		<cfset stoptask.description = "Ending task for this project">
		<cfset stoptask.completed = 0>
		<cfset stoptask.start_date = CreateODBCDate(dateAdd("d", -1, this.due_date))>
		<cfset stoptask.end_date = CreateODBCDate(this.due_date)>
		<cfset stoptask.budget = 1>
		<cfset stoptask.color = "gray">
		<cfset stoptask.percent_complete = 0>
		<cfset stoptask.earliest_start = 0>
		<cfset stoptask.earliest_end = 0>
		<cfset stoptask.latest_start = 0>
		<cfset stoptask.latest_end = 0>
		<cfset stoptask.start = 0>
		<cfset stoptask.stop = 1>
		<cfset stoptask.duration = 1>
		<cfset stoptask.constraint_date = CreateODBCDate(this.start_date)>
		<cfset stoptask.deadline = CreateODBCDate(this.due_date)>
		<cfset stoptask.constraint_id = "SASAP">
		<cfset stoptask.task_group = "">
		<cfset stoptask.scheduled = 0>
		<cfset stoptask.critical = 1>
		
		<cfset stoptask.create()>
		
		<cfset stoptask.add_predecessor(starttask.id)>
		
		<cfset session.message = "Project #this.project_name# added.">
		
		<cfreturn this>
		
	</cffunction>
	
	<cffunction name="next_project_number" returntype="string" access="public" output="false">
	
		<cfquery name="gpn" datasource="#session.company.datasource#">
			SELECT MAX(LEFT(project_number, 3)) AS max_pn FROM projects
		</cfquery>
		
		
		
		<cfif gpn.RecordCount GT 0>
			<cfif gpn.max_pn NEQ "">
				<cfset max_current = gpn.max_pn + 1>
			<cfelse>
				<cfset max_current = 100>
			</cfif>
		<cfelse>
			<cfset max_current = 100>
		</cfif>
		
	
		<cfset retval = "#max_current#-#dateFormat(now(), 'YYYYMMDD')#">

		<cfreturn retval>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.project" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="op" datasource="#session.company.datasource#">
			SELECT * FROM projects WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.project_number = op.project_number>
		<cfset this.project_name = op.project_name>		
		<cfset this.instructions = op.instructions>
		<cfset this.due_date = op.due_date>
		<cfset this.customer_id = op.customer_id>
		<cfset this.created_by = op.created_by>
		<cfset this.start_date = op.start_date>
		<cfset this.budget = op.budget>
		
		<cfset this.written = true>
		<cfset session.message = "Project #this.project_name# opened.">
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.project" access="public" output="false">
		
		<cfquery name="q_update_project" datasource="#session.company.datasource#">
			UPDATE projects
			SET		project_number='#this.project_number#',
					project_name='#this.project_name#',
					instructions='#this.instructions#',
					due_date=#this.due_date#,
					customer_id='#this.customer_id#',
					tax_rate=#this.tax_rate#,
					start_date=#this.start_date#,
					budget=#this.budget#
			WHERE	id='#this.id#'
		</cfquery>
		<cfset session.message = "Project #this.project_name# updated.">
		
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>			
		<cfset obj.deleted = 0>
		
		<cfset obj.update()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="extend_durations" returntype="ptarmigan.project" access="public" output="false">
		<cfargument name="extension_count" type="numeric" required="true">
		<cfargument name="change_order_number" type="string" required="true">
		
			<cfset a = CreateObject("component", "ptarmigan.audit")>
		
			<cfset a.table_name = "projects">
			<cfset a.table_id = this.id>
			<cfset a.change_order_number = change_order_number>
			<cfset a.employee_id = session.user.id>
			<cfset a.audit_date = CreateODBCDate(Now())>
						
			<cfset a.what_changed = "PROJECT DURATION EXTENDED BY " & extension_count & " DAYS">
			<cfset a.create()>
			
			<cfset this.due_date = dateAdd("d", extension_count, this.due_date)>						
			
		<cfreturn this.update()>
	</cffunction>

	<cffunction name="increase_budget" returntype="ptarmigan.project" access="public" output="false">
		<cfargument name="amount" type="numeric" required="true">
		<cfargument name="change_order_number" type="string" required="true">

			<cfset a = CreateObject("component", "ptarmigan.audit")>
		
			<cfset a.table_name = "project">
			<cfset a.table_id = this.id>
			<cfset a.change_order_number = change_order_number>
			<cfset a.employee_id = session.user.id>
			<cfset a.audit_date = CreateODBCDate(Now())>
						
			<cfset a.what_changed = "PROJECT BUDGET INCREASED BY " & amount & " DAYS">
			<cfset a.create()>
			
			<cfset this.budget = this.budget + amount>
		
		<cfreturn this.update()>		
	</cffunction>	
	
	<cffunction name="customer" returntype="ptarmigan.customer" access="public" output="false">
		<cfset t = CreateObject("component", "ptarmigan.customer").open(this.customer_id)>
		
		<cfreturn t>
	</cffunction>

	
	<cffunction name="tasks" returntype="array" access="public" output="false">
		<cfquery name="q_tasks" datasource="#session.company.datasource#">
			SELECT id FROM tasks 
			WHERE project_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">		
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="q_tasks">
			<cfset t = CreateObject("component", "ptarmigan.task").open(q_tasks.id)>
			<cfset obj = CreateObject("component", "ptarmigan.object").open(q_tasks.id)>
			<cfif obj.deleted EQ 0>
				<cfset ArrayAppend(oa, t)>
			</cfif>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="documents" returntype="array" access="public" output="false">
		<cfquery name="q_docs" datasource="#session.company.datasource#">
			SELECT	document_id
			FROM	document_associations
			WHERE	element_table='projects'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_docs">
			<cfset d = CreateObject("component", "ptarmigan.document").open(document_id)>
			<cfset ArrayAppend(oa, d)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	
	
	<cffunction name="parcels" returntype="array" access="public" output="false">
		<cfquery name="q_parcels" datasource="#session.company.datasource#">
			SELECT	parcel_id
			FROM	parcel_associations
			WHERE	element_table='projects'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_parcels">
			<cfset d = CreateObject("component", "ptarmigan.parcel").open(parcel_id)>
			<cfset ArrayAppend(oa, d)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="duration" returntype="numeric" access="public" output="false">
			
		<cfset d = dateDiff("d", this.start_date, this.due_date) + 1>
		
		<cfreturn d>
	</cffunction>
	
	
	
	<cffunction name="change_orders" returntype="array" access="public" output="false">
		<cfquery name="q_change_orders" datasource="#session.company.datasource#">
			SELECT id FROM change_orders WHERE project_id='#this.id#' AND applied=0
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_change_orders">
			<cfset c = CreateObject("component", "ptarmigan.change_order").open(id)>
			<cfset ArrayAppend(oa, c)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="jquery_gantt" returntype="string" access="public" output="false">
		
		<cfset source = ArrayNew(1)>				
		<cfset tasks = this.tasks()>		
		
		<cfset s_src = StructNew()>
		<cfset s_val = StructNew()>	
		<cfset s_data = StructNew()>
						
		<cfloop array="#tasks#" index="t">
			<cfset task_object = CreateObject("component", "ptarmigan.object").open(t.id)>
			
			<cfif task_object.deleted EQ 0>
				<cfset s_src = StructNew()>
				<cfset s_val = StructNew()>	
				<cfset s_data = StructNew()>
				
				<cfset s_src.name = t.task_name>
				<cfset s_src.desc = "Task">
				<cfset s_src.values = ArrayNew(1)>
				
				<cfset s_val.id = t.id>
				
				<cfif t.completed EQ 0>
					<cfset s_val.customClass = "ganttBlue">			
				<cfelse>
					<cfset s_val.customClass = "ganttComplete">
				</cfif>
				
				
				
				<cfset s_val.label = t.task_name>
				<cfset s_val.dataObj = s_data>				
				
				<cfif t.critical EQ 1>
					<cfset s_val.customClass = "ganttRed">
					<cfset s_src.desc = "Critical Task">
					<cfset s_val.label = s_val.label & " [C]">
				</cfif>
				
				<cfset t_date = dateAdd("d", -1 , t.start_date)>
				<cfset s_val.from = "/Date(" & t_date.getTime() & ")/">
				<cfset t_date = dateAdd("d", -1, t.end_date)>
				<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
							
				
				<cfset ArrayAppend(s_src.values, s_val)>
				<cfset ArrayAppend(source, s_src)>
				
			</cfif> <!--- not-deleted check --->
		</cfloop> <!--- tasks loop --->
		
		<cfreturn SerializeJSON(source)>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.project_name>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM projects WHERE id='#this.id#'
		</cfquery>
		
		<cfset this.written = false>
	</cffunction>

<cffunction name="search_result" returntype="void" access="public" output="true"></cffunction>
</cfcomponent>