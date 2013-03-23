<cfcomponent output="true">

	<cfset this.nw_latitude = 0>
	<cfset this.nw_longitude = 0>
	<cfset this.se_latitude = 0>
	<cfset this.se_longitude = 0>
	
	<cfset this.query_time = 0>
	<cfset this.instantiation_time = 0>
	
	<cfset this.parcels = ArrayNew(1)>
	
	<cffunction name="create" returntype="parcels.area" access="public" output="false">
		
		
		
		
		
		<cfquery name="get_parcels" datasource="#session.company.datasource#">
			SELECT id FROM parcels 
			WHERE MBRWITHIN(center, GeomFromText('MULTIPOINT(#this.nw_latitude# #this.nw_longitude#, #this.se_latitude# #this.se_longitude#)'))		
		</cfquery>
		
		<cfset this.query_time = cfquery.ExecutionTime>
		
		<cfset this.parcels = ArrayNew(1)>
		<cfoutput query="get_parcels">
			<cfset parcel = CreateObject("component", "ptarmigan.parcel").open(get_parcels.id)>
			<cfset ArrayAppend(this.parcels, parcel)>
		</cfoutput>
		
		
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get_json" returntype="void" access="public" output="true">
		<cfoutput>#serializeJSON(this)#</cfoutput>
	</cffunction>

</cfcomponent>

		<!--->	SELECT ((ACOS(SIN(#this.center_latitude# * PI() / 180) * SIN(`center_latitude` * PI() / 180) + COS(#this.center_latitude# * PI() / 180) * COS(`center_latitude` * PI() / 180) * COS((#this.center_longitude# - `center_longitude`) * PI() / 180)) * 180 / PI()) * 60 * 1.1515) AS distance,
	            parcels.id 		AS parcel_id
	            FROM			parcels              
			WHERE			parcels.center_latitude!=0
			AND				parcels.center_longitude!=0
	            HAVING             distance<=#this.radius# 			
	            ORDER BY    		distance 
	            ASC--->
