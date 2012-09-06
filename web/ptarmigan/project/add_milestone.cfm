<cfsilent>
	<cfmodule template="../security/require.cfm" type="project">	
	<cfset project = CreateObject("component", "ptarmigan.project").open(url.id)>
</cfsilent>
<cfif IsDefined("form.self_post")>
	<cfset t = CreateObject("component", "ptarmigan.milestone")>
	
	<cfset t.project_id = url.id>
	<cfset t.milestone_number = form.milestone_number>
	<cfset t.milestone_name = form.milestone_name>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.end_date_pessimistic = CreateODBCDate(form.end_date_pessimistic)>
	<cfset t.end_date_optimistic = CreateODBCDate(form.end_date_optimistic)>
	<cfset t.budget = form.budget>
	<cfset t.color = form.color>
	
	<cfif IsDefined("form.floating")>
		<cfset t.floating = 1>
	<cfelse>
		<cfset t.floating = 0>
	</cfif>
		
	<cfset t.create()>
	
	<cflocation url="#session.root_url#/project/edit_project.cfm?id=#url.id#" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Milestone" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="add_milestone" id="add_milestone" action="#session.root_url#/project/add_milestone.cfm?id=#url.id#" method="post">
			<div style="padding:20px;">
				<cfoutput>
					<p><em>Project date range: #dateFormat(project.start_date, 'm/dd/yyyy')#-#dateFormat(project.due_date, 'm/dd/yyyy')#</em></p>
				</cfoutput>
				<table>
					<tr>
						<td>Milestone number:</td>
						<td><cfinput type="text" name="milestone_number" required="true"></td>
					</tr>
					<tr>
						<td>Milestone name:</td>
						<td><cfinput type="text" name="milestone_name" required="true"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><label><input type="checkbox" name="floating">Floating</td>
					</tr>
					<tr>
						<td>Start date:</td>
						<td><cfinput type="datefield" name="start_date" required="true" validate="date"></td>
					</tr>
					<tr>
						<td>End date (normal):</td>
						<td>
							<label>Days from start: <cfinput type="text" size="3" name="end_date_days" id="end_date_days" onblur="add_days('#session.root_url#', 'start_date', 'end_date', 'end_date_days')"></label>								
							<cfinput type="datefield" name="end_date" id="end_date" size="10" required="true" validate="date"></td>		
					</tr>			
					<tr>
						<td>End date (pessimistic):</td>
						<td>
							<label>Days from start: <cfinput type="text" size="3" name="end_date_days_pessimistic" id="end_date_days_pessimistic" onblur="add_days('#session.root_url#', 'start_date', 'end_date_pessimistic', 'end_date_days_pessimistic')"></label>															
							<cfinput type="datefield" name="end_date_pessimistic" id="end_date_pessimistic" size="10" required="true" validate="date"></td>
					</tr>
					<tr>
						<td>End date (optimistic):</td>
						<td>
							<label>Days from start: <cfinput type="text" size="3" name="end_date_days_optimistic" id="end_date_days_optimistic" onblur="add_days('#session.root_url#', 'start_date', 'end_date_optimistic', 'end_date_days_optimistic')"></label>																		
							<cfinput type="datefield" name="end_date_optimistic" id="end_date_optimistic" size="10" required="true" validate="date"></td>
					</tr>
		
					<tr>
						<td>Budget:</td>
						<td>$<cfinput type="text" name="budget"></td>
					</tr>	
					<tr>
						<td>Color:</td>
						<td>
							<select name="color">
								<option value="aqua">Aqua</option>
								<option value="black">Black</option>
								<option value="blue">Blue</option>
								<option value="fuchsia">Fuchsia</option>
								<option value="gray">Gray</option>
								<option value="green">Green</option>
								<option value="lime">Lime</option>
								<option value="maroon">Maroon</option>
								<option value="navy">Navy</option>
								<option value="olive">Olive</option>
								<option value="purple">Purple</option>
								<option value="red">Red</option>
								<option value="silver">Silver</option>
								<option value="teal">Teal</option>
								<option value="yellow">Yellow</option>						
							</select>
						</td>
					</tr>
				</table>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_milestone');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>


