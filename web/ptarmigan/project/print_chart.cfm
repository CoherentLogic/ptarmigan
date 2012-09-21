<cfsilent>
	<cfset p = CreateObject("component", "ptarmigan.project").open(url.project_id)>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab">
	<cfoutput>	
		<title>#p.project_name#</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		
		<style type="text/css">
			body {
				background-image:none;
			}
		</style>
						
	</cfoutput>		
</head>
<body onload="window.print();">
	<cfmodule template="gantt.cfm" id="#url.project_id#" print="true">
</body>
</html>
