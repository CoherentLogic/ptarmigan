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
	<cfset this.cloudmade_api_key = "">
	<cfset this.mapbox_map_id = "">
	<cfset this.anonymous_only = "">
	<cfset this.minimum_zoom_level = "">
	<cfset this.maximum_zoom_level = "">
	<cfset this.initial_zoom_level = 18>
	
	<cffunction name="init" access="public" output="false" returntype="ptarmigan.system">
		<cfset ini_path = expandpath("/ptarmigan.ini")>

		<cfset this.root_url = getprofilestring(ini_path, "Network", "root_url")>		
		<cfset this.upload_path = getprofilestring(ini_path, "Network", "upload_path")>
		<cfset this.thumbnail_path = getprofilestring(ini_path, "Network", "thumbnail_path")>
		<cfset this.datasource = getprofilestring(ini_path, "Database", "datasource")>
		<cfset this.base_url = getprofilestring(ini_path, "Network", "base_url")>
		<cfset this.service = getprofilestring(ini_path, "Company", "service")>

		<cfset this.tile_provider = getprofilestring(ini_path, "GIS", "tile_provider")>		
		<cfset this.center_latitude = getprofilestring(ini_path, "GIS", "center_latitude")>
		<cfset this.center_longitude = getprofilestring(ini_path, "GIS", "center_longitude")>
		<cfif this.tile_provider EQ "cloudmade">
			<cfset this.cloudmade_api_key = getprofilestring(ini_path, "GIS", "cloudmade_api_key")>
		</cfif>
		<cfif this.tile_provider EQ "mapbox">
			<cfset this.mapbox_map_id = getprofilestring(ini_path, "GIS", "mapbox_map_id")>
		</cfif>
		<cfset this.anonymous_only = getprofilestring(ini_path, "Authentication", "anonymous_only")>
		<cfset this.minimum_zoom_level = getprofilestring(ini_path, "GIS", "minimum_zoom_level")>
		<cfset this.maximum_zoom_level = getprofilestring(ini_path, "GIS", "maximum_zoom_level")>
		<cfset this.initial_zoom_level = getprofilestring(ini_path, "GIS", "initial_zoom_level")>	
		<cfset this.geometry_minimum_zoom = getprofilestring(ini_path, "GIS", "geometry_minimum_zoom")>

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