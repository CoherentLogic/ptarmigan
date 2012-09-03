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
<table class="pretty">
	
	<cfoutput query="get_projects">

		<cfset t = CreateObject("component", "ptarmigan.project").open(id)>
		<form name="open_project" method="post" action="#e_action#">
		<input type="hidden" name="id" value="#t.id#">
		<tr>		
			<td>#t.project_name#</td>
			<td>#t.project_number#</td>
			<td>#dateFormat(t.due_date, "MM/DD/YYYY")#</td>
			<td>#t.customer().company_name#</td>
			<td><a href="#session.root_url#/project/edit_project.cfm?id=#id#">Edit Project</a></td>
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

<!---
<div style="height:100%;position:relative;">
        <cfmodule template="/orms/dialog_header.cfm" icon="/graphics/prefproject.png" caption="Create Project">
        
        <div style="padding-left:30px; margin-top:10px; font-size:14px;" id="project_creator_form">
        
        <form name="create_project" id="create_project">
        <cfoutput>
        <input type="hidden" name="om_uuid" id="om_uuid" value="#CreateUUID()#">
        <input type="hidden" name="client_id" id="client_id" value="#session.user.r_pk#">
        </cfoutput>
        <table width="100%" cellpadding="10" cellspacing="0" class="orms_dialog">
        <tr>
                <td align="right" width="30%"><strong>Name of project</strong></td>
                <td align="left" width="70%">
                        <input type="text" name="description" id="description" size="30">
                </td>
        </tr>
        <tr>
                <td align="right" width="30%"><strong>Create on which site</strong></td>
                <td align="left" width="70%">
                <select name="site_id" id="site_id" style="width:160px;" onchange="ProjLoadProjectTypes(GetValue('site_id'));">
        <cfoutput query="getSites">
                <option value="#site_id#">
                <cfmodule template="/authentication/components/siteNameByID.cfm" id="#site_id#">                                
            </option>
        </cfoutput>
                <option value="" selected>Select site...</option>
        </select>
                </td>
        </tr>
        <tr>
                <td align="right" width="30%"><strong>Type of project to create</strong></td>
                <td align="left" width="70%">
                        <div id="proj_types"> [you must first choose a site]</div>
                </td>   
        </tr>
        
        <tr>
                <td align="right" width="30%"><strong>Project is due by</strong></td>
                <td align="left" width="70%">
                        <cfmodule template="/controls/date_picker.cfm" ctlname="duedate" startdate="#Now()#">
                </td>
        </tr>
        </table>
        </form>
        
        </div>
        
        <div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
                <div style="padding:8px; float:right;" id="create_project_buttons" >
                        <a class="button" href="##" onclick="CloseORMSDialog();"><span>Cancel</span></a>
                        <a class="button" href="##" onclick="ProjCreateProject();"><span><strong>Next</strong></span></a>
                        
                </div>
        </div>
</div>

--->