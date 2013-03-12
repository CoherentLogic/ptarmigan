<cfquery name="g_system_reports" datasource="#session.company.datasource#">
	SELECT id, report_name FROM reports WHERE system_report=1 AND class_id='OBJ_REPORT' ORDER BY report_name
</cfquery>

<cfif isdefined("url.id")>
	<cftry>
		<cfset current_object = CreateObject("component", "ptarmigan.object").open(url.id)>
		<cfif current_object.id EQ url.id>
			<cfset object_loaded = true>
		<cfelse>
			<cfset object_loaded = false>
		</cfif>
		<cfcatch type="any">
			<cfset object_loaded = false>
		</cfcatch>
	</cftry>
<cfelse>
	<cfset object_loaded = false>
</cfif>

<div id="navigation-tabs">
	<ul>
		<cfif object_loaded EQ true>
			<li><a href="#object"><cfoutput>#current_object.get().object_name()#</cfoutput></a></li>
		</cfif>
		<li><a href="#ptarmigan">Ptarmigan</a></li>
		<li><a href="#reports">Reports</a></li>
		<li><a href="#projects">Projects</a></li>
		<li><a href="#documents">Documents</a></li>
		<li><a href="#customers">Customers</a></li>
		<li><a href="#employees">Employees</a></li>
		<li><a href="#parcels">Parcels</a></li>
	</ul>
		<cfif object_loaded EQ true>
			<div id="object">
				<div class="sub-navigation">
					<cfoutput>
					<ul>
						<li><a href="javascript:discuss_object('#session.root_url#', '#current_object.id#');">Discuss</a></li>
						<li><a href="#session.root_url#/objects/add_to_basket.cfm?id=#current_object.id#">Add to Basket</a></li>
						<li><a href="javascript:trash_object('#session.root_url#', '#current_object.id#');">Move to Trash Can</a></li>						
					</ul>
					</cfoutput>
				</div>
			</div>
		</cfif>
		<div id="ptarmigan">
			<div class="sub-navigation">
			<ul>					
				<cfif session.logged_in EQ true>
					<cfoutput>
					<li><a href="#session.root_url#/dashboard.cfm">Dashboard</a></li>
					<li><a href="javascript:trash_can('#session.root_url#');">Trash Can</a></li>
					<li><a href="#session.root_url#/logout.cfm">Log out</a></li>
					</cfoutput>
				</cfif>

				<cfoutput><li><a href="javascript:about_ptarmigan();">About Ptarmigan</a></li></cfoutput>
			</ul>
			</div>
		</div>
		<div id="reports">
			<div class="sub-navigation">
			<ul>
				<cfoutput>
				<li><a href="javascript:add_report('#session.root_url#');">New Report</a></li>
				</cfoutput>
				<cfoutput query="g_system_reports">
					<li><a href="#session.root_url#/reports/report.cfm?id=#g_system_reports.id#">#g_system_reports.report_name#</a></li>
				</cfoutput>
			</ul>
			</div> <!--- sub-navigation --->
		</div>
		<div id="documents">
			<div class="sub-navigation">
				<ul>
					<cfif session.logged_in EQ true>
					<cfoutput>
					<li><a href="javascript:add_document('#session.root_url#');">New Document</a></li>
					<li><a href="javascript:search_documents('#session.root_url#');">Search Documents</a></li>
					</cfoutput>
					</cfif>
				</ul>
			</div> <!--- sub-navigation --->
		</div>
		<div id="parcels">
			<div class="sub-navigation">
				<ul>
					<li><a href="#session.root_url#/parcels/define_parcel.cfm">New Parcel</a></li>
					<li><a href="javascript:search_parcels('#session.root_url#');">Search Parcels</a></li>
					<li><a href="#session.root_url#/parcels/parcel_map.cfm" target="_blank">View Map</a></li>
				</ul>
			</div> <!--- sub-navigation --->
		</div>
		<div id="projects">
			<div class="sub-navigation">
				<ul>
					<li><a href="javascript:add_project('#session.root_url#');">New Project</a></li>
					<li><a href="javascript:open_project('#session.root_url#');">Open Project</a></li>
				</ul>
			</div> <!--- sub-navigation --->
		</div>
		<div id="customers">
			<div class="sub-navigation">
				<ul>
					<li><a href="javascript:add_customer('#session.root_url#');">New Customer</a></li>
					<li><a href="javascript:open_customer('#session.root_url#');">Open Customer</a></li>
				</ul>
			</div> <!--- sub-navigation --->
		</div>
		<div id="employees">
			<div class="sub-navigation">
				<ul>
					<li><a href="javascript:add_employee('#session.root_url#');">New Employee</a></li>
					<li><a href="javascript:open_employee('#session.root_url#');">Open Employee</a></li>
				</ul>
			</div> <!--- sub-navigation --->
		</div>				
</div>