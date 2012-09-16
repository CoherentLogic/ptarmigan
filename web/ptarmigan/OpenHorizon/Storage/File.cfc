<!---

$Id$

Copyright (C) 2011 John Willis
 
This file is part of Prefiniti.

Prefiniti is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Prefiniti is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.

--->

<cfcomponent hint="Represents an ORMS-managed file." extends="OpenHorizon.Framework">

	<cfset this.r_pk = 0>
	<cfset this.target_uuid = "">
    <cfset this.file_uuid = "">
    <cfset this.original_filename = "">
    <cfset this.file_extension = "">
    <cfset this.mime_type = "">
    <cfset this.mime_subtype = "">
    <cfset this.file_size = 0>
    <cfset this.post_date = "">
    <cfset this.poster_id = 0>
    <cfset this.poster = "">    
    <cfset this.new_filename = "">
    <cfset this.keywords = "">
    <cfset this.root_storage = this.StorageRoot>
    <cfset this.root_url = this.CMSURL>
    <cfset this.written = false>
        
	<cffunction name="Create" access="public" returntype="OpenHorizon.Storage.File">
		<cfargument name="target_uuid" type="string" required="yes">
        <cfargument name="original_filename" type="string" required="yes">
        <cfargument name="new_filename" type="string" required="yes">
        <cfargument name="file_extension" type="string" required="yes">
        <cfargument name="mime_type" type="string" required="yes">
        <cfargument name="mime_subtype" type="string" required="yes">
        <cfargument name="file_size" type="numeric" required="yes">
        <cfargument name="poster" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="keywords" type="string" required="yes">
        
        <cfset this.file_uuid = CreateUUID()>
        <cfset this.target_uuid = target_uuid>
        <cfset this.original_filename = original_filename>
        <cfset this.file_extension = file_extension>
        <cfset this.mime_type = mime_type>
        <cfset this.mime_subtype = mime_subtype>
		<cfset this.file_size = file_size>        
    	<cfset this.poster_id = poster.r_pk>  
        <cfset this.poster = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.poster_id)>  
        <cfset this.post_date = CreateODBCDateTime(Now())>
        <cfset this.new_filename = new_filename>
        <cfset this.keywords = keywords>
        		
		<cfreturn #this#>
	</cffunction>
    
    <cffunction name="FullPath" access="public" returntype="string" output="no">
    	<cfset retval = this.StorageRoot & this.PathDelimiter & this.new_filename>
        
        <cfreturn #retval#>
    </cffunction>
    
    <cffunction name="Open" access="public" returntype="OpenHorizon.Storage.File">
    	<cfargument name="file_uuid" type="string" required="yes">
        
        <cfquery name="o" datasource="#this.BaseDatasource#">
        	SELECT * FROM orms_files WHERE file_uuid='#file_uuid#'
        </cfquery>
        
        <cfset this.file_uuid = o.file_uuid>
        <cfset this.target_uuid = o.om_uuid>
        <cfset this.original_filename = o.original_filename>
        <cfset this.file_extension = o.file_extension>
        <cfset this.mime_type = o.mime_type>
        <cfset this.mime_subtype = o.mime_subtype>
        <cfset this.file_size = o.file_size>
        <cfset this.poster_id = o.poster_id>
        <cfset this.poster = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.poster_id)>
        <cfset this.post_date = o.post_date>
        <cfset this.new_filename = o.new_filename>
        <cfset this.keywords = o.keywords>
            
        <cfset this.written = true>    
       
        <cfreturn #this#>     
    </cffunction>
    
    <cffunction name="Delete" access="public" returntype="void" output="no">
    	<cffile action="delete" file="#this.FullPath()#">
        
        <cfquery name="delete_file" datasource="#this.BaseDatasource#">
        	DELETE FROM orms_files WHERE file_uuid='#this.file_uuid#'
        </cfquery>
    </cffunction>
    
    <cffunction name="URL" access="public" output="no" returntype="string">
    	<cfset ret_val = this.root_url & this.new_filename>
        
        <cfreturn #ret_val#>
    </cffunction>
    
    <!---
		<cffunction name="Create" access="public" returntype="OpenHorizon.Storage.ObjectEvent" output="no">
		<cfargument name="object_record" type="OpenHorizon.Storage.ObjectRecord" required="yes">
        <cfargument name="event_user" type="OpenHorizon.Identity.User" required="yes">
        <cfargument name="event_name" type="string" required="yes">
        <cfargument name="body_copy" type="string" required="yes">
        <cfargument name="orms_file_rec" type="OpenHorizon.Storage.File" required="no">
	--->
    
    <cffunction name="Save" access="public" output="no" returntype="void">
    	<cfif this.written>
      		<cfset this.UpdateExistingRecord()>
    	<cfelse>
      		<cfset this.WriteAsNewRecord()>
    	
			<cfset evnt = CreateObject("component", "OpenHorizon.Storage.ObjectEvent")>
            <cfset obj = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").Get(this.target_uuid)>
            
            <cfset evnt.Create(obj, this.poster, "Posted a file", this.keywords, this)>
            <cfset evnt.Save()>        	    
		</cfif>

		
        <cfset this.written = true>
  	</cffunction>
    
    <cffunction name="UpdateExistingRecord" access="public" output="no" returntype="void">
    	<cfquery name="uer" datasource="#this.BaseDatasource#">
        
        </cfquery>       
	</cffunction>
    
    <cffunction name="WriteAsNewRecord" access="public" output="no" returntype="void">
    	<cfquery name="wanr" datasource="#this.BaseDatasource#">
        	INSERT INTO orms_files
            			(om_uuid,
                        poster_id,
                        post_date,
                        original_filename,
                        new_filename,
                        file_uuid,
						mime_type,
                        mime_subtype,
                        file_size,
                        keywords,
                        file_extension)
			VALUES		('#this.target_uuid#',
            			#this.poster_id#,
                        #this.post_date#,
                        '#this.original_filename#',
                        '#this.new_filename#',
                        '#this.file_uuid#',
                        '#this.mime_type#',
                        '#this.mime_subtype#',
                        #this.file_size#,
                        '#this.keywords#',
                        '#this.file_extension#')                                                                       
        </cfquery>
        
        <cfquery name="wanr_id" datasource="#this.BaseDatasource#">
        	SELECT id FROM orms_files WHERE file_uuid='#this.file_uuid#'
        </cfquery>
        
        <cfset this.r_pk = wanr_id.id>                        
    </cffunction>
    
    <cffunction name="MIMEType" access="public" returntype="string" output="no">
    	<cfset ret_val = this.mime_type & "/" & this.mime_subtype> 
        <cfreturn #ret_val#>   
    </cffunction>
    
    <cffunction name="Datatype" access="public" returntype="string" output="no">
    	<cfset dt = CreateObject("component", "Prefiniti").Config("Datatypes", this.MIMEType())>    
	    <cfreturn #dt#>        
    </cffunction>
    
    <cffunction name="TypeIcon" returntype="struct" output="no" access="public">
    
    	
        <cfparam name="fExt" default="">
    
    	<cfset fExt = this.file_extension>
    
    	<cfparam name="ts" default="">
	    <cfset ts=StructNew()>
        
        <cfparam name="imgBase" default="">
        <cfset imgBase = "/graphics/AppIconResources/crystal_project/48x48/mimetypes/">
        <cfswitch expression="#fExt#">
            <cfcase value="PDF">
                <cfset ts.icon="#imgBase#pdf.png">
                <cfset ts.description="Adobe Acrobat PDF">
                <cfset ts.code="PDF">
            </cfcase>
            <cfcase value="DWG">
                <cfset ts.icon="#imgBase#vectorgfx.png">
                <cfset ts.description="AutoCAD Drawing">
                <cfset ts.code="DWG">
            </cfcase>
            <cfcase value="PFN">
                <cfset ts.icon="/graphics/map.png">
                <cfset ts.description="Field Point Data">
                <cfset ts.code="PFN">
            </cfcase>
            <cfcase value="JPG">
                <cfset ts.icon="#imgBase#image.png">
                <cfset ts.description="JPEG Image">
                <cfset ts.code="JPG">
            </cfcase>
            <cfcase value="PEG">
                <cfset ts.icon="#imgBase#image.png">
                <cfset ts.description="JPEG Image">
                <cfset ts.code="JPG">
            </cfcase>
            <cfcase value="PNG">
                <cfset ts.icon="#imgBase#image.png">
                <cfset ts.description="PNG Image">
                <cfset ts.code="PNG">
            </cfcase>
            <cfcase value="GIF">
                <cfset ts.icon="#imgBase#image.png">
                <cfset ts.description="GIF Image">
                <cfset ts.code="GIF">
            </cfcase>
            <cfcase value="BMP">
                <cfset ts.icon="#imgBase#image.png">
                <cfset ts.description="Windows Bitmap Image">
                <cfset ts.code="BMP">
            </cfcase>                
            <cfcase value="HTM">
                <cfset ts.icon="#imgBase#html.png">
                <cfset ts.description="HTML Code">
                <cfset ts.code="HTM">        
            </cfcase>
            <cfcase value="TML">            
                <cfset ts.icon="/graphics/page_white_code.png">
                <cfset ts.description="HTML Code">
                <cfset ts.code="HTM">
            </cfcase>
            <cfcase value="CFM">
                <cfset ts.icon="/graphics/page_white_coldfusion.png">
                <cfset ts.description="Adobe ColdFusion Code">
                <cfset ts.code="CFM">
            </cfcase>
            <cfcase value="DOC">
                <cfset ts.icon="#imgBase#wordprocessing.png">
                <cfset ts.description="Microsoft Word Document">
                <cfset ts.code="DOC">
            </cfcase>
            <cfcase value="XML">
                <cfset ts.icon="/graphics/page_white_code.png">
                <cfset ts.description="XML Data">
                <cfset ts.code="XML">
            </cfcase>
            <cfcase value="ZIP">
                <cfset ts.icon="#imgBase#zip.png">
                <cfset ts.description="ZIP Archive">
                <cfset ts.code="ZIP">
            </cfcase>
            <cfcase value="TXT">
                <cfset ts.icon="#imgBase#txt.png">
                <cfset ts.description="Plain Text Document">
                <cfset ts.code="TXT">
            </cfcase>
            <cfcase value="MP3">
                <cfset ts.icon="#imgBase#sound.png">
                <cfset ts.description="MPEG Audio Layer 3">
                <cfset ts.code="TXT">
            </cfcase>    
            <cfcase value="TIF">
                <cfset ts.icon="#imgBase#image.png">
                <cfset ts.description="Tagged Image File Format Image">
                <cfset ts.code="TIF">
            </cfcase>  
            
            <cfdefaultcase>
                <cfset ts.icon="#imgBase#unknown.png">
                    <cfset ts.description="Unknown Type">
                <cfset ts.code=fExt>           
            </cfdefaultcase>            
        </cfswitch>
        
        <cfreturn #ts#>
	</cffunction>
    
</cfcomponent>