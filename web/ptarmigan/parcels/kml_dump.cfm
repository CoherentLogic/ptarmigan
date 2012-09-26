<cffile action="read" file="#url.file#" variable="input_file">
<cfset kml_document = XmlParse(input_file)>

<cfset objects = kml_document.kml.Document.XmlChildren>
<cfset object_count = ArrayLen(objects)>

<cfloop from="1" to="#object_count#" index="i">
		<cftry>
		<cfset placemark = kml_document.kml.Document.Placemark[i]>		
		<cfset parcel_id = placemark.name.XmlText>
		<cfset parcel = CreateObject("component", "ptarmigan.parcel").open_by_apn(parcel_id)>
		<cfswitch expression="#placemark.styleUrl.XmlText#">
			<cfcase value="Filled_Label">
				<cfset coord_text = placemark.Point.coordinates.XmlText>
				<cfset pairs_list = ArrayNew(1)>
				<cfset pairs_list = ListToArray(coord_text, ",")>
				<cfset parcel.center_latitude = pairs_list[2]>
				<cfset parcel.center_longitude = pairs_list[1]>
				<cfset parcel.update()>
			</cfcase>
			<cfcase value="##Default">				
				<cfset coord_text = placemark.LineString.coordinates.XmlText>
				<cfset pairs_list = ArrayNew(1)>
				<cfset pairs_list = ListToArray(coord_text, " ")>
				<cfloop array="#pairs_list#" index="p">
					<cfset coords = ArrayNew(1)>
					<cfset coords = ListToArray(p)>
					<cfset point_latitude = coords[2]>
					<cfset point_longitude = coords[1]>
					<cfset parcel.add_point(point_latitude, point_longitude)>
				</cfloop>
			</cfcase>
		</cfswitch>
		<cfcatch type="any">
		</cfcatch>
		</cftry>
</cfloop>