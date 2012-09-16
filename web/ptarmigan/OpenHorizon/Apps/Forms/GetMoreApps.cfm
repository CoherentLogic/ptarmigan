<!--- Open Horizon GetMoreApps.cfm $Revision: 1.2 $ --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Untitled Document</title>
</head>

<body>
	<div style="width:100%; background-color:#CCC;">
    	<h1 style="padding:10px;">Open Horizon Apps</h1>
		
	</div>
    <input type="button" onclick="NewApp()" value="Create New App">
    <cfparam name="apps" default="">
    <cfset apps = session.User.EnumApps()>
    
    <table width="100%" cellspacing="0" cellpadding="10">
    	     	
		<cfloop array="#apps#" index="app">
    		<cfoutput>
            <tr>
            	<td><img src="#app.Icon#" align="absmiddle" /> <strong>#app.AppName#</strong><br /><p style="margin-left:10px;">#app.Description#</p></td>
                <td>#app.Version#</td>
                <td>#app.Vendor.SiteName#</td>                
            	<td>
                	<cfif session.User.LoginSession.ActiveMembership.IsAppInstalled(app.AppID)>
                    	<strong style="color:blue;">Installed</strong><br /><a href="/System/RemoveApp.cfm?AppID=#app.AppID#">Remove</a>
					<cfelse>
		                <input type="button" value="Open #app.AppName#" onclick="location.replace('/OpenHorizon/exec.cfm?p=#app.AppID#.Basic.Home.0');" />
                	</cfif>
                </td>
            </tr>
            </cfoutput>
	    </cfloop>
	</table>        
        
</body>
</html>