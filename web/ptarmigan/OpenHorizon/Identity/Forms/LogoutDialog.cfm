<!--- Open Horizon LogoutDialog.cfm $Revision: 1.3 $ --->
<cfwindow name="LogoutDialog" title="Sign Out" 
draggable="false"
resizable="false" 
initshow="false" 
height="300" 
width="500"
modal="true"
center="true">
<div style="width:100%;height:auto;" align="center">
	<img src="/OpenHorizon/Resources/Graphics/OpenHorizon/prefiniti.png" style="margin:20px;">
    
    <cfoutput>
    <p>This will sign you out of Open Horizon. Your session time today was <strong>#DateDiff("h", session.User.LoginSession.DateOpened, Now())# hours.</strong></p>
    
    <p><label><input type="checkbox">Send all pending notifications now</label></p>
   
   	<br><br>
    <p><input type="button" value="Cancel" onclick="ColdFusion.Window.hide('LogoutDialog');">
    	<input type="button" value="Log Out" onclick="location.replace('/OpenHorizon/Identity/Forms/Logout.cfm');"></p>
	</cfoutput>        
    
</div>
</cfwindow>