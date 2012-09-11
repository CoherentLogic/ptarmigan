<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	
	<cfset this.report_name = "">
	<cfset this.class_id = "">
	<cfset this.system_report = 0>
	<cfset this.employee_id = "">
		
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
							employee_id)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.report_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.class_id#">,
							<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this.system_report#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.employee_id#">)
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
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.report" access="public" output="false">
		
		<cfquery name="q_update_report" datasource="#session.company.datasource#">
			UPDATE reports
			SET		report_name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.report_name#">,
					class_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.class_id#">,
					system_report=<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this.system_report#">,
					employee_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.employee_id#">
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
		<cfargument name="literal_b" type="string" required="true">
		
		<cfset criteria_id = CreateUUID()>
		
		<cfquery name="add_criteria" datasource="#session.company.datasource#">
			INSERT INTO	report_criteria
							(id,
							report_id,
							member_name,
							operator,
							literal_a,
							literal_b)
			VALUES			(<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#criteria_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#member_name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="8" value="#operator#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#literal_a#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#literal_b#">)
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
			<cfset t.literal_b = q_get_criteria.literal_b>
			
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
		
		<cfreturn left(os, len(os) - 1)>
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