<cfoutput>
<cftry>
	<cfset img_url = CreateObject("component", "OpenHorizon.Graphics.Image").Create(attributes.turl, attributes.width, attributes.height)>
	<img src="#img_url#">
<cfcatch type="any">
	<img src="#attributes.turl#" width="#attributes.width#" height="#attributes.height#">
</cfcatch>
</cftry>    
</cfoutput>