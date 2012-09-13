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
	<cfset this.opener = "">
	
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
			SELECT * FROM object_classes WHERE id=<cfqueryparam cfsqltype="string" value="#this.class_id#">
		</cfquery>
	
		<cfoutput query="qc">
			<cfset this.class_name = qc.class_name>
			<cfset this.component = qc.component>
			<cfset this.top_level = qc.top_level>
			<cfset this.icon = qc.icon>
			<cfset this.opener = this.substitute_opener(qc.opener)>
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
	
	<cffunction name="substitute_opener" returntype="string" access="public" output="false">
		<cfargument name="opener_string" type="string" required="true">
		
			<cfset new_opener_string = replace(opener_string, "{id}", this.id, "all")>
			<cfset new_opener_string = replace(new_opener_string, "{root_url}", session.root_url, "all")>
		
		<cfreturn new_opener_string>
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
	
	<cffunction name="json" returntype="string" access="public" output="false">
		<cfset pt_object = StructNew()>
		<cfset pt_object.class = DeserializeJSON(SerializeJSON(this))>
		<cfset pt_object.implementation = DeserializeJSON(SerializeJSON(this.get()))>
		<cfreturn SerializeJSON(pt_object)>
	</cffunction>	
	
	<cffunction name="data" returntype="struct" access="public" output="false">
		<cfreturn DeserializeJSON(this.json())>
	</cffunction>
	
	<cffunction name="members" returntype="array" access="public" output="false">
		<cfreturn ListToArray(StructKeyList(this.data().implementation.members))>
	</cffunction>
	
	<cffunction name="member_type" returntype="string" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfreturn this.data().implementation.members[member_name].type>
	</cffunction>

	<cffunction name="member_class" returntype="string" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfreturn this.data().implementation.members[member_name].class>
	</cffunction>	

	<cffunction name="member_label" returntype="string" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfreturn this.data().implementation.members[member_name].label>
	</cffunction>

	
	<cffunction name="member_value" returntype="any" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfset o = this.get()>
		<cfset var_name = "##this.get()." & member_name & "##">
		<cfset m = Evaluate(var_name)>
		
		<cfswitch expression="#this.member_type(member_name)#">
			<cfcase value="date">
				<cfreturn dateFormat(m, "mm/dd/yyyy")>
			</cfcase>
			<cfcase value="text">
				<cfreturn m>
			</cfcase>
			<cfcase value="number">
				<cfreturn m>
			</cfcase>
			<cfcase value="money">
				<cfreturn numberFormat(m, ",_$___.__")>
			</cfcase>
			<cfcase value="percentage">
				<cfreturn m & "%">
			</cfcase>
			<cfcase value="object">
				<cfset obj = CreateObject("component", "ptarmigan.object").open(m)>
				<cfif obj.class_id NEQ "">
				<cfreturn obj.get().object_name()>
				<cfelse>
				<cfreturn "[NO LONGER EXISTS - PLEASE REPAIR DATABASE]">
				</cfif>
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="member_value_raw" returntype="string" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">

		<cfset o = this.get()>
		<cfset var_name = "##this.get()." & member_name & "##">
		<cfset m = Evaluate(var_name)>

		<cfreturn m>		
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