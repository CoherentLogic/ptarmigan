<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" style="width:100%; height:100%;">

<head>
	<title>Parcel Map - ptarmigan</title>
	<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
	<cfoutput>
	<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
	<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
	<script type="text/javascript" src="#session.root_url#/parcels/gis.js"></script>
	<script type="text/javascript" src="#session.root_url#/ptarmigan.js"></script>
	</cfoutput>
</head>
<!---  --->
<body onload="init_map('map', 33.1283, -107.2522);" style="height:100%;width:100%;">
	<div id="container" style="height:100%;">
		<div id="map" style="width:100%;height:100%;">
							
		</div>					
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
		
		<div style="position:fixed; bottom:0px; width:100%; height:24px;border-top:1px grooved silver;">
		<div style="height:10px;margin:3px;float:left;">
		<div style="width:150px; height:100%; border:1px solid gray;">
			<div id="progress_bar" style="background-color:navy; width:0%; height:100%;"></div>
		</div>
		</div>
		<span id="loader"></span>
		</div>
	</div>
</body>
</html>