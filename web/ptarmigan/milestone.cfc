<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.project_id = "">
	<cfset this.milestone_number = 0>
	<cfset this.milestone_name = "">
	<cfset this.floating = 0>
	<cfset this.start_date = "">
	<cfset this.end_date = "">
	<cfset this.budget = 0>
	<cfset this.color = "">
	<cfset this.completed = 0>
	<cfset this.percent_complete = 0>
	
	<cfset this.written = false>
	
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
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="tasks" returntype="array" access="public" output="false">
		<cfquery name="q_tasks" datasource="#session.company.datasource#">
			SELECT id FROM tasks WHERE milestone_id='#this.id#' ORDER BY ts
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_tasks">
			<cfset t = CreateObject("component", "ptarmigan.task").open(id)>
			<cfset ArrayAppend(oa, t)>
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
</cfcomponent>