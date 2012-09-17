<cfset document = CreateObject("component", "ptarmigan.document").open(attributes.id)>
<cfset has_preview = false>
<cfswitch expression="#document.content_type()#">
	<cfcase value="image">
		<cfset has_preview = true>
		<cfoutput>
		<img src="#session.root_url#/uploads/#document.path#">
		</cfoutput>
	</cfcase>		
	<cfcase value="application">
		<cfswitch expression="#document.content_sub_type()#">
			<cfcase value="pdf,vnd.pdf" delimiters=",">
				<cfpdf action="getInfo" source="#session.upload_path#/#document.path#" name="pdf_info">
				<cfset page_count = pdf_info.TotalPages>
				<cfpdf 	action="thumbnail" 
						source="#session.upload_path#/#document.path#"
						destination="#session.upload_path#"
						overwrite="true"
						format="jpg"
						scale="100">
				<cfset base_file_name = left(document.path, len(document.path) - 4)>
						
				<cfset has_preview = true>
				<cflayout type="tab">
					<cfloop from="1" to="#page_count#" index="page_number">
						<cflayoutarea title="Page #page_number#">
							<div style="width:100%; height:360px; overflow:auto;">
							<cfset current_file = base_file_name & "_page_" & page_number & ".jpg">
							<cfoutput>
								<img src="#session.root_url#/uploads/#current_file#">
							</cfoutput>
							</div>
						</cflayoutarea>
					</cfloop>
				</cflayout>
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfif has_preview EQ false>
	<h3>No preview available.</h3>
</cfif>