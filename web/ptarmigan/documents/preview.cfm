<cfset document = CreateObject("component", "ptarmigan.document").open(attributes.id)>
<cfset has_preview = false>
<cfswitch expression="#document.content_type()#">
	<cfcase value="image">
		<cfset has_preview = true>
		<cfoutput>					
		<iframe src="http://docs.google.com/gview?url=http://ptarmigan-devel.clogic-int.com/uploads/#document.path#&embedded=true" style="width:100%; height:600;" frameborder="0"></iframe>
		</cfoutput>
	</cfcase>		
	<cfcase value="application">
		<cfswitch expression="#document.content_sub_type()#">
			<cfcase value="pdf,vnd.pdf" delimiters=",">
				<cfset has_preview = true>
				
				<cfoutput>					
				<iframe src="http://docs.google.com/gview?url=http://ptarmigan-devel.clogic-int.com/uploads/#document.path#&embedded=true" style="width:100%; height:600;" frameborder="0"></iframe>
				</cfoutput>
				<!---<cfpdf action="getInfo" source="#session.upload_path#/#document.path#" name="pdf_info">
				<cfset page_count = pdf_info.TotalPages>
				<cfpdf 	action="thumbnail" 
						source="#session.upload_path#/#document.path#"
						destination="#session.upload_path#"
						overwrite="true"
						format="jpg"
						scale="100">
				<cfset base_file_name = left(document.path, len(document.path) - 4)>
						
				<cfset has_preview = true>
				<div id="preview-tabs" class="preview_pages">
					<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
					<td width="20%">
					<cfloop from="1" to="#page_count#" index="page_number">
							
						<div style="border:1px solid ##c0c0c0; padding:4px;">	
						<cfoutput>
							<cfset current_file = session.root_url & "/uploads/" & base_file_name & "_page_" & page_number & ".jpg">
							<cfset img_obj = CreateObject("component", "OpenHorizon.Graphics.Image").Create(current_file, 200, 200)>
							<a href="javascript:preview_show_page(#page_number#);">
								<img src="#img_obj#"></a>
							
							
						</cfoutput>
						</div>
					</cfloop>
					</td>
					<td width="80%" valign="top">
					<cfloop from="1" to="#page_count#" index="page_number">
						<cfoutput><div id="preview_#page_number#"></cfoutput>	
							<cfif page_number EQ 1>
								<cfset preview_display = "block">
							<cfelse>
								<cfset preview_display = "none">
							</cfif>
							<div <cfoutput>style="width:100%; height:auto; overflow:auto; display:#preview_display#;"</cfoutput>>
							<cfset current_file = base_file_name & "_page_" & page_number & ".jpg">
							<cfoutput>
								<img src="#session.root_url#/uploads/#current_file#">
							</cfoutput>
							</div>
						</div>
					</cfloop>		
					</td>
					</tr>
					</table>		
				</div>
				--->
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfif has_preview EQ false>
	<h3>No preview available.</h3>
</cfif>