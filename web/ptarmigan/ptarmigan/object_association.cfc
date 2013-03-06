<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	<cfset this.source_object_id = "">
	<cfset this.target_object_id = "">
	<cfset this.source_object_class = "">
	<cfset this.target_object_class = "">
	<cfset this.association_name = "">
	
	<cfset this.members = StructNew()>
	
	
	<cfscript>
		this.members['ASSOCIATION_NAME'] = StructNew();
		this.members['ASSOCIATION_NAME'].type = "text";
		this.members['ASSOCIATION_NAME'].label = "Association name";
	</cfscript>
	
	
	
	<cfset this.written = false>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.association_name>
	</cffunction>
	
	<cffunction name="create" returntype="ptarmigan.object_association" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_association" datasource="#session.company.datasource#">
			INSERT INTO 	object_associations
							(id,
							source_object_id,
							target_object_id,
							source_object_class,
							target_object_class,
							association_name)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.source_object_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.target_object_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.source_object_class#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.target_object_class#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.association_name#">)
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.object_association" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="q_open_association" datasource="#session.company.datasource#">
			SELECT * 
			FROM	object_associations 
			WHERE 	id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.id = id>
		<cfoutput query="q_open_association">
			<cfset this.source_object_id = q_open_association.source_object_id>
			<cfset this.target_object_id = q_open_association.target_object_id>
			<cfset this.association_name = q_open_association.association_name>
		</cfoutput>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.object_association" access="public" output="false">
		
		<cfquery name="q_update_XXXX" datasource="#session.company.datasource#">
			UPDATE object_associations
			SET		source_object_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.source_object_id#">,
					target_object_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.target_object_id#">,
					source_object_class=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.source_object_class#">,
					target_object_class=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.target_object_class#">,
					association_name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.association_name#">
			WHERE	id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM object_associations WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.written = false>
	</cffunction>

<cffunction name="search_result" returntype="void" access="public" output="true"></cffunction>
</cfcomponent>