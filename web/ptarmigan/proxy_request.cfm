<cfcontent type="#url.content_type#">
<cfhttp method="#url.method#" url="#url.proxy_url#">
<cfoutput>#cfhttp.filecontent#</cfoutput>