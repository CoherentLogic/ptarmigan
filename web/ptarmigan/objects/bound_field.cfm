<!--- 
	BOUND FIELD

	Attributes:
		id:			ptarmigan object id
		member:		member name
		width:  	control width
		show_label: "true" to show a label; "false" to hide it
		
	CSS Classes:
		bound-control-image:	the image for the pencil or disk
		bound-control-text:		selector for text fields
		bound-control-date:		selector for date fields
		bound-control-number:	selector for numeric fields
		bound-control-money:	selector for money fields
		bound-control-percentage:	selector for percentage fields		
		bound-control-object:	selector for object fields
		bound-control-boolean:	selector for boolean fields		
		
		bound-field-wrapper:	wraps the two divs
		
		bound-value-active:		the current value when it is shown
		bound-value-inactive: 	the current value when it is hidden
		bound-edit-active:		the edit control when it is shown
		bound-edit-inactive:	the edit control when it is hidden
	
	Javascript Functions:
		bound_field_mouseover(base_id):	called to show the pencil
		bound_field_activate(base_id):		called when the pencil is clicked
		bound_field_submit(base_id, object_id, member):		called when the disk is clicked
		bound_fields_init():				must be called on DOM ready of calling page 
											so jQuery can attach itself
--->

<!--- get an uppercase version of the member --->
<cfset member = ucase(attributes.member)>

<!--- open the bound object and set the base control ID --->
<cfset bound_object = CreateObject("component", "ptarmigan.object").open(attributes.id)>
<cfset m_val = bound_object.member_value(member)>
<cfset m_raw_val = bound_object.member_value_raw(member)>
<cfset m_lbl = bound_object.member_label(member)>
<cfset base_id = CreateUUID()>

<!--- pull in the type information to set the control's CSS class for jQuery --->
<cfset m_type = bound_object.member_type(attributes.member)>
<cfset control_class = "bound-control-" & m_type>

<cfoutput><div class="bound-field-wrapper" style="width:#attributes.width#;"></cfoutput>
	<cfoutput><div class="bound-value-active" id="bound-value-#base_id#" onmouseover="bound_field_show_pencil('#base_id#')" onmouseout="bound_field_hide_pencil('#base_id#')" onclick="bound_field_activate('#base_id#');"></cfoutput>
		<cfoutput><cfif attributes.show_label EQ "true">#m_lbl#: </cfif>#m_val#</cfoutput>
		
	</div>
	<cfoutput><div class="bound-edit-inactive" id="bound-edit-div-#base_id#"></cfoutput>
		<cfoutput><cfif attributes.show_label EQ "true">#m_lbl#: </cfif>
		<cfswitch expression="#m_type#">
			<cfcase value="boolean">
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#">
					<option value="1" <cfif m_raw_val EQ 1>selected="selected"</cfif>>Yes</option>
					<option value="0" <cfif m_raw_val EQ 0>selected="selected"</cfif>>No</option>
				</select>
			</cfcase>
			<cfcase value="date">
				<input class="#control_class#" autocomplete="off" type="text"	id="bound-edit-#base_id#" value="#m_val#">			
			</cfcase>
			<cfdefaultcase>
				<input class="#control_class#" autocomplete="off" type="text"	id="bound-edit-#base_id#" value="#m_raw_val#">
			</cfdefaultcase>
		</cfswitch>
		<button class="bound-field-button" onclick="bound_field_submit('#base_id#', '#attributes.id#', '#member#', #attributes.full_refresh#);">Save</button></cfoutput>
	</div>
</div>












