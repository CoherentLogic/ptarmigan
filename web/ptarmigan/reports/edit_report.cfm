<cfsilent>
	<cfset report = CreateObject("component", "ptarmigan.report").open(url.id)>
	<cfset t_class = CreateObject("component", "ptarmigan.object_class").open(report.class_id)>			
	<cfset tmp_dobj = CreateObject("component", t_class.component).create()>
	<cfset tmp_obj = CreateObject("component", "ptarmigan.object").open(tmp_dobj.id)>
	<cfset member_names = tmp_obj.members()>
	
	<cfset tmp_obj.mark_deleted(tmp_obj.get_trashcan_handle())>
	
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfform,cfinput-datefield,cftree">
	<cfoutput>	
		<title>#report.report_name# - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
		
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menu.css" />
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menubar.css" />
		<link type="text/css" href="#session.root_url#/jquery_ui/css/smoothness/jquery-ui-1.8.23.custom.css" rel="Stylesheet" />	
		<link rel="stylesheet" type="text/css" href="#session.root_url#/DataTables/media/css/jquery.dataTables_themeroller.css">
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-ui.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menu.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menubar.js"></script>
		<script type="text/javascript" src="#session.root_url#/DataTables/media/js/jquery.dataTables.js"></script>
		<script src="http://view.jqueryui.com/menubar/ui/jquery.ui.position.js" type="text/javascript"></script>
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "840px");
				$("#accordion").accordion();		
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#add_filter").button();
				$("#add_filter").css("float", "right");
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
				
				<cfoutput>
					refresh_filters('#session.root_url#', '#report.id#');
					render_report('#session.root_url#', '##report_preview', '#report.id#', 'preview');
				</cfoutput>
   		 });
	</script>
</head>
<body>
	<!--- BEGIN LAYOUT --->
	<cfinclude template="#session.root_url#/navigation.cfm">
	<div id="container">
		<div id="header">
			<cfoutput>
				<h1>Editing Report: <strong>#report.report_name#</strong></h1>
			</cfoutput>
		</div>
		<div id="navigation">			
			<div id="accordion">
				<p><a href="##">Include</a></p>
				<div>
					
					<cfloop array="#member_names#" index="member">
						<cfoutput>
							<label><input autocomplete="off" id="include_#member#" onclick="set_column('#session.root_url#', 'include_#member#', '#report.id#', '#member#');" type="checkbox" value="#member#" <cfif report.column_included(member)>checked="checked"</cfif>>#tmp_obj.member_label(member)#</label><br>
						</cfoutput>
					</cfloop>
				</div>
			</div>
		</div>
		<div id="content">
			<div id="tabs">
				<ul>
					<li><a href="#report_filters_tab">Filters</a></li>
					<li><a href="#report_preview_tab">Preview</a></li>			
				</ul>
				<div id="report_filters_tab">										
					<div id="report_filters" style="margin-top:30px; min-height:50px;">
						<span id="filter_message"><p><em>No filters have been defined for this report.</em></p></span>
					</div>
					<hr>
					<h3>Add Filter</h3>					
					<div id="if_wrap">
					<iframe id="add_filter_iframe" style="border:none; width:100%; display:block; height:70px;"></iframe>
					</div>
					
				</div>
				<div id="report_preview_tab">
					<div id="report_preview">
						
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
<cfset tmp_obj.delete()>