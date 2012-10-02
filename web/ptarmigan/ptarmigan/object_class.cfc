<cfcomponent output="false">
	<cfset this.id = "">
	
	<cfset this.class_name = "">
	<cfset this.component = "">
	<cfset this.top_level = 0>
	<cfset this.icon = "">
	<cfset this.opener = "">
	<cfset this.table_name = "">
	<cfset this.name_field = "">
	
	<cffunction name="open" returntype="ptarmigan.object_class" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="o" datasource="#session.company.datasource#">
			SELECT * 
			FROM 	object_classes 
			WHERE 	id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#id#">		
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.class_name = o.class_name>
		<cfset this.component = o.component>
		<cfset this.top_level = o.top_level>
		<cfset this.icon = o.icon>
		<cfset this.table_name = o.table_name>
		<cfset this.name_field = o.name_field>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="search_by_name" returntype="array" access="public" output="false">
		<cfargument name="name_value" type="string" required="true">
		
		<cfquery name="q_sbn" datasource="#session.company.datasource#">
			SELECT id FROM #this.table_name# WHERE #this.name_field# LIKE '%#name_value#%'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		<cfoutput query="q_sbn">
			<cfset t = CreateObject("component", "ptarmigan.object").open(q_sbn.id)>
			<cfset ArrayAppend(oa, t)>			
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
</cfcomponent>