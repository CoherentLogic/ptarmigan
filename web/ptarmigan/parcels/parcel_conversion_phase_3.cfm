<cfquery name="update_parcel" datasource="ptarmigan">
	UPDATE parcels 
	SET boundary=GeomFromText('#attributes.wkt#') 
	WHERE id='#attributes.parcel_id#'
</cfquery>