<cfcomponent extends="OpenHorizon.Framework" output="false">
	
	<cfset this.provider = "">
	<cfset this.device_uuid = "">
	<cfset this.latitude = 0>
	<cfset this.longitude = 0>
	<cfset this.elevation = 0>
	<cfset this.bearing = 0>
	<cfset this.speed = 0>
	<cfset this.accuracy = 0>
	<cfset this.comment = "">
	<cfset this.fixtime = "">
	<cfset this.r_id = "">
	<cfset this.written = false>
	
	<cffunction name="Create" access="public" returntype="OpenHorizon.Objects.GISLocation" output="no">
		<cfargument name="provider" type="string" required="yes">
		<cfargument name="device_uuid" typ2e="string" required="yes">
		<cfargument name="comment" type="string" required="yes">
		<cfargument name="latitude" type="numeric" required="yes">
		<cfargument name="longitude" type="numeric" required="yes">
		<cfargument name="elevation" type="numeric" required="yes">
		<cfargument name="bearing" type="numeric" required="yes">
		<cfargument name="speed" type="numeric" required="yes">
		<cfargument name="accuracy" type="numeric" required="yes">

		<cfset this.provider = provider>
		<cfset this.device_uuid = device_uuid>
		<cfset this.comment = comment>
		<cfset this.latitude = latitude>
		<cfset this.longitude = longitude>
		<cfset this.elevation = elevation>
		<cfset this.bearing = bearing>
		<cfset this.speed = speed>
		<cfset this.accuracy = accuracy>
		<cfset this.r_id = CreateUUID()>
		<cfset this.written = false>
						
		<cfreturn this>
	</cffunction>
	
	<cffunction name="Open" access="public" returntype="OpenHorizon.Objects.GISLocation" output="no">
		<cfargument name="location_id" type="string" required="yes">
	
		<cfquery name="qryOpen" datasource="#this.BaseDatasource#">
			SELECT * FROM gis_locations WHERE om_uuid='#location_id#'
		</cfquery>
		
		<cfset this.provider = qryOpen.provider>
		<cfset this.device_uuid = qryOpen.device_uuid>
		<cfset this.comment = qryOpen.comment>
		<cfset this.latitude = qryOpen.latitude>
		<cfset this.longitude = qryOpen.longitude>
		<cfset this.elevation = qryOpen.elevation>
		<cfset this.bearing = qryOpen.bearing>
		<cfset this.speed = qryOpen.speed>
		<cfset this.accuracy = qryOpen.accuracy>
		
		<cfset this.r_id = qryOpen.om_uuid>
		<cfset this.written = true>
		
		<cfreturn this>		
	</cffunction>
	
	

</cfcomponent>