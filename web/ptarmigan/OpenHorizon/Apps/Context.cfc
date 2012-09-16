<cfcomponent displayname="Context" hint="OH App Context class" extends="OpenHorizon.Framework">
	
    <cffunction name="Open" access="public" returntype="OpenHorizon.Apps.Context">
    	<cfargument name="Context" type="string" required="yes" hint="The context">
        <cfargument name="Selector" type="string" required="yes" hint="Selector for field">
        <cfargument name="UserID" type="numeric" required="yes" hint="User ID of the user working on this field">
        
        <cfset this.Context = Context>
        <cfset this.Selector = Selector>
        <cfset this.UserID = UserID>
        
        <cfquery name="ctx" datasource="#this.BaseDatasource#">
        	SELECT * FROM AppContexts WHERE ctx_name='#this.Context#'
		</cfquery>
        
        <cfset this.ctx_datasource = ctx.ctx_datasource>
        <cfset this.ctx_table = ctx.ctx_table>
        <cfset this.ctx_pkfield = ctx.ctx_pkfield>
        <cfset this.ctx_pkstring = ctx.ctx_pkstring>
        <cfset this.ctx_description = ctx.ctx_description>
        <cfset this.ctx_idfield = ctx.ctx_idfield>
        
        <cfreturn #this#>
    </cffunction>
    
    <cffunction name="GetField" access="public" returntype="string" hint="Retrieve a field from this context">
		<cfargument name="FieldName" type="string" required="yes" hint="The field to retrieve">
        
        <cfquery name="GetThisField" datasource="#this.ctx_datasource#">
			<cfif this.ctx_pkstring EQ 1>
                SELECT #FieldName# FROM #this.ctx_table# WHERE #this.ctx_pkfield#='#this.Selector#'
            <cfelse>
                SELECT #FieldName# FROM #this.ctx_table# WHERE #this.ctx_pkfield#=#this.Selector#
            </cfif>
        </cfquery>
        
        <cfparam name="fieldValue" default="">
		<cfset fieldValue = Evaluate("GetThisField.#FieldName#")>
        
        <cfreturn #fieldValue#>
    </cffunction>
    
    <cffunction name="SetField" access="public" returntype="string" hint="Set a field's value in this context">
    	<cfargument name="FieldName" type="string" required="yes" hint="The field to set">
        <cfargument name="FieldValue" type="string" required="yes" hint="The value to be assigned">
        
        <cfparam name="curValue" default="">
        <cfset curValue = this.GetField(FieldName)>
        
        <cfquery name="SetThisField" datasource="#this.ctx_datasource#">
        	<cfif this.ctx_pkstring EQ 1>
	        	UPDATE #this.ctx_table# SET #FieldName#='#FieldValue#' WHERE #this.ctx_pkfield#='#this.Selector#'
			<cfelse>
            	UPDATE #this.ctx_table# SET #FieldName#='#FieldValue#' WHERE #this.ctx_pkfield#=#this.Selector#
            </cfif>
		</cfquery>     
        
        <cfset WriteLogEntry(FieldName, FieldValue)>       
		
        <cfreturn #fieldValue#>
    </cffunction>              
    
    <cffunction name="WriteLogEntry" access="private" returntype="void" hint="Write a log entry">
		<cfargument name="FieldName" type="string" required="yes" hint="The field to write the entry about">
        <cfargument name="FieldValue" type="string" required="yes" hint="The value">
        
        <cfquery name="WLE" datasource="#this.BaseDatasource#">
        	INSERT INTO ppm_changelog
            	(ctx_name,
                ctx_selector,
                ctx_field,
                user_id,
                change_date,
                change_value)
			VALUES
            	('#this.Context#',
                '#this.Selector#',
                '#FieldName#',
                #this.UserID#,
                #CreateODBCDateTime(Now())#,
                '#FieldValue#')
		</cfquery>                  
                                                
	</cffunction>    	                  
    
    <cffunction name="GetLogEntries" access="public" returntype="query" hint="Get log entries for this context">
    	<cfargument name="LimitByField" type="string" required="no" default="">
        
        <cfquery name="gle" datasource="#this.BaseDatasource#">
            SELECT * FROM ppm_changelog 
            WHERE 	ctx_name='#this.Context#' 
            AND		ctx_selector='#this.Selector#'
            <cfif IsDefined("LimitByField")>
            	AND ctx_field='#LimitByField#'
			</cfif>                
            ORDER BY change_date DESC
        </cfquery>
        
        <cfreturn #gle#>
    </cffunction> 
    
   
</cfcomponent>