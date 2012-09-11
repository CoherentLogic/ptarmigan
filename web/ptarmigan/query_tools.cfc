<cfcomponent output="false">
	<cffunction name="currentUser" returntype="string" access="public" output="false">
		<cfreturn session.user.id>
	</cffunction>
	
	<cffunction name="currentDate" returntype="date" access="public" output="false">
		<cfreturn DateFormat(Now(), "mm/dd/yyyy")>
	</cffunction>
		
</cfcomponent>