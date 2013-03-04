<cfdump var="#form#">

<cfset selection_array = ArrayNew(1)>

<cfif isdefined("form.selection")>
	<cfif isarray(form.selection)>
		<cfset selection_array = form.selection>
	<cfelse>
		<cfset ArrayAppend(selection_array, form.selection)>
	</cfif>
	
	<cfswitch expression="#form.basket_action#">
		<cfcase value="link">
			
			<cfset target_object = CreateObject("component", "ptarmigan.object").open(form.target_object_id)>
			
			
			<cfloop array="#selection_array#" item="sel">
				<cfset source_object = CreateObject("component", "ptarmigan.object").open(sel)>
				<cfset link = CreateObject("component", "ptarmigan.object_association")>
				<cfset link.association_name = "Item Basket">
				<cfset link.target_object_id = target_object.id>
				<cfset link.target_object_class = target_object.class_id>
				<cfset link.source_object_id = source_object.id>
				<cfset link.source_object_class = source_object.class_id>
				<cfset link.create()>
			</cfloop>
			
		</cfcase>
		
	</cfswitch>
	
	<cfloop from="1" to="#ArrayLen(session.basket)#" index="basket_index">
		<cfloop array="#selection_array#" item="selection_item">
			<cfif session.basket[basket_index].id EQ selection_item>
				<cfset ArrayDeleteAt(session.basket, basket_index)>
			</cfif>
		</cfloop>
	</cfloop>
</cfif>

<cflocation url="#session.root_url#/objects/dispatch.cfm?id=#form.target_object_id#">

