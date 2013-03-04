<cfcomponent displayname="Image" hint="Contains routines for image manipulation" extends="OpenHorizon.Framework" output="false">
	
	<cfset this.InputURL = "">
	<cfset this.URL = "">
	<cfset this.ServerPath = "">
	<cfset this.ID = "">
	<cfset this.Extension = "">
	
	<cffunction name="Silk" hint="Get a silk icon" access="remote" output="false" returntype="string">
		<cfargument name="Icon" hint="What icon to get, in plain English, i.e. door open" type="string" required="yes">
		<cfargument name="Dimension" hint="What dimension to get, 0 for no resize." type="numeric" required="yes">
		
		<cfparam name="realName" default="">
		<cfset realName = LCase(Icon)>
		<cfset realName = Replace(realName, " ", "_", "all")>
		<cfset realName = "#this.URLBase#/OpenHorizon/Resources/Graphics/Silk/" & realName & ".png">
		
		<cfreturn this.Create(realName, Dimension, Dimension)>
	</cffunction>			
	
	<cffunction name="SimpleImage" hint="Create a new image without specifying dimensions." access="remote" output="false" returntype="string">
		<cfargument name="InputURL" type="string" required="yes" hint="The URL of the image to use">
		
		<cfparam name="retval" default="">
		<cfset retval = this.Create(InputURL, 0, 0)>
		
		<cfreturn #retval#>
	</cffunction>
	
	<cffunction name="Create" hint="Create a new image from a URL" access="remote" output="false" returntype="string">
		<cfargument name="InputURL" type="string" required="yes" hint="The URL of the image">
		<cfargument name="Width" type="numeric" required="yes" hint="The desired width">
		<cfargument name="Height" type="numeric" required="yes" hint="The desired height">
		
		
		<cfquery name="qryCheckImageCache" datasource="#this.BaseDatasource#">
			SELECT * FROM images WHERE InputURL='#InputURL#' AND Width=#Width# AND Height=#Height#
		</cfquery>
		
		<cfset this.Extension = Right(InputURL, 3)>
		
		<cfif qryCheckImageCache.RecordCount GT 0>			<!---cache hit. simply return the cached image --->
			<cfset this.ID = qryCheckImageCache.ID>
			<cfset this.InputURL = qryCheckImageCache.InputURL>
			<cfset this.Width = qryCheckImageCache.Width>
			<cfset this.Height = qryCheckImageCache.Height>
			
			<cfquery name="qryULA" datasource="#this.BaseDatasource#">
				UPDATE images
				SET		LastAccess=#CreateODBCDateTime(Now())#
				WHERE	ID='#this.ID#'
			</cfquery>	
			
		<cfelse>											<!--- cache miss. create the new image, write to cache, exit--->
			<cfset this.ID = CreateUUID()>
			<cfset this.InputURL = InputURL>
			<cfset this.Width = Width>
			<cfset this.Height = Height>
			
			<cfparam name="tmpImage" default="">
			<cfset tmpImage = this.CopyLocal()>						<!--- copy the source image to the local server --->
			
            <cftry>            
				<cfimage source="#tmpImage#" name="SourceImage">			<!--- read the source image into coldfusion --->
				
                <cfcatch type="any">
					<cflog application="true" file="OpenHorizon" type="error" text="OpenHorizon.Graphics.Image: Could not thumbnail #tmpImage# (#cfcatch.message#)">
            		<cfreturn #InputURL#>
            	</cfcatch>
            </cftry>		
			<cfif this.Width GT 0 AND this.Height GT 0>				<!--- if width or height are zero, do not scale. --->
				<cfset ImageSetAntialiasing(SourceImage, "on")>		<!--- turn on antialiasing for the SourceImage and scale it--->
				<cfset ImageScaleToFit(SourceImage, this.Width, this.Height, "highestQuality")>
			</cfif>
															
			<cfparam name="NewPath" default="">						<!--- write the new image --->
			<cfset NewPath = this.ThumbnailCache & "/" & this.ID & "." & this.Extension>
			<cfimage source="#SourceImage#" action="write" destination="#NewPath#" overwrite="true">
			
			<cfquery name="qryWriteThumb" datasource="#this.BaseDatasource#">
				INSERT INTO images 
					(ID,
					InputURL,
					Width,
					Height,
					LastAccess)
				VALUES
					('#this.ID#',
					'#this.InputURL#',
					#this.Width#,
					#this.Height#,
					#CreateODBCDateTime(Now())#)
			</cfquery>
			
		</cfif>	
		
		<cfset this.URL = this.MakeURL()>
		<cfreturn #this.URL#>		
	</cffunction>
	
	
	<cffunction name="MakeURL" hint="Full URL to the image" access="public" output="false" returntype="string">
		
		<cfparam name="tmpURL" default="">
		
		<cfset tmpURL = "#this.URLBase#/OpenHorizon/Resources/Graphics/ThumbnailCache/" & this.ID & "." & this.Extension>
		<cfset this.URL = tmpURL>
		<cfreturn #this.URL#>
	</cffunction>
	
	<cffunction name="CopyLocal" hint="Copies the remote image onto the local server." access="public" output="false" returntype="string">
	
		<cfparam name="tmpName" default="">
		<cfset tmpName = this.ID & "~WRK." & this.Extension>
		
		<cfhttp url="#this.BaseHost##this.InputURL#" method="get" path="#this.ThumbnailCache#" file="#tmpName#" getasbinary="yes">
		
		<cflog application="true" file="OpenHorizon" text="CopyLocal: #cfhttp.StatusCode# #cfhttp.ErrorDetail# #this.BaseHost##this.InputURL#">

		<cfset tmpName = this.ThumbnailCache & "/" & tmpName>
		<cfreturn #tmpName#>
	</cffunction>
	
</cfcomponent>