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


	<cfoutput><span style="display:inline;" class="bound-value-active" id="bound-value-#base_id#" onmouseover="bound_field_show_pencil('#base_id#')" onmouseout="bound_field_hide_pencil('#base_id#')" onclick="bound_field_activate('#base_id#');"></cfoutput>
		<cfoutput><cfif attributes.show_label EQ "true">#m_lbl#: </cfif>
			<cfif m_val NEQ "">
				#m_val#
			<cfelse>
				<em style="color:gray;">Click to add #lcase(m_lbl)#</em>
			</cfif>
		</cfoutput>		
	</span>
<cfoutput><div class="bound-control-wrapper" id="bound-control-wrapper-#base_id#"></cfoutput>
	<cfoutput><div class="bound-edit-inactive" id="bound-edit-div-#base_id#"></cfoutput>
		<div style="width:100%;height:auto;border-bottom:1px solid #999999;background-color:#2957a2;color:white;">
		<div style="padding:2px;">
		<cfoutput><strong>Editing #m_lbl# in #bound_object.class_name#</strong></cfoutput>
		</div>
		</div>
		
		<div style="padding:16px;">
		<strong><cfoutput>#m_lbl#</cfoutput></strong><br/>
		<hr>
		<cfoutput>
		<cfswitch expression="#m_type#">
			<cfcase value="enum">
				<cfset m_values = bound_object.member_enum_values(member)>
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#">
					<cfloop array="#m_values#" index="e_val">
						<option value="#e_val#" <cfif m_raw_val EQ e_val>selected="selected"</cfif>>#e_val#</option>
					</cfloop>
				</select>
			</cfcase>
			<cfcase value="township">
				<cfif len(m_raw_val) GT 1>
					<cfset t_township = left(m_raw_val, len(m_raw_val) - 1)>
					<cfset t_township_direction = right(m_raw_val, 1)>
				<cfelse>
					<cfset t_township = "">
					<cfset t_township_direction = "N">
				</cfif>
				<input type="text" id="bound-township-#base_id#" size="5" value="#t_township#" onchange="bound_field_township_update('#base_id#');">
				<select class="#control_class#" autocomplete="off" id="bound-township-direction-#base_id#" onchange="bound_field_township_update('#base_id#');">
					<option value="N" <cfif t_township_direction EQ "N">selected</cfif>>NORTH</option>
					<option value="S" <cfif t_township_direction EQ "S">selected</cfif>>SOUTH</option>					
				</select>
								
				<input type="hidden" id="bound-edit-#base_id#">
			</cfcase>		
			<cfcase value="range">
				<cfif len(m_raw_val) GT 1>
					<cfset t_range = left(m_raw_val, len(m_raw_val) - 1)>
					<cfset t_range_direction = right(m_raw_val, 1)>
				<cfelse>
					<cfset t_range = "">
					<cfset t_range_direction = "E">
				</cfif>
				<input type="text" id="bound-range-#base_id#" size="5" value="#t_range#" onchange="bound_field_range_update('#base_id#');">
				<select class="#control_class#" autocomplete="off" id="bound-range-direction-#base_id#" onchange="bound_field_range_update('#base_id#');">
					<option value="E" <cfif t_range_direction EQ "E">selected</cfif>>EAST</option>
					<option value="W" <cfif t_range_direction EQ "W">selected</cfif>>WEST</option>					
				</select>
								
				<input type="hidden" id="bound-edit-#base_id#">
			</cfcase>	
			<cfcase value="boolean">
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#">
					<option value="1" <cfif m_raw_val EQ 1>selected="selected"</cfif>>Yes</option>
					<option value="0" <cfif m_raw_val EQ 0>selected="selected"</cfif>>No</option>
				</select>
			</cfcase>
			<cfcase value="usstate">
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#">
					<option value="" <cfif m_raw_val EQ "">selected="selected"</cfif>>Select a State</option> 
					<option value="AL" <cfif m_raw_val EQ "AL">selected="selected"</cfif>>Alabama</option> 
					<option value="AK" <cfif m_raw_val EQ "AK">selected="selected"</cfif>>Alaska</option> 
					<option value="AZ" <cfif m_raw_val EQ "AZ">selected="selected"</cfif>>Arizona</option> 
					<option value="AR" <cfif m_raw_val EQ "AR">selected="selected"</cfif>>Arkansas</option> 
					<option value="CA" <cfif m_raw_val EQ "CA">selected="selected"</cfif>>California</option> 
					<option value="CO" <cfif m_raw_val EQ "CO">selected="selected"</cfif>>Colorado</option> 
					<option value="CT" <cfif m_raw_val EQ "CT">selected="selected"</cfif>>Connecticut</option> 
					<option value="DE" <cfif m_raw_val EQ "DE">selected="selected"</cfif>>Delaware</option> 
					<option value="DC" <cfif m_raw_val EQ "DC">selected="selected"</cfif>>District Of Columbia</option> 
					<option value="FL" <cfif m_raw_val EQ "FL">selected="selected"</cfif>>Florida</option> 
					<option value="GA" <cfif m_raw_val EQ "GA">selected="selected"</cfif>>Georgia</option> 
					<option value="HI" <cfif m_raw_val EQ "HI">selected="selected"</cfif>>Hawaii</option> 
					<option value="ID" <cfif m_raw_val EQ "ID">selected="selected"</cfif>>Idaho</option> 
					<option value="IL" <cfif m_raw_val EQ "IL">selected="selected"</cfif>>Illinois</option> 
					<option value="IN" <cfif m_raw_val EQ "IN">selected="selected"</cfif>>Indiana</option> 
					<option value="IA" <cfif m_raw_val EQ "IA">selected="selected"</cfif>>Iowa</option> 
					<option value="KS" <cfif m_raw_val EQ "KS">selected="selected"</cfif>>Kansas</option> 
					<option value="KY" <cfif m_raw_val EQ "KY">selected="selected"</cfif>>Kentucky</option> 
					<option value="LA" <cfif m_raw_val EQ "LA">selected="selected"</cfif>>Louisiana</option> 
					<option value="ME" <cfif m_raw_val EQ "ME">selected="selected"</cfif>>Maine</option> 
					<option value="MD" <cfif m_raw_val EQ "MD">selected="selected"</cfif>>Maryland</option> 
					<option value="MA" <cfif m_raw_val EQ "MA">selected="selected"</cfif>>Massachusetts</option> 
					<option value="MI" <cfif m_raw_val EQ "MI">selected="selected"</cfif>>Michigan</option> 
					<option value="MN" <cfif m_raw_val EQ "MN">selected="selected"</cfif>>Minnesota</option> 
					<option value="MS" <cfif m_raw_val EQ "MS">selected="selected"</cfif>>Mississippi</option> 
					<option value="MO" <cfif m_raw_val EQ "MO">selected="selected"</cfif>>Missouri</option> 
					<option value="MT" <cfif m_raw_val EQ "MT">selected="selected"</cfif>>Montana</option> 
					<option value="NE" <cfif m_raw_val EQ "NE">selected="selected"</cfif>>Nebraska</option> 
					<option value="NV" <cfif m_raw_val EQ "NV">selected="selected"</cfif>>Nevada</option> 
					<option value="NH" <cfif m_raw_val EQ "NH">selected="selected"</cfif>>New Hampshire</option> 
					<option value="NJ" <cfif m_raw_val EQ "NJ">selected="selected"</cfif>>New Jersey</option> 
					<option value="NM" <cfif m_raw_val EQ "NM">selected="selected"</cfif>>New Mexico</option> 
					<option value="NY" <cfif m_raw_val EQ "NY">selected="selected"</cfif>>New York</option> 
					<option value="NC" <cfif m_raw_val EQ "NC">selected="selected"</cfif>>North Carolina</option> 
					<option value="ND" <cfif m_raw_val EQ "ND">selected="selected"</cfif>>North Dakota</option> 
					<option value="OH" <cfif m_raw_val EQ "OH">selected="selected"</cfif>>Ohio</option> 
					<option value="OK" <cfif m_raw_val EQ "OK">selected="selected"</cfif>>Oklahoma</option> 
					<option value="OR" <cfif m_raw_val EQ "OR">selected="selected"</cfif>>Oregon</option> 
					<option value="PA" <cfif m_raw_val EQ "PA">selected="selected"</cfif>>Pennsylvania</option> 
					<option value="RI" <cfif m_raw_val EQ "RI">selected="selected"</cfif>>Rhode Island</option> 
					<option value="SC" <cfif m_raw_val EQ "SC">selected="selected"</cfif>>South Carolina</option> 
					<option value="SD" <cfif m_raw_val EQ "SD">selected="selected"</cfif>>South Dakota</option> 
					<option value="TN" <cfif m_raw_val EQ "TN">selected="selected"</cfif>>Tennessee</option> 
					<option value="TX" <cfif m_raw_val EQ "TX">selected="selected"</cfif>>Texas</option> 
					<option value="UT" <cfif m_raw_val EQ "UT">selected="selected"</cfif>>Utah</option> 
					<option value="VT" <cfif m_raw_val EQ "VT">selected="selected"</cfif>>Vermont</option> 
					<option value="VA" <cfif m_raw_val EQ "VA">selected="selected"</cfif>>Virginia</option> 
					<option value="WA" <cfif m_raw_val EQ "WA">selected="selected"</cfif>>Washington</option> 
					<option value="WV" <cfif m_raw_val EQ "WV">selected="selected"</cfif>>West Virginia</option> 
					<option value="WI" <cfif m_raw_val EQ "WI">selected="selected"</cfif>>Wisconsin</option> 
					<option value="WY" <cfif m_raw_val EQ "WY">selected="selected"</cfif>>Wyoming</option>
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
				<select class="#control_class#" autocomplete="off" id="bound-edit-#base_id#" style="width:100%;">
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
		
		<strong>Auditing</strong><br/>
		<hr>
		<label>Change Order ##: <br><input type="text" id="bound-edit-conum-#base_id#" style="width:100%;"></label>
		<br>
		Comment:<br>
		<textarea id="bound-edit-comment-#base_id#" style="width:100%; height:200px; margin:0; margin-bottom:8px;"></textarea>
		
		<div id="width:100%; margin-top:20px;">
		<button class="bound-field-button" onclick="bound_field_submit('#base_id#', '#attributes.id#', '#member#', #attributes.full_refresh#);"><img src="#session.root_url#/images/disk.png" align="absmiddle"> Save</button>
		<button class="bound-field-button" onclick="bound_field_revert('#base_id#', '#m_val#');"><img src="#session.root_url#/images/arrow_undo.png" align="absmiddle"> Revert</button>&nbsp;</cfoutput>
		</div>
		</div>
	</div>
</div>












