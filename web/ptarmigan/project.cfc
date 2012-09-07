<cfcomponent output="false">
	
	<cfset this.id = "">
	<cfset this.project_number = "">
	<cfset this.project_name = "">
	<cfset this.instructions = "">
	<cfset this.due_date = "">
	<cfset this.due_date_optimistic = "">
	<cfset this.due_date_pessimistic = "">
	<cfset this.current_milestone = 1>
	<cfset this.customer_id = "">
	<cfset this.created_by = "">
	<cfset this.tax_rate = 0>
	<cfset this.start_date = "">
	<cfset this.budget = 0>
	
	<cfset this.written = false>
	
	
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
				VALUES		('#this.id#',
							'#this.project_number#',
							'#this.project_name#',
							'#this.instructions#',
							#this.due_date#,
							#this.due_date_pessimistic#,
							#this.due_date_optimistic#,
							#this.current_milestone#,
							'#this.customer_id#',
							'#this.created_by#',
							#this.tax_rate#,
							#this.start_date#,
							#this.budget#)
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
		
		<cfset this.written = true>
		<cfreturn this>
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
			<cfset arrayAppend(oa, t)>
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
			SELECT id FROM change_orders WHERE project_id='#this.id#'
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
			<cfset s_src = StructNew()>
			<cfset s_val = StructNew()>	
			<cfset s_data = StructNew()>
			
			<cfset s_src.name = ms.milestone_name>
			<cfset s_src.desc = "Milestone">
			<cfset s_src.values = ArrayNew(1)>
			
			<cfset s_data.element_table = "milestones">
			<cfset s_data.element_id = ms.id>
			<cfset s_data.button_caption = ms.milestone_name>
			
			<cfset s_val.customClass = "ganttRed">			
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
				<cfset s_val.customClass = "ganttBlue">
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
			</cfloop> <!--- tasks inner loop --->									
		</cfloop> <!--- milestones outer loop --->
		
		<cfreturn SerializeJSON(source)>
	</cffunction>
</cfcomponent>