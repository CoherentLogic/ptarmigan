<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Prefiniti Notification</title>
<style type="text/css">
	body 
	{
		margin:0;
		font-family:"Segoe UI", Tahoma, Verdana, Arial, Helvetica, sans-serif;			
	}
	
	#Container
	{
		width:640px;
		margin-left:auto;
		margin-right:auto;
		margin-top:30px;
		border:1px solid #c0c0c0;
	}
	
	#Header
	{
		width:100%;
		padding-top:12px;
		padding-bottom:12px;
		background-color:#efefef;
		border-bottom:1px solid #c0c0c0;		
	}
	
	#Content 
	{
		padding:30px;
	}
	
	#Footer
	{
		width:100%;
		padding-top:12px;
		padding-bottom:12px;
		background-color:#efefef;
		border-top:1px solid #c0c0c0;		
	}


	.LandingHeaderText
	{
		font-weight:lighter; 
		font-size:16px; 
		color:#2957A2; 
		font-family:"Segoe UI", Verdana, Arial, Helvetica, sans-serif;
	}
	.FeedView td {
		font-size:12px;
		font-family:"Segoe UI", Tahoma, Verdana, Arial, Helvetica, sans-serif;
	}
	
	.FeedView td p {
		font-size:12px;
		font-family:"Segoe UI", Tahoma, Verdana, Arial, Helvetica, sans-serif;
	}
	
	.EventComment {
		background-color:#efefef; 
		width:350px; 
		padding:5px;
		margin-bottom:2px;		
	}
	
	.EventComment input {
		width:330px;
		padding:5px;
		border:1px solid #999999;
	}
	
	a {
		text-decoration:none;
		font-size:14px;
		font-family:"Segoe UI", Tahoma, Verdana, Arial, Helvetica, sans-serif;
		color:#2957a2;
	}
	
	a:hover {
		text-decoration:underline;
	}
</style>
</head>

<body>
	<div id="Container">
    	<div id="Header">
    	<img src="#session.framework.URLBase#graphics/prenew-small.png" />
        </div>
        <div id="Content">
        	<cfset event = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").OpenByPK(attributes.r_pk)>
            <cfset site = CreateObject("component", "OpenHorizon.Identity.Site").Open(event.object_record.r_site)>
            <cfoutput>
            <cfif site.site_name NEQ "Prefiniti">
	            <img src="#site.Picture(64, 64)#" />
    	        <hr style="width:100%; border:0; height:1px; background-color:##c0c0c0; color:##c0c0c0;" />
            </cfif>
            <table>
                <tr>                    
                    <td valign="top" style="width:64px;">        
                        <img src="#event.event_user.Picture(64, 64)#" />         
                    </td>
                    <td>
                        <span class="LandingHeaderText">#event.event_user.display_name# #LCase(event.event_name)# on #event.object_record.r_type# #event.object_record.r_name#</span><br>
                        <cfif event.body_copy NEQ "">
                            <p>#event.body_copy#</p>
                        </cfif>
                        
                        <div style="border:1px solid ##c0c0c0;background-color:##efefef; padding:8px;">
                        	<a href="#session.framework.URLBase#Prefiniti.cfm?View=#event.object_record.r_id#">View this #event.object_record.r_type#</a>
                        </div>
                        
                        <span style="font-size:9px; color:##999999;">Posted #DateFormat(event.event_date, "long")# #TimeFormat(event.event_date, "h:mm tt")#</span>
                    </td>
                </tr>
            </table>       
            </cfoutput>
        </div>
        <div id="Footer">
        	<span class="LandingHeaderText">
            	Copyright &copy; 2011 Prefiniti Inc.<br />
                All Rights Reserved.
            </span>
		</div>            
    </div>
</body>
</html>
