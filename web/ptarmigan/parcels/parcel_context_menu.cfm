<link rel="stylesheet" href="/ptarmigan.css">
<cfif isdefined("attributes.parcel_id")>
	<cfset parcel_id = attributes.parcel_id>
<cfelse>
	<cfset parcel_id = url.parcel_id>
</cfif>

<cfoutput>
<div class="context-menu-item"><span class="context-menu-item-image"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/information.png"></span> <a href="#session.root_url#/objects/dispatch.cfm?id=#parcel_id#"><span>Information</span></a></div>
<div class="context-menu-item"><span class="context-menu-item-image"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map_edit.png"></span> <a href="#session.root_url#/objects/dispatch.cfm?id=#parcel_id#"><span>Edit Parcel</span></a></div>
<div class="context-menu-item"><span class="context-menu-item-image"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/page_white_copy.png"></span> <a href="#session.root_url#/objects/dispatch.cfm?id=#parcel_id#"><span>Show Documents</span></a></div>
<hr>
<div class="context-menu-item"><span class="context-menu-item-image"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/bin.png"></span> <a href="#session.root_url#/objects/dispatch.cfm?id=#parcel_id#"><span>Trash</span></a></div>

</cfoutput>
