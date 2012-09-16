<cfcomponent displayname="MobileDevice" extends="OpenHorizon.Framework" implements="OpenHorizon.Interface.IManagedObject" hint="Mobile device support" output="no">

	<cfset this.r_pk = 0>
	<cfset this.r_id = "">
	<cfset this.phone_number = "">
	<cfset this.provider = 0>
	<cfset this.object_record = "">
	<cfset this.owner = 0>
	<cfset this.written = false>
	<cfset this.device_name = "">
	
	<cffunction name="Create" access="public" returntype="OpenHorizon.Objects.MobileDevice" output="no">
		<cfargument name="device_name" type="string" required="yes">
		<cfargument name="phone_number" type="string" required="yes">
		<cfargument name="provider" type="numeric" required="yes">
		<cfargument name="owner" type="numeric" required="yes">
		
		<cfset this.device_name = device_name>
		<cfset this.provider = provider>
		<cfset this.phone_number = phone_number>
		<cfset this.owner = owner>
		
		<cfset this.written = false>
		
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="Open" access="public" returntype="OpenHorizon.Objects.MobileDevice" output="no">
		<cfargument name="r_id" type="string" required="yes">
		
		
		<cfquery name="open" datasource="#this.BaseDatasource#">
			SELECT * FROM mobile_devices WHERE om_uuid='#r_id#'
		</cfquery>
		
		<cfset this.r_pk = open.id>
		<cfset this.r_id = r_id>
		<cfset this.provider = open.provider>
		<cfset this.phone_number = open.phone_number>
		<cfset this.owner = open.owner>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="Save" access="public" returntype="boolean" output="no">
		<cfif this.written EQ true>
			<cfset this.UpdateExistingRecord()>
		<cfelse>
			<cfset this.WriteAsNewRecord()>
		</cfif>		
		
		<cfset this.OrmsUpdate()>
		
		<cfreturn true>
	</cffunction>
	

	<cffunction name="WriteAsNewRecord" access="public" returntype="void" output="no">
		<cfquery name="wanr" datasource="#this.BaseDatasource#">
			INSERT INTO mobile_devices
				(om_uuid,
				phone_number,
				provider,
				owner)
			VALUES
				('#this.r_id#',
				'#this.phone_number#',
				#this.provider#,
				#this.owner#)
		</cfquery>
		
		<cfquery name="wanr_id" datasource="#this.BaseDatasource#">
			SELECT id FROM mobile_devices WHERE om_uuid='#this.r_id#'
		</cfquery>
		
		<cfset this.r_pk = wanr_id.id>
		<cfset this.written = true>
	</cffunction>
	

	<cffunction name="UpdateExistingRecord" access="public" returntype="void" output="no">
		<cfquery name="uer" datasource="#this.BaseDatasource#">	
			UPDATE 	mobile_devices
			SET		phone_number='#this.phone_number#',
					provider=#this.provider#,
					om_uuid='#this.r_id#',
					owner=#this.owner#
			WHERE	id=#this.r_pk#
		</cfquery>
	</cffunction>


	<cffunction name="ObjectRecord" access="public" returntype="OpenHorizon.Storage.ObjectRecord" output="no">
		<cfreturn this.object_record>
	</cffunction>
	
	<cffunction name="OrmsUpdate" access="public" returntype="boolean" output="no" hint="Tell the object to update its ORMS record">
		<cfset rt = CreateObject("component", "OpenHorizon.Storage.ObjectRecord")>
		
		<cfset rtype = "Mobile Device">
		<cfset rowner = this.owner>
		<cfset rsite = session.site.r_pk>
		<cfset rname = this.device_name>		
		<cfset rthumb = "/graphics/navicons/mobile_device.png">
		<cfset redit = "">
		<cfset rview = "">
		<cfset rdel = "">
		<cfset rpk = this.r_pk>
		<cfset rstat = "Active">
		<cfset rpar = "">												
		
		<cfset rt.Crup(rtype, rowner, rsite, rname, redit, rview, rdel, rthumb, rpk, rstat, rpar)>
		
		<cfset this.r_id = rt.r_id>
		<cfset this.object_record = rt>
		
		<cfset this.UpdateExistingRecord()>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OrmsEnumPrivateFields" access="public" returntype="array" output="no" hint="Return an array of the fields supported by this object">
		<cfparam name="tmpFields" default="">
		<cfset tmpFields = ArrayNew(1)>
		
		<cfreturn tmpFields>
	</cffunction>
	
	<cffunction name="OrmsQueryPrivateField" access="public" returntype="string" output="no" hint="Return the value of a supported field">
		<cfargument name="FieldName" type="string" required="yes">		
		
		<cfreturn "">
	</cffunction>
	
	<cffunction name="OrmsSetPrivateField" access="public" returntype="boolean" output="no" hint="Set the value of a supported field">
		<cfargument name="FieldName" type="string" required="yes">	
		<cfargument name="FieldValue" type="string" required="yes">				
	
		<cfreturn true>
	</cffunction>
	
	<cffunction name="OrmsDelete" access="public" returntype="boolean" output="no" hint="Tell the object to go delete itself">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="SetLocation" access="public" returntype="void" output="no">
		<cfargument name="location" type="OpenHorizon.Objects.GISLocation" required="yes">
		
		<cfset LocationOID = CreateUUID()>
		
		<cfquery name="sl" datasource="#this.BaseDatasource#">
			INSERT INTO gis_locations
				(device_uuid,
				provider,
				latitude,
				longitude,
				elevation,
				bearing,
				speed,
				accuracy,
				comment,
				fixtime,
				om_uuid)
			VALUES
				('#location.device_uuid#',
				'#location.provider#',
				#location.latitude#,
				#location.longitude#,
				#location.elevation#,
				#location.bearing#,
				#location.speed#,
				#location.accuracy#,
				'#location.comment#',
				#CreateODBCDateTime(Now())#,
				'#LocationOID#')
		</cfquery>		
		
		<cfset objects = this.GetLinkedObjects()>
		
		<cfloop array="#objects#" index="current_object">
			
			<cfset body_copy = location.comment & '<br/><br/><a class="button" href="javascript:ORMSViewLocation(' & "'" & #LocationOID# & "'" & ');"><span>Show Location</span></a><br/><br/>'>
			
			<cfset user = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(current_object.r_owner)>
			<cfset event = CreateObject("component", "OpenHorizon.Storage.ObjectEvent")>
			<cfset event.Create(current_object,
								user,
								"checked in",
								body_copy)>
			<cfset event.Save()>
			
		</cfloop>
		
	</cffunction>
	
	<cffunction name="GetLocation" access="public" returntype="OpenHorizon.Objects.GISLocation" output="no">
		<cfquery name="gl" datasource="#this.BaseDatasource#" maxrows="1">
			SELECT * FROM gis_locations WHERE device_uuid='#this.r_id#' ORDER BY fixtime DESC
		</cfquery>
		
		<cfset gLoc = CreateObject("component", "OpenHorizon.Objects.GISLocation")>
		
		<cfoutput query="gl">
			<cfset gLoc.Create(provider, device_uuid, comment, latitude, longitude, elevation, bearing, speed, accuracy)>
			<cfset gLoc.fixtime = fixtime>
		</cfoutput>
		
		<cfreturn gLoc>
	</cffunction>
	
	<cffunction name="LocationHistory" access="public" returntype="array" output="no">
		
		<cfquery name="lh" datasource="#this.BaseDatasource#">
			SELECT * FROM gis_locations WHERE device_uuid='#this.r_id#' ORDER BY fixtime DESC
		</cfquery>
		
		<cfset tmpHistory = ArrayNew(1)>
		<cfset gLoc = CreateObject("component", "OpenHorizon.Objects.GISLocation")>
		
		<cfoutput query="lh">
			<cfset gLoc.Create(provider, device_uuid, comment, latitude, longitude, elevation, bearing, speed, accuracy)>
			<cfset gLoc.fixtime = fixtime>
			<cfset ArrayAppend(tmpHistory, gLoc)>
		</cfoutput>
		
		<cfreturn tmpHistory>
	</cffunction>
	
	<cffunction name="GetLinkedObjects" access="public" returntype="array" output="no">
		<cfset retVal = ArrayNew(1)>
		
		<cfquery name="qryGetLinkedObjects" datasource="#this.BaseDatasource#">
			SELECT * FROM orms_relations WHERE rel_target='#this.r_id#' AND rel_type='LocationProvider'
		</cfquery>
		
		<cfoutput query="qryGetLinkedObjects">
			<cfset tmpObj = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").Get(rel_source)>
			<cfset ArrayAppend(retVal, tmpObj)>
		</cfoutput>
		
		<cfreturn retVal>
	</cffunction>
</cfcomponent>