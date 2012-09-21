<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Error</title>		
	<cfoutput><link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css"></cfoutput>
	<style type="text/css">
		#error {
			border-radius:8px;
			-webkit-border-radius:8px;
			-moz-border-radius:8px;
			border:8px solid silver;
			padding: 40px;
			width:700px;
			height:300px;
			background-color:white;
			margin-left:auto;
			margin-right:auto;
			margin-top:48px;
		}
		
		#error h1 {
			font-size:48pt;
			color:silver;
		}
		
		#error p {
			margin-left:80px;
			margin-right:60px;
			font-size:16px;	
			color:gray;		
		}
	</style>
</head>
<body>
		<div id="error">
			<cfoutput>
			<img src="#session.root_url#/images/sorry.png">
			
			<p>Ptarmigan has experienced an unexpected error.</p> 
			
			<p>Please try one of the links below, and feel free to contact us if this problem persists. We actively work to fix bugs and inconsistencies in this software, and we value your patience and support.</p>
		
			<p style="margin-top:80px;"><a href="#session.root_url#/dashboard.cfm">Dashboard</a> | <a href="http://www.coherent-logic.com/">Coherent Logic Development</a></p>
			</cfoutput>
		</div>
</body>
</html>
