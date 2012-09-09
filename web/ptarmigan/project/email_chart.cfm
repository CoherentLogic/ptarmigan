<cfset p = CreateObject("component", "ptarmigan.project").open(url.project_id)>
<cfif IsDefined("form.self_post")>
	
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
	
	<cflocation url="#session.root_url#/dashboard.cfm" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="E-MAIL CHART" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="email_chart" id="email_chart" action="#session.root_url#/project/email_chart.cfm?project_id=#url.project_id#&durations=#url.durations#" method="post">
			<div style="padding:20px;">
				<table>
					<tr>
						<td>Recipient:</td>
						<td><cfinput type="text" name="recipient"></td>
					</tr>
					<tr>
						<td>Subject:</td>
						<td><cfinput type="text" size="40" name="subject" value="#p.project_name# GANTT CHART (#ucase(url.durations)#)"></td>
					</tr>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('email_chart');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>




