<!--- Open Horizon InstallApp.cfm $Revision: 1.2 $ --->
<cfif NOT IsDefined("URL.DoInstall")>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Install App</title>
</head>

<body>
	<div style="width:100%; background-color:#CCC;">
    	<h1 style="padding:10px;">Install App</h1>
	</div>
   	
    <cfparam name="thisApp" default="">
    <cfset thisApp = createObject("component","OpenHorizon.Apps.App").Open(URL.AppID)>
    <cfoutput>
	<div style="margin-left:80px; margin-right:90px;">
    <p><img src="#thisApp.Icon#" align="absmiddle" /> The <strong>#thisApp.AppName#</strong> app must be installed to your <strong>#session.User.LoginSession.ActiveMembership.MembershipType#</strong> membership on the <strong>#session.User.LoginSession.ActiveMembership.SiteName#</strong> site in order to function in this Open Horizon session.</p>
    
    <p>You will only be required to do this once.</p>
    
    <div style="width:100%; background-color:##efefef;">
    <table cellpadding="0" cellspacing="0">
    	<tr>
        	<td width="200" valign="top"><strong>Application:</strong></td>
            <td>#thisApp.AppName# version #thisApp.Version#</td>
		</tr>
        <tr>
        	<td valign="top"><strong>Vendor:</strong></td>
            <td>#thisApp.Vendor.SiteName#</td>
		</tr>
        <tr>
        	<td valign="top">&nbsp;</td>
            <td><a href="#thisApp.WSDLURL#" target="_blank">View Web Service Description</a></td>
		</tr>            
    </table>
    
    	
    <p style="padding:20px;">#thisApp.Description#</p>
    </div>
    
	<input type="button" value="Install App" onclick="location.replace('/OpenHorizon/Apps/Forms/InstallApp.cfm?AppID=#URL.AppID#&DoInstall');"/>
	</cfoutput>
    </div>
</body>
</html>
<cfelse>
	<cfscript>
		thisApp = createObject("component", "OpenHorizon.Apps.App").Open(URL.AppID);
		thisApp.Install(session.User.LoginSession.ActiveMembership);
	</cfscript>
    
    <cflocation url="/OpenHorizon/exec.cfm?p=#URL.AppID#.Basic.Home.0" addtoken="no">
</cfif>
	