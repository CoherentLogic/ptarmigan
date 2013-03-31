<cfcomponent output="false">
	<cfset this.root_url = "">
	<cfset this.upload_path = "">
	<cfset this.thumbnail_path = "">
	<cfset this.thumbnail_cache = "">
	<cfset this.datasource = "">	
	<cfset this.base_url = "">
	
	<cfset this.projects = false>
	<cfset this.documents = false>
	<cfset this.customers = false>
	<cfset this.parcels = false>
	
	<cfset this.center_latitude = "">
	<cfset this.center_longitude = "">
	
	<cffunction name="init" access="public" output="false" returntype="ptarmigan.system">
		<cfset ini_path = expandpath("/ptarmigan.ini")>

		<cfset this.root_url = getprofilestring(ini_path, "Network", "root_url")>		
		<cfset this.upload_path = getprofilestring(ini_path, "Network", "upload_path")>
		<cfset this.thumbnail_path = getprofilestring(ini_path, "Network", "thumbnail_path")>
		<cfset this.datasource = getprofilestring(ini_path, "Database", "datasource")>
		<cfset this.base_url = getprofilestring(ini_path, "Network", "base_url")>
		<cfset this.service = getprofilestring(ini_path, "Company", "service")>
		
		<cfset this.center_latitude = getprofilestring(ini_path, "Company", "center_latitude")>
		<cfset this.center_longitude = getprofilestring(ini_path, "Company", "center_longitude")>
		
		<cfset session.root_url = this.root_url>
		<cfset session.upload_path = this.upload_path>
		<cfset session.thumbnail_path = this.thumbnail_path>
		<cfset this.thumbnail_cache = this.thumbnail_path>
		<cfset session.datasource = this.datasource>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="service_check" access="public" output="false" returntype="boolean">
		<cfargument name="service_code" type="numeric" required="true">
		
		<cfif bitand(this.service, service_code)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	
	</cffunction>
</cfcomponent>