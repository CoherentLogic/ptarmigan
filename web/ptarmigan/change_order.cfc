<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	<cfset this.project_id = "">
	<cfset this.change_order_number = "">
	<cfset this.extends_time = 0>
	<cfset this.extends_time_days = 0>
	<cfset this.increases_budget = 0>
	<cfset this.increases_budget_dollars = 0.0>
	<cfset this.description = "">
	<cfset this.document_id = "">
	<cfset this.status = "">
	<cfset this.applied = 0>
	
	<!--- other fields here --->
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.change_order" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_change_order" datasource="#session.company.datasource#">
			INSERT INTO change_orders
							(id,
							project_id,
							change_order_number,
							extends_time,
							extends_time_days,
							increases_budget,
							increases_budget_dollars,
							description,
							document_id,
							status,
							applied)
			VALUES			('#this.id#',
							'#this.project_id#',
							'#this.change_order_number#',
							#this.extends_time#,
							#this.extends_time_days#,
							#this.increases_budget#,
							#this.increases_budget_dollars#,
							'#this.description#',
							'#this.document_id#',
							'#this.status#',
							#this.applied#)
			
		</cfquery>
		
		<cfset session.message = "Change order #this.change_order_number# created.">

		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_CHANGE_ORDER">
		<cfset obj.parent_id = this.project_id>
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.change_order" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="co" datasource="#session.company.datasource#">
			SELECT * FROM change_orders WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.project_id = co.project_id>
		<cfset this.change_order_number = co.change_order_number>
		<cfset this.extends_time = co.extends_time>
		<cfset this.extends_time_days = co.extends_time_days>
		<cfset this.increases_budget = co.increases_budget>
		<cfset this.increases_budget_dollars = co.increases_budget_dollars>
		<cfset this.description = co.description>
		<cfset this.document_id = co.document_id>
		<cfset this.status = co.status>
		<cfset this.applied = co.applied>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.change_order" access="public" output="false">
		
		<cfquery name="q_update_change_order" datasource="#session.company.datasource#">
			UPDATE change_orders
			SET		change_order_number='#this.change_order_number#',
					project_id='#this.project_id#',
					extends_time=#this.extends_time#,
					extends_time_days=#this.extends_time_days#,
					increases_budget=#this.increases_budget#,
					increases_budget_dollars=#this.increases_budget_dollars#,
					description='#this.description#',
					document_id='#this.document_id#',
					status='#this.status#',
					applied=#this.applied#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset session.message = "Change order #this.change_order_number# updated.">

		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>	
		<cfset obj.deleted = 0>
		<cfset obj.parent_id = this.project_id>
		
		<cfset obj.update()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="apply" returntype="ptarmigan.change_order" access="public" output="false">
		<cfargument name="fields" type="struct" required="true">
		
		<cfset apply_element = "">
		
		<cfset this.status = fields.status>
		
		<cfswitch expression="#fields.apply_to#">
			<cfcase value="new_task">
				<cfset t = CreateObject("component", "ptarmigan.task")>
				
				<cfset t.milestone_id = fields.new_task_milestone>
				<cfset t.task_name = fields.new_task_name>
				<cfset t.start_date = CreateODBCDate(fields.new_task_start_date)>
				<cfif this.extends_time EQ 1>
					<cfset end_date = dateAdd("d", this.extends_time_days, t.start_date)>					
				<cfelse>
					<cfset end_date = dateAdd("d", 1, t.start_date)>
				</cfif>
				<cfset t.end_date = end_date>
				<cfset t.end_date_optimistic = end_date>
				<cfset t.end_date_pessimistic = end_date>				
				<cfif this.increases_budget EQ 1>
					<cfset budget = this.increases_budget_dollars>
				<cfelse>
					<cfset bugdet = 1.00>
				</cfif>
				<cfset t.budget = budget>
				
				<cfset apply_element = t.create()>

				<cfif this.extends_time EQ 1>				
					<cfif IsDefined("fields.apply_upstream")>
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
						<cfset ms.extend_durations(this.extends_time_days, this.change_order_number)>
						<cfset p = ms.project().extend_durations(this.extends_time_days, this.change_order_number)>
					</cfif>
				</cfif>
				
				<cfif this.increases_budget EQ 1>
					<cfif IsDefined("fields.apply_upstream")>
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
						<cfset ms.increase_budget(this.increases_budget_dollars, this.change_order_number)>
						<cfset p = ms.project().increase_budget(this.increases_budget_dollars, this.change_order_number)>					
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="existing_task">
				<cfset t = CreateObject("component", "ptarmigan.task").open(fields.existing_task)>			

				<cfif this.extends_time EQ 1>
					<cfset t.extend_durations(this.extends_time_days, this.change_order_number)>
		
					<cfif IsDefined("fields.apply_upstream")>
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
						<cfset ms.extend_durations(this.extends_time_days, this.change_order_number)>
						<cfset p = ms.project().extend_durations(this.extends_time_days, this.change_order_number)>
					</cfif>
				</cfif>
				
				<cfif this.increases_budget EQ 1>
					<cfset t.increase_budget(this.increases_budget_dollars, this.change_order_number)>
					<cfif IsDefined("fields.apply_upstream")>
						<cfset ms = CreateObject("component", "ptarmigan.milestone").open(t.milestone_id)>
						<cfset ms.increase_budget(this.increases_budget_dollars, this.change_order_number)>
						<cfset p = ms.project().increase_budget(this.increases_budget_dollars, this.change_order_number)>					
					</cfif>				
				</cfif>
									
				<cfset apply_element = t>				
			</cfcase>
			<cfcase value="new_milestone">
				<cfset ms = CreateObject("component", "ptarmigan.milestone")>
				
				<cfset ms.project_id = this.project_id>
				<cfset ms.milestone_name = fields.new_milestone_name>
				<cfset ms.start_date = CreateODBCDate(fields.new_milestone_start_date)>
				<cfif this.extends_time EQ 1>
					<cfset end_date = dateAdd("d", this.extends_time_days, ms.start_date)>
				<cfelse>
					<cfset end_date = dateAdd("d", 1, ms.start_date)>
				</cfif>
				<cfset ms.end_date = end_date>
				<cfset ms.end_date_optimistic = end_date>
				<cfset ms.end_date_pessimistic = end_date>				
				<cfif this.increases_budget EQ 1>
					<cfset budget = this.increases_budget_dollars>
				<cfelse>
					<cfset bugdet = 1.00>
				</cfif>
				<cfset ms.budget = budget>
				
				<cfset apply_element = ms.create()>
				<cfif this.extends_time EQ 1>				
					<cfif IsDefined("fields.apply_upstream")>						
						<cfset p = ms.project().extend_durations(this.extends_time_days, this.change_order_number)>
					</cfif>
				</cfif>			
				<cfif this.increases_budget EQ 1>
					<cfif IsDefined("fields.apply_upstream")>
						<cfset p = ms.project().increase_budget(this.increases_budget_dollars, this.change_order_number)>
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="existing_milestone">
				<cfset ms = CreateObject("component", "ptarmigan.milestone").open(fields.existing_milestone)>			
				
				<cfif this.extends_time EQ 1>
					<cfset ms.extend_durations(this.extends_time_days, this.change_order_number)>
					<cfif IsDefined("fields.apply_upstream")>						
						<cfset p = ms.project().extend_durations(this.extends_time_days, this.change_order_number)>
					</cfif>
				</cfif>
				
				<cfif this.increases_budget EQ 1>
					<cfset ms.increase_budget(this.increases_budget_dollars, this.change_order_number)>
					<cfif IsDefined("fields.apply_upstream")>
						<cfset p = ms.project().increase_budget(this.increases_budget_dollars, this.change_order_number)>
					</cfif>
				</cfif>								
				
				<cfset apply_element = ms>	
				<cfset this.update()>						
			</cfcase>
		</cfswitch>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.change_order_number>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM change_orders WHERE id='#this.id#'
		</cfquery>
		
		<cfset this.written = false>
	</cffunction>	

</cfcomponent>