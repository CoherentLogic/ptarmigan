<cfset parcel_object = CreateObject("component", "ptarmigan.object").open(url.parcel_id)>
<cfset parcel = parcel_object.get()>

<cfoutput>
<cfif session.logged_in EQ true>
	<button class="left-button" onclick="click_mode('research');"><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/map_edit.png" style="vertical-align:middle;"> <a href="#session.root_url#/objects/dispatch.cfm?id=#url.parcel_id#" target="_blank">Edit Parcel</a></button>
</cfif>
<table>
	<thead>
		<tr>
			<th>Property</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>APN</td>
			<td>#parcel.parcel_id#</td>
		</tr>
		<tr>
			<td>Account Number</td>
			<td>#parcel.account_number#</td>
		</tr>
		<tr>
			<td>Reception Number</td>
			<td>#parcel.reception_number#</td>
		</tr>
		<tr>
			<td>Owner Name</td>
			<td>#parcel.owner_name#</td>
		</tr>
		<tr>
			<td>Physical Address</td>
			<td>#parcel.physical_address#</td>
		</tr>
		<tr>
			<td>Physical City</td>
			<td>#parcel.physical_city#</td>
		</tr>
		<tr>
			<td>Physical State</td>
			<td>#parcel.physical_state#</td>
		</tr>
		<tr>
			<td>Physical ZIP</td>
			<td>#parcel.physical_zip#</td>
		</tr>
		<tr>
			<td>Subdivision</td>
			<td>#parcel.subdivision#</td>
		</tr>
		<tr>
			<td>Lot</td>
			<td>#parcel.lot#</td>
		</tr>
		<tr>
			<td>Block</td>
			<td>#parcel.block#</td>
		</tr>
		<tr>
			<td>Section</td>
			<td>#parcel.section#</td>
		</tr>
		<tr>
			<td>Township</td>
			<td>#parcel.township#</td>
		</tr>
		<tr>
			<td>Range</td>
			<td>#parcel.range#</td>
		</tr>
		<tr>
			<td>Mailing Address</td>
			<td>#parcel.mailing_address#</td>
		</tr>
		<tr>
			<td>Mailing City</td>
			<td>#parcel.mailing_city#</td>
		</tr>
		<tr>
			<td>Mailing State</td>
			<td>#parcel.mailing_state#</td>
		</tr>
		<tr>
			<td>Mailing ZIP</td>
			<td>#parcel.mailing_zip#</td>
		</tr>
		<tr>
			<td>Building Value</td>
			<td>#numberFormat(parcel.assessed_building_value, ',_$___.__')#</td>
		</tr>
		<tr>
			<td>Land Value</td>
			<td>#numberFormat(parcel.assessed_land_value, ',_$___.__')#</td>
		</tr>		
		<tr>
			<td>Has Ground Survey</td>
			<td>
				<cfif parcel.ground_survey EQ 0>
					No
				<cfelse>
					Yes
				</cfif>
			</td>
		</tr>
		<tr>
			<td>Area (Sq. Ft.)</td>
			<td>#parcel.area_sq_ft#</td>
		</tr>
		<tr>
			<td>Area (Sq. Yd.)</td>
			<td>#parcel.area_sq_yd#</td>
		</tr>
		<tr>
			<td>Area (Acres)</td>
			<td>#parcel.area_acres#</td>
		</tr>
		<tr>
			<td>Legal Description</td>
			<td>#parcel.metes_and_bounds#</td>
		</tr>				
	</tbody>
</table>

</cfoutput>