<div style="font-size:16px;">
<cfmenu type="horizontal" bgcolor="efefef">
	<cfmenuitem name="ptarmigan" display="ptarmigan">
		<cfif session.logged_in EQ true>
			<cfmenuitem display="Dashboard" href="#session.root_url#/dashboard.cfm"/>
			<cfif session.user.is_admin() EQ true>
				<cfmenuitem display="Company">		
					<cfmenuitem display="Set pay periods" href="#session.root_url#/company/create_pay_periods.cfm"/>
				</cfmenuitem>
			</cfif>
			<cfmenuitem display="Log out" href="#session.root_url#/logout.cfm"/>
		</cfif>
		<cfmenuitem display="About" href="#session.root_url#/about.cfm"/>
	</cfmenuitem>
	<cfif session.logged_in EQ true>
		<cfif session.user.is_project_manager() EQ true>
			<cfmenuitem name="Projects" display="Projects">
				<cfmenuitem display="Add project" href="#session.root_url#/project/add_project.cfm?"/>
				<cfmenuitem display="Edit project" href="#session.root_url#/project/choose_project.cfm?action=edit"/>
				<cfmenuitem display="View project" href="#session.root_url#/project/choose_project.cfm?action=view"/>	
				<cfmenuitem display="Add task code" href="#session.root_url#/project/add_task_code.cfm"/>
				<cfmenuitem display="Edit task code" href="#session.root_url#/project/choose_task_code.cfm?action=edit"/>
			</cfmenuitem>
		</cfif>
		<cfmenuitem name="Time" display="Time">
			<cfmenuitem display="Enter time" href="#session.root_url#/time/add_time.cfm"/>
			<cfmenuitem display="Edit time entry" href="#session.root_url#/time/choose_time.cfm?action=edit"/>
			<cfif session.user.is_time_approver() EQ true>
				<cfmenuitem display="Approve time entries" href="#session.root_url#/time/approve.cfm"/>	
			</cfif>
		</cfmenuitem>
		<cfmenuitem name="Documents" display="Documents">
			<cfmenuitem display="Add document" href="javascript:add_document('#session.root_url#');"/>	
		</cfmenuitem>
		<cfif session.user.is_admin() EQ true>
			<cfmenuitem name="Customers" display="Customers">
				<cfmenuitem display="Add customer" href="#session.root_url#/customer/add_customer.cfm"/>	
				<cfmenuitem display="Edit customer" href="#session.root_url#/customer/choose_customer.cfm?action=edit"/>
				<cfmenuitem display="View customer" href="#session.root_url#/customer/choose_customer.cfm?action=view"/>
			</cfmenuitem>
			
			<cfmenuitem name="Employees" display="Employees">
				<cfmenuitem display="Add employee" href="#session.root_url#/employee/add_employee.cfm"/>
				<cfmenuitem display="Edit employee" href="#session.root_url#/employee/choose_employee.cfm?action=edit"/>
				<cfmenuitem display="View employee" href="#session.root_url#/employee/choose_employee.cfm?action=view"/>								
			</cfmenuitem>
		</cfif>
	</cfif>
</cfmenu>
</div>