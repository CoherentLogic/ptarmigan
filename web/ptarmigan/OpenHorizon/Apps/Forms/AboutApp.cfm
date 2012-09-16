<!--- Open Horizon AboutApp.cfm $Revision: 1.2 $ --->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>About App</title>
</head>

<body>
	<cfparam name="thisApp" default="">
    <cfset thisApp = createObject("component", "OpenHorizon.Apps.App").Open(URL.AppID)>
    
   
    <cfoutput>
    <div style="width:100%;" align="center">
       
       	<p style="padding-top:20px; padding-left:80px; padding-right:80px; padding-bottom:0px;"><strong style="font-size:14px;">#thisApp.AppName#</strong></p>
        <p style="padding-bottom:20px; font-size:8px;">Version #thisApp.Version#</p>
        
        
        <img src="#thisApp.Icon#" />
       
		
        <p style="margin-top:40px; font-size:8px;"><strong>Copyright &copy; #thisApp.Vendor.SiteName#</strong></p>
       
        
        <p style="margin:10px; background-color:##EFEFEF; font-size:8px;">#thisApp.Description#</p>       	
        
        <br /><br />
        
        <input type="button" value="Close" onclick="ColdFusion.Window.hide('About_#thisApp.AppID#');" /><br />
         <a href="#thisApp.WSDLURL#" target="_blank" style="font-size:8px;">View Web Service Description</a>
        
    </div>
    </cfoutput>
</body>
</html>