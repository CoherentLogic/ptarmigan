<cffunction name="convertStructToLower" access="public" returntype="struct">
        <cfargument name="st" required="true" type="struct">

        <cfset var aKeys = structKeyArray(st)>
        <cfset var stN = structNew()>
        <cfset var i= 0>
        <cfset var ai= 0>
        <cfloop array="#aKeys#" index="i">
            <cfif isStruct(st[i])>
                <cfset stN['#lCase(i)#'] = convertStructToLower(st[i])>
            <cfelseif isArray(st[i])>
                <cfloop from=1 to="#arraylen(st[i])#" index="ai">
                    <cfif isStruct(st[i][ai])>
                        <cfset st[i][ai] = convertStructToLower(st[i][ai])>
                    <cfelse>
                        <cfset st[i][ai] = st[i][ai]>
                    </cfif>
                </cfloop>
                <cfset stN['#lcase(i)#'] = st[i]>
            <cfelse>
                <cfset stN['#lcase(i)#'] = st[i]>
            </cfif>
        </cfloop>
        <cfreturn stn>
   </cffunction>
	
<cfset project = CreateObject("component", "ptarmigan.project").open(url.id)>
<cfset d_struct = DeserializeJSON(project.jquery_gantt(url.durations))>
<cfset m_struct = StructNew()>
<cfset m_struct.json = d_struct>
<cfcontent type="application/json">
<cfoutput>#SerializeJSON(convertStructToLower(m_struct))#</cfoutput>