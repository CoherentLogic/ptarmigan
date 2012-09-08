<cfmodule template="../security/require.cfm" type="">
<cfquery name="get_projects" datasource="#session.company.datasource#">
	SELECT id FROM projects ORDER BY due_date
</cfquery>

<cfswitch expression="#url.action#">
	<cfcase value="edit">
		<cfset e_action="edit_project.cfm">
	</cfcase>
	<cfcase value="view">
		<cfset e_action="view_project.cfm">
	</cfcase>
</cfswitch>
<div style="width:100%; height:100%; position:relative; background-color:white;">
<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Open Project" icon="#session.root_url#/images/project_dialog.png">
<div style="padding:30px; height:200px; width:500px;overflow:auto">
<table class="pretty" style="margin:0;width:100%;">
	
	<cfoutput query="get_projects">

		<cfset t = CreateObject("component", "ptarmigan.project").open(id)>
		<form name="open_project" method="post" action="#e_action#">
			<input type="hidden" name="id" value="#t.id#">
			<tr>		
				<td style="border:none;">#t.project_name#</td>				
				<td style="border:none;">#t.customer().company_name#</td>
				<td style="border:none;"><a class="button" href="#session.root_url#/project/edit_project.cfm?id=#id#"><span>Open</span></a></td>
			</tr>		
		</form>
	</cfoutput>	
</table>
</div>
 	<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
    	<div style="padding:8px; float:right;" id="create_project_buttons" >
        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>                    	
    	</div>
	</div>
</div>

