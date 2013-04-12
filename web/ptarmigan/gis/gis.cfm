<html>
<head>
	<cfoutput>
		<title>Ptarmigan GIS</title>
		<link rel="stylesheet" type="text/css" href="ext-4.2/resources/css/ext-all.css">
		<script type="text/javascript" src="ext-4.2/ext-debug.js"></script>
		<link rel="stylesheet" href="#session.root_url#/leaflet-master/leaflet.css">
		<script src="#session.root_url#/leaflet-master/leaflet-src.js"></script>
		<script src="#session.root_url#/ptarmigan.js"></script>
		<script type="text/javascript" src="gis.js"></script>
		<!--- <script type="text/javascript" src="plugins/__pt_query_attributes/plugin.js"></script> --->
		<script type="text/javascript" src="app.js"></script>
		
	</cfoutput>
</head>
<body>
	<div id="sidebar" class="x-hide-display">
		
	</div>
	<div id="map-container" style="width:100%;height:100%;">
		<div id="map" style="width:100%;height:100%;">
		
		</div>
	</div>
	<div id="search-results" class="x-hide-display">
		Search Results
	</div>
	<div id="doc-viewer" class="x-hide-display">
		Doc Viewer
	</div>
	<div id="status-bar" class="x-hide-display">
		
	</div>
	<div id="toolbar" class="x-hide-display">
		Toolbar
	</div>
</body>
</html>