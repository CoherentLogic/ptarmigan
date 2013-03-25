<div style="max-width:540px;min-width:440px;" onclick="event.stopPropagation();" ondblclick="event.stopPropagation();" onmousedown="event.stopPropagation();" onmouseup="event.stopPropagation();" onmouseover="event.stopPropagation();">
	<div id="plugin-1">
		<table>
		<tr>
			<td valign="middle"><cfoutput> <img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/control_rewind.png" onclick="event.stopPropagation();"></cfoutput></td>
			<td valign="middle"><img src="plugins/ParcelQuery/icon.png" width="64"></td>
			<td valign="middle" style="width:415px;">
				<h1>Research</h1>
				<p>Look up ownership, location, valuation, and other information for a parcel.</p>
			</td>
			<td valign="middle"><cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/control_fastforward_blue.png" onclick="show_plugin(2, 'forward'); event.stopPropagation();"></cfoutput></td>
		</tr>
		</table>
		<div class="leaflet-plugin-results" id="research-results">
				
		</div>	
		<div style="float:right;overflow:hidden;">
			<a class="button" onclick="click_mode('research');"><span>Begin</span></a>
		</div>
	</div>
	
	<div id="plugin-2" style="display:none;">
		<table>
		<tr>
			<td valign="middle"><cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/control_rewind_blue.png" onclick="show_plugin(1, 'reverse'); event.stopPropagation();"></cfoutput></td>
			<td valign="middle"><img src="plugins/Mensuration/icon.png" width="64"></td>
			<td valign="middle" style="width:415px;">
				<h1>Mensuration</h1>
				<p>Measure the bearing and distance between two points.</p>
			</td>
			<td valign="middle"><cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/control_fastforward_blue.png" onclick="show_plugin(3, 'forward'); event.stopPropagation();"></cfoutput></td>
		</tr>
		</table>
		<center>
		<div class="leaflet-plugin-results" id="mensuration-results">
					
		</div>	
		</center>
		<div style="float:right;overflow:hidden;">
			<a class="button" onclick="click_mode('measure'); event.stopPropagation();"><span>Begin</span></a>
		</div>
	</div>
	
	<div id="plugin-3" style="display:none;">
		<table>
		<tr>
			<td valign="middle"><cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/control_rewind_blue.png" onclick="show_plugin(2, 'reverse'); event.stopPropagation();"></cfoutput></td>
			<td valign="middle"><img src="plugins/Documents/icon.png" width="64"></td>
			<td valign="middle" style="width:415px;">
				<h1>Documents</h1>
				<p>View documents pertaining to the selected parcel.</p>
			</td>
			<td valign="middle"><cfoutput><img src="#session.root_url#/OpenHorizon/Resources/Graphics/Silk/control_fastforward.png" onclick="event.stopPropagation();"></cfoutput></td>
		</tr>
		</table>
		<div class="leaflet-plugin-results" id="documents-results">
					
		</div>	
		<div style="float:right;overflow:hidden;">
			<a class="button" onclick="click_mode('documents');"><span>Begin</span></a>
		</div>
	</div>
</div>