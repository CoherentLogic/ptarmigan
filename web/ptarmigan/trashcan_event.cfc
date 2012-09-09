<cfcomponent output="false">
	<cfset this.objects = ArrayNew(1)>

	<cffunction name="open" returntype="ptarmigan.trashcan_event" access="public" output="false">
		<cfargument name="trashcan_handle" type="string" required="true">	
		
		<cfset this.trashcan_handle = trashcan_handle>
		
		<cfquery name="go" datasource="#session.company.datasource#">
			SELECT id FROM objects WHERE trashcan_handle='#this.trashcan_handle#' AND deleted=1
		</cfquery>
		
		<cfset this.objects = ArrayNew(1)>
		<cfoutput query="go">
			<cfset t = CreateObject("component", "ptarmigan.object").open(go.id)>
			<cfset ArrayAppend(this.objects, t)>
		</cfoutput>
		
		<cfreturn this>
	</cffunction>

</cfcomponent>