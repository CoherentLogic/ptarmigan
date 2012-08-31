<cfcomponent output="true">

	<cfset this.center_latitude = 0>
	<cfset this.center_longitude = 0>
	<cfset this.radius = 0>
	<cfset this.parcels = ArrayNew(1)>
	
	<cffunction name="create" returntype="ptarmigan.parcels.area" access="public" output="false">
		
		<cfquery name="get_parcels" datasource="#session.company.datasource#">
			SELECT ((ACOS(SIN(#this.center_latitude# * PI() / 180) * SIN(`center_latitude` * PI() / 180) + COS(#this.center_latitude# * PI() / 180) * COS(`center_latitude` * PI() / 180) * COS((#this.center_longitude# - `center_longitude`) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS distance,
	            parcels.id 		AS parcel_id
	            FROM			parcels              
	            HAVING             distance<=#this.radius# 
	            ORDER BY    		distance 
	            ASC
		</cfquery>
		
		<cfset this.parcels = ArrayNew(1)>
		<cfoutput query="get_parcels">
			<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(get_parcels.parcel_id)>
			<cfset ArrayAppend(this.parcels, parcel)>
		</cfoutput>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_json" returntype="void" access="public" output="true">
		<cfoutput>#serializeJSON(this)#</cfoutput>
	</cffunction>

</cfcomponent>