
	<table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:20px;">
		<tr>
			<td>				
				<img src="/ptarmigan/ptarmigan.png">
			</td>
			<td align="right" valign="bottom">
				
					<cfoutput>
						#session.user.full_name()#
								
						<cfif session.user.is_admin() EQ true>
							<img align="absmiddle" src="#session.root_url#/images/site_admin.png" onmouseover="Tip('Administrator');" onmouseout="UnTip();">
						</cfif>
						
						<cfif session.user.is_project_manager() EQ true>
							<img align="absmiddle" src="#session.root_url#/images/stats.png" onmouseover="Tip('Project Manager');" onmouseout="UnTip();">
						</cfif>
						<cfif session.user.is_billing_manager() EQ true>
							<img align="absmiddle" src="#session.root_url#/images/expense.png" onmouseover="Tip('Billing Manager');" onmouseout="UnTip();">
						</cfif>
					</cfoutput>							
			</td>
		</tr>
	</table>
	<cfif session.logged_in NEQ true>
		<center>
		
		<p><cfoutput>#session.message#</cfoutput></p>
		</center>
	<cfelse>
		
	</cfif>
