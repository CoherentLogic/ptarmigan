<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Error Dispatcher</title>		
	<cfoutput>
	<script>
		window.location.replace('#session.root_url#/utilities/error.cfm');
	</script>
	</cfoutput>
</head>
<body>
	<cflocation url="#session.root_url#/utilities/error.cfm" addtoken="false">
</body>
</html>
