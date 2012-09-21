<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfsilent>
	<cfset report = CreateObject("component", "ptarmigan.report").open(url.id)>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>#report.report_name# - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "98%");
				$("#accordion").accordion();		
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
				$(".pt_buttons").button();
				
				<cfoutput>
				render_report('#session.root_url#', '##report_preview', '#report.id#', 'preview');
				</cfoutput>
				
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				
   		 });
	</script>
</head>
<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="header">
			<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>#report.report_name#</strong></h1></cfoutput></td>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick="add_report('#session.root_url#');"><img src="#session.root_url#/images/add.png"></button>
						<cfif session.user.is_admin() EQ true OR report.employee_id EQ session.user_id>
							<button class="pt_buttons" onclick="window.location.replace('#session.root_url#/reports/edit_report.cfm?id=#report.id#')"><img src="#session.root_url#/images/pencil.png"></button>
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#report.id#');"><img src="#session.root_url#/images/trash.png"></button>
						</cfif>
						<button class="pt_buttons" onclick="window.location.replace('#session.root_url#/reports/edit_report.cfm?id=#report.id#')"><img src="#session.root_url#/images/print.png"></button>
						</cfoutput>
					</td>
				</tr>
			</table>
		</div>	
		<div id="content" style="margin:0px;width:100%;">
			<div id="tabs">
				<ul>
					<cfoutput><li><a href="##results">#report.report_name#</a></li></cfoutput>
				</ul>
				<div id="results">
					<div id="report_preview">
						
					</div>
				</div>
			</div>
		</div>
	</div>

</body>

</html>
