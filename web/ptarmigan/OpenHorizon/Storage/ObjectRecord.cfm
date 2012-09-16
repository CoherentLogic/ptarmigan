<!--- <cfset Authenticator = CreateObject("webservice", "http://orms.prefiniti.com/Authentication.cfc?wsdl")>

<cfif IsDefined("URL.sk")>
	<cfif NOT Authenticator.ValidateKey('#URL.sk#')>
        <cfthrow message="Invalid session token." detail="The session token you passed to this service is not valid.">
    </cfif>
<cfelse>
	<cfthrow message="No session token was specified." detail="You must pass a valid session token to this service.">
</cfif>
 --->

<cfquery name="orms_object" datasource="#session.framework.BaseDatasource#">
	SELECT * FROM orms WHERE id='#URL.orms_id#'
</cfquery> 

<cfquery name="orms_keys" datasource="#session.framework.BaseDatasource#">
	SELECT * FROM orms_keywords WHERE r_id='#URL.orms_id#'
</cfquery>

<cfquery name="orms_relationships" datasource="#session.framework.BaseDatasource#">
	SELECT * FROM orms_relations WHERE rel_source='#URL.orms_id#'    
</cfquery>

<cfquery name="orms_subscriptions" datasource="#session.framework.BaseDatasource#">
	SELECT * FROM orms_subscriptions WHERE target_uuid='#URL.orms_id#'
</cfquery>

<cfquery name="orms_events" datasource="#session.framework.BaseDatasource#">
	SELECT * FROM orms_events WHERE target_uuid='#URL.orms_id#'
</cfquery>   


<cfxml variable="obj">
<?xml version="1.0" encoding="iso-8859-1"?>
<orms version="0.1">
	<cfoutput query="orms_object">
		<id>#id#</id>
        <type>#r_type#</type>        
        <name>#r_name#</name>
        <thumbnail>#r_thumb#</thumbnail>
        <created>#r_created#</created>
        <status>#r_status#</status>
        <parent>#r_parent#</parent>
        <owner-pk>#r_owner#</owner-pk>
        <site-pk>#r_site#</site-pk>        
        <latitude>#r_latitude#</latitude>
        <longitude>#r_longitude#</longitude>
        <ask-location>#r_ask_location#</ask-location>
        <has-location>#r_has_location#</has-location>
	</cfoutput>
    
   	<cfoutput query="orms_keys">
   		<entry>
        	<key>#k_word#</key>
        	<value>#k_value#</value>
        </entry>
    </cfoutput>   
    
    <cfoutput query="orms_relationships">
    	<relationship>
        	<source>#rel_source#</source>
            <target>#rel_target#</target>
            <type>#rel_type#</type>
            <created>#rel_created#</created>
            <expires>#rel_expires#</expires>
		</relationship>
    </cfoutput>
    
    <cfoutput query="orms_subscriptions">
    	<subscription>#user_id#</subscription>
    </cfoutput>
    
    <cfoutput query="orms_events">
    	<event id="#id#">
        	<user-pk>#user_id#</user-pk>
            <date>#event_date#</date>
            <name>#event_name#</name>
            <body>#body_copy#</body>
            <file>#file_uuid#</file>
        </event>
    </cfoutput>
</orms>
</cfxml>      
        
<cfset xml_string = ToString(obj)>
<cfcontent type="text/xml" reset="yes"><cfoutput>#xml_string#</cfoutput>          