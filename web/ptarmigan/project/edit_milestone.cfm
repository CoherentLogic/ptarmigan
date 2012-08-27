<cfmodule template="../security/require.cfm" type="project">

<cfoutput>
<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
</cfoutput>

<cfset t = CreateObject("component", "ptarmigan.milestone").open(url.id)>
	
<cfif IsDefined("form.submit_milestone")>

	<cfif (t.start_date NEQ CreateODBCDate(form.start_date)) OR
		  (t.end_date NEQ CreateODBCDate(form.end_date)) OR
		  (t.end_date_optimistic NEQ CreateODBCDate(form.end_date_optimistic)) OR
		  (t.end_date_pessimistic NEQ CreateODBCDate(form.end_date_pessimistic))>
		<cfset a = CreateObject("component", "ptarmigan.audit")>
		<cfset a.employee_id = session.user.id>
		<cfset a.table_name = "milestones">
		<cfset a.table_id = url.id>
		<cfset a.change_order_number = form.change_order_number>
		<cfset a.comment = form.comment>
		
		<cfset cr = "">
		<cfif t.start_date NEQ CreateODBCDate(form.start_date)>
			<cfset cr = cr & "<br>START DATE CHANGED FROM " & dateFormat(t.start_date, "mm/dd/yyyy") & " TO " & form.start_date>
		</cfif>
		<cfif t.end_date NEQ CreateODBCDate(form.end_date)>
			<cfset cr = cr & "<br>END DATE (NORMAL) CHANGED FROM " & dateFormat(t.end_date, "mm/dd/yyyy") & " TO " & form.end_date>
		</cfif>
		<cfif t.end_date_pessimistic NEQ CreateODBCDate(form.end_date_pessimistic)>
			<cfset cr = cr & "<br>END DATE (PESSIMISTIC) CHANGED FROM " & dateFormat(t.end_date_pessimistic, "mm/dd/yyyy") & " TO " & form.end_date_pessimistic>
		</cfif>
		<cfif t.end_date_optimistic NEQ CreateODBCDate(form.end_date_optimistic)>
			<cfset cr = cr & "<br>END DATE (OPTIMISTIC) CHANGED FROM " & dateFormat(t.end_date_optimistic, "mm/dd/yyyy") & " TO " & form.end_date_optimistic>
		</cfif>

		<cfset a.what_changed = cr>		
		
		<cfset a.create()>
	</cfif>

	<cfset t.milestone_number = form.milestone_number>
	<cfset t.milestone_name = form.milestone_name>
	<cfset t.start_date = CreateODBCDate(form.start_date)>
	<cfset t.end_date = CreateODBCDate(form.end_date)>
	<cfset t.end_date_pessimistic = CreateODBCDate(form.end_date_pessimistic)>
	<cfset t.end_date_optimistic = CreateODBCDate(form.end_date_optimistic)>		
	<cfset t.budget = form.budget>
	<cfset t.color = form.color>
	<cfset t.percent_complete = form.percent_complete>
	<cfif IsDefined("form.floating")>
		<cfset t.floating = 1>
	<cfelse>
		<cfset t.floating = 0>
	</cfif>
	<cfif IsDefined("form.completed")>
		<cfset t.completed = 1>
	<cfelse>
		<cfset t.completed = 0>
	</cfif>

	<cfset t.update()>
	
	<cfset session.message="Milestone updated">	

	

<cfelse>
	<div style="padding:20px;">
	
	<cfoutput>
	<cfform name="edit_milestone" action="edit_milestone.cfm?id=#url.id#&suppress_headers" method="post" onsubmit="window.location.reload();">
		<cflayout type="tab">
		<cflayoutarea title="Milestone">	
		<div style="height:370px;padding:10px;">
		<table>
			<tr>
				<td>Milestone number:</td>
				<td><cfinput type="text" name="milestone_number" value="#t.milestone_number#"></td>
			</tr>
			<tr>
				<td>Milestone name:</td>
				<td><cfinput type="text" name="milestone_name" value="#t.milestone_name#"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>					
					<label><input type="checkbox" name="floating" <cfif t.floating EQ 1>checked</cfif>>Floating</td>
			</tr>
			<tr>
				<td>Start date:</td>
				<td><cfinput type="datefield" name="start_date" value="#dateFormat(t.start_date, 'mm/dd/yyyy')#"></td>
			</tr>
			<tr>
				<td>End date (normal):</td>
				<td><cfinput type="datefield" name="end_date" value="#dateFormat(t.end_date, 'mm/dd/yyyy')#"></td>		
			</tr>			
			<tr>
				<td>End date (pessimistic):</td>
				<td><cfinput type="datefield" name="end_date_pessimistic" value="#dateFormat(t.end_date_pessimistic, 'mm/dd/yyyy')#"></td>		
			</tr>			
			<tr>
				<td>End date (optimistic):</td>
				<td><cfinput type="datefield" name="end_date_optimistic" value="#dateFormat(t.end_date_optimistic, 'mm/dd/yyyy')#"></td>		
			</tr>			
			<tr>
				<td>Completion:</td>
				<td>
					<label>Percentage: <cfinput type="text" name="percent_complete" value="#t.percent_complete#"></label><br>
					<label><input type="checkbox" name="completed" <cfif t.completed EQ 1>checked</cfif>>Completed</label>
				</td>
			</tr>
			<tr>
				<td>Budget:</td>
				<td>$<cfinput type="text" name="budget" value="#t.budget#"></td>
			</tr>	
			<tr>
				<td>Color:</td>
				<td>
					<select name="color">
						<option value="aqua" <cfif t.color EQ "aqua">selected</cfif>>Aqua</option>
						<option value="black" <cfif t.color EQ "black">selected</cfif>>Black</option>
						<option value="blue" <cfif t.color EQ "blue">selected</cfif>>Blue</option>
						<option value="fuchsia" <cfif t.color EQ "fuchsia">selected</cfif>>Fuchsia</option>
						<option value="gray" <cfif t.color EQ "gray">selected</cfif>>Gray</option>
						<option value="green" <cfif t.color EQ "green">selected</cfif>>Green</option>
						<option value="lime" <cfif t.color EQ "lime">selected</cfif>>Lime</option>
						<option value="maroon" <cfif t.color EQ "maroon">selected</cfif>>Maroon</option>
						<option value="navy" <cfif t.color EQ "navy">selected</cfif>>Navy</option>
						<option value="olive" <cfif t.color EQ "olive">selected</cfif>>Olive</option>
						<option value="purple" <cfif t.color EQ "purple">selected</cfif>>Purple</option>
						<option value="red" <cfif t.color EQ "red">selected</cfif>>Red</option>
						<option value="silver" <cfif t.color EQ "silver">selected</cfif>>Silver</option>
						<option value="teal" <cfif t.color EQ "teal">selected</cfif>>Teal</option>
						<option value="yellow" <cfif t.color EQ "yellow">selected</cfif>>Yellow</option>
						<option value="pink" <cfif t.color EQ "pink">selected</cfif>>Pink</option>
						<option value="orange" <cfif t.color EQ "orange">selected</cfif>>Orange</option>
						<option value="brown" <cfif t.color EQ "brown">selected</cfif>>Brown</option>
						<option value="turquoise" <cfif t.color EQ "turquoise">selected</cfif>>Turquoise</option>
						<option value="plum" <cfif t.color EQ "plum">selected</cfif>>Plum</option>
						<option value="cyan" <cfif t.color EQ "cyan">selected</cfif>>Cyan</option>
						<option value="SteelBlue" <cfif t.color EQ "SteelBlue">selected</cfif>>Steel Blue</option>
					</select>
				</td>
			</tr>
		</table>
		</div>
		</cflayoutarea>
		<cflayoutarea title="Auditing">
		<div style="height:370px;padding:10px;">
		<table>
			<tr>
				<td>Employee:</td>
				<td>#session.user.full_name()#</td>
			</tr>
			<tr>
				<td>Change order ##:</td>
				<td><cfinput type="text" name="change_order_number"></td>
			</tr>
			<tr>
				<td>Comments:</td>
				<td><textarea rows="5" cols="40" name="comment"></textarea></td>
			</tr>
		</table>
		</div>
		</cflayoutarea>
		</cflayout>		
		<input type="submit" name="submit_milestone" value="Apply">
	</cfform>
	</cfoutput>
	
	</div>
</cfif>
