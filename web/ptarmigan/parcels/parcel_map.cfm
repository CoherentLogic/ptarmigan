

<head>
	<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
	<script type="text/javascript" src="gis.js"></script>
	<script type="text/javascript" src="../ptarmigan.js"></script>
	<cfajaximport tags="cfwindow,cflayout-tab">
</head>

<body onload="init_map('map', 33.1283, -107.2522);" style="height:100%;width:100%;">
			
			<div id="map" style="width:100%;height:100%;">
						
			</div>					
	<div id="loading_div" style="width:400px;height:300px;position:absolute;display:none;opacity:0.7;border:1px solid gainsboro;">
		<img src="../images/loading_parcel.gif" width="400" height="300" alt="Loading Parcel...">
	</div>
	<div id="load_status">
		<span style="font-family:Arial,Helvetica,sans-serif; margin-bottom:20px; font-size:20px; color:navy; opacity:0.4; letter-spacing:8px;">PTARMIGAN PARCEL MAP</span>
		<hr>
		<table border="0" cellpadding="20" cellspacing="0" width="100%" style="margin:0;" class="pretty">
			<tr>
				<th>APN</th>
				<th>ACCT</th>
				<th>RCPT</th>
				<th>OWNER</th>
				<th>MAIL ADDR</th>
				<th>PHYS ADDR</th>
				<th>SECTION</th>
				<th>SUBDIVISION</th>
				<th>LAND VALUE</th>
				<th>BLDG VALUE</th>
				<th>AREA</th>
				<th>SURVEY</th>
			</tr>
			<tr>
				<td><span id="PARCEL_ID"></span></td>
				<td><span id="ACCOUNT_NUMBER"></span></td>
				<td><span id="RECEPTION_NUMBER"></span></td>
				<td><span id="OWNER_NAME"></span></td>
				<td><span id="MAILING_ADDRESS"></span></td>
				<td><span id="PHYSICAL_ADDRESS"></span></td>				
				<td><span id="LEGAL_SECTION"></span></td>
				<td><span id="SUBDIVISION"></span></td>
				<td><span id="LAND_VALUE"></span></td>
				<td><span id="BUILDING_VALUE"></span></td>
				<td><span id="AREA"></span></td>
				<td><span id="GROUND_SURVEY"></span></td>
			</tr>
		</table>
	
		<div id="loader" style="position:fixed; bottom:0px; width:100%; height:24px;border-top:1px grooved silver;">
			
		</div>
	</div>
</body>