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
			<cfcase value="pdf">
				<cfset out_file = document.path & "_THUMBNAIL.jpg">
				<cfpdf 	action="thumbnail" 
						source="#session.upload_path#/#document.path#"
						destination="#session.upload_path#"
						overwrite="true"
						format="jpg">
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfif has_preview EQ false>
	<h3>No preview available.</h3>
</cfif>