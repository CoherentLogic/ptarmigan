<cfmodule template="../security/require.cfm" type="">
<cfquery name="get_employees" datasource="#session.company.datasource#">
	SELECT id FROM employees ORDER BY last_name,first_name
</cfquery>
<div style="width:100%; height:100%; position:relative; background-color:white;">
	<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Open Employee" icon="#session.root_url#/images/project_dialog.png">
	<div style="padding:30px; height:200px; width:500px;overflow:auto">
		<table width="100%" style="margin:0;" class="pretty">			
			<cfoutput query="get_employees">
		
				<cfset t = CreateObject("component", "ptarmigan.employee").open(id)>								
				<tr>		
					<td style="border:none;">#t.last_name#, #t.honorific# #t.first_name# #t.middle_initial# #t.suffix#</td>					
					<td style="border:none;"><a class="button" href="javascript:edit_employee('#session.root_url#', '#t.id#');"><span>Open</span></a></td>
				</tr>
			</cfoutput>
		</table>
	</div>
	<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
    	<div style="padding:8px; float:right;" id="create_project_buttons" >
        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>                    	
    	</div>
	</div>
</div>