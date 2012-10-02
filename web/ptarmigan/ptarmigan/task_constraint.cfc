<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	<cfset this.constraint_name = "">
	<cfset this.members = StructNew()>
	
	
	<cfscript>
		this.members['CONSTRAINT_NAME'] = StructNew();
		this.members['CONSTRAINT_NAME'].type = "text";
		this.members['CONSTRAINT_NAME'].label = "Constraint name";
	</cfscript>
	
	<cfset this.written = false>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">	
		<cfreturn this.constraint_name>
	</cffunction>
	
	<cffunction name="create" returntype="ptarmigan.task_constraint" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_constraint" datasource="#session.company.datasource#">
			INSERT INTO task_constraints
							(id,
							constraint_name)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="60" value="#this.constraint_name#">)
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.task_constraint" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="q_open_constraint" datasource="#session.company.datasource#">
			SELECT * FROM task_constraints
			WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#id#">
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.constraint_name = q_open_constraint.constraint_name>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.task_constraint" access="public" output="false">
		
		<cfquery name="q_update_constraint" datasource="#session.company.datasource#">
			UPDATE task_constraints
			SET		constraint_name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="60" value="#this.constraint_name#">
			WHERE	id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM task_constraints WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.written = false>
	</cffunction>

</cfcomponent>