<cfcomponent output="false">
	<cfset this.root_url = "">
	<cfset this.upload_path = "">
	<cfset this.thumbnail_path = "">
	<cfset this.thumbnail_cache = "">
	<cfset this.datasource = "">
	<cfset this.base_url = "">
	
	<cffunction name="init" access="public" output="false" returntype="ptarmigan.system">
		<cfset ini_path = expandpath("/ptarmigan.ini")>

		<cfset this.root_url = getprofilestring(ini_path, "Network", "root_url")>		
		<cfset this.upload_path = getprofilestring(ini_path, "Network", "upload_path")>
		<cfset this.thumbnail_path = getprofilestring(ini_path, "Network", "thumbnail_path")>
		<cfset this.datasource = getprofilestring(ini_path, "Database", "datasource")>
		<cfset this.base_url = getprofilestring(ini_path, "Network", "base_url")>
		
		<cfset session.root_url = this.root_url>
		<cfset session.upload_path = this.upload_path>
		<cfset session.thumbnail_path = this.thumbnail_path>
		<cfset this.thumbnail_cache = this.thumbnail_path>
		<cfset session.datasource = this.datasource>
		
		<cfreturn this>
	</cffunction>
</cfcomponent>