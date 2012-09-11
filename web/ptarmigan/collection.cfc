<cfcomponent output="false">
	<cfset this.class_id = "">
	<cfset this.filters = "">
	
	<cffunction name="get" returntype="array" access="public" output="false">
		
		<cfparam name="all_rows" type="array" default="#ArrayNew(1)#">

		<cfquery name="gobj" datasource="#session.company.datasource#">
			SELECT id FROM objects WHERE class_id=<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.class_id#">
		</cfquery>
		
		<cfset all_rows = ArrayNew(1)>
		<cfoutput query="gobj">
			<cfset t = CreateObject("component", "ptarmigan.object").open(id)>			
			<cfset ArrayAppend(all_rows, t)>			
		</cfoutput>
	
		<cfset filters = ListToArray(this.filters, ";")>
		<cfset res = ArrayNew(1)>

		<cfloop array="#all_rows#" index="row">
			<cfif this.row_matches(row, filters) EQ true>
				<cfset ArrayAppend(res, row)>
			</cfif>
		</cfloop>
		
		<cfreturn res>				
	</cffunction>
		
	<cffunction name="row_matches" returntype="boolean" access="public" output="false">
		<cfargument name="the_row" type="ptarmigan.object" required="true">
		<cfargument name="the_filters" type="array" required="true">
		
		<cfloop array="#the_filters#" index="filt">
			<cfset filt_words = parse_line(filt)>
			
			<cfset column_name = filt_words[1]>
			<cfset operator = filt_words[2]>
			<cfset literal = filt_words[3]>
			<cfif ucase(operator) EQ "BETWEEN">
				<cfset literal_2 = filt_words[5]>
			</cfif>
			
			<cfif left(literal, 1) EQ "{" AND right(literal, 1) EQ "}">
				<cfset literal = mid(literal, 2, len(literal))>
				<cfset literal = left(literal, len(literal) - 1)>		
				<cfset literal = "CreateObject('component', 'ptarmigan.query_tools')." & literal>		
				<cfset literal = Evaluate(literal)>
			</cfif>
			
			<cfset col_val = the_row.member_value_raw(column_name)>
			
			<cfif the_row.member_type(column_name) EQ "date">
				<cfset col_val = CreateODBCDate(col_val)>
				<cfset literal = CreateODBCDate(literal)>
				<cfif ucase(operator) EQ "BETWEEN">
					<cfset literal_2 = CreateODBCDate(literal_2)>
				</cfif>
			</cfif>
			
			<cfswitch expression="#operator#">
				<cfcase value="=">
					<cfif col_val NEQ literal>
						<cfreturn false>
					</cfif>						
				</cfcase>
				<cfcase value=">">
					<cfif col_val LE literal>
						<cfreturn false>
					</cfif>
				</cfcase>
				<cfcase value="<">
					<cfif col_val GE literal>
						<cfreturn false>
					</cfif>
				</cfcase>
				<cfcase value="!=">
					<cfif col_val EQ literal>
						<cfreturn false>
					</cfif>
				</cfcase>
			</cfswitch>
			
		</cfloop>
		
		<cfreturn true>
	</cffunction>
	
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

				if(ch == "'") {
					for(j = i + 1; j <= line_length; j++) {
						iqch = mid(input_line, j, 1);

						if(iqch == "'") {
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

        <cfreturn tmpArray>
	</cffunction>

	
</cfcomponent>