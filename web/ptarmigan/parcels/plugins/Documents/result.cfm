<cfset parcel_object = CreateObject("component", "ptarmigan.object").open(url.parcel_id)>

<cfset tmp_array = ArrayNew(1)>

<cfloop array="#parcel_object.get_associated_objects('OBJ_DOCUMENT', 'TARGET')#" index="assoc">	
		<cfset ArrayAppend(tmp_array, assoc.id)>
</cfloop>

<cfloop array="#parcel_object.get_associated_objects('OBJ_DOCUMENT', 'SOURCE')#" index="assoc">
	<cfif not arrayfind(tmp_array, assoc.id)>
		<cfset ArrayAppend(tmp_array, assoc.id)>
	</cfif>
</cfloop>

<cfset obj_array = ArrayNew(1)>

<cfloop array="#tmp_array#" index="itm">
	<cfset arrayappend(obj_array, createobject("component", "ptarmigan.object").open(itm))>
</cfloop>

<cfloop array="#obj_array#" index="obj">
	<cfoutput>
	<img src="#obj.get_icon()#" align="absmiddle"> <a href="#session.root_url#/objects/dispatch.cfm?id=#obj.id#">#assoc.get().object_name()#</a><br>
	</cfoutput>
</cfloop>