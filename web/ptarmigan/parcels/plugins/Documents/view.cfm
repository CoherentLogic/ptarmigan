<cfset document = CreateObject("component", "ptarmigan.document").open(url.id)>
<cfoutput>
	
<iframe src="http://docs.google.com/gview?url=#session.system.base_url#/uploads/#document.path#&embedded=true" style="width:100%; height:100%;" frameborder="0"></iframe>
</cfoutput>