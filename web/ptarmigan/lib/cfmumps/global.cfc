<!---
    cfmumps CFML to GT.M adaptor
     Copyright (C) 2014 Coherent Logic Development LLC
--->
<cfcomponent output="false">
	<cfset this.globalName = "">
	<cfset this.subscripts = "">

	<cffunction name="open" returntype="lib.cfmumps.global" access="public" output="false">
		<cfargument name="globalName" type="string" required="true">
		<cfargument name="subscripts" type="array" required="true">
			
		<cfset this.globalName = arguments.globalName>
		<cfif arrayLen(arguments.subscripts) GT 0>
			<cfset this.subscripts = arguments.subscripts>
		<cfelse>
			<cfset this.subscripts = []>
		</cfif>

		<cfset this.db = createObject("component", "lib.cfmumps.mumps")>

		<cfreturn this>
	</cffunction>

	<cffunction name="value" returntype="any" access="public" output="false">
		<cfargument name="newValue" type="string" required="false">

		<cfif isDefined("arguments.newValue")>
			<cfset this.db.open()>
			<cfset this.db.set(this.globalName, this.subscripts, arguments.newValue)>
			<cfset retVal = this.db.get(this.globalName, this.subscripts)>
			<cfset this.db.close()>
		<cfelse>
			<cfset this.db.open()>
			<cfset retVal = this.db.get(this.globalName, this.subscripts)>
			<cfset this.db.close()>
		</cfif>
		
		<cfreturn retVal>
	</cffunction>
	
	<cffunction name="defined" returntype="struct" access="public" output="false">
		<cfset this.db.open()>
		<cfset retVal = this.db.data(this.globalName, this.subscripts)>
		<cfset this.db.close()>

		<cfreturn retVal>
	</cffunction>

	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfset this.db.open()>
		<cfset this.db.kill(this.globalName, this.subscripts)>
		<cfset this.db.close()>
	</cffunction>

	<cffunction name="setObject" returntype="void" access="public" output="true">
		<cfargument name="inputStruct" type="any" required="true">
		<cfargument name="subscripts" type="array" required="false">

		<cfif isDefined("arguments.subscripts")>
			<cfset subs = duplicate(arguments.subscripts)>
		<cfelse>
			<cfset subs = duplicate(this.subscripts)>
		</cfif>

		<cfif isStruct(arguments.inputStruct)>
			<cfset keyList = structKeyList(arguments.inputStruct)>
			<cfset keyArray = listToArray(keyList)>

			<cfloop array="#keyArray#" index="key">
				<cfset subs.append(key)>

				<cfif isStruct(arguments.inputStruct[key]) OR isArray(arguments.inputStruct[key])>				
					<cfset this.setObject(arguments.inputStruct[key], subs)>
				<cfelse>
					<cfset this.db.open()>
					<cfset this.db.set(this.globalName, subs, arguments.inputStruct[key])>
					<cfset this.db.close()>
				</cfif>			
			
				<cfset subs.deleteAt(subs.len())>
			</cfloop>		
		<cfelseif isArray(arguments.inputStruct)>
			<cfloop from="1" to="#arrayLen(arguments.inputStruct)#" index="index">
				<cfset subs.append(index)>
					
				<cfif isStruct(arguments.inputStruct[index]) OR isArray(arguments.inputStruct[index])>
					<cfset this.setObject(arguments.inputStruct[index], subs)>
				<cfelse>
					<cfset this.db.open()>
					<cfset this.db.set(this.globalName, subs, arguments.inputStruct[index])>
					<cfset this.db.close()>
				</cfif>
			
				<cfset subs.deleteAt(subs.len())>
			</cfloop>			
		</cfif>	
	</cffunction>

	<cffunction name="getObject" returntype="struct" access="public" output="true">
		<cfargument name="subscripts" type="array" required="false">
		<cfargument name="outputStruct" type="struct" required="false">

		<cfif isDefined("arguments.subscripts")>
			<cfset var mSubscripts = duplicate(arguments.subscripts)>
		<cfelse>
			<cfset var mSubscripts = duplicate(this.subscripts)>
		</cfif>
		
		<cfif NOT isDefined("arguments.outputStruct")>
			<cfset var outStruct = {}>
		<cfelse>
			<cfset var outStruct = duplicate(arguments.outputStruct)>			
		</cfif>
		

		<cfset var lastResult = false>
		<cfset var mSubscripts.append("")>

		<cfif this.db.isOpen() EQ false>
			<cfset this.db.open()>
		</cfif>


		<cfloop condition="lastResult EQ false">		
			<cfset var order = this.db.order(this.globalName, mSubscripts)>
			<cfset var lastResult = order.lastResult>

			<cfif lastResult>
				<cfcontinue>
			</cfif>

			<cfset var mSubscripts.deleteAt(mSubscripts.len())>
			<cfset var mSubscripts.append(order.value)>
			<cfset structSubs = mSubscripts.slice(this.subscripts.len()+1, mSubscripts.len() - this.subscripts.len())>

			<cfset var data = this.db.data(this.globalName, mSubscripts)>

			<cfif data.hasData AND data.hasSubscripts>				
				<cfset assignment = "outStruct">
				<cfloop array="#structSubs#" index="elem">
					<cfif isNumeric(elem)>
						<cfset assignment &= "[" & elem & "]">
					<cfelse>
						<cfset assignment &= "['" & elem & "']"> 
					</cfif>
				</cfloop>

				<cfset "#assignment#['']" = this.db.get(this.globalName, mSubscripts)> 
				<cfset outStruct.append(this.getObject(mSubscripts, outStruct))>
			<cfelseif data.hasSubscripts AND NOT data.hasData>
				<cfset outStruct.append(this.getObject(mSubscripts, outStruct))>
			<cfelseif data.hasData AND NOT data.hasSubscripts>
				<cfset assignment = "outStruct">
				<cfloop array="#structSubs#" index="elem">
					<cfif isNumeric(elem)>
						<cfset assignment &= "[" & elem & "]">
					<cfelse>
						<cfset assignment &= "['" & elem & "']">
					</cfif>
				</cfloop>

				<cfset "#assignment#" = this.db.get(this.globalName, mSubscripts)>			
			</cfif>

		</cfloop>

		<cfreturn outStruct>
	</cffunction>

</cfcomponent>


