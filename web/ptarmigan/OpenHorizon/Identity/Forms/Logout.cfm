<!--- Open Horizon Logout.cfm $Revision: 1.2 $ --->
<cftry>
<cfscript>
	session.User.CloseSession();
</cfscript>
<cfcatch>
<cfoutput>#cfcatch.Message#</cfoutput>
</cfcatch>
</cftry>

<cflocation url="/OpenHorizon/Identity/Forms/Login.cfm" addtoken="no">