<!--- Open Horizon ReturnValue.cfc $Revision: 1.2 $ --->
<cfcomponent displayname="ReturnValue" hint="Represents a return value from an OH function" implements="OpenHorizon.Datatypes.IDatatype">
	   
	   <cfset this.Success = false>	   
	   <cfset this.ExceptionMessage = "">
	   <cfset this.ExceptionDetail = "">
	   <cfset this.Object = "">
	   
	   <cffunction name="Create" access="public" returntype="OpenHorizon.Datatypes.ReturnValue">
	   		<cfargument name="Success" type="boolean" required="yes">
	   		<cfargument name="ExceptionMessage" type="string" required="yes">
	   		<cfargument name="ExceptionDetail" type="string" required="yes">
	   		<cfargument name="Object" type="any" required="yes">
	   		
	   		<cfset this.Success = Success>
	   		<cfset this.ExceptionMessage = ExceptionMessage>
	   		<cfset this.ExceptionDetail = ExceptionDetail>
	   		<cfset this.Object = Object>
	   		
	   		<cfreturn #this#>
	   </cffunction>
	   
	   
	   
	   <cffunction name="Stringify" returntype="string" access="public" output="no">
			<!--- TODO: implement sensible Stringify() here --->
		   	<cfreturn "String Return">
	   </cffunction>
</cfcomponent>