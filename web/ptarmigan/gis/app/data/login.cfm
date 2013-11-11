<cfset requestBody = toString(getHttpRequestData().content)>
<cfset login_packet = deserializejson(requestBody)>
<cfset t_user = CreateObject("component", "ptarmigan.employee").open_by_username(login_packet.username)>
<cfset auth_struct = structnew()>
<cfif t_user.id NEQ 0>
	<!--- good user id --->
	<cfif t_user.password_hash EQ hash(login_packet.password)>
		<cfif t_user.active EQ 1>
			<cfset session.logged_in = true>		
			<cfset session.user = t_user>
			<cfset session.message = "Welcome to Ptarmigan GIS, " & t_user.first_name & "<br><br>" & "You may now access restricted features of the application.">
			
			<cfset auth_struct.success = true>
			<cfset auth_struct.message = session.message>
			
		<cfelse>
			<cfset session.logged_in = false>
			<cfset session.message = "This account is not active">
			<cfset auth_struct.success = false>
			<cfset auth_struct.message = session.message>
		</cfif>
	<cfelse>
		<cfset session.logged_in = false>
		<cfset session.message = "Invalid username or password">
		<cfset auth_struct.success = false>
		<cfset auth_struct.message = session.message>
	</cfif>
	
<cfelse>
	<cfset session.logged_in = false>
	<cfset session.message = "Invalid username or password">
	<cfset auth_struct.success = false>
	<cfset auth_struct.message = session.message>
</cfif>	
<cfoutput>#serializejson(auth_struct)#</cfoutput>