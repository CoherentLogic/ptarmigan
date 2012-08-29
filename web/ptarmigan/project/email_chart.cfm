
<cfset p = CreateObject("component", "ptarmigan.project").open(url.project_id)>



<cfif IsDefined("form.submit")>
	<cfset output_file = "#p.id#_#url.durations#.pdf">
	<cfset output_file_path = "#session.upload_path#/#output_file#">
	
	<cfdocument format="PDF" filename="#output_file_path#" overwrite="true" pagetype="custom" pagewidth="40" pageheight="36">
		<cfmodule template="gantt_chart.cfm" id="#url.project_id#" mode="view" durations="#url.durations#">
	</cfdocument>
	<cfmail from="#session.user.email#" to="#form.recipient#" subject="#form.subject#" type="text/html" mimeattach="#output_file_path#">
		
		Attached: Gantt chart (#url.durations#) for #p.project_name#<br>
		<hr>
		<center>
			Powered by ptarmigan<br>
			Copyright &copy; 2012 Coherent Logic Development LLC
		</center>
		
		
	</cfmail>
<cfelse>
	<div style="padding:20px;">
		<cfform name="email_chart" action="email_chart.cfm?project_id=#url.project_id#&durations=#url.durations#&suppress_headers" onsubmit="window.location.reload();">
			<div style="height:180px;">
			<table>
				<tr>
					<td>Recipient:</td>
					<td><cfinput type="text" name="recipient"></td>
				</tr>
				<tr>
					<td>Subject:</td>
					<td><cfinput type="text" name="subject" value="#p.project_name# GANTT CHART (#ucase(url.durations)#)"></td>
				</tr>
			</table>
			</div>
			<input type="submit" name="submit" value="Send">
			<input type="button" onclick="window.location.reload()" value="Cancel">
		</cfform>
	</div>
</cfif>