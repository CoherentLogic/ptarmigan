<cfcomponent output="false">
	<cfset this.id = "">
	
	<cfset this.class_name = "">
	<cfset this.component = "">
	<cfset this.top_level = 0>
	<cfset this.icon = "">
	
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
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
</cfcomponent>