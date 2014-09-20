<cfset parcel_object = CreateObject("component", "ptarmigan.object").open(url.parcel_id)>
<cfset parcel = parcel_object.get()>

<cfoutput>
<cfif session.logged_in EQ true>
	<button class="left-button" onclick="click_mode('research');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map_edit.png" style="vertical-align:middle;"> <a href="#session.root_url#/objects/dispatch.cfm?id=#url.parcel_id#" target="_blank">Edit Parcel</a></button>
</cfif>

<div class="tree">
<ul>
	<li class="jstree-open">
		<a href="##">Parcel Code #parcel.parcel_id#</a>
		<ul>			
			<li><a href="##">Account No.: #parcel.account_number#</a></li>
			<li><a href="##">Reception No.: #parcel.reception_number#</a></li>
			<li><a href="##">Owner Name: #parcel.owner_name#</a></li>
			<li><a href="##">Physical Address: #parcel.physical_address#</a></li>
			<li><a href="##">Physical City: #parcel.physical_city#</a></li>
			<li><a href="##">Physical State: #parcel.physical_state#</a></li>
			<li><a href="##">Physical ZIP: #parcel.physical_zip#</a></li>
			<li><a href="##">Subdivision: #parcel.subdivision#</a></li>
			<li><a href="##">Lot: #parcel.lot#</a></li>
			<li><a href="##">Block: #parcel.block#</a></li>
			<li><a href="##">Section: #parcel.section#</a></li>
			<li><a href="##">Township: #parcel.township#</a></li>
			<li><a href="##">Range: #parcel.range#</a></li>
			<li><a href="##">Mailing Address: #parcel.mailing_address#</a></li>
			<li><a href="##">Mailing City: #parcel.mailing_city#</a></li>
			<li><a href="##">Mailing State: #parcel.mailing_state#</a></li>
			<li><a href="##">Mailing ZIP: #parcel.mailing_zip#</a></li>
			<li><a href="##">Building Value: #numberFormat(parcel.assessed_building_value, ',_$___.__')#</a></li>
			<li><a href="##">Land Value: #numberFormat(parcel.assessed_land_value, ',_$___.__')#</a></li>
			<li><a href="##">Has Ground Survey:
				<cfif parcel.ground_survey EQ 0>
					No
				<cfelse>
					Yes
				</cfif>
			</a></li>
			<li><a href="##">Area (Sq. Ft.): #parcel.area_sq_ft#</a></li>
			<li><a href="##">Area (Sq. Yd.): #parcel.area_sq_yd#</a></li>
			<li><a href="##">Area (Acres): #parcel.area_acres#</a></li>
			<li><a href="##">Legal Description: #parcel.metes_and_bounds#</a></li>			
		</ul>
	</li>
</ul>
</div>

<p>Boundary WKT:</p>
<center>
<textarea style="width:350px; height:70px;" readonly>#parcel.wkt#</textarea>
</center>
</cfoutput>

