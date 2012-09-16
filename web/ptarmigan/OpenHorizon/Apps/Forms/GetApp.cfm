<!--- Open Horizon GetApp.cfm $Revision: 1.2 $ --->
<cfsetting showdebugoutput="no">
<cfcontent type="application/x-javascript">

<cfscript>
	theJSON = createObject("component", "OpenHorizon.Apps.App").Open(URL.AppID).GetJSON();
	writeOutput(theJSON);
</cfscript>	