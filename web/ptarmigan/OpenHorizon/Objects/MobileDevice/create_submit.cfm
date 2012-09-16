
<cfset dev = CreateObject("component", "OpenHorizon.Objects.MobileDevice")>
<cfset dev.Create(url.device_name, url.phone_number, url.carrier, session.user.r_pk)>
<cfset dev.Save()>		

<table width="100%" cellpadding="10" cellspacing="0" class="orms_dialog">
	<tr>
		<td align="center" valign="top"><img src="/graphics/sunrise.png" width="100"></td>
		<td align="left" valign="top" style="font-size:14px;">
			<h2 style="color:#2957a2; letter-spacing:6px; text-transform:uppercase;">Mobile Device Created</h2>
			<p>Congratulations! Your mobile device has been created. Click on the <strong>Finish</strong> button to proceed.</p>
			
			<p>Your Device Code is <strong><cfoutput>#dev.ObjectRecord().r_id#</cfoutput></strong></p>
		</td>
	</tr>
</table>		 