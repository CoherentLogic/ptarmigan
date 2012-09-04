<cfif IsDefined("form.self_post")>
	
	<cfset co = CreateObject("component", "ptarmigan.change_order")>
	<cfset co.change_order_number = form.change_order_number>
	<cfif IsDefined("form.extends_time")>
		<cfset co.extends_time = 1>
	<cfelse>
		<cfset co.extends_time = 0>
	</cfif>
	<cfset co.extends_time_days = form.extends_time_days>
	<cfif IsDefined("form.increases_budget")>
		<cfset co.increases_budget = 1>
	<cfelse>
		<cfset co.increases_budget = 0>
	</cfif>
	<cfset co.increases_budget_dollars = form.increases_budget_dollars>
	<cfset co.description = form.description>
	<cfset co.project_id = url.project_id>
	
	<cfset co.create()>
	
	
	<cflocation url="#session.root_url#/dashboard.cfm" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Add Change Order" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="add_change_order" id="add_change_order" action="#session.root_url#/project/add_change_order.cfm?id=#url.id#" method="post">
			<div style="padding:20px;">
				<table>
					<tr>
						<td>Change order #:</td>					
						<td><cfinput type="text" name="change_order_number"></td>
					</tr>
					<tr>
						<td>Cost:</td>
						<td>
							<p><label><input type="checkbox" name="extends_time">Extends duration by
							<cfinput type="text" size="4" name="extends_time_days" value="0"> days</label></p>
							<p><label><input type="checkbox" name="increases_budget">Increases budget by</label>
							$<cfinput type="text" size="4" name="increases_budget_dollars" value="0.00"></p>
						</td>
					</tr>
					<tr>
						<td>Description:</td>
						<td>
							<textarea name="description" rows="4" cols="40"></textarea>
						</td>
					</tr>
				</table>												
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('add_change_order');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>