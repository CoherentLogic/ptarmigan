<div id="dynamic_field_editor">
</div>

<div id="header">
	<cfoutput><img src="#session.root_url#/ptarmigan-full.png" style="margin-top:25px;"></cfoutput>
	<cfif session.logged_in EQ true>
	<div id="account-info">
		<cfoutput>
		#session.user.full_name()#
		</cfoutput>
	</div>
	</cfif>
</div>


