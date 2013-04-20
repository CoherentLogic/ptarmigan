<html>
<head>
	<cfoutput>
		<title>#session.company.company_name# - Ptarmigan GIS 2013</title>
		<link rel="stylesheet" type="text/css" href="ext-4.2/resources/css/ext-all.css">
		<link rel="stylesheet" type="text/css" href="gis.css">
		<script type="text/javascript" src="ext-4.2/ext-debug.js"></script>
		<script type="text/javascript" src="widget/uxNotification.js"></script>
		<link rel="stylesheet" href="#session.root_url#/leaflet-master/leaflet.css">
		<script src="#session.root_url#/leaflet-master/leaflet-src.js"></script>		
		<script src="#session.root_url#/ptarmigan.js"></script>
		<script type="text/javascript" src="gis.js"></script>
		<script type="text/javascript" src="pt_session.js"></script>
		<script type="text/javascript" src="app.js"></script>				
	</cfoutput>
</head>
<body>			
		
	<div id="map-container" style="width:100%;height:100%;background-color:transparent;">
		<div id="map" style="width:100%;height:100%;background-color:transparent;">
		
		</div>
	</div>
	
</body>
</html>