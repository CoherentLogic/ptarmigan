<cfmodule template="../security/require.cfm" type="project">

<cfquery name="customers" datasource="#session.company.datasource#">
	SELECT company_name,id FROM customers ORDER BY company_name
</cfquery>


<div style="position:relative; height:100%; width:100%; background-color:white;">
<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Project" icon="#session.root_url#/images/project_dialog.png">

<cfoutput><form name="add_project" id="add_project" action="#session.root_url#/project/add_project_submit.cfm" method="post"></cfoutput>
	<div style="padding:20px;">
		<table width="100%">
			<tr>
				<td>Project name:</td>
				<td><input type="text" maxlength="255" name="project_name"></td>
			</tr>
			<tr>
				<td>Customer:</td>
				<td>
					<select name="customer_id">
						<cfoutput query="customers">
							<option value="#id#">#company_name#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td>Start date:</td>
				<td><input class="pt_dates" type="text" name="start_date">
			</tr>
			<tr>
				<td>End date:</td>
				<td><input class="pt_dates" type="text" name="due_date"></td>
			</tr>
			<tr>
				<td>Budget:</td>
				<td><input type="text" name="budget"></td>
			</tr>
			<tr>
				<td>Tax rate:</td>
				<td><input type="text" name="tax_rate" size="4"><strong>%</strong></td>
			</tr>
			<tr>
				<td>Instructions:</td>
				<td><textarea name="instructions" cols="40" rows="3"></textarea>
			</tr>						
		</table>
	</div>
	<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
    	<div style="padding:8px; float:right;" id="create_project_buttons" >
        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>
			<cfoutput>
			<a class="button" href="##" onclick="document.forms['add_project'].submit();"><span>Apply</span></a>
		    </cfoutput>       	
		</div>
	</div>

</form>
</div>