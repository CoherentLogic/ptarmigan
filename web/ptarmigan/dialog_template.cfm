<cfif IsDefined("form.self_post")>
	
	<!---
	TODO: Add submit action here
	--->
	
	<cflocation url="#session.root_url#/dashboard.cfm" addtoken="false">
<cfelse>
	<div style="position:relative; height:100%; width:100%; background-color:white;">
		<cfmodule template="#session.root_url#/utilities/dialog_header.cfm" caption="Dialog Caption" icon="#session.root_url#/images/project_dialog.png">
	
		<cfform name="form_name" id="form_id" action="#session.root_url#/***ACTION***" method="post">
			<div style="padding:20px;">
				<!--- 
				TODO: Add form controls here
				--->
			</div>
			<input type="hidden" name="self_post" id="self_post" value="">
		</cfform>
		
		<div style="position:absolute; bottom:0px; border-top:1px solid #c0c0c0; width:100%; height:45px; background-color:#efefef;">
	    	<div style="padding:8px; float:right;">
	        	<a class="button" href="##" onclick="window.location.reload();"><span>Cancel</span></a>			
				<a class="button" href="##" onclick="form_submit('form_id');"><span>Apply</span></a>
			</div>
		</div>
	</div>
</cfif>