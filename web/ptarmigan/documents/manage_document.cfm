
<cfmodule template="../security/require.cfm" type="project">

<cfset document = CreateObject("component", "ptarmigan.document").open(url.id)>

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

<div id="container">
	<div id="header">
		<cfoutput>
			<h1>#document.document_name#</h1>
		</cfoutput>
	</div>
	<div id="navigation">
		<cfoutput>
		<form name="document_properties" action="manage_document.cfm?id=#url.id#" method="post" enctype="multipart/form-data">
		<table class="property_dialog">
			<tr>
				<th colspan="2">
					PROPERTIES
				</th>
			</tr>
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
					<td>Upload file</td>
					<td><input type="file" name="upload_file"></td>
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
		<hr>		
		<div class="help_box">
			<h3><img src="<cfoutput>#session.root_url#</cfoutput>/images/leaf.png" align="absmiddle"> Tip</h3>
			<p style="margin-left:30px;"><em>You can associate documents with employees, customers, projects, milestones, tasks, and expenses by selecting from the appropriate tab on the right side of this screen.</em></p>
		</div>	
	</div> <!--- navigation --->
	
	<div id="content">
		<cflayout type="tab">
			<cflayoutarea title="Preview">
				<div style="width:100%;height:400px;overflow:auto;">
					<cfmodule template="preview.cfm" id="#document.id#">
				</div>
			</cflayoutarea>
			<cflayoutarea title="Employees">
				<cfmodule template="associations.cfm" type="employees" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Customers">
				<cfmodule template="associations.cfm" type="customers" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Projects">
				<cfmodule template="associations.cfm" type="projects" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Milestones">
				<cfmodule template="associations.cfm" type="milestones" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Tasks">
				<cfmodule template="associations.cfm" type="tasks" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Expenses">
				<cfmodule template="associations.cfm" type="expenses" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Find Parcels">
				<cfmodule template="associate_parcel.cfm" id="#document.id#">
			</cflayoutarea>
			<cflayoutarea title="Current Parcels">
				<cfmodule template="associations.cfm" type="parcels" id="#document.id#">
			</cflayoutarea>
		</cflayout>		
	</div>
</div>
	
	
