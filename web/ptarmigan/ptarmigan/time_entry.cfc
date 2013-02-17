<cfcomponent output="false">

	<cfset this.id = "">
	<cfset this.employee_id = "">
	<cfset this.start_time = "">
	<cfset this.end_time = "">
	<cfset this.approved = 0>
	<cfset this.approver_id = "">
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.time_entry" access="public" output="false">
	
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_time_entry" datasource="#session.company.datasource#">
			INSERT INTO time_entries
						(id,
						start_time,
						end_time,
						approved,
						approver_id,
						employee_id)
			VALUES		('#this.id#',
						#CreateODBCDateTime(this.start_time)#,
						#CreateODBCDateTime(this.end_time)#,
						#this.approved#,
						'#this.approver_id#',
						'#this.employee_id#')
		</cfquery>
		
		<cfset this.written = true>
		<cfreturn this>
	
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.time_entry" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="ote" datasource="#session.company.datasource#">
			SELECT * FROM time_entries WHERE id='#id#'
		</cfquery>
		
		<cfset this.id = id>
		<cfset this.start_time = ote.start_time>
		<cfset this.end_time = ote.end_time>
		<cfset this.approved = ote.approved>
		<cfset this.approver_id = ote.approver_id>
		<cfset this.employee_id = ote.employee_id>
		
		<cfset this.written = true>		
		<cfreturn this>
		
	</cffunction>
	
	<cffunction name="update" returntype="ptarmigan.time_entry" access="public" output="false">
	
		<cfquery name="q_update_time_entry" datasource="#session.company.datasource#">
			UPDATE time_entries
			SET		start_time=#CreateODBCDateTime(this.start_time)#,
					end_time=#CreateODBCDateTime(this.end_time)#,
					approved=#this.approved#,
					approver_id='#this.approver_id#'
			WHERE	id='#this.id#'
		</cfquery>
	
		<cfset this.written = true>
		<cfreturn this>
	
	</cffunction>
	
	<cffunction name="approve" returntype="ptarmigan.time_entry" access="public" output="false">
		<cfargument name="user_id" type="string" required="true">
		
		<cfset this.approved = 1>
		<cfset this.approver_id = user_id>
		
		<cfset this.update()>
		
		<cfset emp = CreateObject("component", "ptarmigan.employee").open(asgn.employee_id)>
		<cfset task_code = CreateObject("component", "ptarmigan.task_code").open(tca.task_code_id)>
		<cfset task = CreateObject("component", "ptarmigan.task").open(asgn.task_id)>
		<cfset milestone = CreateObject("component", "ptarmigan.milestone").open(task.milestone_id)>
		<cfset project = CreateObject("component", "ptarmigan.project").open(milestone.project_id)>
		
		<cfset emp_rate = tca.employee_rate>
		
		
		<cfset pay = CreateObject("component", "ptarmigan.payroll_event")>
		
		<cfset pay.employee_id = emp.id>
		<cfset pay.charged = CreateODBCDate(Now())>
		<cfset pay.amount = this.hours_decimal() * emp_rate>
		<cfset pay.paid = 0>
		<cfset pay.time_entry_date = CreateODBCDateTime(this.end_time)>
		<cfset pay.description = "#project.project_name#: #task.task_name#/#task_code.task_name#: (#this.hours_decimal()# HOURS)">
		
		<cfset pay.create()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="deny" returntype="ptarmigan.time_entry" access="public" output="false">
		<cfargument name="user_id" type="string" required="true">
		
		<cfset this.approved = 2>
		<cfset this.approver_id = user_id>
		
		<cfset this.update()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="RoundTo15" returntype="date" access="public" output="false">
		<cfargument name="theTime" type="date" required="true">
		
		
		<cfset roundedMinutes = round(minute(theTime) / 15 ) * 15>
		<cfset newHour = hour(theTime)>
    
		<cfif roundedMinutes EQ 60>
			<cfset newHour = newHour + 1>
    	    <cfset roundedMinutes = 0>
		</cfif>
    	
		<cfreturn dateFormat(theTime, "MM/DD/YYYY") & " " & timeFormat(createTime(newHour,roundedMinutes,0),"h:mm tt")>    
    </cffunction>
	
	<cffunction name="hours_decimal" returntype="numeric" access="public" output="false">
	
		<cfset diff_min = datediff("n", this.RoundTo15(this.start_time), this.RoundTo15(this.end_time))>
		
		<cfreturn diff_min / 60>
	</cffunction>
	
	
</cfcomponent>