<cfcomponent output="false">

	<cfset this.id = "">
	<!--- other fields here --->
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.expense" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_XXXX" datasource="#session.company.datasource#">
			
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.expense" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="oxx" datasource="#session.company.datasource#">
			
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.expense" access="public" output="false">
		
		<cfquery name="q_update_XXXX" datasource="#session.company.datasource#">
			
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

</cfcomponent>