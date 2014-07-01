<cfcontent type="application/json">
<cfsilent>
	<cfset mumps = createObject("component", "lib.cfmumps.mumps")>
	<cfset glob = createObject("component", "lib.cfmumps.global")>

	<cfset lastResult = false>
	<cfset nextSubscript = "">

	<cfset layers = []>

	<cfset mumps.open()>
	
	<cfloop condition="lastResult EQ false">
		<cfset order = mumps.order("rasterLayers", [nextSubscript])>
		<cfset lastResult = order.lastResult>
		<cfset nextSubscript = order.value>
	
		<cfif nextSubscript NEQ "">
			<cfset os = {}>
			<cfset glob.open("rasterLayers", [nextSubscript])>
			<cfset os = glob.getObject()>
		
			<cfset layers.append(os)>
		</cfif>
	</cfloop>

	<cfset mumps.close()>
</cfsilent>
<cfoutput>#serializeJson(layers)#</cfoutput>
