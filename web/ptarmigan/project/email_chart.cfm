
<cfset p = CreateObject("component", "ptarmigan.project").open(url.project_id)>

<cfif IsDefined("form.submit")>
	<cfmail from="#session.user.email#" to="#form.recipient#" subject="#form.subject#" type="text/html">
		<html>
		<head>
			<title><cfoutput>#form.subject#</cfoutput></title>
		<style type="text/css">
		table.pretty {
		 margin: 1em 1em 1em 2em;
		 background: whitesmoke;
		 border-collapse: collapse;
		}
		table.pretty th, table.pretty td {
		 border: 1px gainsboro solid;
		 padding: 0.2em;
		 
		}
		table.pretty th {
		 background: gainsboro;
		 text-align: left;
		 color:navy;
		}
		table.pretty caption {
		 margin-left: inherit;
		 margin-right: inherit;
		}
		
		table.pretty tr:hover {
		 background-color:gainsboro;
		 color:navy;
		}
		</style>
		</head>
		<body>
		<cfmodule template="gantt_chart.cfm" id="#url.project_id#" mode="view" durations="#url.durations#">
		<hr>
		<center>
			Powered by ptarmigan<br>
			Copyright &copy; 2012 Coherent Logic Development LLC
		</center>
		</body>
		</html>
		
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