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
				bound_fields_init();
				<cfinclude template="#session.root_url#/utilities/jquery_init.cfm">
				
				try {
					$(".preview_pages").tabs();
				} catch (ex) {}
				
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
		<div id="header">
			<table width="100%">
				<tr>
					<td><cfoutput><h1><strong>#document.object_name()#</strong></h1></cfoutput></td>
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
					<li><a href="#doc">Document</a></li>
					<li><a href="#doc_preview">Preview</a></li>
				</ul>
				<div id="doc">
					<div id="left-column" class="panel">
					<h1>Document Details</h1>
					<p>
					<cfoutput>
					<table>
						<tbody>
						<tr>
							<td>Name:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="document_name" width="auto" show_label="false" full_refresh="false"></td>
							<td>Filing date:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="filing_date" width="auto" show_label="false" full_refresh="false">
							</td>
						</tr>
						<tr>
							<td>Document number:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="document_number" show_label="false" full_refresh="false"></td>
							<td>Filing category:</td>
							<td>
								<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="filing_category" width="auto" show_label="false" full_refresh="false">
							</td>				
						</tr>				
						<tr>
							<td>Filing container:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="filing_container" width="auto" show_label="false" full_refresh="false"></td>				
							<td>Filing division:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="filing_division" width="auto" show_label="false" full_refresh="false"></td>
						</tr>
						<tr>
							<td>Filing material type:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="filing_material_type" width="auto" show_label="false" full_refresh="false"></td>				
							<td>Filing number:</td>
							<td><cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="filing_number" width="auto" show_label="false" full_refresh="false"></td>
						</tr>
						
						</tbody>
					</table>
					</cfoutput>
					</p>
					<h1>Description</h1>
					<cfmodule template="#session.root_url#/objects/bound_field.cfm" id="#url.id#" member="description" width="auto" show_label="false" full_refresh="false"></td>
					<h1>Edit History</h1>
					<cfif object.get_audits().recordcount EQ 0>
						<p><em>No edits associated with this document</em></p>
					<cfelse>
						<cfset aud_query = object.get_audits()>
						<cfoutput query="aud_query">
							<cfset emp = CreateObject("component", "ptarmigan.object").open(employee_id)>
							<div class="comment_box">
								<span style="font-size:10px;color:gray;">#dateFormat(edit_date, "full")# #timeFormat(edit_date, "h:mm tt")# C/O ##: #change_order_number#</span>								
								<p><span style="color:##2957a2;">#emp.get().object_name()#</span> changed <strong>#member_name#</strong> from <strong>#original_value#</strong> to <strong>#new_value#</strong>
								<br><em>#comment#</em>
								</p>																
							</div>
						</cfoutput>
					</cfif>	
					</div>
					<div id="right-column" class="panel">
						<cfmodule template="#session.root_url#/objects/related_items.cfm" object_id="#object.id#">
					</div>
				</div>
				<div id="doc_preview">
					<cfmodule template="preview.cfm" id="#url.id#">
				</div>
			</div>
		</div>
	</div>

</body>

</html>
