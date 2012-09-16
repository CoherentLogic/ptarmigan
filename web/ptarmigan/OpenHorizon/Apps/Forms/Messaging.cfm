<style type="text/css">
	.msg td {
		background-color:black;
		color:gold;
	}
	.inbox_name {
		font-size:14px;
		font-weight:lighter;
	}
</style>
<cfset inbox = CreateObject("component", "OpenHorizon.Messaging.Inbox").Open(session.User)>
<cftry>
<cfloop array="#inbox.UsersInThread#" index="usr">
	
	<cfoutput>
	<cfif Len(usr.Object.FullName()) GT 3>
	
	
	<table width="100%" cellpadding="5" cellspacing="0" class="msg">
	<tr>
		<td width="21" valign="top">
			<!---<cfset img = createObject("component", "OpenHorizon.Graphics.Image").Create(usr.Object.Picture, 32, 32)>--->
			<img src="#usr.Object.Picture#" width="40" height="40">
		</td>
		<td valign="top">
			<span class="inbox_name">#usr.Object.FullName()#</span> (#Trim(inbox.ThreadMessageCountByUser(usr.Object))# )<br>
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
			<td align="left" style="font-size:xx-small;">#inbox.MostRecentMessagePreviewByUser(usr.Object)#&nbsp;</td>
			<td align="right" style="font-size:xx-small;"><em>#inbox.MostRecentMessageDate(usr.Object)#</em></td>
			</tr>
			</table>
		</td>
	</tr>
	</table>
	<hr>
	</cfif>
	</cfoutput>
					
	
</cfloop>
<cfcatch>
	
</cfcatch>
</cftry>	