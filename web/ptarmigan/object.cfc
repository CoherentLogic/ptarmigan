<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.class_id = "">
	<cfset this.parent_id = session.company.object_name()>
	<cfset this.deleted = 0>
	<cfset this.trashcan_handle = "">
	<cfset this.class_name = "">
	<cfset this.component = "">
	<cfset this.top_level = 0>
	<cfset this.icon = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.object" access="public" output="false">
	
		<cfquery name="q_create_object" datasource="#session.company.datasource#">
			INSERT INTO objects
							(id,
							class_id,
							parent_id,
							deleted,
							trashcan_handle)
			VALUES			(<cfqueryparam value="#this.id#" cfsqltype="cf_sql_varchar">,
							 <cfqueryparam value="#this.class_id#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#this.parent_id#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#this.deleted#" cfsqltype="cf_sql_tinyint">,
							<cfqueryparam value="#this.trashcan_handle#" cfsqltype="cf_sql_varchar">)
		</cfquery>
		
		<cfset this.update_class_info()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update_class_info" returntype="void" access="public" output="false">
		<cfquery name="qc" datasource="#session.company.datasource#">
			SELECT * FROM object_classes WHERE id='#this.class_id#'
		</cfquery>
	
		<cfoutput query="qc">
			<cfset this.class_name = qc.class_name>
			<cfset this.component = qc.component>
			<cfset this.top_level = qc.top_level>
			<cfset this.icon = qc.icon>
		</cfoutput>
		
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.object" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="oo" datasource="#session.company.datasource#">
			SELECT * FROM objects WHERE id=<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.class_id = oo.class_id>
		<cfset this.parent_id = oo.parent_id>
		<cfset this.deleted = oo.deleted>
		<cfset this.trashcan_handle = oo.trashcan_handle>
		
		<cfset this.update_class_info()>
				
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.object" access="public" output="false">
		
		<cfquery name="q_update_object" datasource="#session.company.datasource#">
			UPDATE objects 
			SET		class_id=<cfqueryparam value="#this.class_id#" cfsqltype="cf_sql_varchar">,
					parent_id=<cfqueryparam value="#this.parent_id#" cfsqltype="cf_sql_varchar">,
					deleted=<cfqueryparam value="#this.deleted#" cfsqltype="cf_sql_integer">,
					trashcan_handle=<cfqueryparam value="#this.trashcan_handle#" cfsqltype="cf_sql_varchar">
			WHERE	id=<cfqueryparam value="#this.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset this.update_class_info()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_trashcan_handle" returntype="string" access="public" output="false">
		<cfreturn CreateUUID()>
	</cffunction>	
				
	<cffunction name="mark_deleted" returntype="ptarmigan.object" access="public" output="false">
		<cfargument name="trashcan_handle" type="string" required="true">
		
		<cfif this.has_children() EQ true>
			<cfset children = this.get_children()>
			
			<cfloop array="#children#" index="child">
				<cfset child.mark_deleted(trashcan_handle)>
			</cfloop>
		</cfif>
		<cfset this.trashcan_handle = trashcan_handle>
		<cfset this.deleted = 1>
		<cfset this.update()>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="unmark_deleted" returntype="ptarmigan.object" access="public" output="false">
		<cfif this.has_children() EQ true>
			<cfset children = this.get_children()>
			
			<cfloop array="#children#" index="child">
				<cfset child.unmark_deleted()>
			</cfloop>
		</cfif>
		<cfset this.deleted = 0>
		<cfset this.update()>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_parent" returntype="ptarmigan.object" access="public" output="false">
		<cfreturn CreateObject("component", "ptarmigan.object").open(this.parent_id)>
	</cffunction>
		
	<cffunction name="get_children" returntype="array" access="public" output="false">
		<cfquery name="c_of" datasource="#session.company.datasource#">
			SELECT id FROM objects WHERE parent_id=<cfqueryparam value="#this.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="c_of">
			<cfset t = CreateObject("component", "ptarmigan.object").open(c_of.id)>
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="has_children" returntype="numeric" access="public" output="false">
		<cfquery name="c_of" datasource="#session.company.datasource#">
			SELECT id FROM objects WHERE parent_id=<cfqueryparam value="#this.id#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif c_of.recordcount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>	
		</cfif>
	</cffunction>
	
	
	<cffunction name="get" returntype="any" access="public" output="false">
		<cfreturn CreateObject("component", this.component).open(this.id)>
	</cffunction>		
	
	<cffunction name="delete" returntype="ptarmigan.object" acnot cess="public" output="false">
		<cfset target = CreateObject("component", this.component).open(this.id)>
		<cfset target.delete()>
		
		<cfquery name="delete_this" datasource="#session.company.datasource#">
			DELETE FROM objects WHERE id=<cfqueryparam value="#this.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset this.written = false>
		
		<cfreturn this>
	</cffunction>
	
</cfcomponent>