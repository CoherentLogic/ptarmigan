<cfmodule template="security/require.cfm" type="">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
	<cfoutput>	
		<title>Dashboard - Ptarmigan</title>
		<link rel="icon" 
    	  type="image/x-icon" 
	      href="#session.root_url#/favicon.ico">
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
		
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#navigation-tabs").tabs();	
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
   		 });
	</script>
</head>
<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->
	<cfinclude template="#session.root_url#/navigation.cfm">
	<div id="container">
		
		<div id="content" style="width:100%;margin-left:0;">
			<cfmodule template="#session.root_url#/navigation-tabs.cfm">
		
			
		</div>
	</div>

</body>

</html>
