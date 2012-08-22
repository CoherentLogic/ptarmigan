<cfset asgn = session.user.all_open_assignments()>



<cfdocument format="PDF">
<html>
<head>
	<title>Workday Guide</title>
	
	<style>
		body {
			font-family:Tahoma,Verdana,Arial,Helvetica,sans-serif;
		}
	</style>
</head>
<body>

<cfdocumentitem type="footer">
<hr>
<table width="100%" border="0">
	<tr>
		<td align="left" valign="top">
		<cfoutput>
		<h1>Workday Guide</h1>
		<p><em>#DateFormat(Now(), "full")#</em></p>
		</cfoutput>
		</td>
		<td align="right" valign="bottom">
			<cfoutput>
				#session.user.last_name#, #session.user.honorific# #session.user.first_name# #session.user.middle_initial# #session.user.suffix#
			</cfoutput>
		</td>
	</tr>
</table>
</cfdocumentitem>
<table width="100%" border="0">
	<tr>
		<td align="left" valign="top">
		<cfoutput>
		<h1>Workday Guide</h1>
		<p><em>#DateFormat(Now(), "full")#</em></p>
		</cfoutput>
		</td>
		<td align="right" valign="bottom">
			<cfoutput>
				#session.user.last_name#, #session.user.honorific# #session.user.first_name# #session.user.middle_initial# #session.user.suffix#
			</cfoutput>
		</td>
	</tr>
</table>
<hr>

<cfloop array="#asgn#" index="ca">
	
	<cfset task_codes = ca.task_codes()>
	<cfoutput>
	<h3>#ca.project_name()#</h3>
	

	</cfoutput>
	<cfif ca.location_preference EQ 0>
		<cfset address_string = URLEncodedFormat(ca.address & " " & ca.city & " " & ca.state & "," & ca.zip)>	
	<cfelse>
		<cfset address_string = URLEncodedFormat(ca.latitude & "," & ca.longitude)>
	</cfif>
	<table width="100%" border="0">
		<tr>
			<td valign="top" style="width:300px;">
				<cfoutput>
				<img src="http://maps.googleapis.com/maps/api/staticmap?center=#address_string#&markers=#address_string#&zoom=14&size=300x300&sensor=false&key=AIzaSyAOsXZsfxSM1JwTHVXOJz6UAXWqhR13Hfg">
				</cfoutput>
			</td>
			<td valign="top">
				<cfoutput>
					<p><em>#ca.customer_name()#</em></p>
					
					<strong>Milestone:</strong> #ca.milestone_name()#<br>
					<strong>Subtask:</strong> #ca.task_name()#<br><br>
					
					<strong>Location:</strong>
					<blockquote>
					<cfif ca.location_preference EQ 0>
						#ca.address#<br>
						#ca.city#, #ca.state# #ca.zip#
					<cfelse>
						<strong>Latitude:</strong> #ca.latitude#<br>
						<strong>Longitude:</strong> #ca.longitude#
					</cfif>
					</blockquote>
				</cfoutput>
			</td>		
		</tr>
	</table>
	<cfoutput>				
		<h3>Instructions:</h3>
			<blockquote>
				#ca.instructions#
			</blockquote>
		<h3>Task codes:</h3>
		<ul>
		<cfloop array="#task_codes#" index="tc">
			<li>#tc.task_name#</li>
		</cfloop>
		</ul>
	</cfoutput>
	<cfdocumentitem type="pagebreak"/>
	
	<cfoutput>
	<h3>#ca.project_name()# - TIME ENTRY</h3>
	</cfoutput>
	<table width="100%" border="1" cellpadding="3">
	<tr>
		<th>TASK CODE</th>
		<th>DATE</th>
		<th>START TIME</th>
		<th>END TIME</th>
		<th>HOURS</th>
	</tr>
	<cfset topind = 25 / ArrayLen(task_codes)>
	<cfloop array="#task_codes#" index="tc">
		<cfoutput>
		
		<cfloop from="1" to="#topind#" index="i">
		<tr>
			<td>#tc.task_name#</td>
			<td>#DateFormat(Now(), "M/DD/YYYY")#</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		</cfloop>
		</cfoutput>
	</cfloop>
	</table>
</cfloop>
</body>
</html>
</cfdocument>