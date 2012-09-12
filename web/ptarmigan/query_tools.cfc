<cfcomponent output="false">
	<cffunction name="currentUser" returntype="string" access="public" output="false">
		<cfreturn session.user.id>
	</cffunction>
	
	<cffunction name="currentDate" returntype="date" access="public" output="false">
		<cfreturn DateFormat(Now(), "mm/dd/yyyy")>
	</cffunction>
	
	<cffunction name="startOfWeek" returntype="date" access="public" output="false">
		<cfreturn DateFormat(DateAdd("d", "-#DayOfWeek(Now()) - 1#", Now()), "mm/dd/yyyy")>
	</cffunction>

	<cffunction name="endOfWeek" returntype="date" access="public" output="false">
		<cfreturn DateFormat(DateAdd("d", "#DayOfWeek(Now()) - 1#", Now()), "mm/dd/yyyy")>
	</cffunction>
	
	<!---<cffunction name="startOfMonth>" returntype="date" access="public" output="false">
	
	</cffunction>

	<cffunction name="endOfMonth" returntype="date" access="public" output="false">
	
	</cffunction>
	
	<cffunction name="startOfYear" returntype="date" access="public" output="false">
	
	</cffunction>

	<cffunction name="endOfYear" returntype="date" access="public" output="false">
	
	</cffunction>--->
		
</cfcomponent>