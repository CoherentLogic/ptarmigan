<cfcomponent output="false" implements="iMumpsConnector">
	<cfset this.connector = "">
	<cfset this.component = "lib.cfmumps.mcGtmMWire">
	<cfset this.connector = createObject("component", this.component)>

	<cffunction name="open" returntype="component" access="public" output="false">
		<cfset this.connector.open()>
		<cfreturn this>
	</cffunction>

	<cffunction name="isOpen" returntype="boolean" access="public" output="false">
		<cfreturn this.connector.isOpen()>
	</cffunction>

	<cffunction name="close" returntype="component" access="public" output="false">
		<cfreturn this.connector.close()>
	</cffunction>

	<cffunction name="set" returntype="void" access="public" output="false"
				description="Sets the value of a MUMPS global node"
				hint="Sets the value of a MUMPS global node">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be set">
		<cfargument name="subscripts" type="array" required="true" hint="Array of subscripts">
		<cfargument name="value" type="string" required="true" hint="Value to set">

		<cfset this.connector.set(globalName, subscripts, value)>

		<cfreturn>
	</cffunction>

	<cffunction name="get" returntype="any" access="public" output="false"
				description="Retrieves the value of a GT.M global node"
				hint="Retrieves the value of a GT.M global node">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">

		<cfreturn this.connector.get(globalName, subscripts)>
	</cffunction>

	<cffunction name="kill" returntype="void" access="public" output="false"
				description="Deletes a MUMPS global node"
				hint="Deletes a MUMPS global node">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset this.connector.kill(globalName, subscripts)>
		
		<cfreturn>
	</cffunction>

	<cffunction name="data" returntype="struct" access="public" output="false"
				description="Determines whether a global node exists and/or has child nodes or data">				
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">

		<cfreturn this.connector.data(globalName, subscripts)>
	</cffunction>

	<cffunction name="order" returntype="struct" access="public" output="false"
				description="Obtain the next value of the specified global subscript">				
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">

		<cfreturn this.connector.order(globalName, subscripts)>
	</cffunction>

	<cffunction name="query" returntype="struct" access="public" output="false"
				description="Returns the next global reference following the one specified"
				hint="Returns the next global reference following the one specified">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">

		<cfreturn this.connector.query(globalName, subscripts)>
	</cffunction>

	<cffunction name="lock" returntype="boolean" access="public" output="false"
				description="Locks a MUMPS global reference">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be locked">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">

		<cfreturn this.connector.lock(globalName, subscripts)>
	</cffunction>

	<cffunction name="unlock" returntype="void" access="public" output="false"
				description="Unlocks a MUMPS global reference">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be unlocked">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">

		<cfset this.connector.unlock(globalName, subscripts)>

		<cfreturn>
	</cffunction>

	<cffunction name="mFunction" returntype="any" access="public" output="false">
		<cfargument name="fn" type="string" required="true">
		
		<cfreturn this.connector.mFunction(fn)>
	</cffunction>

	<cffunction name="mVersion" returntype="string" access="public" output="false"
		    description="Return the version of MUMPS">

		<cfreturn this.connector.mVersion()>
	</cffunction>

</cfcomponent>
