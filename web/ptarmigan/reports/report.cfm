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
	<cfinclude template="#session.root_url#/navigation.cfm">
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="inner-tube">
		<div id="content-right">
			<cfinclude template="#session.root_url#/sidebar.cfm">
		</div> <!--- content-right --->
		<div id="content" style="margin:0px;width:80%;">		
			<cfmodule template="#session.root_url#/navigation-tabs.cfm">
			<cfif session.user.is_admin() EQ true OR report.employee_id EQ session.user_id>
				<cfoutput>
				<div class="toolbar">
				<div style="padding:10px;">
				<button class="pt_buttons" onclick="window.location.replace('#session.root_url#/reports/edit_report.cfm?id=#report.id#')"><img src="#session.root_url#/images/pencil.png"> Edit Report</button>
				</div>
				</div>
				</cfoutput>
			</cfif>										
			<div id="tabs-min">
				<ul>
					<cfoutput><li><a href="##results">#report.report_name#</a></li></cfoutput>
				</ul>
				<div id="results">
					<div id="report_preview">
						
					</div>
				</div>
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>

