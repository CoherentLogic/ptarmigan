<div style="font-size:16px;">
<cfmenu type="horizontal" bgcolor="efefef">
	<cfmenuitem name="ptarmigan" display="ptarmigan">
		<cfif session.logged_in EQ true>
			<cfmenuitem display="Dashboard" href="#session.root_url#/dashboard.cfm"/>
			<cfmenuitem display="Manage Company" href="#session.root_url#/manage.cfm"/>		
			<cfmenuitem display="Log out" href="#session.root_url#/logout.cfm"/>
		</cfif>
		<cfmenuitem display="About" href="#session.root_url#/about.cfm"/>
	</cfmenuitem>
	<cfif session.logged_in EQ true>
		<cfif session.user.is_project_manager() EQ true>
			<cfmenuitem name="Projects" display="Projects">
				<cfmenuitem display="Add project" href="#session.root_url#/project/add_project.cfm"/>
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
<!---
<strong>Workday</strong><br>
<blockquote>
	<a href="right.cfm" target="content">My Dashboard</a>
</blockquote>
<strong>Project Management</strong><br>
<blockquote>
	<a href="project/add_project.cfm" target="content">Add project</a><br>
	<a href="project/choose_project.cfm?action=edit" target="content">Edit project</a><br>
	<a href="project/choose_project.cfm?action=view" target="content">View project</a><br>	
	<a href="project/add_task_code.cfm" target="content">Add task code</a><br>
	<a href="project/choose_task_code.cfm?action=edit" target="content">Edit task code</a>
</blockquote>
<strong>Time Collection</strong><br>
<blockquote>
	<a href="time/add_time.cfm" target="content">Add time</a><br>
	<a href="time/choose_time.cfm?action=edit" target="content">Edit time</a><br>
	<a href="time/approve.cfm" target="content">Approve time</a>
</blockquote>
<strong>Billing &amp; Payments</strong><br>
<blockquote>
	<a href="billing/add_invoice.cfm" target="content">Add invoice</a><br>
	<a href="billing/choose_invoice.cfm?action=add-payment" target="content">Add payment</a>
</blockquote>
<strong>Customer Administration</strong>
<blockquote>
	<a href="customer/add_customer.cfm" target="content">Add customer</a><br>
	<a href="customer/choose_customer.cfm?action=edit" target="content">Edit customer</a><br>
	<a href="customer/choose_customer.cfm?action=view" target="content">View customer</a>
</blockquote>
<strong>Employee Administration</strong>
<blockquote>
	<a href="employee/add_employee.cfm" target="content">Add employee</a><br>
	<a href="employee/choose_employee.cfm?action=edit" target="content">Edit employee</a><br>
	<a href="employee/choose_employee.cfm?action=view" target="content">View employee</a>
</blockquote>
--->