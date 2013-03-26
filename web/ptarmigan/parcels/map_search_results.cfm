<cfswitch expression="#url.search_type#">
	<cfcase value="search-geocode">
		<cfhttp method="Get" url="http://maps.googleapis.com/maps/api/geocode/json?address=#url.geocode#&sensor=false" >
	</cfcase>
	<cfcase value="search-apn">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE parcel_id LIKE '%#url.apn#%'
		</cfquery>
	</cfcase>
	<cfcase value="search-property-address">						
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE physical_address LIKE '%#url.property_address#%'
		</cfquery>
	</cfcase>	
	<cfcase value="search-reception-number">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE reception_number LIKE '%#url.reception_number#%'
		</cfquery>
	</cfcase>
	<cfcase value="search-account-number">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE account_number LIKE '%#url.account_number#%'
		</cfquery>
	</cfcase>
	<cfcase value="search-owner-name">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT * FROM parcels WHERE owner_name LIKE '%#url.owner_name#%'
		</cfquery>
	</cfcase>
	<cfcase value="search-legal-section">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT 	* 
			FROM 	parcels 
			WHERE 	`section` LIKE '%#url.section#%'
			AND		`township` LIKE '%#url.township#%'
			AND 	`range` LIKE '%#url.range#%'
		</cfquery>
	</cfcase>
	<cfcase value="search-subdivision">
		<cfquery name="s" datasource="#session.company.datasource#">
			SELECT 	* 
			FROM 	parcels 
			WHERE 	subdivision LIKE '%#url.subdivision#%'
			AND 	lot LIKE '%#url.lot#%'
			AND 	block LIKE '%#url.block#%'
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
				</div>
			</cfoutput>
		</cfif>
		
	</div>
</div>