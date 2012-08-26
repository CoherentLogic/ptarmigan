<cffunction name="hours_decimal" returntype="numeric" access="public" output="false">
	<cfargument name="start_time" type="date" required="true">
	<cfargument name="end_time" type="date" required="true">
		
	<cfset diff_min = datediff("n", RoundTo15(start_time), RoundTo15(end_time))>
		
	<cfreturn diff_min / 60>
</cffunction>

<cffunction name="RoundTo15" returntype="date" access="public" output="false">
	<cfargument name="theTime" type="date" required="true">
		
		
	<cfset roundedMinutes = round(minute(theTime) / 15 ) * 15>
	<cfset newHour = hour(theTime)>
    
	<cfif roundedMinutes EQ 60>
		<cfset newHour=newHour + 1>
   	    <cfset roundedMinutes = 0>
	</cfif>
    	
	<cfreturn dateFormat(theTime, "MM/DD/YYYY") & " " & timeFormat(createTime(newHour,roundedMinutes,0),"h:mm tt")>    
 </cffunction>