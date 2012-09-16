<!--- Open Horizon TimeCollection.cfc $Revision: 1.2 $ --->
<cfcomponent displayname="Open Horizon Time Collection" hint="The Open Horizon Time Collection application" output="no">
    
    <cffunction name="Connect" access="remote" returntype="string" output="no">
    	<cfargument name="SessionID" type="string" required="yes">
        
   		<cfreturn "Community">
    </cffunction>
    
    <cffunction name="EnumViews" access="remote" returntype="array" output="no">
		<cfparam name="tmpArray" default="">
        <cfset tmpArray = ArrayNew(1)>
        
        <cfscript>
			ArrayAppend(tmpArray, 'Home');
			ArrayAppend(tmpArray, 'Create New Timesheet');
			ArrayAppend(tmpArray, 'My Open Timesheets');			
			
			ArrayAppend(tmpArray, 'First Run');
		</cfscript>
        
        <cfreturn #tmpArray#>		
	</cffunction>
</cfcomponent>