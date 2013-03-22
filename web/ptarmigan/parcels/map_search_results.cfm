<cfswitch expression="#url.search_type#">
	<cfcase value="search-geocode">
		<cfhttp method="Get" url="http://maps.googleapis.com/maps/api/geocode/json?address=#url.geocode#&sensor=false" >
	</cfcase>
</cfswitch>

<div style="padding:20px; overflow:auto;">
	<div class="panel">
		<h1>Search Results</h1>
		<cfif url.search_type EQ "search-geocode">
			<cfset search_result = deserializejson(cfhttp.filecontent)>
			<cfset res_array = search_result.results>
			
			<cfloop array="#res_array#" index="arr">
				<div class="search_result">
					<cfoutput>
						<a href="##" onclick="map_recenter(#arr.geometry.location.lat#, #arr.geometry.location.lng#)">#arr.formatted_address#</a><br/>
						<div class="search_class">Physical Address (#arr.geometry.location_type#)</div>
																						
					</cfoutput>
				</div>
			</cfloop>
		</cfif>
		
	</div>
</div>