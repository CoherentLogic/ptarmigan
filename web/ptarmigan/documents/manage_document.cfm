<cfsilent>
	<cfmodule template="../security/require.cfm" type="">

	<cfset document = CreateObject("component", "ptarmigan.document").open(url.id)>
	<cfset session.current_object = CreateObject("component", "ptarmigan.object").open(url.id)>
	<cfif IsDefined("form.submit")>	
		<cfif IsDefined("form.upload_file")>
			<cffile action="upload" filefield="form.upload_file" destination="#session.upload_path#" nameconflict="makeunique">
			<cfset document.path = cffile.serverfile>
			<cfset document.mime_type = cffile.ContentType & "/" & cffile.ContentSubType>
		</cfif>
		
		<cfset document.document_name = ucase(form.document_name)>
		<cfset document.description = ucase(form.description)>
		<cfset document.document_number = form.document_number>
		<cfset document.filing_category = form.filing_category>
		<cfset document.filing_container = form.filing_container>
		<cfset document.filing_division = ucase(form.filing_division)>
		<cfset document.filing_material_type = form.filing_material_type>
		<cfset document.filing_number = ucase(form.filing_number)>
		<cfset document.filing_date = CreateODBCDate(form.filing_date)>
		
		<cfset document.update()>
		
		<cflocation url="#session.root_url#/documents/de_formify.cfm?id=#url.id#">
	</cfif>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfajaximport tags="cfwindow,cfform,cfinput-datefield,cftree,cflayout-tab,cftooltip">
	<cfoutput>	
		<title>#document.document_name# (Document) - ptarmigan</title>
		
		<link rel="stylesheet" type="text/css" href="#session.root_url#/ptarmigan.css">
		<script src="#session.root_url#/ptarmigan.js" type="text/javascript"></script>
		
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
				<p><a href="##">Document Properties</a></p>
				<div>
				<cfoutput>
					<form name="document_properties" action="manage_document.cfm?id=#url.id#" method="post" enctype="multipart/form-data">
						<table class="property_dialog">
							<tr>
								<td>Name</td>
								<td><input type="text" name="document_name" value="#document.document_name#"></td>
							</tr>
							<tr>
								<td>Document number</td>
								<td><input type="text" name="document_number" value="#document.document_number#"></td>
							</tr>
							<tr>
								<td>Description</td>
								<td><textarea name="description">#document.description#</textarea></td>
							</tr>
							<tr>
								<td>Filing date:</td>
								<td><input type="text" name="filing_date" value="#dateFormat(document.filing_date, 'mm/dd/yyyy')#"></td>
							</tr>
							<tr>
								<td>Container category:</td>
								<td>
									<select name="filing_category" autocomplete="off">
										<option value="FILE" <cfif document.filing_category EQ "FILE">selected="selected"</cfif>>FILE</option>
										<option value="STORAGE" <cfif document.filing_category EQ "STORAGE">selected="selected"</cfif>>STORAGE</option>
										<option value="DEED" <cfif document.filing_category EQ "DEED">selected="selected"</cfif>>DEED</option>
										<option value="SUBDIVISION" <cfif document.filing_category EQ "SUBDIVISION">selected="selected"</cfif>>SUBDIVISION</option>
									</select>	
								</td>
							</tr>
							<tr>
								<td>Container type:</td>
								<td>
									<select name="filing_container" autocomplete="off">
										<option value="CABINET" <cfif document.filing_container EQ "CABINET">selected="selected"</cfif>>CABINET</option>
										<option value="SHELF" <cfif document.filing_container EQ "SHELF">selected="selected"</cfif>>SHELF</option>
										<option value="BOOK" <cfif document.filing_container EQ "BOOK">selected="selected"</cfif>>BOOK</option>					
										<option value="PLAT" <cfif document.filing_container EQ "PLAT">selected="selected"</cfif>>PLAT</option>
									</select>
								</td>					
							</tr>
							<tr>
								<td>Container number:</td>
								<td><input type="text" name="filing_division" size="4" value="#document.filing_division#"></td>					
							</tr>
							<tr>
								<td>Filing material:</td>
								<td>
									<select name="filing_material_type" autocomplete="off">
										<option value="FOLDER" <cfif document.filing_material_type EQ "FOLDER">selected="selected"</cfif>>FOLDER</option>
										<option value="BOX" <cfif document.filing_material_type EQ "BOX">selected="selected"</cfif>>BOX</option>
										<option value="PAGE" <cfif document.filing_material_type EQ "PAGE">selected="selected"</cfif>>PAGE</option>
										<option value="SLIDE" <cfif document.filing_material_type EQ "SLIDE">selected="selected"</cfif>>SLIDE</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Filing number/label:</td>
								<td>
									<input type="text" name="filing_number" value="#document.filing_number#">
								</td>
							</tr>
							<cfif document.path EQ "">
								<tr>
									<td colspan="2">Upload file<br><input type="file" name="upload_file"></td>
								</tr>
							<cfelse>
								<tr>
									<td>File</td>
									<td><a href="#session.root_url#/uploads/#document.path#" target="_blank">Open file</a></td>
								</tr>
								<tr>
									<td>File type</td>
									<td>#ucase(document.content_type())#</td>
								</tr>
								<tr>
									<td>File subtype</td>
									<td>#ucase(document.content_sub_type())#</td>
								</tr>
				
							</cfif>
						</table>
						<input type="submit" name="submit" value="Apply">
					</form>
				</cfoutput>
			</div>			
		</div>
		</div>
		<div id="content">		
			<div id="tabs">
				<ul>
					<li><a href="#aPreview">Preview</a></li>
					<li><a href="#aEmployees">Employees</a></li>
					<li><a href="#aCustomers">Customers</a></li>
					<li><a href="#aProjects">Projects</a></li>
					<li><a href="#aMilestones">Milestones</a></li>
					<li><a href="#aTasks">Tasks</a></li>
					<li><a href="#aExpenses">Expenses</a></li>
					<li><a href="#aParcels#">Parcels</li>
				</ul>
				<div id="aPreview">
					<cfmodule template="preview.cfm" id="#document.id#">
				</div>
				<div id="aEmployees">
					<cfmodule template="associations.cfm" type="employees" id="#document.id#">
				</div>
				<div id="aCustomers">
					<cfmodule template="associations.cfm" type="customers" id="#document.id#">
				</div>
				<div id="aProjects">
					<cfmodule template="associations.cfm" type="projects" id="#document.id#">
				</div>
				<div id="aMilestones">
					<cfmodule template="associations.cfm" type="milestones" id="#document.id#">
				</div>
				<div id="aTasks">
					<cfmodule template="associations.cfm" type="tasks" id="#document.id#">
				</div>
				<div id="aExpenses">
					<cfmodule template="associations.cfm" type="expenses" id="#document.id#">
				</div>
				<div id="aParcels">
					<cfoutput>
						<div style="margin-bottom:30px;">
							<a class="button" href="##" onclick="search_parcels('#session.root_url#', '#document.id#')"><span>Find and Attach</span></a>
						</div>
					</cfoutput>
					<table width="100%" class="pretty" style="margin:0;">
						<tr>
							<th>APN/ACCT/RCPT</th>
							<th>OWNER</th>
							<th>SUBDIVISION</th>
							<th>LOT</th>
							<th>BLOCK</th>
							<th>LEGAL SECTION</th>
							<th>AREA</th>
							<th>VALUE</th>
							<th>GRND SURVEY</th>			
						</tr>
					<cfloop array="#document.parcels()#" index="p">
						<tr>
							<td>
								<cfoutput>
									APN:  #p.parcel_id#<br>
									RCPT: #p.reception_number#<br>
									ACCT: #p.account_number#
								</cfoutput>
							</td>
							<td><cfoutput>#p.owner_name#</cfoutput></td>
							<td><cfoutput>#p.subdivision#</cfoutput></td>
							<td><cfoutput>#p.lot#</cfoutput></td>
							<td><cfoutput>#p.block#</cfoutput></td>
							<td>
								<cfif p.section NEQ "">
									<cfoutput>SEC #p.section# T#p.township# R#p.range#</cfoutput>
								</cfif>
							</td>
							<td>
								<cfoutput>
									#p.area_sq_ft# SQ. FT.<br>
									#p.area_sq_yd# SQ. YD.<br>
									#p.area_acres# ACRES
								</cfoutput>
							</td>
							<td>
								<cfoutput>
									LAND: #numberFormat(p.assessed_land_value, ",_$___.__")#<br>
									BLDG: #numberFormat(p.assessed_building_value, ",_$___.__")#
								</cfoutput>
							</td>
							<td>
								<cfif p.ground_survey EQ 1>Y<cfelse>N</cfif>
							</td>
						</tr>
						<tr>
							<td colspan="9">
								<table width="100%">
									<tr>
										<td>
											<strong>PHYSICAL LOCATION:</strong><br>
											<cfoutput>
												#p.physical_address#<br>
												#p.physical_city# #p.physical_state# #p.physical_zip#
											</cfoutput>
										</td>
										<td>
											<strong>MAILING ADDRESS:</strong><br>
											<cfoutput>
												#p.mailing_address#<br>
												#p.physical_city# #p.physical_state# #p.physical_zip#
											</cfoutput>
										</td>
										<td valign="bottom" align="right">
											<cfoutput>
												<a class="button" href="#session.root_url#/parcels/manage_parcel.cfm?id=#p.id#"><span>View parcel</span></a><br>												
											</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</cfloop>
					</table>
				</div> <!--- aParcels --->
			</div> <!--- tabs --->		
		</div> <!--- content --->
	</div> <!--- container --->
</body>
</html>




	