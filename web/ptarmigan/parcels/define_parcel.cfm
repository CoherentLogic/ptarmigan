<cfsilent>
	Preprocessing goes here
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab,cftooltip">
	<cfoutput>	
		<title>Define Parcel - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
		<script src="#session.root_url#/parcels/parcels.js" type="text/javascript"></script>
		<script src="http://maps.googleapis.com/maps/api/js?sensor=false&libraries=drawing"></script>
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menu.css" />
		<link rel="stylesheet" href="http://view.jqueryui.com/menubar/themes/base/jquery.ui.menubar.css" />
		<link type="text/css" href="#session.root_url#/jquery_ui/css/smoothness/jquery-ui-1.8.23.custom.css" rel="Stylesheet" />	
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-1.7.2.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery-ui.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menu.js"></script>
		<script type="text/javascript" src="#session.root_url#/jquery_ui/js/jquery.ui.menubar.js"></script>
		<script src="http://view.jqueryui.com/menubar/ui/jquery.ui.position.js" type="text/javascript"></script>
	</cfoutput>		
	<script type="text/javascript">
		 $(document).ready(function() {   			
				$("#tabs").tabs();	
				$("#tabs").css("float", "left");
				$("#tabs").css("width", "840px");
				$("#accordion").accordion();		
				$("#navigation_bar").menubar({
					autoExpand:true,
					menuIcon:true,
					buttons:false
				});			
				
				$("#navigation_bar").css("color", "black");
				$('#navigation_bar').css("float", "left");
				$(".ui-state-default").css("color", "black");
				
				define_parcel();
   		 });
	</script>
</head>
<body>
	<cfoutput>
	<script src="#session.root_url#/wz_tooltip.js" type="text/javascript"></script>
	</cfoutput>
	<!--- BEGIN LAYOUT --->
	<cfinclude template="#session.root_url#/navigation.cfm">
	<div id="container">		
		<div id="navigation">			
			<div id="accordion">
				<p><a href="##">Parcel Properties</a></p>
				<div>
					<form name="parcel_properties" action="insert_parcel.cfm" method="post">
						<table class="property_dialog">							
							<tr>
								<td>Parcel ID</td>
								<td><input type="text" name="parcel_id"></td>					
							</tr>
							<tr>
								<td>Area (sq. ft.)</td>
								<td><input type="text" name="area_sq_ft" id="area_sq_ft"></td>					
							</tr>
							<tr>
								<td>Area (sq. yd.)</td>
								<td><input type="text" name="area_sq_yd" id="area_sq_yd"></td>					
							</tr>
							<tr>
								<td>Area (acres)</td>
								<td><input type="text" name="area_acres" id="area_acres"></td>					
							</tr>
							<tr>
								<td>Owner name</td>
								<td><input type="text" name="owner_name"></td>
							</tr>
							<tr>
								<td>Account number</td>
								<td><input type="text" name="account_number"></td>
							</tr>
							<tr>
								<td>Subdivision</td>
								<td><input type="text" name="subdivision"></td>
							</tr>
							<tr>
								<td>Lot</td>
								<td><input type="text" name="lot"></td>
							</tr>
							<tr>
								<td>Block</td>
								<td><input type="text" name="block"></td>
							</tr>
							<tr>
								<td>Section</td>
								<td><input type="text" name="section"></td>
							</tr>
							<tr>
								<td>Township</td>
								<td nowrap>
									<input type="text" name="township" style="width:78%;">
									<select name="township_direction" style="width:20%;">
										<option value="N">North</option>
										<option value="S">South</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Range</td>
								<td nowrap>
									<input type="text" name="range" style="width:78%;">
									<select name="range_direction" style="width:20%;">
										<option value="E">East</option>
										<option value="W">West</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Mailing address</td>
								<td><input type="text" name="mailing_address"></td>
							</tr>
							<tr>
								<td>Mailing city</td>
								<td><input type="text" name="mailing_city"></td>
							</tr>
							<tr>
								<td>Mailing state</td>
								<td><input type="text" name="mailing_state"></td>
							</tr>
							<tr>
								<td>Mailing ZIP</td>
								<td><input type="text" name="mailing_zip"></td>
							</tr>
							<tr>
								<td>Physical address</td>
								<td><input type="text" name="physical_address"></td>
							</tr>
							<tr>
								<td>Physical city</td>
								<td><input type="text" name="physical_city"></td>
							</tr>
							<tr>
								<td>Physical state</td>
								<td><input type="text" name="physical_state"></td>
							</tr>				
							<tr>
								<td>Physical ZIP</td>
								<td><input type="text" name="physical_zip"></td>
							</tr>
							<tr>
								<td>Assessed land value</td>
								<td><input type="text" name="assessed_land_value" value="0"></td>					
							</tr>
							<tr>
								<td>Assessed building value</td>
								<td><input type="text" name="assessed_building_value" value="0"></td>
							</tr>
							<tr>					
								<td>Reception number</td>
								<td><input type="text" name="reception_number"></td>
							</tr>
							<tr>
								<td>Has ground survey</td>
								<td>
									<select name="ground_survey">
										<option value="1">Yes</option>
										<option value="0">No</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Metes &amp; bounds</td>
								<td>
									<textarea name="metes_and_bounds"></textarea>
								</td>
							</tr>
							
						</table>
						<input type="hidden" name="points" id="points">
						<input type="hidden" name="center_latitude" id="center_latitude">
						<input type="hidden" name="center_longitude" id="center_longitude">
					</form>
				</div> <!--- parcel properties --->
			</div> <!--- accordion --->
		</div> <!--- navigation --->
		<div id="content">
			<div id="tabs">
				<ul>
					<li><a href="#tab1">Map</a></li>
				</ul>
				<div id="tab1">
					<div id="map" style="width:100%;height:400px;">
						
					</div>
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>