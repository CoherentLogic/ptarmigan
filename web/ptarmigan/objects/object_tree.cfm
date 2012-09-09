<cfset obj = CreateObject("component", "ptarmigan.object").open(session.company.object_name())>

<cfset print_tree(obj)>

<cffunction name="print_tree" returntype="void" output="true">
	<cfargument name="obj" type="ptarmigan.object" required="true">
	
	<cfoutput>#obj.class_name#: #obj.get().object_name()# <cfif obj.deleted EQ 1>[DELETED] TRASHCAN HANDLE: #obj.trashcan_handle#</cfif><br></cfoutput>
	
	<cfif obj.has_children() EQ true>
		<cfset children = obj.get_children()>
		
		<blockquote>
		<cfloop array="#children#" index="child">			
			<cfset print_tree(child)>
		</cfloop>
		</blockquote>

	</cfif>
	
</cffunction>