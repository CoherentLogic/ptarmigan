<cfmodule template="#session.root_url#/security/require.cfm" type="">
<cfsilent>
	<cfset object =  CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfset document = CreateObject("component", "ptarmigan.document").open(url.id)>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>	
	<cfoutput>	
		<title>#object.get().object_name()# - ptarmigan</title>		
		<cfinclude template="#session.root_url#/utilities/script_base.cfm">
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   											
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">												
   		 });
	</script>
</head>
<body>
	<cfinclude template="#session.root_url#/navigation.cfm">
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->	
	<div id="container">
		<div id="inner-tube">
		<div id="content-right">
			<cfinclude template="#session.root_url#/sidebar.cfm">
		</div> <!--- content-right --->
		<div id="content" style="margin:0px;width:80%;">		
			<cfmodule template="#session.root_url#/navigation-tabs.cfm">							
			<div id="tabs-min">
				<ul>
					<li><a href="#tab1">Document</a></li>
					<li><a href="#tab2">Preview</a></li>
				</ul>
				<div id="tab1">
					<div id="left-column" class="panel">
					<h1>Thing Details</h1>
					<p>
					<cfoutput>
					<table>
						<tbody>
						<tr>
							<td>Name:</td>
							<td>
								TODO: create bound fields
								<!---<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="document_name" width="auto" show_label="false" full_refresh="false">--->
							</td>
						</tr>
																
						</tbody>
					</table>
					</cfoutput>
					</p>					
					</div>
					<div id="right-column" class="panel">
						<cfmodule template="#session.root_url#/objects/related_items.cfm" object_id="#object.id#">
					</div> 
				</div>
				<div id="tab2">
					<cfmodule template="preview.cfm" id="#url.id#">
				</div>
			</div> <!--- tabs-min --->	
		</div> <!--- inner-tube --->
	</div> <!--- content --->			
</div> <!--- container --->
</body>
</html>
