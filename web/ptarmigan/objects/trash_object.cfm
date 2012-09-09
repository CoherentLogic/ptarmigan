<cfset obj = CreateObject("component", "ptarmigan.object").open(url.id)>
<cfif IsDefined("form.self_post")>
	
	<cfset trashcan_handle = obj.get_trashcan_handle()>
	<cfset obj.mark_deleted(trashcan_handle)>
	
	<cflocation url="#session.root_url#/dashboard.cfm" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Move to trash" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="move_to_trash" id="move_to_trash" action="#session.root_url#/objects/trash_object.cfm?id=#url.id#" method="post">
			<div style="padding:20px;">				
				<p>Are you really sure you want to move <strong><cfoutput>#obj.get().object_name()#</cfoutput></strong>, which is a <strong><cfoutput>#obj.class_name#</cfoutput></strong>, to the trash can?</p>
				<br>
				<p>This action can be undone if you change your mind later.</p>
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>No</span></a>			
				<a class="button" href="##" onclick="form_submit('move_to_trash');"><span>Yes</span></a>
			</div>
		</div>
	</div>
</cfif>