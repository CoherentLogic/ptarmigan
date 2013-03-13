<div id="dynamic_field_editor">
</div>

<div id="header">
	<cfoutput><img src="#session.root_url#/ptarmigan.png" style="margin-top:8px;"></cfoutput>
	<cfif session.logged_in EQ true>
	<div id="account-info">
		<cfoutput>
		#session.user.full_name()#
		</cfoutput>
	</div>
	</cfif>
</div>


