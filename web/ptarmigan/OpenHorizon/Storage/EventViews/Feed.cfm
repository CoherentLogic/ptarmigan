<cfset event = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").OpenByPK(attributes.r_pk)>

<style type="text/css">
	.FeedView td {
		font-size:12px;
		font-family:"Segoe UI", Tahoma, Verdana, Arial, Helvetica, sans-serif;
	}
	
	.FeedView td p {
		font-size:12px;
		font-family:"Segoe UI", Tahoma, Verdana, Arial, Helvetica, sans-serif;
	}
	
	.EventComment {
		background-color:#efefef; 
		width:350px; 
		padding:5px;
		margin-bottom:2px;		
	}
	
	.EventComment input {
		width:330px;
		padding:5px;
		border:1px solid #999999;
	}
</style>

<cfset event_comments = event.Comments(1, 500)>

<div class="FeedView">
<cfoutput>
<table>
	<tr>
    	<td valign="top" style="width:64px;">        
			<img src="#event.event_user.Picture(64, 64)#" />         
		</td>
        <td>
        	<span class="LandingHeaderText">#event.event_user.display_name# #LCase(event.event_name)#</span><br>
            <cfif event.body_copy NEQ "">
            	<p>#event.body_copy#</p>
            </cfif>
            <cfif event.file_uuid NEQ "NO FILE">
            	<div style="margin-left:10px; margin-top:30px; margin-bottom:10px;">
            	<cfset f = CreateObject("component", "OpenHorizon.Storage.File").Open(event.file_uuid)>				
                <cfif f.Datatype() EQ "">
                    <span style="color:black; font-size:12px;">No Preview Available<br />(#f.MIMEType()#)</span>
                <cfelse>    
                    <cfset data_type = CreateObject("component", f.Datatype()).Render(f.URL(), f.FullPath(), 220, 220)>
                </cfif>
                </div>
            </cfif>
            
            <span style="font-size:9px; color:##999999;">Posted #DateFormat(event.event_date, "long")# #TimeFormat(event.event_date, "h:mm tt")#            
            &nbsp;<img src="/graphics/comment_add.png" align="absmiddle" onclick="showDivBlock('event_comment_box_#event.r_pk#'); showDivBlock('all_comments_#event.r_pk#');"></span><br>
            
            <div class="EventComment" id="event_comment_box_#event.r_pk#" style="display:none;">
            	<input 	type="text" 
                		id="event_comment_#event.r_pk#" 
                        name="event_comment_#event.r_pk#"
                        onkeypress="ORMSPostEventComment(event, '#event.r_pk#');">
            </div>
            
            <div id="new_comment_#event.r_pk#" class="EventComment" style="display:none;">
            
            </div>
            
            <div id="all_comments_#event.r_pk#">
            <cfloop array="#event_comments#" index="ec">
            	<div id="event_comment_#ec.r_pk#" class="EventComment">
                	<strong>#ec.user.display_name#</strong> - #ec.body_copy#
                </div>
            </cfloop>
            </div>
            
        </td>
	</tr>
</table>       
</cfoutput>
</div>