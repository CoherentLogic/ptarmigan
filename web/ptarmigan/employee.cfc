<cfcomponent output="false">
	
	<!---authentication--->
	<cfset this.id = "">
	<cfset this.username = "">
	<cfset this.password_hash = "">
	<cfset this.active = 0>

	
	<!---identity--->
	<cfset this.honorific = "">
	<cfset this.first_name = "">
	<cfset this.middle_initial = "">
	<cfset this.last_name = "">
	<cfset this.suffix = "">
	<cfset this.gender = "">
	
	<!---employment--->
	<cfset this.title = "">
	<cfset this.hire_date = "">
	<cfset this.term_date = "">
	
	<!---address--->
	<cfset this.mail_address = "">
	<cfset this.mail_city = "">
	<cfset this.mail_state = "">
	<cfset this.mail_zip = "">

	<!---email--->
	<cfset this.email = "">
	
	<!---phone--->
	<cfset this.work_phone = "">
	<cfset this.home_phone = "">
	<cfset this.mobile_phone = "">
	
	<!---clock in/out--->
	<cfset this.clocked_task_code_asgn_id = "">
	<cfset this.clocked_timestamp = CreateODBCDateTime(Now())>
	<cfset this.clocked_in = 0>
	
		
	<!---housekeeping--->
	
	<cfset this.written=false>
	
	<cffunction name="create" returntype="ptarmigan.employee" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		<cfquery name="employee_create" datasource="ptarmigan">
			INSERT INTO employees
						(id,
						username,
						password_hash,
						active,
						honorific,
						first_name,
						middle_initial,
						last_name,
						suffix,
						gender,
						title,
						hire_date,
						<cfif this.term_date NEQ 0>
						term_date,
						</cfif>
						mail_address,
						mail_city,
						mail_state,
						mail_zip,
						email,
						work_phone,
						home_phone,
						mobile_phone,
						clocked_task_code_asgn_id,
						clocked_timestamp,
						clocked_in)
			VALUES		('#this.id#',
						'#this.username#',
						'#this.password_hash#',
						#this.active#,
						'#this.honorific#',
						'#this.first_name#',
						'#this.middle_initial#',
						'#this.last_name#',
						'#this.suffix#',
						'#this.gender#',
						'#this.title#',
						#this.hire_date#,
						<cfif this.term_date NEQ 0>
						#this.term_date#,
						</cfif>
						'#this.mail_address#',
						'#this.mail_city#',
						'#this.mail_state#',
						'#this.mail_zip#',
						'#this.email#',
						'#this.work_phone#',
						'#this.home_phone#',
						'#this.mobile_phone#',
						'#this.clocked_task_code_asgn_id#',
						#this.clocked_timestamp#,
						#this.clocked_in#)
		</cfquery>
		
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.employee" access="public" output="false">
		<cfargument name="id" datatype="string" required="true">
		
		<cfquery name="q_open" datasource="ptarmigan">
			SELECT username FROM employees WHERE id='#id#'
		</cfquery>
		
		<cfreturn this.open_by_username(q_open.username)>
	</cffunction>
	
	<cffunction name="open_by_username" returntype="ptarmigan.employee" access="public" output="false">
		<cfargument name="username" type="string" required="true">
		
		<cfquery name="obu" datasource="ptarmigan">
			SELECT * FROM employees WHERE username='#UCase(username)#'
		</cfquery>
		
		<cfif obu.RecordCount GT 0>
			<cfset this.id = '#obu.id#'>
			<cfset this.username = '#obu.username#'>
			<cfset this.password_hash = '#obu.password_hash#'>
			<cfset this.active = #obu.active#>
			<cfset this.honorific = '#obu.honorific#'>
			<cfset this.first_name = '#obu.first_name#'>
			<cfset this.middle_initial = '#obu.middle_initial#'>
			<cfset this.last_name = '#obu.last_name#'>
			<cfset this.suffix = '#obu.suffix#'>
			<cfset this.gender = '#obu.gender#'>
			<cfset this.title = '#obu.title#'>
			<cfset this.hire_date = '#obu.hire_date#'>
			<cfset this.term_date = '#obu.term_date#'>
			<cfset this.mail_address = '#obu.mail_address#'>
			<cfset this.mail_city = '#obu.mail_city#'>
			<cfset this.mail_state = '#obu.mail_state#'>
			<cfset this.mail_zip = '#obu.mail_zip#'>
			<cfset this.email = '#obu.email#'>
			<cfset this.work_phone = '#obu.work_phone#'>
			<cfset this.home_phone = '#obu.home_phone#'>
			<cfset this.mobile_phone = '#obu.mobile_phone#'>
			
			<cfset this.clocked_task_code_asgn_id = obu.clocked_task_code_asgn_id>
			<cfset this.clocked_timestamp = obu.clocked_timestamp>
			<cfset this.clocked_in = obu.clocked_in>
			
			
			<cfset this.written = true>
		<cfelse>
			<cfset this.id = 0>
		</cfif>
		
		<cfreturn this>		
	</cffunction>
	
	<cffunction name="update" returntype="boolean" access="public" output="false">
		
		<cfquery name="q_e_update" datasource="ptarmigan">
			UPDATE employees
			SET		username='#this.username#',
					password_hash='#this.password_hash#',
					active=#this.active#,
					honorific='#this.honorific#',
					first_name='#this.first_name#',
					middle_initial='#this.middle_initial#',
					last_name='#this.last_name#',
					suffix='#this.suffix#',
					gender='#this.gender#',
					title='#this.title#',
					hire_date=#this.hire_date#,
					<cfif this.term_date NEQ "" AND this.term_date NEQ 0>
					term_date=#this.term_date#,
					</cfif>
					mail_address='#this.mail_address#',
					mail_city='#this.mail_city#',
					mail_state='#this.mail_state#',
					mail_zip='#this.mail_zip#',
					email='#this.email#',
					work_phone='#this.work_phone#',
					home_phone='#this.home_phone#',
					mobile_phone='#this.mobile_phone#',
					clocked_task_code_asgn_id='#this.clocked_task_code_asgn_id#',
					clocked_timestamp=#CreateODBCDateTime(this.clocked_timestamp)#,
					clocked_in=#this.clocked_in#
			WHERE	id='#this.id#'
		</cfquery>
		
		<cfset this.written = true>
		
		<cfreturn true>
	</cffunction>
		
	<cffunction name="admin" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_admin() EQ false>
				<cfquery name="set_admin_true" datasource="ptarmigan">
					INSERT INTO administrators(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_admin_false" datasource="ptarmigan">
				DELETE FROM administrators WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="time_approver" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_time_approver() EQ false>
				<cfquery name="set_time_approver_true" datasource="ptarmigan">
					INSERT INTO time_approvers(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_time_approver_false" datasource="ptarmigan">
				DELETE FROM time_approvers WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="billing_manager" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_billing_manager() EQ false>
				<cfquery name="set_billing_manager_true" datasource="ptarmigan">
					INSERT INTO billing_managers(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_billing_managers_false" datasource="ptarmigan">
				DELETE FROM billing_managers WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="project_manager" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_project_manager() EQ false>	
				<cfquery name="set_project_manager_true" datasource="ptarmigan">
					INSERT INTO project_managers(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_project_manager_false" datasource="ptarmigan">
				DELETE FROM project_managers WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>
	
	
	<cffunction name="is_admin" returntype="boolean" access="public" output="false">
	
		<cfquery name="q_is_admin" datasource="ptarmigan">
			SELECT * FROM administrators WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_admin.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="is_time_approver" returntype="boolean" access="public" output="false">
		
		<cfquery name="q_is_time_approver" datasource="ptarmigan">
			SELECT * FROM time_approvers WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_time_approver.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="is_project_manager" returntype="boolean" access="public" output="false">
		
		<cfquery name="q_is_project_manager" datasource="ptarmigan">
			SELECT * FROM project_managers WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_project_manager.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="is_billing_manager" returntype="boolean" access="public" output="false">
			
		<cfquery name="q_is_billing_manager" datasource="ptarmigan">
			SELECT * FROM billing_managers WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_billing_manager.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>	
	
	<cffunction name="assignments" returntype="array" access="public" output="false">
		<cfargument name="task_id" type="string" required="true">
		
		<cfquery name="q_asgn" datasource="ptarmigan">
			SELECT		id AS asgn_id
			FROM		assignments
			WHERE		task_id='#task_id#'
			AND			employee_id='#this.id#'
			ORDER BY	start_date
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_asgn">
			<cfset t = CreateObject("component", "ptarmigan.assignment").open(asgn_id)>
			
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="all_open_assignments" returntype="array" access="public" output="false">
	
		<cfquery name="q_asgn" datasource="ptarmigan">
			SELECT		id AS asgn_id
			FROM		assignments			
			WHERE		employee_id='#this.id#'
			AND			start_date<=#CreateODBCDate(Now())#
			AND			end_date>=#CreateODBCDate(Now())#
			ORDER BY	start_date
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_asgn">
			<cfset t = CreateObject("component", "ptarmigan.assignment").open(asgn_id)>
			
			<cfset ArrayAppend(oa, t)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="clock_in" returntype="void" access="public" output="false">
		<cfargument name="task_code_asgn" type="string" required="true">
		
		<cfset this.clocked_in = 1>
		<cfset this.clocked_task_code_asgn_id = task_code_asgn>
		<cfset this.clocked_timestamp = CreateODBCDateTime(Now())>
		
		<cfset this.update()>
	</cffunction>
	
	<cffunction name="clock_out" returntype="void" access="public" output="false">
		<cfset this.clocked_in = 0>
		
		<cfset te = CreateObject("component", "ptarmigan.time_entry")>
		
		<cfset te.task_code_assignment_id = this.clocked_task_code_asgn_id>
		<cfset te.start_time = CreateODBCDateTime(this.clocked_timestamp)>
		<cfset te.end_time = CreateODBCDateTime(Now())>
		<cfset te.approved = 0>
		<cfset te.approver_id = "">
		
		<cfset te.create()>
						
		<cfset this.update()>
	</cffunction>
	
	<cffunction name="pay_owed" returntype="numeric" access="public" output="false">
	
		<cfquery name="q_pay_owed" datasource="ptarmigan">
			SELECT 	SUM(amount) AS PSUM 
			FROM 	payroll_event 
			WHERE	employee_id='#this.id#'
			AND		paid=0
		</cfquery>
		
		<cfif IsNumeric(q_pay_owed.PSUM)>
			<cfreturn q_pay_owed.PSUM>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="pay_paid" returntype="numeric" access="public" output="false">
	
		<cfquery name="q_pay_paid" datasource="ptarmigan">
			SELECT 	SUM(paid) AS PSUM 
			FROM 	payroll_event 
			WHERE	employee_id='#this.id#'
			AND		paid=1
		</cfquery>
		
		<cfreturn q_pay_paid.PSUM>
	</cffunction>	
	
</cfcomponent>