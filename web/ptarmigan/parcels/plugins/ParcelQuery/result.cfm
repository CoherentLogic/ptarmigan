<cfset parcel_object = CreateObject("component", "ptarmigan.object").open(url.parcel_id)>
<cfset parcel = parcel_object.get()>

<cfdump var="#parcel#">