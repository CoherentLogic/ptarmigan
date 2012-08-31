
		<cfdiv>
			<cfmodule template="../parcels/parcel_search.cfm" id="my_thing">
		</cfdiv>		
		<hr>		
		<div style="width:100%;text-align:center;">
			<div style="padding:20px;">
				<span id="selected_parcel_apn" style="font-style:italic;">No parcel selected</span>
				<input type="hidden" id="selected_parcel">
				<cfoutput>
				<input type="button" name="associate_parcel_button" value="Associate Selected Parcel" onclick="associate_parcel_with_document('#session.root_url#', document.getElementById('selected_parcel').value, '#attributes.id#');">
				</cfoutput>
			</div>
		</div>
