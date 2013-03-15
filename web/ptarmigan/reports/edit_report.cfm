<cfmodule template="#session.root_url#/security/require.cfm" type="">
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
	
				
				$("#add_filter").button();
				$("#add_filter").css("float", "right");
								
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
			<cfoutput>
				<div class="toolbar">
				<div style="padding:10px;">
				<button class="pt_buttons" onclick="window.location.replace('#session.root_url#/reports/report.cfm?id=#report.id#')"><img src="#session.root_url#/images/go.png"> Run Report</button>
				</div>
				</div>
			</cfoutput>
			<div class="form_instructions" style="width:auto; font-weight:lighter;">
				<p>
					<strong>Reports can use any of the following variable criteria (the rightmost field in the "Report Filters" tab):</strong>
					
					<blockquote>
						<strong>{currentUser}:</strong> Represents the user who is logged in<br>
						<strong>{currentDate}:</strong> Represents the current date<br>
						<strong>{startOfWeek}:</strong> Represents the first day of the current week<br>
						<strong>{endOfWeek}:</strong> Represents the last day of the current week<br>
						<strong>{startOfMonth}:</strong> Represents the first day of the current month<br>
						<strong>{endOfMonth}:</strong> Represents the last day of the current month<br>
						<strong>{startOfYear}:</strong> Represents the first day of the current year
					</blockquote>
				</p>
				<strong>WQL: </strong> <span style="font-weight:lighter;"><cfoutput>#report.get_wql()#</cfoutput></span>
			</div>						
			<div id="tabs-min">
				<ul>
					<li><a href="#report_filters_tab">Report Filters</a></li>
					<li><a href="#included_fields">Included Fields</a></li>
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
				<div id="included_fields">
					<div style="padding:20px;">
						<cfloop array="#member_names#" index="member">
							<cfoutput>
								<label><input autocomplete="off" id="include_#member#" onclick="set_column('#session.root_url#', 'include_#member#', '#report.id#', '#member#');" type="checkbox" value="#member#" <cfif report.column_included(member)>checked="checked"</cfif>>#tmp_obj.member_label(member)#</label><br>
							</cfoutput>
						</cfloop>
					</div>
				</div>
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>
<cfset tmp_obj.delete()>
