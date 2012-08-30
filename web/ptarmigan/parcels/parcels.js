function define_parcel() 
{
        var mapOptions = {
          center: new google.maps.LatLng(32.3197, -106.7653),
          zoom: 16,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        var map = new google.maps.Map(document.getElementById('map'),
          mapOptions);

        var drawingManager = new google.maps.drawing.DrawingManager({
          drawingMode: google.maps.drawing.OverlayType.MARKER,
          drawingControl: true,
          drawingControlOptions: {
            position: google.maps.ControlPosition.TOP_CENTER,
            drawingModes: [
              google.maps.drawing.OverlayType.POLYGON,
            ]
          },
        });
        drawingManager.setMap(map);

	google.maps.event.addListener(drawingManager, 'polygoncomplete', function(polygon) {
	var paths = polygon.getPath();
	var path_count = paths.getLength();
	var lat;
	var lon;
	var points = "";

		for (var i = 0; i < path_count ;i++)
		{
			lat = paths.getAt(i).lat();
			lon = paths.getAt(i).lng();
			points += lat;
			points += ":";
			points += lon;
			points += ",";			
		}   

		area = google.maps.geometry.spherical.computeArea(paths);
		area_acres = round_number(area * 0.000247105, 2);
		area_sq_ft = round_number(area * 10.7639, 2);
		area_sq_yd = round_number(area * 1.19599, 2);
		document.getElementById("area_acres").value = area_acres;
		document.getElementById("area_sq_ft").value = area_sq_ft;
		document.getElementById("area_sq_yd").value = area_sq_yd;
		document.getElementById("points").value = points;
		
		document.forms['parcel_properties'].submit();
	});

}


function round_number(num, dec) {
	var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
	return result;
}
