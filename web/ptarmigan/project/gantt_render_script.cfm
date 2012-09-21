<cfset project = CreateObject("component", "ptarmigan.project").open(attributes.id)>

<cfloop array="#project.tasks()#" index="t">
	<cfloop array="#t.successors()#" index="s">
		<cfset source_el = t.id & "_end_cell">
		<cfset target_el = s.id & "_start_cell">
		<cfoutput>
		try {
		jsPlumb.connect({
			source:"#source_el#", 
			target:"#target_el#",
			detachable:false,							
			anchors:["BottomCenter", "LeftMiddle" ],
			connector:[ "Flowchart", { stub:5 }],
			paintStyle:{ strokeStyle:"navy", lineWidth:1 },
			endpoint:[ "Dot", { radius:3 }],
			endpointStyle:{ fillStyle: "navy" },
			overlay: "PlainArrow"
		});
		} catch (ex) {}
		</cfoutput>
	</cfloop>
</cfloop>
