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
	<cfset doc = assoc.get()>
	<cfoutput>	
	<div id="poop1">
	<ul>
		<li>
			<a href="#session.root_url#/objects/dispatch.cfm?id=#obj.id#">#assoc.get().object_name()#</a>
			<ul>
				<li>Document ##: #doc.document_number#</li>
				<li>Revision: #doc.document_revision#</li>
				<li>Filing category: #doc.filing_category#</li>
				<li>Filing container: #doc.filing_container#</li>
				<li>Filing division: #doc.filing_division#</li>
				<li>Filing material: #doc.filing_material_type#</li>
				<li>Filing number: #doc.filing_number#</li>
				<li>Filing date: #doc.filing_date#</li>
				<li>Section: #doc.section#</li>
				<li>Township: #doc.township#</li>
				<li>Range: #doc.range#</li>
				<li>Subdivision: #doc.subdivision#</li>
				<li>Lot: #doc.lot#</li>
				<li>Block: #doc.block#</li>
				<li>USRS Parcel: #doc.usrs_parcel#</li>
				<li>USRS Sheet: #doc.usrs_sheet#</li>
				<li>Address: #doc.address#</li>
				<li>City: #doc.city#</li>
				<li>State: #doc.state#</li>
				<li>ZIP: #doc.zip#</li>
				<li>Owner name: #doc.owner_name#</li>
			</ul>
		</li>
	</ul>
	</div>
	</cfoutput>
</cfloop>
