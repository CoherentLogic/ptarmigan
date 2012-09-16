<!--- Open Horizon default.cfm $Revision: 1.3 $ --->
<html>
<head>
	<title>Open Horizon</title>
	<link rel="stylesheet" href="Resources/Styles/OpenHorizon.css">
    <script src="Resources/Scripts/OpenHorizon.js" type="text/javascript"></script>
    <script src="Resources/Scripts/Apps.js" type="text/javascript"></script>

	<cfajaximport tags="cfajaxproxy,cfgrid,cfform,cflayout-border,cftree,cflayout-tab,cfwindow,cfdiv,cfmenu,cfpod">

</head>


<!---<cf_require vars="url.AppID,url.View,url.Params,session.User.LoginSession" onfail="MalformedURL.cfm"/>--->
    
<cfif IsDefined("session.User.LoginSession")>	
<body>  
	
<cfset RLArray = ArrayNew(1)>  
<cfset RLArray = ListToArray(URL.p, ".")>

<cfset session.RL = URL.p>
<cfset session.AppID = RLarray[1] & "." & RLArray[2]>
<cfset session.BaseDir = "/OpenHorizon/AppStorage/" & RLArray[1] & "/" & RLArray[2] & "/Fieldsets/" >
<cfset session.Payload = session.BaseDir & RLArray[3] & "/" & RLArray[4] & ".cfm">
<cfset session.Selector = RLArray[5]>
<cfset session.User.LoginSession.CurrentApp = createObject("component", "OpenHorizon.Apps.App").Open(session.AppID)>

<cfquery name="crl" datasource="webwarecl">
	SELECT * FROM RunLog WHERE AppID='#session.AppID#' AND MembershipID=#session.User.LoginSession.ActiveMembership.MembershipID#
</cfquery>

<cfif crl.RecordCount EQ 0>
	<cfwindow name="SetupDialog" title="Set Up Application" 
		draggable="false"
		resizable="true" 
		initshow="true" 
		height="400" 
		width="500"
		modal="true"
		center="true"
		source="#session.BaseDir#Basic/Setup.cfm"/>
		<cfquery name="srl" datasource="webwarecl">
			INSERT INTO RunLog (
				AppID,
				MembershipID,
				RunDate,
				PValue)
			VALUES (
				'#session.AppID#',
				#session.User.LoginSession.ActiveMembership.MembershipID#,
				#CreateODBCDateTime(Now())#,
				'#URL.p#'
				)		
		</cfquery>
<cfelse>
	<cfquery name="srl" datasource="webwarecl">
	INSERT INTO RunLog (
		AppID,
		MembershipID,
		RunDate,
		PValue)
	VALUES (
		'#session.AppID#',
		#session.User.LoginSession.ActiveMembership.MembershipID#,
		#CreateODBCDateTime(Now())#,
		'#URL.p#'
		)		
	</cfquery>		
</cfif>	
	

<cfinclude template="Identity/Forms/LogoutDialog.cfm">	


<cflayout type="border">

    <cflayoutarea position="top">
    <!--- 	<div style="width:100%; height:50px; background-image:url(/graphics/LightBlueGradient.jpg); background-repeat:repeat-x;">
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/filenew.png" class="_PPM_TOOLBAR_IMAGE"/>
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/fileprint.png" class="_PPM_TOOLBAR_IMAGE" />
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/find.png"  class="_PPM_TOOLBAR_IMAGE"/>
        </div>
     --->    
    
    </cflayoutarea>

	<cflayoutarea position="center">
		<cfinclude template="/OpenHorizon/Apps/Forms/MenuBar.cfm">		
			
        <cfinclude template="#session.Payload#">
   
	</cflayoutarea>

	<cflayoutarea position="left" style="background-color:black;" splitter="true" collapsible="true" size="400" maxsize="500" initCollapsed="true" title="Tools"> 
		<cfinclude template="/OpenHorizon/Apps/Forms/Messaging.cfm">	
    </cflayoutarea>
	
	<cflayoutarea position="bottom" style="background-color:##efefef; text-align:right; height:20px;">
		<cfset img = createObject("component", "OpenHorizon.Graphics.Image")>
		<cfoutput><img src="#img.Silk('Email Open', 16)#"></cfoutput>
	</cflayoutarea>


</cflayout>    
 </body>

<cfelse>
	<cflocation url="Identity/Forms/Login.cfm">
</cfif>	
 </html>