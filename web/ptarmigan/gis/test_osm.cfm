<!DOCTYPE html>
<html lang="en">
	<head>
		<title>Query Test</title>
	</head>
	<body>
		<cfquery name="qtest" datasource="ptarmigan">
			SELECT AsText(boundary) AS boundary_text FROM parcels
		</cfquery>
		
		<cfoutput query="qtest" maxrows="100">
			#boundary_text#<br>
		</cfoutput>
	</body>
</html>
