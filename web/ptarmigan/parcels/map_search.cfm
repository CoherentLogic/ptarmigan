<span class="search-wrapper">
<span id="search-geocode" style="display:inline-block;">
	<input type="text" id="s-geocode" placeholder="Find an address" class="map-toolbar-search-right">	
</span>
<span id="search-property-address" style="display:none;">
	<input type="text" id="s-property-address" placeholder="Property address" class="map-toolbar-search-right">
</span>
<span id="search-apn" style="display:none;">
	<input type="text" id="s-apn" placeholder="APN" class="map-toolbar-search-right">
</span>
<span id="search-reception-number" style="display:none;">
	<input type="text" id="s-reception-number" placeholder="Reception number" class="map-toolbar-search-right">
</span>
<span id="search-account-number" style="display:none;">
	<input type="text" id="s-account-number" placeholder="Account number" class="map-toolbar-search-right">
</span>
<span id="search-owner-name" style="display:none;">
	<input type="text" id="s-owner-name" placeholder="Owner name" class="map-toolbar-search-right">
</span>
<span id="search-legal-section" style="display:none;">
	<input type="text" id="s-section" placeholder="Section" class="map-toolbar-search" style="width:150px;">
	<input type="text" id="s-township" placeholder="Township" class="map-toolbar-search-middle" style="width:60px;">
	<input type="text" id="s-range" placeholder="Range" class="map-toolbar-search-right" style="width:60px;">
</span>
<span id="search-subdivision" style="display:none;">
	<input type="text" id="s-subdivision" placeholder="Subdivision" class="map-toolbar-search" style="width:150px;">
	<input type="text" id="s-lot" placeholder="Lot" class="map-toolbar-search-middle" style="width:60px;">
	<input type="text" id="s-block" placeholder="Block" class="map-toolbar-search-right" style="width:60px;">
</span>
<select name="search-type" id="search-type" style="border:none; width:30px;" onclick="set_search_type();">
	<option value="search-geocode" selected>Find address on map</option>
	<option value="search-property-address">Search by property address</option>
	<option value="search-apn">Search by APN</option>
	<option value="search-reception-number">Search by reception number</option>
	<option value="search-account-number">Search by account number</option>
	<option value="search-owner-name">Search by owner name</option>
	<option value="search-legal-section">Search by legal section</option>
	<option value="search-subdivision">Search by subdivision</option>
</select>
</span>
<cfoutput>
<button onclick="map_search();"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/zoom.png" style="vertical-align:middle;"> Search</button>
</cfoutput>
