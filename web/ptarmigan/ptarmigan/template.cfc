<cfcomponent output="false" implements="ptarmigan.i_object">

	<cfset this.id = "">
	<!--- TODO: add other fields here --->
	
	<cfset this.members = StructNew()>
	
	
	<cfscript>
		this.members['MEMBER_NAME'] = StructNew();
		this.members['MEMBER_NAME'].type = "text";
		this.members['MEMBER_NAME'].label = "Enter member label here";
		
		<!--- TODO: add other members here --->
	</cfscript>
	
	<cfset this.written = false>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<!--- TODO: return the name of this object here --->
		<cfreturn this.XXXX>
	</cffunction>
	
	<cffunction name="create" returntype="ptarmigan.XXXX" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_XXXX" datasource="#session.company.datasource#">
			<!--- TODO: build create query here --->	
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.XXXX" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="q_open_XXXX" datasource="#session.company.datasource#">
			<!--- TODO: build open query here --->	
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="update" returntype="ptarmigan.XXXX" access="public" output="false">
		
		<cfquery name="q_update_XXXX" datasource="#session.company.datasource#">
			<!--- TODO: build update query here --->	
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			<!--- TODO: modify the delete query to suit the object's needs --->
			DELETE FROM XXX WHERE id=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#this.id#">
		</cfquery>
		
		<cfset this.written = false>
	</cffunction>

</cfcomponent>