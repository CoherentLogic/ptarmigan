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

<cfif arraylen(obj_array) EQ 0>
	<p>No documents associated with the selected parcel.</p>
</cfif>


<div class="tree">
<cfloop array="#obj_array#" index="obj">
	<cfset doc = assoc.get()>
	<cfoutput>	
	
	<ul>
		<li>
			<a href="#session.root_url#/objects/dispatch.cfm?id=#obj.id#">#assoc.get().object_name()#</a>
			<ul>
				<li><a href="##">Document ##: #doc.document_number#</a></li>
				<li><a href="##">Revision: #doc.document_revision#</a></li>
				<li><a href="##">Filing category: #doc.filing_category#</a></li>
				<li><a href="##">Filing container: #doc.filing_container#</a></li>
				<li><a href="##">Filing division: #doc.filing_division#</a></li>
				<li><a href="##">Filing material: #doc.filing_material_type#</a></li>
				<li><a href="##">Filing number: #doc.filing_number#</a></li>
				<li><a href="##">Filing date: #doc.filing_date#</a></li>
				<li><a href="##">Section: #doc.section#</a></li>
				<li><a href="##">Township: #doc.township#</a></li>
				<li><a href="##">Range: #doc.range#</a></li>
				<li><a href="##">Subdivision: #doc.subdivision#</a></li>
				<li><a href="##">Lot: #doc.lot#</a></li>
				<li><a href="##">Block: #doc.block#</a></li>
				<li><a href="##">USRS Parcel: #doc.usrs_parcel#</a></li>
				<li><a href="##">USRS Sheet: #doc.usrs_sheet#</a></li>
				<li><a href="##">Address: #doc.address#</a></li>
				<li><a href="##">City: #doc.city#</a></li>
				<li><a href="##">State: #doc.state#</a></li>
				<li><a href="##">ZIP: #doc.zip#</a></li>
				<li><a href="##">Owner name: #doc.owner_name#</a></li>
			</ul>
		</li>
	</ul>
	
	</cfoutput>
</cfloop>
</div>