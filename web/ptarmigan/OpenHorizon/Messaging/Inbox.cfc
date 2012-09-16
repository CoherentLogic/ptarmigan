<cfcomponent displayname="Inbox" extends="OpenHorizon.Framework" hint="Messaging architecture" output="false">
	<cfset this.UsersInThread = ArrayNew(1)>
	
	
	<cffunction name="Open" displayname="Open" hint="Open an inbox by user object" access="public" returntype="OpenHorizon.Messaging.Inbox">
		<cfargument name="User" type="OpenHorizon.Identity.User" hint="The user object" required="true">
			
			<cfquery name="getMessagingUsers" datasource="#this.BaseDatasource#">
				SELECT DISTINCT fromuser FROM messageinbox WHERE touser=#User.DBKey# ORDER BY tdate DESC
			</cfquery>
					
			
			<cfoutput query="getMessagingUsers">
				<cfset tmpUser = createObject("component", "OpenHorizon.Identity.User").OpenByDBKey(fromuser)>
				<cfset ArrayAppend(this.UsersInThread, tmpUser)>
			</cfoutput>
		<cfreturn #this#>
	</cffunction>
	
	<cffunction name="ThreadMessageCountByUser" displayname="ThreadMessageCountByUser" access="public" returntype="numeric">
		<cfargument name="User" type="OpenHorizon.Identity.User" hint="The user object" required="true">
		
		<cfquery name="getTMS" datasource="#this.BaseDatasource#">
			SELECT COUNT(fromuser) AS mc FROM messageinbox WHERE fromuser=#User.DBKey#
		</cfquery>
		
		<cfreturn #getTMS.mc#>
	</cffunction>
	
	<cffunction name="MostRecentMessagePreviewByUser" displayname="MostRecentMessagePreviewByUser" access="public" returntype="string">
		<cfargument name="User" type="OpenHorizon.Identity.User" hint="The user object" required="true">
		
			<cfquery name="mp" datasource="#this.BaseDatasource#">
				SELECT tbody FROM messageinbox WHERE fromuser="#User.DBKey#" ORDER BY tdate DESC
			</cfquery>
			
			<cfoutput query="mp" maxrows="1">
				<cfset tb = Left(tbody, 25) & "...">
			</cfoutput>
			
			<cfreturn #tb#>								
	</cffunction>
	
	<cffunction name="MostRecentMessageDate" displayname="MostRecentMessageDate" access="public" returntype="string">
		<cfargument name="User" type="OpenHorizon.Identity.User" hint="The user object" required="true">
		
			<cfquery name="dp" datasource="#this.BaseDatasource#">
				SELECT tdate FROM messageinbox WHERE fromuser="#User.DBKey#" ORDER BY tdate DESC
			</cfquery>			
			
			<cfoutput query="dp" maxrows="1">
				<cfset tb = DateFormat(tdate, "mm/dd/yyyy") & " " & TimeFormat(tdate, "h:mm tt")>
			</cfoutput>
			
			<cfreturn #tb#>								
	</cffunction>		
		
</cfcomponent>