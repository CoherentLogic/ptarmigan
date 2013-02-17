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
	
	<cfset stats = CreateObject("component", "company.statistics")>
	
	<cfquery name="get_pay_periods" datasource="#session.company.datasource#">
		SELECT 		* 
		FROM 		pay_periods 
		ORDER BY 	start_date
	</cfquery>

</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<cfoutput>	
		<title>Dashboard - Ptarmigan</title>
		<link rel="icon" 
    	  type="image/x-icon" 
	      href="#session.root_url#/favicon.ico">
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$('#navigation_bar').css("float", "left");
				$(".ui-state-default").css("color", "black");
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
   		 });
	</script>
</head>
<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->
	<cfinclude template="#session.root_url#/navigation.cfm">
	<div id="container">
		
		<div id="content" style="width:100%;margin-left:0;">
			<div id="tabs">
				<ul>
					<li><a href="#tab1"><cfoutput><img src="#session.root_url#/images/zoom.png" align="absmiddle" style="margin-right:8px;"></cfoutput>Quick View</a></li>
					<!---<li><a href="#tab2#"><cfoutput><img src="#session.root_url#/images/note.png" align="absmiddle" style="margin-right:8px;"></cfoutput>Notes</li>--->
				</ul>
				<div id="tab1">
					<div class="dashboard_element" style="width:100%;overflow:hidden;">
						<div class="dashboard_element_header"><p>This Week's Priority Projects</p></div>
						<table width="100%" class="calendar">
						<tr>
							<th>Sun</th>
							<th>Mon</th>
							<th>Tue</th>
							<th>Wed</th>
							<th>Thu</th>
							<th>Fri</th>
							<th>Sat</th>
						</tr>
						<cfset next_day = DateAdd("d", "-#DayOfWeek(Now()) - 1#", Now())>
						<tr>
						<cfloop from="1" to="7" index="dayNum">
							<cfif dayNum EQ 1 or dayNum EQ 7>
								<cfset bgc = "whitesmoke">
							<cfelse>
								<cfset bgc = "white">
							</cfif>
							<!--- <cfif dateFormat(Now(), "mm/dd/yyyy") EQ dateFormat(next_day, "mm/dd/yyyy")>
								<cfset bgc = "white">
							</cfif> --->
							
							<td <cfoutput>style="background-color:#bgc#;"</cfoutput>>
								
								<span class="date_bar"><cfoutput>#dateFormat(next_day, "d")#</cfoutput></span>
								<div>									
								<cfset priority_projects = CreateObject("component", "ptarmigan.company").priority_projects(next_day, next_day)>
								<cfloop array="#priority_projects#" index="p">
									<cfoutput><a href="project/edit_project.cfm?id=#p.id#">#p.project_name# DUE</a><br></cfoutput>
								</cfloop>
								</div>
							</td>
							<cfset next_day = dateAdd("d", 1, next_day)>
						</cfloop>
						</tr>
						</table>
					</div>				
					<cfset active_projects = session.company.active_projects()>
					<div class="dashboard_element" style="width:100%;overflow:hidden;">
						<div class="dashboard_element_header" style="background-color:#e17009; color:white;"><p>Active Projects</p></div>	
						<table width="100%" cellpadding="0" cellspacing="0" class="dashboard_table">		
						<tr>
							<th>Project</th>
							<th>Due Date</th>			
						</tr>							
						<cfloop array="#active_projects#" index="p">
							<cfoutput>
								<tr>
									<td width="70%" style="padding:3px;"><a href="#session.root_url#/project/edit_project.cfm?id=#p.id#">#p.project_name#</td>
									<td width="30%" style="padding:3px;">#dateFormat(p.due_date, "m/dd")#</td>
								</tr>
							</cfoutput>
						</cfloop>
						</table>
					</div>	
									
					<div class="dashboard_element" style="width:100%;overflow:hidden;">
						<cfset active_tasks = session.company.active_tasks()>
					
						<div class="dashboard_element_header" style="background-color:blue; color:white;"><p>Active Tasks</p></div>	
						<table width="100%" cellpadding="0" cellspacing="0"  class="dashboard_table">		
						<tr>
							<th>Task</th>
							<th>Due Date</th>			
						</tr>							
						<cfloop array="#active_tasks#" index="t">
							<cfoutput>
								<tr>
									<td width="70%" style="padding:3px;"><a href="#session.root_url#/project/edit_project.cfm?id=#t.project().id#">#t.project().project_name#</a>: #t.task_name#</td>
									<td width="30%" style="padding:3px;">#dateFormat(t.end_date, "m/dd")# (#t.percent_complete#%)</td>
								</tr>
							</cfoutput>
						</cfloop>
						</table>
					</div>						
				</div>				
			</div>
		</div>
	</div>

</body>

</html>
