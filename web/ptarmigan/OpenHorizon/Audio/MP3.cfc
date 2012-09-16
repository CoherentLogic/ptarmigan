<cfcomponent displayName="MP3" hint="Reads ID3 information from an MP3" output="false">

	<cfset variables.filename = "">
	<cfset variables.loaded = false>
	<cfset variables.id3tag = "">
	
	<cffunction name="init" access="public" returnType="mp3" output="false">
		<cfargument name="filename" type="string" required="false">
		
		<!--- create an instance of the java code --->
		<cfset variables.mp3 = createObject("java", "org.farng.mp3.MP3File")>

		<cfif structKeyExists(arguments, "filename")>
			<!--- read it in --->
			<cfset variables.filename = arguments.filename>
			<cfset Open(variables.filename)>			
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="checkLoaded" access="private" returnType="void" output="false"
				hint="Helper function to throw error if no mp3 loaded.">
		<cfif not variables.loaded>
			<cfthrow message="You must first read in an MP3!">
		</cfif>
	</cffunction>

	<cffunction name="AlbumTitle" access="public" returnType="string" output="false"
				hint="Returns the album title.">
		<cfreturn variables.id3tag.getAlbumTitle()>
	</cffunction>

	<cffunction name="Artist" access="public" returnType="string" output="false"
				hint="Returns the artist.">
		<cfreturn variables.id3tag.getLeadArtist()>
	</cffunction>

		
	<cffunction name="SongGenre" access="public" returnType="string" output="false"
				hint="Returns the song genre.">
		<cfreturn variables.id3tag.getSongGenre()>
	</cffunction>
	
	<cffunction name="SongTitle" access="public" returnType="string" output="false"
				hint="Returns the song title.">
		<cfreturn variables.id3tag.getSongTitle()>
	</cffunction>

	<cffunction name="TrackNumber" access="public" returnType="string" output="false"
				hint="Returns the song title.">
		<cfreturn variables.id3tag.getTrackNumberOnAlbum()>
	</cffunction>

	<cffunction name="YearReleased" access="public" returnType="string" output="false"
				hint="Returns the song's release date.">
		<cfreturn variables.id3tag.getYearReleased()>
	</cffunction>
	
	<cffunction name="hasID3V1" access="public" returnType="boolean" output="true"
				hint="Returns true if the mp3 has id3v1 information.">
		<cfset checkLoaded()>

		<cfreturn variables.mp3.hasID3v1Tag()>
	</cffunction>

	<cffunction name="hasID3V2" access="public" returnType="boolean" output="false"
				hint="Returns true if the mp3 has id3v2 information.">
		<cfset checkLoaded()>
		
		<cfreturn variables.mp3.hasID3v2Tag()>
	</cffunction>
	
	<cffunction name="Open" access="public" returnType="void" output="false">
		<cfargument name="filename" type="string" required="true">

		<!--- does the file exist? --->	
		<cfif not fileExists(arguments.fileName)>
			<cfthrow message="#arguments.fileName# does not exist.">
		</cfif>

		<!--- copy to global scope --->
		<cfset variables.filename = arguments.filename>
		
		<cftry>
			<cfset variables.mp3.init(variables.filename)>
			<cfset variables.loaded = true>
			
			<cfif hasID3V1()>
				<cfset variables.id3tag = variables.mp3.getID3v1Tag()>
			</cfif>
			<cfif hasID3V2()>
				<cfset variables.id3tag = variables.mp3.getID3v2Tag()>
			</cfif>
			
			<cfcatch>
				<cfthrow message="Invalid MP3 file: #arguments.filename# #cfcatch.message#">
			</cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>