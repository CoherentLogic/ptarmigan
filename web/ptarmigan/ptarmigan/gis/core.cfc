<cfcomponent output="false">
	<cffunction name="layers" access="public" returntype="array" output="false">
		<cfquery name="q_layers" datasource="#session.company.datasource#">
			SELECT id FROM parcel_layers ORDER BY layer_name
		</cfquery>
		
		<cfset output_array = ArrayNew(1)>
		<cfoutput query="q_layers">
			<cfset tmp_layer = CreateObject("component", "ptarmigan.gis.layer").open(q_layers.id)>
			<cfset tmp_layer.layer_type = "vector">
			<cfset ArrayAppend(output_array, tmp_layer)>
		</cfoutput>
		
		<cfreturn output_array>
	</cffunction>
	
	<cffunction name="layers_json" access="public" returntype="string" output="false">				
		<cfreturn serializejson(this.layers())>
	</cffunction>
		
</cfcomponent>
