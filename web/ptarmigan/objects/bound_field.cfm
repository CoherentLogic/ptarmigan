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

<cfoutput><div class="bound-control-wrapper" id="bound-control-wrapper-#base_id#"></cfoutput>
	<cfoutput><div class="bound-value-active" id="bound-value-#base_id#" onmouseover="bound_field_show_pencil('#base_id#')" onmouseout="bound_field_hide_pencil('#base_id#')" onclick="bound_field_activate('#base_id#');"></cfoutput>
		<cfoutput><cfif attributes.show_label EQ "true">#m_lbl#: </cfif>
			#m_val#
		</cfoutput>
		
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
			<cfcase value="color">
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#">
					<option value="aqua" <cfif m_raw_val EQ "aqua">selected</cfif>>Aqua</option>
					<option value="black" <cfif m_raw_val EQ "black">selected</cfif>>Black</option>
					<option value="blue" <cfif m_raw_val EQ "blue">selected</cfif>>Blue</option>
					<option value="fuchsia" <cfif m_raw_val EQ "fuchsia">selected</cfif>>Fuchsia</option>
					<option value="gray" <cfif m_raw_val EQ "gray">selected</cfif>>Gray</option>
					<option value="green" <cfif m_raw_val EQ "green">selected</cfif>>Green</option>
					<option value="lime" <cfif m_raw_val EQ "lime">selected</cfif>>Lime</option>
					<option value="maroon" <cfif m_raw_val EQ "maroon">selected</cfif>>Maroon</option>
					<option value="navy" <cfif m_raw_val EQ "navy">selected</cfif>>Navy</option>
					<option value="olive" <cfif m_raw_val EQ "olive">selected</cfif>>Olive</option>
					<option value="purple" <cfif m_raw_val EQ "purple">selected</cfif>>Purple</option>
					<option value="red" <cfif m_raw_val EQ "red">selected</cfif>>Red</option>
					<option value="silver" <cfif m_raw_val EQ "silver">selected</cfif>>Silver</option>
					<option value="teal" <cfif m_raw_val EQ "teal">selected</cfif>>Teal</option>
					<option value="yellow" <cfif m_raw_val EQ "yellow">selected</cfif>>Yellow</option>
				</select>
			</cfcase>
			<cfcase value="date">
				<input class="#control_class#" autocomplete="off" type="text"	id="bound-edit-#base_id#" value="#m_val#">			
			</cfcase>
			<cfcase value="object">
				<cfset m_class = bound_object.member_class(member)>
				<cfset obj_coll = CreateObject("component", "ptarmigan.collection")>
				<cfset obj_coll.class_id = m_class>
				<cfset obj_coll.get()>				
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#">
					<cfloop array="#obj_coll.get()#" index="obj">
						<option value="#obj.get().id#" <cfif obj.get().id EQ m_raw_val>selected="selected"</cfif>>#obj.get().object_name()#</option>
					</cfloop>
				</select>								
			</cfcase>
			<cfdefaultcase>
				<input class="#control_class#" autocomplete="off" type="text"	id="bound-edit-#base_id#" value="#m_raw_val#" style="width:100%;">
			</cfdefaultcase>
		</cfswitch>
		<input type="hidden" id="bound-edit-original-#base_id#" value="#m_raw_val#">
		<br>
		<label>C/O ##: <br><input type="text" id="bound-edit-conum-#base_id#" style="width:100%;"></label>
		<br>
		Comment:<br>
		<textarea id="bound-edit-comment-#base_id#" style="width:100%; height:200px; margin:0; margin-bottom:8px;"></textarea>
		
		<div id="width:100%; margin-top:20px;">
		<button class="bound-field-button" onclick="bound_field_submit('#base_id#', '#attributes.id#', '#member#', #attributes.full_refresh#);"><img src="#session.root_url#/images/disk.png"></button>
		<button class="bound-field-button" onclick="bound_field_revert('#base_id#', '#m_val#');"><img src="#session.root_url#/images/arrow_undo.png"></button>&nbsp;</cfoutput>
		</div>
	</div>
</div>












