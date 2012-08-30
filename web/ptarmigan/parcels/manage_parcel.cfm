<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(url.id)>
<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>

<cfquery name="parcel_points" datasource="#session.company.datasource#">
	SELECT * FROM parcel_points WHERE parcel_id='#url.id#'
</cfquery>

<head>
	<script type="text/javascript">
		function draw_parcels()
		{
			var mapOptions = {
	          center: new google.maps.LatLng(32.3197, -106.7653),
	          zoom: 16,
	          mapTypeId: google.maps.MapTypeId.ROADMAP
	        };
	
	        var map = new google.maps.Map(document.getElementById('map'),
	          mapOptions);
	          
	        var parcel = [];
	        
	        var coords = [
				<cfoutput query="parcel_points">
			   		new google.maps.LatLng(#latitude#, #longitude#),
			   	</cfoutput>
			 ];
			
			 parcel.push(new google.maps.Polygon({
			   paths: coords,
			 }));
			
			 parcel[parcel.length-1].setMap(map);
	         
			
		}
	</script>
</head>

<body onload="draw_parcels();">
	<div id="container">
		<div id="header">
			<h1>Parcel Viewer</h1>
		</div>
		
		<div id="navigation">
			<cfoutput>
			<form name="parcel_properties" action="insert_parcel.cfm" method="post">
			<table class="property_dialog">
				<tr>
					<th colspan="2">PROPERTIES</th>
				</tr>
				<tr>
					<td>Parcel ID</td>
					<td><input type="text" name="parcel_id" value="#parcel.parcel_id#"></td>					
				</tr>
				<tr>
					<td>Area (sq. ft.)</td>
					<td><input type="text" name="area_sq_ft" id="area_sq_ft" value="#parcel.area_sq_ft#"></td>					
				</tr>
				<tr>
					<td>Area (sq. yd.)</td>
					<td><input type="text" name="area_sq_yd" id="area_sq_yd" value="#parcel.area_sq_yd#"></td>					
				</tr>
				<tr>
					<td>Area (acres)</td>
					<td><input type="text" name="area_acres" id="area_acres" value="#parcel.area_acres#"></td>					
				</tr>
			</table>
			</form>
			</cfoutput>
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
