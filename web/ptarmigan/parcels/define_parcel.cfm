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
					<td>Points</td>
					<td><input type="text" name="points" id="points"></td>
				</tr>
			</table>
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