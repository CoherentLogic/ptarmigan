<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.milestone_id = "">
	<cfset this.task_name = "">
	<cfset this.description = "">
	<cfset this.completed = 0>
	<cfset this.start_date = "">
	<cfset this.end_date = "">
	<cfset this.budget = "">
	<cfset this.color = "">
	<cfset this.percent_complete = 0>
	
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.task" access="public" output="false">
	
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_task_create" datasource="#session.company.datasource#">
			INSERT INTO tasks
						(id,
						milestone_id,
						task_name,
						description,
						completed,
						percent_complete,
						start_date,
						end_date,
						end_date_pessimistic,
						end_date_optimistic,
						budget,
						color)
			VALUES		('#this.id#',
						'#this.milestone_id#',
						'#UCase(this.task_name)#',
						'#UCase(this.description)#',
						#this.completed#,
						#this.percent_complete#,
						#this.start_date#,
						#this.end_date#,
						#this.end_date_pessimistic#,
						#this.end_date_optimistic#,
						#this.budget#,
						'#this.color#')
		</cfquery>
		<cfset session.message = "Task #this.task_name# added.">
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.task" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="t" datasource="#session.company.datasource#">
			SELECT * FROM tasks WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.milestone_id = t.milestone_id>
		<cfset this.task_name = t.task_name>
		<cfset this.description = t.description>
		<cfset this.completed = t.completed>
		<cfset this.percent_complete = t.percent_complete>
		<cfset this.start_date = t.start_date>
		<cfset this.end_date = t.end_date>
		<cfset this.end_date_pessimistic = t.end_date_pessimistic>
		<cfset this.end_date_optimistic = t.end_date_optimistic>
		<cfset this.budget = t.budget>
		<cfset this.color = t.color>
		
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.task" access="public" output="false">
		
		<cfquery name="q_task_update" datasource="#session.company.datasource#">
			UPDATE tasks
			SET		milestone_id='#this.milestone_id#',
					task_name='#UCase(this.task_name)#',
					description='#UCase(this.description)#',
					completed=#this.completed#,
					percent_complete=#this.percent_complete#,
					start_date=#this.start_date#,
					end_date=#this.end_date#,
					end_date_pessimistic=#this.end_date_pessimistic#,
					end_date_optimistic=#this.end_date_optimistic#,
					budget=#this.budget#,
					color='#this.color#'
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset session.message = "Task #this.task_name# updated.">
		
		<cfset this.written = true>
	
		<cfreturn this>
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
	
		<cfquery name="te" datasource="#session.company.datasource#">
			SELECT	SUM(amount) AS task_total
			FROM	project_expenses
			WHERE	element_table='tasks'
			AND		element_id='#this.id#'
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
			WHERE	element_table='tasks'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_docs">
			<cfset d = CreateObject("component", "ptarmigan.document").open(document_id)>
			<cfset ArrayAppend(oa, d)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
</cfcomponent>