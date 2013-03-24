<cfset sqlquery = "UPDATE parcels SET boundary=GeomFromText('" & attributes.wkt & "') WHERE parcel_id='" & attributes.parcel_id & "'">

<cfquery name="update_parcel" datasource="ptarmigan">
	UPDATE parcels 
	SET boundary=GeomFromText('#attributes.wkt#') 
	WHERE parcel_id='#attributes.parcel_id#'
</cfquery>
