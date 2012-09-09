<div id="menu_header">
	<cfoutput>		
		<ul id="navigation_bar" class="menubar-icons">
			<li>
				<a href="##ptarmigan">Ptarmigan</a>
				<ul>					
					<cfif session.logged_in EQ true>
						<li><a href="#session.root_url#/dashboard.cfm">Dashboard</a></li>
						<cfif session.user.is_admin() EQ true>
							<li>
								<a href="##company">Company</a>
								<ul>								
									<li><a href="#session.root_url#/company/create_pay_periods.cfm">Create pay periods</a></li>
								</ul>
							</li>
						</cfif>
						<li><a href="javascript:trash_can('#session.root_url#');">Trash Can</a></li>
						<li><a href="#session.root_url#/logout.cfm">Log out</a></li>
					</cfif>
					<li><a href="#session.root_url#/about.cfm">About Ptarmigan</a></li>
				</ul>
			</li>	
			<cfif session.logged_in EQ true>
				<cfif session.user.is_project_manager() EQ true>
					<li>
						<a href="##projects">Projects</a>
						<ul>
							<li><a href="javascript:add_project('#session.root_url#');">Add</a></li>
							<li><a href="javascript:open_project('#session.root_url#');">Open</a></li>
						</ul>
					</li>
				</cfif>
				<li>
					<a href="##Documents">Documents</a>
					<ul>
						<li><a href="javascript:search_documents('#session.root_url#');">Search</a></li>
						<li><a href="javascript:add_document('#session.root_url#');">Add</a></li>
					</ul>
				</li>
				<cfif session.user.is_admin() EQ true>
					<li>
						<a href="##Customers">Customers</a>
						<ul>
							<li><a href="javascript:add_customer('#session.root_url#');">Add</a></li>
							<li><a href="javascript:open_customer('#session.root_url#');">Open</a></li>
						</ul>
					</li>
					<li>
						<a href="##Employees">Employees</a>
						<ul>
							<li><a href="javascript:add_employee('#session.root_url#');">Add</a></li>
							<li><a href="javascript:open_employee('#session.root_url#');">Open</a></li>
						</ul>
					</li>				
				</cfif>
				<li>
					<a href="##Parcels">Parcels</a>
					<ul>
						<li><a href="javascript:search_parcels('#session.root_url#');">Search</a></li>
						<li><a href="#session.root_url#/parcels/parcel_map.cfm" target="_blank">View Map</a></li>
						<li><a href="#session.root_url#/parcels/define_parcel.cfm">Add</a></li>
					</ul>
				</li>
				<cfif session.current_object NEQ "">
					<li>
						<a href="##Object">#session.current_object.class_name#</a>
						<ul>
							<!---
							<li><a href="javascript:discuss_object('#session.root_url#', '#session.current_object.id#');">Discuss</a></li>
							--->
							<li><a href="javascript:trash_object('#session.root_url#', '#session.current_object.id#');">Move to Trash Can</a></li>
				
						</ul>
					</li>
				</cfif>
			</cfif>
		</ul>
	</cfoutput>
	<div style="float:right;text-align:right;position:absolute;top:0px;right:0px;">
		<cfoutput>
			<span style="color:navy;">
				#session.user.full_name()#<br>
			</span>
											
			<span style="color:navy;">#session.message#</span>
		</cfoutput>				
	</div>
</div>	
