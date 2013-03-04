<cfif ArrayLen(session.basket) GT 0>
<div class="basket_wrapper">
	<div style="padding:5px;">
	<strong>Basket</strong><br />
	<hr>
	<form name="item_basket" method="post" <cfoutput>action="#session.root_url#/objects/item_basket_submit.cfm"</cfoutput>>
		<cfoutput>
			<input type="hidden" name="target_object_id" value="#current_object.id#">			
		</cfoutput>
		<table width="100%">
		<cfloop array="#session.basket#" item="basket_item">
			<tr>
				<td><cfoutput><input type="checkbox" name="selection" value="#basket_item.id#"></cfoutput></td>
				<td><cfoutput><img src="#basket_item.get_icon()#" onmouseover="Tip('#basket_item.class_name#');" onmouseout="UnTip();"></cfoutput></td>		
				<td><cfoutput><a href="#session.root_url#/objects/dispatch.cfm?id=#basket_item.id#">#basket_item.get().object_name()#</a></cfoutput></td>			
			</tr>
		</cfloop>
		</table>
		<cfoutput>
		<select name="basket_action">
			<option value="link">Link to #current_object.get().object_name()#</option>
			<option value="remove">Remove from basket</option>
			<option value="email">E-Mail</option>
			<option value="print">Print</option>
			<option value="download">Download</option>
		</select>
		<input type="submit" name="submit" value="Go">
		</cfoutput>
	</form>
	</div>
</div>
</cfif>