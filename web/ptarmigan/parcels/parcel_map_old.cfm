<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
<cfquery name="get_parcels" datasource="#session.company.datasource#">
	SELECT id FROM parcels WHERE center_latitude!=0 AND center_longitude!=0
</cfquery>

<cfset parcels = ArrayNew(1)>
<cfoutput query="get_parcels">
	<cfset p = CreateObject("component", "ptarmigan.parcel").open(id)>
	<cfset ArrayAppend(parcels, p)>
</cfoutput>

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
	        
	        var polygon = "";
	        
	        <cfloop array="#parcels#" index="p">
	        	<cfset parcel_points = p.get_points()>
		        var coords = [
					<cfoutput query="parcel_points">
				   		new google.maps.LatLng(#latitude#, #longitude#),
				   	</cfoutput>
				 ];
				 
				 polygon = new google.maps.Polygon({paths: coords})
				 
				 parcel.push(polygon);
				
				 parcel[parcel.length-1].setMap(map);
				 parcel = [];
			 </cfloop>
	         
			
		}
	</script>
</head>

<body onload="draw_parcels();">
	<div id="container">
		<div id="header">
			<h1>Parcel Map</h1>
		</div>
		<div id="navigation">
			
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