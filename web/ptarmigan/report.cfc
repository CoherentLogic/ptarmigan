<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	
	<cfset this.report_name = "">
	<cfset this.class_id = "">
	<cfset this.system_report = 0>
	<cfset this.employee_id = "">
	<cfset this.report_key = "">
	
	<cfset this.members = StructNew()>
	
	<cfset this.members['REPORT_NAME'] = StructNew()>
	<cfset this.members['REPORT_NAME'].type = "text">
	<cfset this.members['REPORT_NAME'].label = "Report name">
	
	<cfset this.members['CLASS_ID'] = StructNew()>
	<cfset this.members['CLASS_ID'].type = "text">
	<cfset this.members['CLASS_ID'].label = "Using">
	
	<cfset this.members['SYSTEM_REPORT'] = StructNew()>
	<cfset this.members['SYSTEM_REPORT'].type = "boolean">
	<cfset this.members['SYSTEM_REPORT'].label = "System report">

	<cfset this.members['REPORT_KEY'] = StructNew()>
	<cfset this.members['REPORT_KEY'].type = "text">
	<cfset this.members['REPORT_KEY'].label = "Report key">
	
	<cfset this.members['EMPLOYEE_ID'] = StructNew()>	
	<cfset this.members['EMPLOYEE_ID'].type = "object">
	<cfset this.members['EMPLOYEE_ID'].class = "OBJ_EMPLOYEE">
	<cfset this.members['EMPLOYEE_ID'].label = "Created by">
		
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.report" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_report" datasource="#session.company.datasource#">
			INSERT INTO reports
							(id,
							report_name,
							class_id,
							system_report,
							employee_id,
							report_key)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.report_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.class_id#">,
							<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this.system_report#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.employee_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.report_key#">)
		</cfquery>
		
		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_REPORT">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.report" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="o" datasource="#session.company.datasource#">
			SELECT * FROM reports WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.report_name = o.report_name>
		<cfset this.class_id = o.class_id>
		<cfset this.system_report = o.system_report>
		<cfset this.employee_id = o.employee_id>			
		<cfset this.report_key = o.report_key>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.report" access="public" output="false">
		
		<cfquery name="q_update_report" datasource="#session.company.datasource#">
			UPDATE reports
			SET		report_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.report_name#">,
					class_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.class_id#">,
					system_report=<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this.system_report#">,
					employee_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.employee_id#">,
					report_key=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.report_key#">
			WHERE	id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.id#">
		</cfquery>
		
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>			
		<cfset obj.deleted = 0>		
		
		<cfset obj.update()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add_criteria" returntype="string" access="public" output="false">
		<cfargument name="report_id" type="string" required="true">
		<cfargument name="member_name" type="string" required="true">
		<cfargument name="operator" type="string" required="true">
		<cfargument name="literal_a" type="string" required="true">
	
		<cfset criteria_id = CreateUUID()>
		
		<cfquery name="add_criteria" datasource="#session.company.datasource#">
			INSERT INTO	report_criteria
							(id,
							report_id,
							member_name,
							operator,
							literal_a)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#criteria_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#member_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="8" value="#operator#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#literal_a#">)
		</cfquery>
		
		<cfreturn criteria_id>		
	</cffunction>
	
	<cffunction name="get_criteria" returntype="array" access="public" output="false">
		<cfquery name="q_get_criteria" datasource="#session.company.datasource#">
			SELECT * FROM report_criteria
			WHERE	report_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_get_criteria">
			<cfset t = StructNew()>
			<cfset t.id = q_get_criteria.id>
			<cfset t.report_id = q_get_criteria.report_id>
			<cfset t.member_name = q_get_criteria.member_name>
			<cfset t.operator = q_get_criteria.operator>
			<cfset t.literal_a = q_get_criteria.literal_a>

			
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="get_criteria_string" returntype="string" access="public" output="false">
		<cfset cri = this.get_criteria()>
		
		<cfset os = "">
		<cfloop array="#cri#" index="filter">
			<cfset os = os & filter.member_name & " " & filter.operator & " '" & filter.literal_a & "';">	
		</cfloop>
		
		<cfif len(os) GT 0>
			<cfreturn left(os, len(os) - 1)>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="get_columns" returntype="array" access="public" output="false">
		<cfquery name="qcols" datasource="#session.company.datasource#">
			SELECT member_name FROM report_columns
			WHERE report_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset out = ArrayNew(1)>
		<cfoutput query="qcols">
			<cfset ArrayAppend(out, qcols.member_name)>
		</cfoutput>
	
		<cfreturn out>
	</cffunction>
	
	<cffunction name="get_wql" returntype="string" access="public" output="false">
		<cfparam name="wql" default="">
		<cfscript>
			wql = "REPORT ITEMS OF TYPE " & this.class_id & " WHERE " & this.get_criteria_string() & " INCLUDING ";
			wql = wql & ArrayToList(this.get_columns());
		</cfscript>
		
		<cfreturn wql>		
	</cffunction>
	
	<cffunction name="column_included" returntype="boolean" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfquery name="q_column_included" datasource="#session.company.datasource#">
			SELECT id FROM report_columns 
			WHERE report_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
			AND member_name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#member_name#">
		</cfquery>
		
		<cfif q_column_included.recordcount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="include_column" returntype="void" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfset c_id = CreateUUID()>
		
		<cfquery name="q_include_column" datasource="#session.company.datasource#">
			INSERT INTO report_columns
						(id,
						report_id,
						member_name)
			VALUES		(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#c_id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#member_name#">)
		</cfquery>
	</cffunction>
	
	<cffunction name="exclude_column" returntype="void" access="public" output="false">
		<cfargument name="member_name" type="string" required="true">
		
		<cfquery name="q_exclude_column" datasource="#session.company.datasource#">
			DELETE FROM report_columns
			WHERE	report_id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
			AND		member_name=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#member_name#">
		</cfquery>
	</cffunction>
			
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.report_name>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM reports WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.written = false>
	</cffunction>

</cfcomponent>