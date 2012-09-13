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
	
	<cffunction name="startOfMonth" returntype="date" access="public" output="false">
		<cfset c_year = dateFormat(Now(), "yyyy")>
		<cfset c_month = dateFormat(Now(), "mm")>
		<cfset c_day = "1">
		<cfset new_date = CreateDate(c_year, c_month, c_day)>		
		<cfreturn new_date>
	</cffunction>

	<cffunction name="endOfMonth" returntype="date" access="public" output="false">
		<cfset c_year = DateFormat(Now(), "yyyy")>
		<cfset c_month = DateFormat(Now(), "mm")>
		<cfset c_day = DaysInMonth(Now())>		
		<cfset new_date = CreateDate(c_year, c_month, c_day)>		
		<cfreturn new_date>	
	</cffunction>
	
	<cffunction name="startOfYear" returntype="date" access="public" output="false">
		<cfset c_year = DateFormat(Now(), "yyyy")>
		<cfset c_month = "01">
		<cfset c_day = "01">		
		<cfset new_date = CreateDate(c_year, c_month, c_day)>		
		<cfreturn new_date>		
	</cffunction>

	<cffunction name="endOfYear" returntype="date" access="public" output="false">
		<cfset c_year = dateFormat(Now(), "yyyy")>
		<cfset c_month = "12">
		<cfset c_day = "31">		
		<cfset new_date = CreateDate(c_year, c_month, c_day)>		
		<cfreturn new_date>	
	</cffunction>
		
</cfcomponent>