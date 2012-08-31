<cfoutput>
<script src="#session.root_url#/parcels/parcels.js" type="text/javascript"></script>
<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
</cfoutput>


<body onload="define_parcel();">

	<div id="container">
		<div id="header">
			<h1>Define Parcel</h1>
		</div>
		
		<div id="navigation">
			<form name="parcel_properties" action="insert_parcel.cfm" method="post">
			<table class="property_dialog">
				<tr>
					<th colspan="2">PROPERTIES</th>
				</tr>
				<tr>
					<td>Parcel ID</td>
					<td><input type="text" name="parcel_id"></td>					
				</tr>
				<tr>
					<td>Area (sq. ft.)</td>
					<td><input type="text" name="area_sq_ft" id="area_sq_ft"></td>					
				</tr>
				<tr>
					<td>Area (sq. yd.)</td>
					<td><input type="text" name="area_sq_yd" id="area_sq_yd"></td>					
				</tr>
				<tr>
					<td>Area (acres)</td>
					<td><input type="text" name="area_acres" id="area_acres"></td>					
				</tr>
				<tr>
					<td>Owner name</td>
					<td><input type="text" name="owner_name"></td>
				</tr>
				<tr>
					<td>Account number</td>
					<td><input type="text" name="account_number"></td>
				</tr>
				<tr>
					<td>Subdivision</td>
					<td><input type="text" name="subdivision"></td>
				</tr>
				<tr>
					<td>Lot</td>
					<td><input type="text" name="lot"></td>
				</tr>
				<tr>
					<td>Block</td>
					<td><input type="text" name="block"></td>
				</tr>
				<tr>
					<td>Section</td>
					<td><input type="text" name="section"></td>
				</tr>
				<tr>
					<td>Township</td>
					<td nowrap>
						<input type="text" name="township" style="width:78%;">
						<select name="township_direction" style="width:20%;">
							<option value="N">North</option>
							<option value="S">South</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Range</td>
					<td nowrap>
						<input type="text" name="range" style="width:78%;">
						<select name="range_direction" style="width:20%;">
							<option value="E">East</option>
							<option value="W">West</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Mailing address</td>
					<td><input type="text" name="mailing_address"></td>
				</tr>
				<tr>
					<td>Mailing city</td>
					<td><input type="text" name="mailing_city"></td>
				</tr>
				<tr>
					<td>Mailing state</td>
					<td><input type="text" name="mailing_state"></td>
				</tr>
				<tr>
					<td>Mailing ZIP</td>
					<td><input type="text" name="mailing_zip"></td>
				</tr>
				<tr>
					<td>Physical address</td>
					<td><input type="text" name="physical_address"></td>
				</tr>
				<tr>
					<td>Physical city</td>
					<td><input type="text" name="physical_city"></td>
				</tr>
				<tr>
					<td>Physical state</td>
					<td><input type="text" name="physical_state"></td>
				</tr>				
				<tr>
					<td>Physical ZIP</td>
					<td><input type="text" name="physical_zip"></td>
				</tr>
				<tr>
					<td>Assessed land value</td>
					<td><input type="text" name="assessed_land_value" value="0"></td>					
				</tr>
				<tr>
					<td>Assessed building value</td>
					<td><input type="text" name="assessed_building_value" value="0"></td>
				</tr>
				<tr>					
					<td>Reception number</td>
					<td><input type="text" name="reception_number"></td>
				</tr>
				<tr>
					<td>Has ground survey</td>
					<td>
						<select name="ground_survey">
							<option value="1">Yes</option>
							<option value="0">No</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Metes &amp; bounds</td>
					<td>
						<textarea name="metes_and_bounds"></textarea>
					</td>
				</tr>
				
			</table>
			<input type="hidden" name="points" id="points">
			<input type="hidden" name="center_latitude" id="center_latitude">
			<input type="hidden" name="center_longitude" id="center_longitude">
			</form>
		</div>
		
		<div id="content">
			<cflayout type="tab">
				<cflayoutarea title="Map">
					<div id="map" style="width:100%;height:400px;">
						
					</div>
				</cflayoutarea>
			</cflayout>
		</div>
	</div>

</body>