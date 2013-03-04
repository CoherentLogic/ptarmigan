<cfcomponent output="false" implements="ptarmigan.i_object">
	
	<!---authentication--->
	<cfset this.id = CreateUUID()>
	<cfset this.username = "none">
	<cfset this.password_hash = "undefined">
	<cfset this.active = 0>

	
	<!---identity--->
	<cfset this.honorific = "Mrs.">
	<cfset this.first_name = "Unidentified">
	<cfset this.middle_initial = "Q">
	<cfset this.last_name = "Employee">
	<cfset this.suffix = "">
	<cfset this.gender = "">
	
	<!---employment--->
	<cfset this.title = "No Title">
	<cfset this.hire_date = CreateODBCDate(Now())>
	<cfset this.term_date = CreateODBCDate(Now())>
	
	<!---address--->
	<cfset this.mail_address = "123 Any St.">
	<cfset this.mail_city = "Anywhere">
	<cfset this.mail_state = "AA">
	<cfset this.mail_zip = "12345">

	<!---email--->
	<cfset this.email = "mail@nowhere.com">
	
	<!---phone--->
	<cfset this.work_phone = "555-555-1212">
	<cfset this.home_phone = "555-555-1212">
	<cfset this.mobile_phone = "555-555-1212">
	
	<!---clock in/out--->
	<cfset this.clocked_task_code_asgn_id = "">
	<cfset this.clocked_timestamp = CreateODBCDateTime(Now())>
	<cfset this.clocked_in = 0>
	
		
	<!---housekeeping--->
	
	<cfset this.written=false>
	
	<cfset this.members = StructNew()>
		
	<cfscript>
		this.members['USERNAME'] = StructNew();
		this.members['USERNAME'].type = "text";
		this.members['USERNAME'].label = "Username";
		
		this.members['ACTIVE'] = StructNew();
		this.members['ACTIVE'].type = "boolean";
		this.members['ACTIVE'].label = "Active";

		this.members['HONORIFIC'] = StructNew();
		this.members['HONORIFIC'].type = "text";
		this.members['HONORIFIC'].label = "Honorific";
		
		this.members['FIRST_NAME'] = StructNew();
		this.members['FIRST_NAME'].type = "text";
		this.members['FIRST_NAME'].label = "First name";						

		this.members['MIDDLE_INITIAL'] = StructNew();
		this.members['MIDDLE_INITIAL'].type = "text";
		this.members['MIDDLE_INITIAL'].label = "Middle initial";						

		this.members['LAST_NAME'] = StructNew();
		this.members['LAST_NAME'].type = "text";
		this.members['LAST_NAME'].label = "Last name";						

		this.members['SUFFIX'] = StructNew();
		this.members['SUFFIX'].type = "text";
		this.members['SUFFIX'].label = "Suffix";						

		this.members['GENDER'] = StructNew();
		this.members['GENDER'].type = "text";
		this.members['GENDER'].label = "Gender";						

		this.members['TITLE'] = StructNew();
		this.members['TITLE'].type = "text";
		this.members['TITLE'].label = "Title";						

		this.members['HIRE_DATE'] = StructNew();
		this.members['HIRE_DATE'].type = "date";
		this.members['HIRE_DATE'].label = "Hire date";						

		this.members['TERM_DATE'] = StructNew();
		this.members['TERM_DATE'].type = "date";
		this.members['TERM_DATE'].label = "Termination date";						

		this.members['MAIL_ADDRESS'] = StructNew();
		this.members['MAIL_ADDRESS'].type = "text";
		this.members['MAIL_ADDRESS'].label = "Mailing address";						

		this.members['MAIL_CITY'] = StructNew();
		this.members['MAIL_CITY'].type = "text";
		this.members['MAIL_CITY'].label = "City";

		this.members['MAIL_STATE'] = StructNew();
		this.members['MAIL_STATE'].type = "text";
		this.members['MAIL_STATE'].label = "State";

		this.members['MAIL_ZIP'] = StructNew();
		this.members['MAIL_ZIP'].type = "text";
		this.members['MAIL_ZIP'].label = "ZIP code";

		this.members['EMAIL'] = StructNew();
		this.members['EMAIL'].type = "text";
		this.members['EMAIL'].label = "E-mail address";

		this.members['WORK_PHONE'] = StructNew();
		this.members['WORK_PHONE'].type = "text";
		this.members['WORK_PHONE'].label = "Work phone";

		this.members['HOME_PHONE'] = StructNew();
		this.members['HOME_PHONE'].type = "text";
		this.members['HOME_PHONE'].label = "Home phone";

		this.members['MOBILE_PHONE'] = StructNew();
		this.members['MOBILE_PHONE'].type = "text";
		this.members['MOBILE_PHONE'].label = "Mobile phone";

	</cfscript>
	
	<cffunction name="create" returntype="ptarmigan.employee" access="public" output="false">
		
		<cfset this.id = CreateUUID()>
		<cfquery name="employee_create" datasource="#session.company.datasource#">
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
		
		<cfset session.message = "Employee #this.full_name()# added.">
		<cfset obj = CreateObject("component", "ptarmigan.object")>	
		<cfset obj.id = this.id>		
		<cfset obj.class_id = "OBJ_EMPLOYEE">
		<cfset obj.deleted = 0>
		
		<cfset obj.create()>
		<cfset this.written = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="open" returntype="ptarmigan.employee" access="public" output="false">
		<cfargument name="id" datatype="string" required="true">
		
		<cfquery name="q_open" datasource="#session.company.datasource#">
			SELECT username FROM employees WHERE id='#id#'
		</cfquery>
		
		<cfreturn this.open_by_username(q_open.username)>
	</cffunction>
	
	<cffunction name="open_by_username" returntype="ptarmigan.employee" access="public" output="false">
		<cfargument name="username" type="string" required="true">
		
		<cfquery name="obu" datasource="#session.company.datasource#">
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
			<cfset session.message = "Employee #this.full_name()# updated.">
			
			<cfset this.written = true>
		<cfelse>
			<cfset this.id = 0>
		</cfif>
		
		<cfreturn this>		
	</cffunction>
	
	<cffunction name="update" returntype="boolean" access="public" output="false">
		
		<cfquery name="q_e_update" datasource="#session.company.datasource#">
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
		
		<cfset obj = CreateObject("component", "ptarmigan.object").open(this.id)>						
		<cfset obj.update()>
		
		<cfset this.written = true>
		
		<cfreturn true>
	</cffunction>
		
	<cffunction name="admin" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_admin() EQ false>
				<cfquery name="set_admin_true" datasource="#session.company.datasource#">
					INSERT INTO administrators(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_admin_false" datasource="#session.company.datasource#">
				DELETE FROM administrators WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="time_approver" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_time_approver() EQ false>
				<cfquery name="set_time_approver_true" datasource="#session.company.datasource#">
					INSERT INTO time_approvers(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_time_approver_false" datasource="#session.company.datasource#">
				DELETE FROM time_approvers WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="billing_manager" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_billing_manager() EQ false>
				<cfquery name="set_billing_manager_true" datasource="#session.company.datasource#">
					INSERT INTO billing_managers(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_billing_managers_false" datasource="#session.company.datasource#">
				DELETE FROM billing_managers WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="project_manager" returntype="void" access="public" output="false">
		<cfargument name="v" type="boolean" required="true">
		
		<cfif v EQ true>
			<cfif this.is_project_manager() EQ false>	
				<cfquery name="set_project_manager_true" datasource="#session.company.datasource#">
					INSERT INTO project_managers(id) VALUES('#this.id#')
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="set_project_manager_false" datasource="#session.company.datasource#">
				DELETE FROM project_managers WHERE id='#this.id#'
			</cfquery>
		</cfif>
	</cffunction>
	
	
	<cffunction name="is_admin" returntype="boolean" access="public" output="false">
	
		<cfquery name="q_is_admin" datasource="#session.company.datasource#">
			SELECT * FROM administrators WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_admin.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="is_time_approver" returntype="boolean" access="public" output="false">
		
		<cfquery name="q_is_time_approver" datasource="#session.company.datasource#">
			SELECT * FROM time_approvers WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_time_approver.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="is_project_manager" returntype="boolean" access="public" output="false">
		
		<cfquery name="q_is_project_manager" datasource="#session.company.datasource#">
			SELECT * FROM project_managers WHERE id='#this.id#'
		</cfquery>
		
		<cfif q_is_project_manager.RecordCount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="is_billing_manager" returntype="boolean" access="public" output="false">
			
		<cfquery name="q_is_billing_manager" datasource="#session.company.datasource#">
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
		
		<cfquery name="q_asgn" datasource="#session.company.datasource#">
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
	
		<cfquery name="q_asgn" datasource="#session.company.datasource#">
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
	<cffunction name="assignments_by_range" returntype="array" access="public" output="false">
		<cfargument name="from_date" datatype="string" required="true">
		<cfargument name="to_date" datatype="string" required="true">

		<cfquery name="q_asgn" datasource="#session.company.datasource#">
			SELECT		id AS asgn_id
			FROM		assignments			
			WHERE		employee_id='#this.id#'
			AND			start_date>=#CreateODBCDate(from_date)#
			AND			end_date>=#CreateODBCDate(to_date)#
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
		
		<cfset te.employee_id = this.id>
		<cfset te.task_code_assignment_id = this.clocked_task_code_asgn_id>
		<cfset te.start_time = CreateODBCDateTime(this.clocked_timestamp)>
		<cfset te.end_time = CreateODBCDateTime(Now())>
		<cfset te.approved = 0>
		<cfset te.approver_id = "">
		
		<cfset te.create()>
						
		<cfset this.update()>
	</cffunction>
	
	<cffunction name="pay_owed" returntype="numeric" access="public" output="false">
	
		<cfquery name="q_pay_owed" datasource="#session.company.datasource#">
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
	
		<cfquery name="q_pay_paid" datasource="#session.company.datasource#">
			SELECT 	SUM(paid) AS PSUM 
			FROM 	payroll_event 
			WHERE	employee_id='#this.id#'
			AND		paid=1
		</cfquery>
		
		<cfreturn q_pay_paid.PSUM>
	</cffunction>	
	
	<cffunction name="full_name" returntype="string" access="public" output="false">
	
		<cfset name_str = "#this.last_name#, #this.honorific# #this.first_name# #this.middle_initial# #this.suffix#">
		
		<cfreturn name_str>
	</cffunction>
	
	<cffunction name="documents" returntype="array" access="public" output="false">
		<cfquery name="q_docs" datasource="#session.company.datasource#">
			SELECT	document_id
			FROM	document_associations
			WHERE	element_table='employees'
			AND		element_id='#this.id#'
		</cfquery>
		
		<cfset oa = ArrayNew(1)>
		
		<cfoutput query="q_docs">
			<cfset d = CreateObject("component", "ptarmigan.document").open(document_id)>
			<cfset ArrayAppend(oa, d)>
		</cfoutput>
		
		<cfreturn oa>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d" datasource="#session.company.datasource#">
			DELETE FROM employees WHERE id='#this.id#'
		</cfquery>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.full_name()>
	</cffunction>
	<cffunction name="search_result" returntype="void" access="public" output="true">
	</cffunction>
</cfcomponent>