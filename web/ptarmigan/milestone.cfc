<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.project_id = "">
	<cfset this.milestone_number = 0>
	<cfset this.milestone_name = "">
	<cfset this.floating = 0>
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.milestone" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_milestone_create" datasource="ptarmigan">
			INSERT INTO milestones
						(id,
						project_id,
						milestone_number,
						milestone_name,
						floating)
			VALUES		('#this.id#',
						'#this.project_id#',
						#this.milestone_number#,
						'#UCase(this.milestone_name)#',
						#this.floating#)
		</cfquery>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.milestone" access="public" output="false">
		<cfargument name="id" type="string" required="yes">
		
		<cfquery name="mo" datasource="ptarmigan">
			SELECT * FROM milestones WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.project_id = mo.project_id>
		<cfset this.milestone_number = mo.milestone_number>
		<cfset this.milestone_name = mo.milestone_name>
		<cfset this.floating = mo.floating>
				
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.milestone" access="public" output="false">
		
		<cfquery name="mu" datasource="ptarmigan">
			UPDATE milestones
			SET		project_id='#this.project_id#',
					milestone_number=#this.milestone_number#,
					milestone_name='#this.milestone_name#',
					floating=#this.floating#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="tasks" returntype="array" access="public" output="false">
		<cfquery name="q_tasks" datasource="ptarmigan">
			SELECT id FROM tasks WHERE milestone_id='#this.id#' ORDER BY ts
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_tasks">
			<cfset t = CreateObject("component", "ptarmigan.task").open(id)>
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
</cfcomponent>