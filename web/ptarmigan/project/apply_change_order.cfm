<cfsilent>
	<cfset project = CreateObject("component", "ptarmigan.project").open(url.project_id)>
	<cfset milestones = project.milestones()>
</cfsilent>

<cfif IsDefined("form.self_post")>
	
	<!---
	TODO: Add submit action here
	--->
	
	<cflocation url="#session.root_url#/dashboard.cfm" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Apply Change Order" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="form_name" id="form_id" action="#session.root_url#/***ACTION***" method="post">
			<div style="padding:20px;">
				<table width="100%" cellspacing="10">
					<tr>
						<td width="20%">Change order:</td>
						<td width="80%">
							<select name="change_order_number">
								<option value="">134-234918</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Apply to:</td>
						<td>	
							<div style="height:215px;">
								<p><label><input type="radio" name="apply_to" value="new_task" checked="checked" onclick="set_apply_controls();">New task</option></p>
								<div style="margin:20px; display:block;" id="new_task_controls">
								<table>
									<tr>
										<td>Task name:</td>
										<td><input type="text" name="new_task_name"></td>							
									</tr>
									<tr>
										<td>Start date:</td>
										<td><cfinput type="datefield" name="new_task_start_date"></td>
									</tr>
								</table>
								</div>
								
								<p><label><input type="radio" name="apply_to" value="existing_task" onclick="set_apply_controls();">Existing task</label></p>
								<div style="margin:20px; display:none;" id="existing_task_controls">
									<select name="existing_task">
										<option value="task_name">Task</option>
									</select>
								</div>
								
								<p><label><input type="radio" name="apply_to" value="new_milestone" onclick="set_apply_controls();">New milestone</label></p>
								<div style="margin:20px; display:none;" id="new_milestone_controls">
									<table>
										<tr>
											<td>Milestone name:</td>
											<td><input type="text" name="new_milestone_name"></td>							
										</tr>
										<tr>
											<td>Start date:</td>
											<td><cfinput type="datefield" name="new_milestone_start_date"></td>
										</tr>
									</table>
								</div>
	
								
								<p><label><input type="radio" name="apply_to" value="existing_milestone" onclick="set_apply_controls();">Existing milestone</label></p>
								<div style="margin:20px; display:none;" id="existing_milestone_controls">
									<select name="existing_milestone">
										<cfloop array="#milestones#" index="ms">
											<cfoutput>
												<option value="#ms.id#">#ms.milestone_name#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
							
						</td>
					</tr>				
					<tr>
						<td>Adjust:</td>
						<td>
							<p><label><input type="checkbox" name="apply_upstream">Apply to upstream project elements</label></p>
							<p><label><input type="checkbox" name="shift_subsequent">Shift subsequent project elements</label></p>
						</td>
					</tr>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('form_id');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>