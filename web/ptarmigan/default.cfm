<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
	<cfoutput>
		<title>#session.company.company_name# - Geodigraph GIS 2014</title>
		<link rel="stylesheet" type="text/css" href="ext-5.0.1/build/packages/ext-theme-crisp/build/resources/ext-theme-crisp-all.css">
		<link rel="stylesheet" type="text/css" href="gis.css">
		<link rel="stylesheet" href="leaflet-0.7.3/leaflet.css">
		<link rel="stylesheet" href="leaflet-plugins/L.Control.Zoomslider.css">
	</cfoutput>
</head>
<body>			
		
	<div id="map-container" style="width:100%;height:100%;background-color:transparent;">
		<div id="map" style="width:100%;height:100%;background-color:transparent;">
		
		</div>
	</div>

	<cfoutput>
		<script type="text/javascript">
			var Ext = Ext || {};
			Ext.manifest = { 
			    compatibility: {
		                ext: '4.2'
			    }
			}
		</script>
		
		<script type="text/javascript" src="ext-5.0.1/build/ext-all.js"></script>
		<script type="text/javascript" src="widget/uxNotification.js"></script>
		<script type="text/javascript" src="leaflet-0.7.3/leaflet.js"></script>		
		<script type="text/javascript" src="leaflet-plugins/L.Control.Zoomslider.js"></script>
		<script type="text/javascript" src="ptarmigan.js"></script>
		<script type="text/javascript" src="gis.js"></script>
		<script type="text/javascript" src="pt_session.js"></script>
		<script type="text/javascript" src="app.js"></script>				
	</cfoutput>

</body>
</html>
