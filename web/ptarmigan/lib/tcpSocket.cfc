<cfcomponent output="false" displayname="tcpSocket" hint="Provides TCP Socket connectivity">
	<cfset this.host = "">
	<cfset this.port = "">
	<cfset this.socket = "">
	<cfset this.success = false>
	<cfset this.errorMessage = "">
	<cfset this.response = "">
	<cfset this.logLevel = 0>

	<cffunction name="open" returntype="lib.tcpSocket" access="public" output="false">
		<cfargument name="host" required="true" type="string">
		<cfargument name="port" required="true" type="numeric">
		
		<cfset this.host = arguments.host>
		<cfset this.port = arguments.port>		
		<cfset this.socket = createObject("java", "java.net.Socket")>
		

		<cftry>
			<cfset this.socket.init(this.host, this.port)>
			<cfcatch type="object">
				<cfset this.success = false>
				<cfset this.errorMessage = "tcpSocket.open: could not connect to #this.host#:#this.port#">			
				
				<cfreturn this>
			</cfcatch>
		</cftry>
		
		<cfset this.outputStream = this.socket.getOutputStream()>			
		<cfset this.output = createObject("java", "java.io.PrintWriter").init(this.outputStream)>
		<cfset this.inputStream = this.socket.getInputStream()>	
		<cfset this.inputStreamReader = createObject("java", "java.io.InputStreamReader").init(this.inputStream)>
       		<cfset this.input = createObject("java", "java.io.BufferedReader").init(this.inputStreamReader)>
		
		<cfset this.success = true>
		<cfset this.errorMessage = "">
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="close" access="public" returntype="lib.tcpSocket" output="false">
		<cfif this.socket.isConnected()>
			<cfset this.success = true>
			<cfset this.errorMessage = "">
			
			<cfset this.socket.close()>
		<cfelse>
			<cfset this.success = false>
			<cfset this.errorMessage = "tcpSocket.close: socket not open">
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="send" returntype="lib.tcpSocket" access="public" output="false">
		<cfargument name="message" required="true" type="string">

		<cfif this.logLevel GE 3>
			<cflog text="send: #message#" file="tcpSocket" type="Information">
		</cfif>
		
		<cfif this.socket.isConnected()>				       	       		        
	       	<cfset this.output.println(arguments.message)>
	       	<cfset this.output.println()> 
	       	<cfset this.output.flush()>
	       
	       	<cfset this.response = "">			
			<cfset this.success = true>
			<cfset this.errorMessage = "">
		<cfelse>
			<cfset this.success = false>
			<cfset this.errorMessage = "tcpSocket.send: socket not connected">
		</cfif>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="read" returntype="lib.tcpSocket" access="public" output="false">
		
		<cfif this.socket.isConnected()>							       	
	       	<cfset this.response = this.input.readLine()>

		<cfif this.logLevel GE 3>
			<cflog text="read: #this.response#" file="tcpSocket" type="Information">
		</cfif>
				

	       	<cfset this.success = true>
	       	<cfset this.errorMessage = "">	
		<cfelse>
			<cfset this.success = false>
			<cfset this.errorMessage = "tcpSocket.read: socket not connected">				            	       	
		</cfif>
	
		<cfreturn this>
	</cffunction>
</cfcomponent>
