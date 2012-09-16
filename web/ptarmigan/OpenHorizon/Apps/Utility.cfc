<cfcomponent displayname="Utility" hint="OH Application utility functions">
	<cffunction name="parse_line" access="public" returntype="array"> 
    	<cfargument name="input_line" type="string" required="yes" hint="The line to be parsed">
        
        <cfparam name="tmpArray" default="">
        <cfparam name="ch" default="">
        <cfparam name="buildup" default="">
        <cfparam name="qword" default="">
        <cfparam name="iqbu" default="">
        <cfparam name="iqch" default="">
        <cfparam name="line_length" default="">
        <cfset line_length = len(input_line)>
		
		<cfset tmpArray = ArrayNew(1)>
        
        <cfscript>			
			
			for(i = 1; i <= line_length; i++) {
				ch = mid(input_line, i, 1);
				
				if(ch == '"') {
					for(j = i + 1; j <= line_length; j++) {
						iqch = mid(input_line, j, 1);
						
						if(iqch == '"') {
							cword = iqbu;
							i = j + 1;
							arrayappend(tmpArray, cword);
							iqbu = "";
							cword = "";
							buildup = "";
							break;
						}
						else {
							iqbu = iqbu & iqch;
						}
					}					
				}
				else if(ch == ' ') {
					cword = buildup;
					arrayappend(tmpArray, cword);
					buildup = "";
				}				
				else {
					buildup = buildup & ch;
				}
							
			}
			cword = buildup;
			arrayappend(tmpArray, cword);
			
		</cfscript>
        
        <cfreturn #tmpArray#>
	</cffunction>        
	
    <cffunction name="FriendlySize" access="public" output="no" returntype="string">
    	<cfargument name="bytes" type="numeric" required="yes">
        
        <cfset kilobyte = 1024>
        <cfset megabyte = 1048576>
        <cfset gigabyte = 1073741824>
        <cfset terabyte = 1099511627776>
        <cfset petabyte = 1125899906842624>
        <cfset exabyte = petabyte * 1024>
   
   		<cfif bytes GE exabyte>
        	<cfset nv = bytes / exabyte>
            <cfset ret_val = Int(nv) & "EB">
       		<cfreturn ret_val>
        </cfif>

   		<cfif bytes GE petabyte>
        	<cfset nv = bytes / petabyte>
            <cfset ret_val = Int(nv) & "PB">
       		<cfreturn ret_val>
        </cfif>

   		<cfif bytes GE terabyte>
        	<cfset nv = bytes / terabyte>
            <cfset ret_val = Int(nv) & "TB">
       		<cfreturn ret_val>
        </cfif>

   		<cfif bytes GE gigabyte>
        	<cfset nv = bytes / gigabyte>
            <cfset ret_val = Int(nv) & "GB">
       		<cfreturn ret_val>
        </cfif>
       
   		<cfif bytes GE megabyte>
        	<cfset nv = bytes / megabyte>
            <cfset ret_val = Int(nv) & "MB">
       		<cfreturn ret_val>
        </cfif>
        
        <cfif bytes GE kilobyte>
        	<cfset nv = bytes / kilobyte>
            <cfset ret_val = Int(nv) & "KB">
       		<cfreturn ret_val>
        </cfif>
        
        <cfset ret_val = bytes & " bytes">
        <cfreturn #ret_val#>
        
    </cffunction>
</cfcomponent>