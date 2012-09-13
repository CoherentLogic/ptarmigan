<cfset report = CreateObject("component", "ptarmigan.report").open(url.id)>
<cfset t_class = CreateObject("component", "ptarmigan.object_class").open(report.class_id)>
<cfset tmp_dobj = CreateObject("component", t_class.component).create()>
<cfset tmp_obj = CreateObject("component", "ptarmigan.object").open(tmp_dobj.id)>
<cfset member_names = tmp_obj.members()>
<cfset tmp_obj.mark_deleted(tmp_obj.get_trashcan_handle())>

<cfif url.mode EQ "add">	
	<body style="background:none;">
	<cfoutput>
	<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
	</cfoutput>
	<cfoutput>
	<form name="add_filter" id="add_filter" action="#session.root_url#/reports/add_criteria.cfm?id=#report.id#" method="post">
	</cfoutput>
	<table width="100%">
		<tr>
			<td>
				<select name="member_name" id="member_name">
					<cfloop array="#member_names#" index="member">
						<cfoutput>
							<option value="#member#">#tmp_obj.member_label(member)#</option>
						</cfoutput>
					</cfloop>
				</select>
			</td>
			<td>
				<select name="operator" id="operator">
					<option value="=">IS EQUAL TO</option>
					<option value="<">IS LESS THAN</option>
					<option value=">">IS GREATER THAN</option>
					<option value="!=">IS NOT EQUAL TO</option>	
					<option value="[">INCLUDES</option>		
					<option value="]">DOES NOT INCLUDE</option>		
				</select>
			</td>
			<td>
				<input type="text" size="15" name="literal_a">
			</td>				
			<td>
				<input type="submit" name="submit" value="Add Filter">
			</td>
		</tr>
	</table>
	</form>
	</body>
<cfelse>
	<cfset filters = report.get_criteria()>
	
	<cfloop array="#filters#" index="f">
		<table style="width:100%;margin:0;border:none;" width="100%" class="pretty">
			<cfoutput>			
			<tr onmouseover="$('##filter_actions_#f.id#').show();" onmouseout="$('##filter_actions_#f.id#').hide();">
			</cfoutput>
				<td style="border:none;">
					<cfoutput><select name="member_name" id="member_name_#f.id#" onblur="update_filter('#session.root_url#', '#f.id#');"></cfoutput>
						<cfloop array="#member_names#" index="member">
							<cfoutput>
								<option value="#member#"<cfif f.member_name EQ member>selected="selected"</cfif>>#tmp_obj.member_label(member)#</option>
							</cfoutput>
						</cfloop>
					</select>
				</td>
				<td style="border:none;">
					<cfoutput>
					<select name="operator" id="operator_#f.id#" onblur="update_filter('#session.root_url#', '#f.id#');">
						<option value="=" <cfif f.operator EQ "=">selected="selected"</cfif>>IS EQUAL TO</option>
						<option value="<" <cfif f.operator EQ "<">selected="selected"</cfif>>IS LESS THAN</option>
						<option value=">" <cfif f.operator EQ ">">selected="selected"</cfif>>IS GREATER THAN</option>
						<option value="!=" <cfif f.operator EQ "!=">selected="selected"</cfif>>IS NOT EQUAL TO</option>
						<option value="[" <cfif f.operator EQ "[">selected="selected"</cfif>>INCLUDES</option>
						<option value="]" <cfif f.operator EQ "]">selected="select"</cfif>>DOES NOT INCLUDE</option>
					</select>
					</cfoutput>
				</td>
				<td style="border:none;">
					<cfoutput>
					<input type="text" size="15" name="literal_a" id="literal_a_#f.id#" value="#f.literal_a#" onblur="update_filter('#session.root_url#', '#f.id#');">
					</cfoutput>
				</td>								
				<td align="right" style="width:100px;border:none;">
					<cfoutput>
					<span class="filter_actions" id="filter_actions_#f.id#"><button class="buttons"><img src="#session.root_url#/images/task.png"></button></span>
					</cfoutput>
				</td>
			</tr>
		</table>
	</cfloop>	
</cfif>

<cfset tmp_obj.delete()>