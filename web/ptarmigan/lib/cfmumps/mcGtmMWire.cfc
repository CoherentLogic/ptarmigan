<!---
    cfmumps CFML to GT.M adaptor
     Copyright (C) 2014 Coherent Logic Development LLC
--->
<cfcomponent output="false" implements="iMumpsConnector">
	<cfset this.host = "localhost">
	<cfset this.port = 6330>	<!--- The mwire service employs a default port of 6330 --->
	<cfset this.password = "">
	<cfset this.secure = false>
	<cfset this.authenticated = false>
	<cfset this.pIsOpen = false>
	<cfset this.logLevel = 0>

	<cffunction name="open" returntype="component" access="public" output="false">

		<cfif this.pIsOpen>
			<cfreturn this>
		</cfif>

		<cfset this.socket = createObject("component", "lib.tcpSocket")>
		<cfset this.socket.open(this.host, this.port)>
		
		<cfif this.secure>
			<cfset this.socket.send("AUTH #this.password#")>
			<cfif this.socket.success>
				<cfset authReply = this.socket.read()>
				<cfif authReply.success>
					<cfset statusCode = left(authReply.response, 1)>
					<cfset statusMessage = mid(authReply.response, 2)>
					
					<cfif statusCode EQ "-">					
						<cfset resp.lines = 1>
						<cfset resp.type = "errorMessage">
						<cfset resp.message = statusMessage>
						<cfset resp.bytes = len(statusMessage)>
						<cfset resp.success = false>
					</cfif>
					<cfif statusCode EQ "+">
						<cfset resp.lines = 1>
						<cfset resp.type = "success">
						<cfset resp.message = statusMessage>
						<cfset resp.bytes = len(statusMessage)>
						<cfset resp.success = true>											
						<cfset this.authenticated = true>
					</cfif>					
				<cfelse>
					<cfset resp.success = false>					
				</cfif>				
			<cfelse>
				<cfset resp.success = false>
			</cfif>
		<cfelse>
			<cfset this.authenticated = true>
		</cfif>

		<cfset this.pIsOpen = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="close" returntype="component" access="public" output="false">
		<cfset this.authenticated = false>
		<cfset this.socket.close()>

		<cfset this.pIsOpen = false>

		<cfreturn this>
	</cffunction>

	<cffunction name="isOpen" returntype="boolean" access="public" output="false">
		<cfreturn this.pIsOpen>
	</cffunction>
	
	<cffunction name="sendMWire" returntype="struct" access="public" output="false"
				description="Sends M/Wire protocol messages and decodes the response">
		<cfargument name="message" type="string" required="true">
		<cfargument name="messageAddendum" type="string" required="false">


		<cfif this.logLevel GE 3>
			<cflog text="m/wire commmand: #message#" file="mcGtmMWire" type="Information">
		</cfif>
		
		<cfset var resp = structNew()>
		
		<cfset var resp.lines = "">
		<cfset var resp.type = "">
		<cfset var resp.message = "">
		<cfset var resp.bytes = 0>
		<cfset var resp.success = true>
		<cfset var resp.data = "">
		<cfset var resp.dataType = "">				
	
		<cfif this.authenticated>
			<cfif isDefined("arguments.messageAddendum")>
				<cfset fullMsg = arguments.message & chr(13) & chr(10) & arguments.messageAddendum>
			<cfelse>
				<cfset fullMsg = arguments.message>
			</cfif>
			<cfset this.socket.send(fullMsg)>
			
			
			<cfif find(" ", arguments.message)>
				<cfset mWireCommand = rtrim(left(arguments.message, find(" ", arguments.message)))>
			<cfelse>
				<cfset mWireCommand = trim(arguments.message)>
			</cfif>
			
			<cfswitch expression="#mWireCommand#">
				<cfcase value="SET">
					<cfset this.socket.read()>
					<cfset resp.data = "">
					<cfset resp.success = true>
				</cfcase>
				<cfcase value="GET">
					<cfset this.socket.read()>
					<cfset firstLine = this.socket.response>
					<cfset resp.data = firstLine>
					<cfset numBytes = int(mid(firstLine, 2))>	
					
					<cfif numBytes EQ -1>
						<cfset resp.defined = false>
					<cfelse>
						<cfset resp.defined = true>
					</cfif>

					<cfif numBytes GT 0>											
						<cfset this.socket.read()>
						<cfset resp.success = true>
						<cfset resp.data = this.socket.response>
					<cfelse>
						<cfset this.socket.read()>
						<cfset resp.data = "">
					</cfif>	
				</cfcase>
				<cfcase value="KILL">
					<cfset this.socket.read()>
					<cfset resp.data = "">
					<cfset resp.success = true>
				</cfcase>
				<cfcase value="DATA">
					<cfset resp.data = structNew()>
					
					<cfset this.socket.read()>
					<cfset defined = mid(this.socket.response, 2)>

					<cfswitch expression="#defined#">
						<cfcase value="0">
							<cfset resp.data.defined = false>
							<cfset resp.data.hasData = false>
							<cfset resp.data.hasSubscripts = false>
						</cfcase>
						<cfcase value="1">
							<cfset resp.data.defined = true>
							<cfset resp.data.hasData = true>
							<cfset resp.data.hasSubscripts = false>						
						</cfcase>
						<cfcase value="10">
							<cfset resp.data.defined = true>
							<cfset resp.data.hasData = false>
							<cfset resp.data.hasSubscripts = true>
						</cfcase>
						<cfcase value="11">
							<cfset resp.data.defined = true>
							<cfset resp.data.hasData = true>
							<cfset resp.data.hasSubscripts = true>			
						</cfcase>
						<cfdefaultcase>
							<cfthrow type="mwire"
								 message="DATA received an invalid response"
								 errorCode="DATA_INVALID"
								 extendedInfo="Response Received: #this.socket.response#"
								 detail="M/Wire command: '#arguments.message#'">			 
						</cfdefaultcase>
					</cfswitch>				
				</cfcase>
				<cfcase value="ORDER">					
					<cfset this.socket.read()>					
					<cfset defined = mid(this.socket.response, 2)>									
					
					<cfif defined EQ -1>
						<cfset resp.lastResult = true>
						<cfset resp.data = "">					
					<cfelse>
						<cfset resp.lastResult = false>
						<cfset this.socket.read()>
						<cfset resp.data = this.socket.response>						
					</cfif>
				</cfcase>
				<cfcase value="QUERY">
					<cfset this.socket.read()>					
					<cfset defined = mid(this.socket.response, 2)>
					
					<cfif defined EQ -1>
						<cfset resp.lastResult = true>
						<cfset resp.data = "">
					<cfelse>
						<cfset resp.lastResult = false>
						<cfset this.socket.read()>
						<cfset resp.data = this.socket.response>						
					</cfif>
				</cfcase>
				<cfcase value="LOCK">
					<cfset this.socket.read()>
					<cfset success = mid(this.socket.response, 2)>
					<cfif success EQ 1>
						<cfset resp.success = true>
					<cfelse>
						<cfset resp.success = false>
					</cfif>
				</cfcase>
				<cfcase value="UNLOCK">
					<cfset this.socket.read()>
					<cfset resp = structNew()>
				</cfcase>
				<cfcase value="VERSION">
					<cfset this.socket.read()>
					<cfset resp.data = mid(this.socket.response, 2)>
				</cfcase>
				<cfcase value="MVERSION">
					<cfset this.socket.read()>
					<cfset resp.data = mid(this.socket.response, 2)>
				</cfcase>
				<cfcase value="FUNCTION">
					<cfset this.socket.read()>
					<cfset this.socket.read()>
					<cfset resp.data = this.socket.response>
				</cfcase>
			</cfswitch>
		</cfif>						
		
		<cfreturn resp>		
	</cffunction>

	<cffunction name="set" returntype="void" access="public" output="false"
				description="Sets the value of a GT.M global node"
				hint="Sets the value of a GT.M global node">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be set">
		<cfargument name="subscripts" type="array" required="true" hint="Array of subscripts">
		<cfargument name="value" type="string" required="true" hint="Value to set">

		<cfset mwCmd = "SET " & arguments.globalName>		
		
		<cfif arrayLen(subscripts) GT 0>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>

		<cfset mwCmd &= " " & len(value)> 
		<cfset this.sendMWire(mwCmd, value)>					
	</cffunction>			
	
	<cffunction name="get" returntype="any" access="public" output="false"
				description="Retrieves the value of a GT.M global node"
				hint="Retrieves the value of a GT.M global node">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "GET " & arguments.globalName>		
		
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset resp = this.sendMWire(mwCmd)>
		
		<cfreturn resp.data>						
	</cffunction>			

	<cffunction name="kill" returntype="void" access="public" output="false"
				description="Deletes a GT.M global node"
				hint="Deletes a GT.M global node">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "KILL " & arguments.globalName>		
		
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset this.sendMWire(mwCmd)>						
	</cffunction>			
	
	<cffunction name="data" returntype="struct" access="public" output="false"
				description="Determines whether a global node exists and/or has child nodes or data">				
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "DATA " & arguments.globalName>
				
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset resp = this.sendMWire(mwCmd)>
		
		<cfreturn resp.data>	
	</cffunction>		
	
	<cffunction name="order" returntype="struct" access="public" output="false"
				description="Obtain the next value of the specified global subscript">				
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "ORDER " & arguments.globalName>
				
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset var resp = this.sendMWire(mwCmd)>
		
		<cfset ret = structNew()>
			<cfset ret.lastResult = resp.lastResult>
			<cfset ret.value = resp.data>
		<cfreturn ret>	
	</cffunction>	

	<cffunction name="query" returntype="struct" access="public" output="false"
				description="Returns the next global reference following the one specified"
				hint="Returns the next global reference following the one specified">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be retrieved">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "QUERY " & arguments.globalName>		
		
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset resp = this.sendMWire(mwCmd)>
		
		<cfset ret = structNew()>
		<cfset ret.lastResult = resp.lastResult>
		<cfset ret.value = resp.data>
		
		<cfreturn ret>				
	</cffunction>		

	<cffunction name="lock" returntype="boolean" access="public" output="false"
				description="Locks a GT.M global reference">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be locked">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "LOCK " & arguments.globalName>		
		
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset resp = this.sendMWire(mwCmd)>
		
		<cfreturn resp.success>						
	</cffunction>
	
	<cffunction name="unlock" returntype="void" access="public" output="false"
				description="Unlocks a GT.M global reference">
		<cfargument name="globalName" type="string" required="true" hint="Name of the global to be unlocked">
		<cfargument name="subscripts" type="array" required="false" hint="Array of subscripts">
		
		<cfset mwCmd = "UNLOCK " & arguments.globalName>		
		
		<cfif isDefined("arguments.subscripts")>
			<cfset mwCmd &= "[">
			<cfloop array="#arguments.subscripts#" index="sub">
				<cfif isNumeric(sub)>
					<cfset mwCmd &= sub & ",">
				<cfelse>
					<cfset mwCmd &= chr(34) & sub & chr(34) & ",">
				</cfif>
			</cfloop>
			
			<cfset mwCmd = left(mwCmd, len(mwCmd) - 1) & "]">
		</cfif>
		
		<cfset resp = this.sendMWire(mwCmd)>									
	</cffunction>

	<cffunction name="mVersion" returntype="string" access="public" output="false"
		    description="Return the version of GT.M">
		<cfset mwCmd = "MVERSION">
		<cfset resp = this.sendMWire(mwCmd)>

		<cfreturn resp.data>
	</cffunction>

	<cffunction name="mFunction" returntype="any" access="public" output="false"
		    description="Call a GT.M extrinsic function">
		<cfargument name="fn" type="string" required="true" hint="Function">

		<cfset mwCmd = "FUNCTION " & arguments.fn>		
		<cfset resp = this.sendMWire(mwCmd)>

		<cfreturn resp.data>
	</cffunction>

	<cffunction name="mWireVersion" returntype="string" access="public" output="false">
		<cfset mwCmd = "VERSION">
		<cfset resp = this.sendMWire(mwCmd)>

		<cfreturn resp.data>
	</cffunction>
</cfcomponent>
