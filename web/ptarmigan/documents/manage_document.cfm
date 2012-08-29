<cfajaximport tags="cfwindow,cfform,cfinput-datefield">

<cfmodule template="../security/require.cfm" type="project">

<cfset document = CreateObject("component", "ptarmigan.document").open(url.id)>

<cfif IsDefined("form.submit")>	
	<cfif IsDefined("form.upload_file")>
		<cffile action="upload" filefield="form.upload_file" destination="#session.upload_path#" nameconflict="makeunique">
		<cfset document.path = cffile.serverfile>
		<cfset document.mime_type = cffile.ContentType & "/" & cffile.ContentSubType>
	</cfif>
	
	<cfset document.document_name = form.document_name>
	<cfset document.description = form.description>
	<cfset document.document_number = form.document_number>
	
	<cfset document.update()>
	
	<cflocation url="#session.root_url#/documents/de_formify.cfm?id=#url.id#">
</cfif>

<div id="container">
	<div id="header">
		<cfoutput>
			<h1>#document.document_name#</h1> #document.content_type()# : #document.content_sub_type()#
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
		</cflayout>		
	</div>
</div>
	
	
