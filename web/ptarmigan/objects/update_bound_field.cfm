<cfset object = CreateObject("component", "ptarmigan.object").open(url.id)>
<cfset object.set_member_value(url.member_name, url.value)>
<cfset object.add_audit(url.member_name, url.original, url.value, url.conum, url.comment)>
<cfoutput>#object.member_value(url.member_name)#</cfoutput>		
		