<cfinterface hint="Defines the interface that ORMS-managed objects should implement.">
	<cffunction name="ObjectRecord" returntype="OpenHorizon.Storage.ObjectRecord" access="public" output="no" hint="Returns the object record"/>
	<cffunction name="OrmsUpdate" access="public" returntype="boolean" output="no" hint="Tell the object to update its ORMS record"/>
	<cffunction name="OrmsEnumPrivateFields" access="public" returntype="array" output="no" hint="Return an array of the fields supported by this object"/>
	<cffunction name="OrmsQueryPrivateField" access="public" returntype="string" output="no" hint="Return the value of a supported field">
		<cfargument name="FieldName" type="string" required="yes">		
	</cffunction>
	<cffunction name="OrmsSetPrivateField" access="public" returntype="boolean" output="no" hint="Set the value of a supported field">
		<cfargument name="FieldName" type="string" required="yes">	
		<cfargument name="FieldValue" type="string" required="yes">				
	</cffunction>
	<cffunction name="OrmsDelete" access="public" returntype="boolean" output="no" hint="Tell the object to go delete itself"/>
</cfinterface>