<cfset object = CreateObject("component", "ptarmigan.object").open(attributes.object_id)>

<h1>This links to</h1>
<cfif ArrayLen(object.get_associated_objects("ALL", "TARGET")) EQ 0>
	<em>This doesn't link to anything.</em>
<cfelse>
	
	<cfloop array="#object.get_associated_objects('ALL', 'TARGET')#" index="assoc">
		<cfoutput>
			<img src="#assoc.get_icon()#" onmouseover="Tip('#assoc.class_name#')" onmouseout="UnTip();" align="absmiddle"> <a href="#session.root_url#/objects/dispatch.cfm?id=#assoc.id#">#assoc.get().object_name()#</a><br>
		</cfoutput>
	</cfloop>
	
</cfif>
<h1>Linked to this</h1>
<cfif ArrayLen(object.get_associated_objects("ALL", "SOURCE")) EQ 0>
	<em>Nothing links to this.</em>
<cfelse>
	
	<cfloop array="#object.get_associated_objects('ALL', 'SOURCE')#" index="assoc">
		<cfoutput>
			<cftry>
			<img src="#assoc.get_icon()#" onmouseover="Tip('#assoc.class_name#')" onmouseout="UnTip();" align="absmiddle"> <a href="#session.root_url#/objects/dispatch.cfm?id=#assoc.id#">#assoc.get().object_name()#</a><br>
			<cfcatch>
			Error
			</cfcatch>
			</cftry>
		</cfoutput>
	</cfloop>
	
</cfif>