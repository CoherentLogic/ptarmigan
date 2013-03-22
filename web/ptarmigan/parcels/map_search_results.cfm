<cfswitch expression="#url.search_type#">
	<cfcase value="search-geocode">
		<cfhttp method="Get" url="http://maps.googleapis.com/maps/api/geocode/json?address=#url.geocode#&sensor=false" >
	</cfcase>
	<cfcase value="search-apn">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE parcel_id LIKE '%#url.apn#'
		</cfquery>
	</cfcase>
</cfswitch>

<span class="map-sidebar-header">Search Results <a style="float:right;" href="##" onclick="close_map_search();"><img style="vertical-align:center;" <Cfoutput>src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/cross.png"</cfoutput>></a></span>
<div style="padding:20px; overflow:auto;">
	<div class="panel">
		
		<cfif url.search_type EQ "search-geocode">
			<cfset search_result = deserializejson(cfhttp.filecontent)>
			<cfset res_array = search_result.results>
			
			<cfloop array="#res_array#" index="arr">
				<div class="search_result">
					<cfoutput>
						<a href="##" onclick="map_recenter(#arr.geometry.location.lat#, #arr.geometry.location.lng#)">#arr.formatted_address#</a><br/>
						<div class="search_class">Physical Address (#arr.geometry.location_type#)</div>

						<p>
							<a href="##" onclick="set_bookmark(#arr.geometry.location.lat#, #arr.geometry.location.lng#, '#arr.formatted_address#');">Set Bookmark</a> | <a href="##">Share Location</a>																						
						</p>
					</cfoutput>
				</div>
				
			</cfloop>
		<cfelse>
		
			<cfoutput query="s">
				<div class="search_result">
					<a href="##" onclick="map_recenter(#s.center_latitude#, #s.center_longitude#)">#s.parcel_id#</a>
					<div class="search_class">Parcel</div>
					<p>
						<a href="##" onclick="set_bookmark(#s.center_latitude#, #s.center_longitude#, '#s.parcel_id#');">Set Bookmark</a> | <a href="##">Share Location</a>																						
					</p>
				</div>
			</cfoutput>
		</cfif>
		
	</div>
</div>