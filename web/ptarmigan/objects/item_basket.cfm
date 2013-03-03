<cfif ArrayLen(session.basket) GT 0>
<div class="basket_wrapper">
	<div style="padding:5px;">
	<strong>Item Basket</strong><br />
	<hr>
	<table width="100%">
	<cfloop array="#session.basket#" item="basket_item">
		<tr>
		<td><input type="checkbox"></td>
		<td><cfoutput><img src="#basket_item.get_icon()#"></cfoutput></td>		
		<td><cfoutput><a href="#session.root_url#/objects/dispatch.cfm?id=#basket_item.id#">#basket_item.get().object_name()#</a></cfoutput></td>
		
		</tr>
	</cfloop>
	</table>
	<cfoutput>
	<select name="basket_actions">
		<option value="link">Link to #current_object.get().object_name()#</option>
		<option value="remove">Remove from basket</option>
		<option value="email">E-Mail</option>
		<option value="print">Print</option>
		<option value="download">Download</option>
	</select>
	<input type="button" name="button" value="Go">
	</cfoutput>
	
	</div>
</div>
</cfif>