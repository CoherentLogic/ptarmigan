<cfcontent type="application/json">
<cfsilent>
	<cfquery name="q_plugins" datasource="#session.company.datasource#">
		SELECT * FROM plugins
	</cfquery>
</cfsilent>
<cfset ts = arraynew(1)>
<cfset ti = 1>
<cfoutput query="q_plugins">
	<cfset ts[ti] = structnew()>
	<cfset ts[ti].plugin_name = q_plugins.plugin_name>
	<cfset ti = ti + 1>
</cfoutput>
<cfoutput>#serializejson(ts)#</cfoutput>