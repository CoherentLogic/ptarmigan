<!--- Open Horizon IApplication.cfc $Revision: 1.2 $ --->
<cfinterface displayname="IApplication" hint="The base interface for OH applications. All OH applications must implement this interface.">
	<cffunction name="EnumDatatypes" access="public" returntype="any" hint="Return an enumeration of all datatypes handled by this application.">
    </cffunction>
    
    <cffunction name="EnumEntryPoints" access="public" returntype="any" hint="Return an enumeration of all entry points defined by this application.">
    </cffunction>
    
    <cffunction name="EnumRecentDocuments" access="public" returntype="any" hint="Return an enumeration of documents recently accessed by this application." >
    </cffunction>
    
    <cffunction name="EnumRequiredPermissions" access="public" returntype="any" hint="Return an enumeration of all the permissions this application requires in order to function.">
    </cffunction>
    
    <cffunction name="EntryPoint" access="public" returntype="void" hint="Return the specified entry point into this application.">
    </cffunction>
</cfinterface>