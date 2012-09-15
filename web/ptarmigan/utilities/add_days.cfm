<cfswitch expression="#url.exclude_weekends#">
	<cfcase value="false">
		<cfoutput>#dateFormat(dateAdd("d", url.days, url.start_date), "mm/dd/yyyy")#</cfoutput>
	</cfcase>
	<cfcase value="true">
		<cfset days_counted = 0>
		<cfset next_date = CreateODBCDate(url.start_date)>
		<cfloop condition="#days_counted# NEQ #url.days#">
			<cfif (DayOfWeek(next_date) NEQ 1) AND (DayOfWeek(next_date) NEQ 7)>				
				<cfset days_counted = days_counted + 1>				
			</cfif>
			<cfset next_date = dateAdd("d", 1, next_date)>
		</cfloop>
		<cfoutput>#dateFormat(next_date, "mm/dd/yyyy")#</cfoutput>
	</cfcase>
</cfswitch>