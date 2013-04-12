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
	<cfset this.table_name = "">
	<cfset this.name_field = "">
	
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
	
	<cffunction name="get_icon" returntype="string" access="public" output="false">
		<cfreturn session.root_url & "/images/" & this.icon>
	</cffunction>

	<cffunction name="update_class_info" returntype="void" access="public" output="false">
		<cfquery name="qc" datasource="#session.company.datasource#">
			SELECT * FROM object_classes WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.class_id#">
		</cfquery>
	
		<cfoutput query="qc">
			<cfset this.class_name = qc.class_name>
			<cfset this.component = qc.component>
			<cfset this.top_level = qc.top_level>
			<cfset this.icon = qc.icon>
			<cfset this.opener = this.substitute_opener(qc.opener)>
			<cfset this.table_name = qc.table_name>
			<cfset this.name_field = qc.name_field>
		</cfoutput>
		
	</cffunction>
	
	<cffunction name="get_associated_objects" returntype="array" access="public" output="false">
		<cfargument name="target_class_id" type="string" required="true">
		<cfargument name="rel_type" type="string" required="true">
		
		<cfquery name="q_get_associated_objects" datasource="#session.company.datasource#">
			SELECT target_object_id, source_object_id
			FROM 	object_associations 
			<cfif rel_type EQ "TARGET">
				WHERE 	source_object_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
			<cfelse>
				WHERE	target_object_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
			</cfif>
			<cfif target_class_id NEQ "ALL">
			AND		target_object_class=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#arguments.target_class_id#">
			</cfif>
		</cfquery>

		<cfset out_array = ArrayNew(1)>
		<cfoutput query="q_get_associated_objects">
			<cfif rel_type EQ "TARGET">
				<cfset tmp_obj = CreateObject("component", "ptarmigan.object").open(q_get_associated_objects.target_object_id)>
			<cfelse>
				<cfset tmp_obj = CreateObject("component", "ptarmigan.object").open(q_get_associated_objects.source_object_id)>			
			</cfif>
			<cfset ArrayAppend(out_array, tmp_obj)>
		</cfoutput>
		
		<cfreturn out_array>
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
		
		<cfset access_id = CreateUUID()>
		
		<cfif isdefined("session.user.id")>
		<cfquery name="write_access_event" datasource="#session.company.datasource#">
			INSERT INTO object_access
				(id,
				object_id,
				class_id,
				user_id,
				access_date)
			VALUES
				('#access_id#',
				'#this.id#',
				'#this.class_id#',
				'#session.user.id#',
				#CreateODBCDateTime(Now())#)
		</cfquery>
		</cfif>
		
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
		
		<cflog application="true" file="pt_otrack" type="information" text="PT_OTRACK: #session.user.full_name()# updated #this.class_id#:#this.id#">

		
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
	
	<cffunction name="access_count" returntype="numeric" output="false" access="public">
		<cfquery name="get_access_count" datasource="#session.company.datasource#">
			SELECT COUNT(object_id) AS a_count FROM object_access WHERE object_id='#this.id#'
		</cfquery>
		<cfreturn get_access_count.a_count>
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

	<cffunction name="set_member_value" returntype="void" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		<cfargument name="member_value" type="any" required="true">
		
		<cfset tmp_obj = this.get()>
		<cfif this.member_type(member_name) NEQ "date">
			<cfset new_value = member_value>
		<cfelse>
			<cfset new_value = CreateODBCDate(member_value)>
		</cfif>
		
		<cflog application="true" file="pt_otrack" type="information" text="PT_OTRACK: #session.user.full_name()# changed #this.class_id#:#this.id#.#member_name# from #this.member_value(member_name)# to #member_value#">

		
		<cfset "tmp_obj.#lcase(member_name)#" = new_value>
		<cfset tmp_obj.update()>
	</cffunction>
	
	<cffunction name="member_enum_values" returntype="array" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfreturn ListToArray(this.data().implementation.members[member_name].values)>
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
			<cfcase value="usstate">
				<cfreturn m>
			</cfcase>
			<cfcase value="text">
				<cfreturn m>
			</cfcase>
			<cfcase value="richtext">
				<cfreturn m>
			</cfcase>
			<cfcase value="township">
				<cfreturn m>
			</cfcase>
			<cfcase value="range">
				<cfreturn m>
			</cfcase>
			<cfcase value="enum">
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
					<cfreturn "*** NO LONGER EXISTS ***">
				</cfif>
			</cfcase>
			<cfcase value="boolean">
				<cfif m EQ 1>
					<cfreturn "Yes">
				<cfelse>
					<cfreturn "No">
				</cfif>
			</cfcase>
			<cfcase value="color">
				<cfreturn m>
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="add_audit" returntype="void" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		<cfargument name="original_value" type="string" required="true">
		<cfargument name="new_value" type="string" required="true">
		<cfargument name="change_order_number" type="string" required="true">
		<cfargument name="comment" type="string" required="true">
		
		<cfset audit_id = CreateUUID()>
		
		<cfquery name="q_add_audit" datasource="#session.company.datasource#">
			INSERT INTO	object_audits
							(id,
							object_id,
							member_name,
							original_value,
							new_value,
							change_order_number,
							comment,
							employee_id)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#audit_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#member_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#original_value#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#new_value#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#change_order_number#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#comment#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#session.user.id#">)
		</cfquery>		
		
		<cflog application="true" file="pt_otrack" type="information" text="PT_OTRACK: #session.user.full_name()# created an audit against #this.class_id#:#this.id#">

	</cffunction>
	
	<cffunction name="get_audits" returntype="query" access="public" output="false">
		<cfquery name="q_get_audits" datasource="#session.company.datasource#">
			SELECT * FROM object_audits 
			WHERE object_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
			ORDER BY edit_date
		</cfquery>
		
		<cfreturn q_get_audits>
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