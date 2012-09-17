<cfcomponent implements="ptarmigan.OpenHorizon.Datatypes.IDatatype" extends="ptarmigan.OpenHorizon.Framework">
	<cffunction name="Render" access="public" output="yes" returntype="void">
    	<cfargument name="turl" type="string" required="yes">
       	<cfargument name="fpath" type="string" required="yes">
        <cfargument name="width" type="numeric" required="yes">
        <cfargument name="height" type="numeric" required="yes">        
        
        <cfmodule template="/OpenHorizon/Datatypes/datatype_mpegaudio/preview_mpegaudio.cfm" turl="#turl#" fpath="#fpath#" width="#width#" height="#height#">
        
    </cffunction>
</cfcomponent>