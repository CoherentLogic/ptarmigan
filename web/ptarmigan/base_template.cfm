<!--- TODO: Update log-in requirements --->
<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfsilent>
	<!--- TODO: Set preprocessing code here --->
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfoutput>	
		<title>Document Title - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "98%");					
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$(".ui-state-default").css("color", "black");
				$(".pt_buttons").button();								
				
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				
   		 });
	</script>
</head>
<body>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="header">
			<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>Thing Title</strong></h1></cfoutput></td>
					<td align="right">
						<cfoutput>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/add.png"></button>
						<cfif session.user.is_admin() EQ true>
							<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/pencil.png"></button>
							<button class="pt_buttons" onclick="trash_object('#session.root_url#', '#url.id#');"><img src="#session.root_url#/images/trash.png"></button>
						</cfif>
						<button class="pt_buttons" onclick=""><img src="#session.root_url#/images/print.png"></button>
						</cfoutput>
					</td>
				</tr>
			</table>
		</div>	
		<div id="content" style="margin:0px;width:100%;">
			<div id="tabs">
				<ul>
					<cfoutput><li><a href="##tab1">Tab 1</a></li></cfoutput>
				</ul>
				<div id="tab1">
					Tab 1
				</div>
			</div>
		</div>
	</div>
</body>
</html>
