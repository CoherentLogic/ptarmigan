
<cfset report = CreateObject("component", "ptarmigan.report").open(url.id)>

<cfif report.system_report EQ 1>
	<cfmodule template="#session.root_url#/security/require.cfm" type="admin">
<cfelse>
	<cfmodule template="#session.root_url#/security/require.cfm" type="">
</cfif>

<cfset t_class = CreateObject("component", "ptarmigan.object_class").open(report.class_id)>			
<cfset tmp_dobj = CreateObject("component", t_class.component).create()>
<cfset tmp_obj = CreateObject("component", "ptarmigan.object").open(tmp_dobj.id)>
<cfset member_names = tmp_obj.members()>

<cfset tmp_obj.mark_deleted(tmp_obj.get_trashcan_handle())>
	
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
				
				$(".filter_actions").hide();
				
				$(".pt_buttons").button();
				<cfoutput>
					refresh_filters('#session.root_url#', '#report.id#');
					//render_report('#session.root_url#', '##report_preview', '#report.id#', 'preview');
				</cfoutput>
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
   		 });
	</script>
</head>
<body>
	<!--- BEGIN LAYOUT --->
	<cfinclude template="#session.root_url#/navigation.cfm">
	<div id="container">
		<div id="header">
			<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>#report.report_name#</strong></h1></cfoutput></td>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick="window.location.replace('#session.root_url#/reports/report.cfm?id=#report.id#')"><img src="#session.root_url#/images/go.png"></button>
						</cfoutput>
					</td>
				</tr>
			</table>
			
			<!--- <strong>WQL String: </strong> <br><cfoutput>#report.get_wql()#</cfoutput> --->
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
			</div>
		</div>
	</div>
</body>
</html>
<cfset tmp_obj.delete()>