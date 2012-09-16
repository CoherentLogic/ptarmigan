<cfcomponent output="false" implements="ptarmigan.i_object">
	
	<cfset this.id = "">
	<cfset this.project_number = "">
	<cfset this.project_name = "">
	<cfset this.instructions = "">
	<cfset this.due_date = CreateODBCDate(Now())>
	<cfset this.due_date_optimistic = CreateODBCDate(Now())>
	<cfset this.due_date_pessimistic = CreateODBCDate(Now())>
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
		
		this.members['DUE_DATE_OPTIMISTIC'] = StructNew();
		this.members['DUE_DATE_OPTIMISTIC'].type = "date";
		this.members['DUE_DATE_OPTIMISTIC'].label = "End date (optimistic)";
		
		this.members['DUE_DATE_PESSIMISTIC'] = StructNew();
		this.members['DUE_DATE_PESSIMISTIC'].type = "date";
		this.members['DUE_DATE_PESSIMISTIC'].label = "End date (pessimistic)";
		
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
							due_date_pessimistic,
							due_date_optimistic,
							current_milestone,
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
							<cfqueryparam cfsqltype="cf_sql_date" value="#this.due_date_pessimistic#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#this.due_date_optimistic#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#this.current_milestone#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.customer_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.created_by#">,
							<cfqueryparam cfsqltype="cf_sql_real" value="#this.tax_rate#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#this.start_date#">,
							<cfqueryparam cfsqltype="cf_sql_real" value="#this.budget#">)
			</cfquery>
		</cflock>
		
		<cfset t = CreateObject("component", "ptarmigan.milestone")>
		
		<cfset t.project_id = this.id>
		<cfset t.milestone_number = 1000>
		<cfset t.milestone_name = "MISCELLANEOUS TASKS">
		<cfset t.floating = 1>
		<cfset t.start_date = CreateODBCDate(Now())>
		<cfset t.end_date = CreateODBCDate(Now())>
		<cfset t.end_date_optimistic = CreateODBCDate(Now())>
		<cfset t.end_date_pessimistic = CreateODBCDate(Now())>
		
		<cfset t.create()>
		
		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_PROJECT">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
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
		<cfset this.due_date_pessimistic = op.due_date_pessimistic>
		<cfset this.due_date_optimistic = op.due_date_optimistic>
		<cfset this.current_milestone = op.current_milestone>
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
					due_date_pessimistic=#this.due_date_pessimistic#,
					due_date_optimistic=#this.due_date_optimistic#,
					current_milestone=#this.current_milestone#,
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
			<cfset this.due_date_optimistic = dateAdd("d", extension_count, this.due_date_optimistic)>						
			<cfset this.due_date_pessimistic = dateAdd("d", extension_count, this.due_date_pessimistic)>						
			
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
	
	<cffunction name="milestones" returntype="array" access="public" output="false">		
		
		<cfquery name="gm" datasource="#session.company.datasource#">
			SELECT * FROM milestones WHERE project_id='#this.id#' ORDER BY milestone_number
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="gm">
			<cfset t = CreateObject("component", "ptarmigan.milestone").open(id)>
			<cfset tobj = CreateObject("component", "ptarmigan.object").open(id)>
			<cfif tobj.deleted EQ 0>
				<cfset arrayAppend(oa, t)>
			</cfif>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="tasks" returntype="array" access="public" output="false">

		<cfset oaa = ArrayNew(1)>
		<cfset mss = this.milestones()>		
		<cfloop array="#mss#" index="mso">
			<cfset tskas = mso.tasks()>
			<cfloop array="#tskas#" index="tov">
					<cfset ArrayAppend(oaa, tov)>
			</cfloop>
		</cfloop>
		
		<cfreturn oaa>
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
		<cfargument name="type" type="string" required="true">
		
		<cfswitch expression="#type#">
			<cfcase value="normal">
				<cfset d = dateDiff("d", this.start_date, this.due_date) + 1>
			</cfcase>
			<cfcase value="optimistic">
				<cfset d = dateDiff("d", this.start_date, this.due_date_optimistic) + 1>
			</cfcase>
			<cfcase value="pessimistic">
				<cfset d = dateDiff("d", this.start_date, this.due_date_pessimistic) + 1>
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
		<cfargument name="durations" type="string" required="true">
		
		<cfset source = ArrayNew(1)>				
		<cfset milestones = this.milestones()>		
		
		<cfset s_src = StructNew()>
		<cfset s_val = StructNew()>	
		<cfset s_data = StructNew()>
				
		<cfset s_src.name = this.project_name>
		<cfset s_src.desc = "Project">
		<cfset s_src.values = ArrayNew(1)>
		
		<cfset s_data.element_table = "projects">
		<cfset s_data.element_id = this.id>
		<cfset s_data.button_caption = this.project_name>

		<cfset s_val.customClass = "ganttGreen">
		<cfset s_val.label = this.project_name>		
		<cfset s_val.dataObj = s_data>
		
		<cfset t_date = dateAdd("d", -1, this.start_date)>
		<cfset s_val.from = "/Date(" & t_date.getTime() & ")/">

		<cfswitch expression="#durations#">
			<cfcase value="pessimistic">
				<cfset t_date = dateAdd("d", -1 , this.due_date_pessimistic)>
				<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
			</cfcase>
			<cfcase value="optimistic">
				<cfset t_date = dateAdd("d", -1 , this.due_date_optimistic)>
				<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
			</cfcase>
			<cfcase value="normal">			
				<cfset t_date = dateAdd("d", -1 , this.due_date)>
				<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
			</cfcase>
		</cfswitch>
		
		<cfset ArrayAppend(s_src.values, s_val)>
		<cfset ArrayAppend(source, s_src)>
		
		<cfloop array="#milestones#" index="ms">
			<cfset milestone_object = CreateObject("component", "ptarmigan.object").open(ms.id)>
			
			<cfif milestone_object.deleted EQ 0>
				<cfset s_src = StructNew()>
				<cfset s_val = StructNew()>	
				<cfset s_data = StructNew()>
				
				<cfset s_src.name = ms.milestone_name>
				<cfset s_src.desc = "Milestone">
				<cfset s_src.values = ArrayNew(1)>
				
				<cfset s_data.element_table = "milestones">
				<cfset s_data.element_id = ms.id>
				<cfset s_data.button_caption = ms.milestone_name>
				
				<cfif ms.completed EQ 0>
					<cfset s_val.customClass = "ganttRed">			
				<cfelse>
					<cfset s_val.customClass = "ganttComplete">
				</cfif>
				
				<cfset s_val.label = ms.milestone_name>
				<cfset s_val.dataObj = s_data>
				
				<cfif ms.floating EQ 0>
					<cfset t_date = dateAdd("d", -1, ms.start_date)>
					<cfset s_val.from = "/Date(" & t_date.getTime() & ")/">			
					
					<cfswitch expression="#durations#">
						<cfcase value="pessimistic">
							<cfset t_date = dateAdd("d", -1 , ms.end_date_pessimistic)>
							<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
						</cfcase>
						<cfcase value="optimistic">
							<cfset t_date = dateAdd("d", -1 , ms.end_date_optimistic)>
							<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
						</cfcase>
						<cfcase value="normal">			
							<cfset t_date = dateAdd("d", -1 , ms.end_date)>
							<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
						</cfcase>
					</cfswitch>
				<cfelse>
					<cfset t_date = dateAdd("d", -1 , ms.project().start_date)>
					<cfset s_val.from = "/Date(" & t_date.getTime() & ")/">
					<cfset t_date = dateAdd("d", -1, ms.project().due_date)>
					<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
					<cfset s_val.customClass = "ganttOrange">
				</cfif>
				
				<cfset ArrayAppend(s_src.values, s_val)>
				<cfset ArrayAppend(source, s_src)>
				
				<cfset tasks = ms.tasks()>
				
				<cfloop array="#tasks#" index="t">
					<cfset task_object = CreateObject("component", "ptarmigan.object").open(t.id)>
					
					<cfif task_object.deleted EQ 0>
						<cfset s_src = StructNew()>
						<cfset s_val = StructNew()>	
						<cfset s_data = StructNew()>
						
						<cfset s_src.name = t.task_name>
						<cfset s_src.desc = "Task">
						<cfset s_src.values = ArrayNew(1)>
						
						<cfset s_data.element_table = "tasks">
						<cfset s_data.element_id = t.id>
						<cfset s_data.button_caption = t.task_name>
			
						<cfset s_val.label = t.task_name>
						<cfset t_date = dateAdd("d", -1, t.start_date)>
						<cfset s_val.from = "/Date(" & t_date.getTime() & ")/">
						
						<cfif t.completed EQ 0>
							<cfset s_val.customClass = "ganttBlue">
						<cfelse>
							<cfset s_val.customClass = "ganttCompleted">
						</cfif>
						<cfset s_val.dataObj = s_data>
						
						<cfswitch expression="#durations#">
							<cfcase value="pessimistic">
								<cfset t_date = dateAdd("d", -1 , t.end_date_pessimistic)>
								<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
							</cfcase>
							<cfcase value="optimistic">
								<cfset t_date = dateAdd("d", -1 , t.end_date_optimistic)>
								<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">						
							</cfcase>
							<cfcase value="normal">	
								<cfset t_date = dateAdd("d", -1, t.end_date)>		
								<cfset s_val.to = "/Date(" & t_date.getTime() & ")/">
							</cfcase>
						</cfswitch>
						
						<cfset ArrayAppend(s_src.values, s_val)>
						<cfset ArrayAppend(source, s_src)>
					</cfif>
				</cfloop> <!--- tasks inner loop --->									
			</cfif> <!--- not-deleted check --->
		</cfloop> <!--- milestones outer loop --->
		
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
</cfcomponent>