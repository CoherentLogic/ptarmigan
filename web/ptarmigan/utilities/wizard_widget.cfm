<!---
	attributes:
	
	tab_count:		total tabs
	current_tab:	zero-based index of current tab
	tab_selector:	jquery selector for tabs collection
--->

<cfset previous_enabled = false>
<cfset next_enabled = false>
<cfset submit_enabled = false>


<cfif attributes.current_tab GT 0>
	<cfset previous_enabled = true>
</cfif>

<cfif attributes.current_tab LT attributes.tab_count>
	<cfset next_enabled = true>
</cfif>

<cfif attributes.tab_count EQ 1>
	<cfset next_enabled = false>
</cfif>

<cfif attributes.current_tab EQ (attributes.tab_count - 1)>
	<cfset submit_enabled = true>
</cfif>
<cfset previous_tab = attributes.current_tab - 1>
<cfset next_tab = attributes.current_tab + 1>

<div class="wizard_widget">
	<cfif previous_enabled EQ true>
		<cfoutput><input type="button" name="previous" value="Previous" onclick="$('#attributes.tab_selector#').tabs({selected:#previous_tab#});"></cfoutput>
	</cfif>	
	<cfif next_enabled EQ true>
		<cfoutput><input type="button" name="next" value="Next" onclick="$('#attributes.tab_selector#').tabs({selected:#next_tab#});"></cfoutput>
	</cfif>
	<cfif submit_enabled EQ true>
		<input type="submit" name="submit" value="Submit">
	</cfif>
</div>
