<cfcomponent implements="OpenHorizon.Datatypes.IDatatype" extends="OpenHorizon.Framework">
	<cffunction name="Render" access="public" output="yes" returntype="void">
    	<cfargument name="turl" type="string" required="yes">
        <cfargument name="fpath" type="string" required="yes">
        <cfargument name="width" type="numeric" required="yes">
        <cfargument name="height" type="numeric" required="yes">        
        
        <cfmodule template="/OpenHorizon/Datatypes/datatype_image/preview_image.cfm" turl="#turl#" width="#width#" height="#height#">
        
    </cffunction>
</cfcomponent>