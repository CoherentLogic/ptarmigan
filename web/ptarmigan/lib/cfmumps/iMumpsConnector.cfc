<cfinterface>
	<cffunction name="open" returntype="component" access="public" output="false"/>
	<cffunction name="isOpen" returntype="boolean" access="public" output="false"/>
	<cffunction name="close" returntype="component" access="public" output="false"/>
	<cffunction name="set" returntype="void" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="true">
		<cfargument name="value" type="string" required="true">
	</cffunction>
	<cffunction name="get" returntype="any" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="false">
	</cffunction>
	<cffunction name="kill" returntype="void" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="false">
	</cffunction>
	<cffunction name="data" returntype="struct" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="false">
	</cffunction>
	<cffunction name="order" returntype="struct" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="false">
	</cffunction>
	<cffunction name="lock" returntype="boolean" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="false">
	</cffunction>
	<cffunction name="unlock" returntype="void" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="false">
	</cffunction>
	<cffunction name="mVersion" returntype="string" access="public" output="false"/>
	<cffunction name="mFunction" returntype="any" access="public" output="false">
		<cfargument name="fn" type="string" required="true">
	</cffunction>
</cfinterface>
