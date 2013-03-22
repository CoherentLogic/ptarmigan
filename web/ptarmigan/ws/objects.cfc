<cfcomponent output="false" hint="Ptarmigan SOAP API" displayname="objects">

	
 	<cffunction name="object_members" returntype="array" access="remote" output="false">
		<cfargument name="username" type="string" required="true" hint="Ptarmigan account username">
		<cfargument name="password" type="string" required="true" hint="Ptarmigan account password">
		<cfargument name="object_id" type="string" required="true" hint="ID of a Ptarmigan object">
		
		<cftry>
		<cfset sys = CreateObject("component", "ptarmigan.system").init()>

		<cfif sys.authenticate(username, password) EQ true>
			<cfset obj = CreateObject("component", "ptarmigan.object").open(object_id)>
			<cfreturn obj.members()>
		</cfif>
		
		<cfset nRet = ArrayNew(1)>
		<cfreturn nRet>		
		<cfcatch>
		</cfcatch>
		</cftry>
	</cffunction>	 	
		
	<cffunction name="test" returntype="string" access="remote" output="false">		
		<cftry>
		<cfreturn "bodynotch toots">
		<cfcatch></cfcatch>
		</cftry>
	</cffunction>


</cfcomponent>