<cfset object = CreateObject("component", "ptarmigan.object").open(url.id)>
<cflocation url="#object.opener#" addtoken="false">
