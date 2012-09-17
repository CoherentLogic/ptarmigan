<cfset doc = CreateObject("component", "ptarmigan.document").open(attributes.id)>
<div style="border:1px solid #efefef; width:240px; height:240px; padding:20px; float:left; margin-right:10px; text-align:center; margin-bottom:10px;">
	<cfoutput>
	<center>
	<div style="height:200px; width:200px; text-align:center; margin-bottom:10px;">
	<center>
	<a href="#session.root_url#/documents/manage_document.cfm?id=#doc.id#">
	<img src="#doc.thumbnail_url#" style="margin-left:auto; margin-right:auto;">
	</a>
	</center>
	</div>
	</center>
	<a href="#session.root_url#/documents/manage_document.cfm?id=#doc.id#">#doc.document_name#</a>
	</cfoutput>
</div>