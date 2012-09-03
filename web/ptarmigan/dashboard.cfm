<cfsilent>
	<cfmodule template="security/require.cfm" type="">

	<cfif IsDefined("form.current_pay_period")>
		<cfset pay_period_id = form.current_pay_period>
	<cfelseif IsDefined("url.pay_period_id")>
		<cfset pay_period_id = url.pay_period_id>
	</cfif>
	
	<cfif NOT IsDefined("url.pay_period_id") AND NOT IsDefined("form.current_pay_period")>
		<cfquery name="get_current_pay_period" datasource="#session.company.datasource#">
			SELECT 	* 
			FROM 	pay_periods 
			WHERE 	start_date<=#CreateODBCDate(Now())#
			AND 	end_date>=#CreateODBCDate(Now())#
		</cfquery>
		<cfset selected_pay_period_id = get_current_pay_period.id>
		<cfset pay_period_id = get_current_pay_period.id>
	<cfelse>
		<cfquery name="get_current_pay_period" datasource="#session.company.datasource#">
			SELECT	*
			FROM	pay_periods
			WHERE	id='#pay_period_id#'
		</cfquery>
		
		
		<cfset selected_pay_period_id = pay_period_id>
	
	</cfif>
	
	
	
	<cfset open_date = get_current_pay_period.start_date>
	<cfset close_date = get_current_pay_period.end_date>
	<cfif get_current_pay_period.closed EQ 1>
		<cfset period_status = "CLOSED">
	<cfelse>
		<cfset period_status = "OPEN">
	</cfif>
	
	<cfset stats = CreateObject("component", "ptarmigan.company.statistics")>
	
	<cfquery name="get_pay_periods" datasource="#session.company.datasource#">
		SELECT 		* 
		FROM 		pay_periods 
		ORDER BY 	start_date
	</cfquery>

</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab,cflayout-border">
	<cfoutput>	
		<title>DOC TITLE - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
		
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menu.css" />
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menubar.css" />
		<link type="text/css" href="#session.root_url#/jquery_ui/css/redmond/jquery-ui-1.8.23.custom.css" rel="Stylesheet" />	
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-ui.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menu.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menubar.js"></script>
		<script src="http://view.jqueryui.com/menubar/ui/jquery.ui.position.js" type="text/javascript"></script>
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "850px");
				$("#accordion").accordion();		
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
   		 });
	</script>
</head>
<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->
	<div id="container">
		<div id="header">
			<cfinclude template="#session.root_url#/top.cfm">
			<cfinclude template="#session.root_url#/navigation.cfm">			
		</div>	
		<div id="navigation">			
			<div id="accordion">
				<p><a href="##">Pay Period</a></p>
				<div>
					<form name="change_pay_period" action="dashboard.cfm" method="post">
					<table class="property_dialog">
						<tr>
							<td>Date range</td>
							<td>
								<select name="current_pay_period" onchange="this.form.submit();">
									<cfoutput query="get_pay_periods">
										<option value="#id#" <cfif selected_pay_period_id EQ id>selected</cfif>>#dateFormat(start_date, 'm/dd/yyyy')#-#dateFormat(end_date, 'm/dd/yyyy')#</option>
									</cfoutput>
								</select>
							</td>						
						</tr>
						<tr>
							<td>Status</td>
							<td><cfoutput>#period_status#</cfoutput></td>					
						</tr>
						<tr>
							<td>Hours worked (me)</td>
							<td><cfoutput>#stats.hours_worked(open_date, close_date, session.user.id)#</cfoutput></td>
						</tr>
						<cfif session.user.is_time_approver() EQ true>
						<tr>
							<td>Hours worked (company)</td>
							<td><cfoutput>#stats.hours_worked(open_date, close_date)#</cfoutput></td>
						</tr>
						</cfif>
						<cfif session.user.is_project_manager() EQ true>
						<tr>
							<td>Projects active</td>
							<td>
								<cfoutput>
									#stats.projects_open(open_date, close_date)#
								</cfoutput>	
							</td>
						</tr>
						</cfif>
						<tr>
							<td>Assignments (me)</td>
							<td>
								<cfoutput>
									#stats.assignments_open(open_date, close_date, session.user.id)#
								</cfoutput>
							</td>
						</tr>
						<cfif session.user.is_project_manager() EQ true>
						<tr>
							<td>Assignments (company)</td>
							<td>
								<cfoutput>
									#stats.assignments_open(open_date, close_date)#								
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td>Milestones active</td>
							<td>
								<cfoutput>
									#stats.milestones_open(open_date, close_date)#
								</cfoutput>
							</td>						
						</tr>
						<tr>
							<td>Tasks active</td>
							<td>
								<cfoutput>
									#stats.tasks_open(open_date, close_date)#
								</cfoutput>
							</td>
						</tr>
						</cfif>
					</table>
					<input type="submit" name="change_pay_period" value="Update">
					</form>
				</div> <!--- pay period section --->
			</div>
		</div>
		<div id="content">
			<div id="tabs">
				<ul>
					<li><a href="#tab1">Tab 1</a></li>
					<li><a href="#tab2">Tab 2</a></li>
				</ul>
				<div id="tab1">
					Tab 1 content
				</div>
				<div id="tab2">
					Tab 2 content
				</div>
			</div>
		</div>
	</div>

</body>

</html>
