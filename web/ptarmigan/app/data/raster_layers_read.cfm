<cfcontent type="application/json">[{"layer_extents":"","layer_color":"","layer_key_name":"","layer_public":"1","southwest_coordinates":{"0":{"0":""}},"written":"","layer_projection":"","url":"http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png","layer_enabled":"1","layer_type":"raster","layer_name":"Open Street Map","layer_geom_field":"","layer_key_abbreviation":"","northeast_coordinates":{"0":{"0":""}},"name":"Open Street Map","id":"STREET","layer_boundary":"","layer_southwest_extent":"","layer_projection_name":"","layer_northeast_extent":"","layer_table":"","layer_key_field":"","attribution":"Map data &copy; OpenStreetMap contributors"}]


<!--- <cfsilent>
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
<cfoutput>#serializeJson(layers)#</cfoutput> --->
