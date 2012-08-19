
<center>

<cfif IsDefined("session.logged_in")>
	<cfif session.logged_in EQ false>
		<h1>Not Logged In</h1>
		<p>You must be logged in to view this page.</p>
		<cfabort>
	</cfif>
<cfelse>
		<h1>Not Logged In</h1>
		<p>You must be logged in to view this page.</p>
		<cfabort>
</cfif>

<cfswitch expression="#attributes.type#">
	<cfcase value="admin">
		<cfif session.user.is_admin() EQ false>
			<h1>Insufficient Permissions</h1>
			<p>You must have the SITE ADMIN role to view this page.</p>
			<cfabort>
		</cfif>
	</cfcase>
	<cfcase value="time">
		<cfif session.user.is_time_approver() EQ false>
			<h1>Insufficient Permissions</h1>
			<p>You must have the TIME MGR role to view this page.</p>
			<cfabort>
		</cfif>
	</cfcase>
	<cfcase value="project">
		<cfif session.user.is_project_manager() EQ false>
			<h1>Insufficient Permissions</h1>
			<p>You must have the PROJECT MGR role to view this page.</p>
			<cfabort>
		</cfif>
	</cfcase>
	<cfcase value="billing">
		<cfif session.user.is_billing_manager() EQ false>
			<h1>Insufficient Permissions</h1>
			<p>You must have the BILLING MGR role to view this page.</p>
			<cfabort>
		</cfif>
	</cfcase>
</cfswitch>
</center>