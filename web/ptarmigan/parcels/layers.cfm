<cfset c = createobject("component", "ptarmigan.gis.core")>
<cfset map_layers = c.layers()>


<span class="search-wrapper">
	<cfoutput><img title="Active Layer" src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/layers.png" style="vertical-align:middle; margin-left:5px;"></cfoutput>
	<select name="active-layer" title="Active Layer" id="active-layer" style="border:none; width:190px;" class="map-toolbar-search-right">
		<cfloop array="#map_layers#" index="lyr">
			<cfoutput>
				<option value="#lyr.id#">#lyr.layer_name#</option>
			</cfoutput>
		</cfloop>
	</select>
</span>