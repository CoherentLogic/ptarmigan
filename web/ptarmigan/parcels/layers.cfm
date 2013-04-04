<cfset c = createobject("component", "ptarmigan.gis.core")>
<cfset map_layers = c.layers()>


<span class="search-wrapper">
	<select name="active_layer" id="active_layer">
		<cfloop array="#map_layers#" index="lyr">
			<cfoutput>
				<option value="#lyr.id#">#layer.layer_name#</option>
			</cfoutput>
		</cfloop>
	</select>
</span>