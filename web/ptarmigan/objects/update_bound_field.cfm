<cfset object = CreateObject("component", "ptarmigan.object").open(url.id)>
<cfset object.set_member_value(url.member_name, url.value)>
<cfoutput>#object.member_value(url.member_name)#</cfoutput>