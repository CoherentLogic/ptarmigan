<cfmodule template="../security/require.cfm" type="project">

<cfset project = CreateObject("component", "ptarmigan.project").open(url.id)>





<cfif IsDefined("form.submit_milestone")>
	<cfset t = CreateObject("component", "ptarmigan.milestone")>
	
	<cfset t.project_id = url.id>
	<cfset t.milestone_number = form.milestone_number>
	<cfset t.milestone_name = form.milestone_name>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.end_date_pessimistic = CreateODBCDate(form.end_date_pessimistic)>
	<cfset t.end_date_optimistic = CreateODBCDate(form.end_date_optimistic)>
	<cfset t.budget = form.budget>
	<cfif IsDefined("form.floating")>
		<cfset t.floating = 1>
	<cfelse>
		<cfset t.floating = 0>
	</cfif>
	
	<cfset t.create()>
	
	<cfset session.message="Milestone created">
	
	
	
	
<cfelse>

	<h1>Add Milestone</h1>
	
	
	<cfoutput>
	<p><em>Project date range: #dateFormat(project.start_date, 'm/dd/yyyy')#-#dateFormat(project.due_date, 'm/dd/yyyy')#</em></p>
	<form name="add_milestone" action="add_milestone.cfm?id=#url.id#" method="post">
		<table>
			<tr>
				<td>Milestone number:</td>
				<td><input type="text" name="milestone_number"></td>
			</tr>
			<tr>
				<td>Milestone name:</td>
				<td><input type="text" name="milestone_name"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><label><input type="checkbox" name="floating">Floating</td>
			</tr>
			<tr>
				<td>Start date (MM/DD/YYYY):</td>
				<td><input type="text" name="start_date"></td>
			</tr>
			<tr>
				<td>End date (normal) (MM/DD/YYYY):</td>
				<td><input type="text" name="end_date"></td>		
			</tr>			
			<tr>
				<td>End date (pessimistic) (MM/DD/YYYY):</td>
				<td><input type="text" name="end_date_pessimistic"></td>
			</tr>
			<tr>
				<td>End date (optimistic) (MM/DD/YYYY):</td>
				<td><input type="text" name="end_date_optimistic"></td>
			</tr>

			<tr>
				<td>Budget:</td>
				<td>$<input type="text" name="budget"></td>
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
						<option value="pink">Pink</option>
						<option value="orange">Orange</option>
						<option value="brown">Brown</option>
						<option value="turquoise">Turquoise</option>
						<option value="plum">Plum</option>
						<option value="cyan">Cyan</option>
						<option value="SteelBlue">Steel Blue</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>&nbsp</td>
				<td align="right"><input type="submit" name="submit_milestone" value="Submit"></td>
			</tr>
		</table>
	</form>
	</cfoutput>

</cfif>