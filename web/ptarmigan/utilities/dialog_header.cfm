
<div style="position:absolute; top:60px; right:10px;">
<cfmodule template="#session.root_url#/help/help_button.cfm" page="#GetFileFromPath(cgi.path_translated)#">
</div>

<cfoutput>
<div style="width:100%; height:50px; background-color:##2957a2; font-size:24px;margin-bottom:30px;"><div style="padding:8px; text-transform:uppercase; font-weight:bold; color:##efefef; letter-spacing:6px;"><img src="#attributes.icon#" width="48" height="48" align="absmiddle" style="margin-left:20px; margin-top:20px; margin-right:20px; font-family:Arial;">#attributes.caption#</div></div>

</cfoutput>
