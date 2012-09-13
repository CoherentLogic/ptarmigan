<cfcomponent output="false" implements="ptarmigan.i_object">
	<cfset this.id = "">
	<cfset this.table_name = "">
	<cfset this.table_id = "">
	<cfset this.change_order_number = "">
	<cfset this.audit_date = CreateODBCDate(Now())>
	<cfset this.employee_id = "">
	<cfset this.comment = "">
	<cfset this.what_changed = "">
	
	<cfset this.members = StructNew()>
	
	
	<cfscript>
		this.members['CHANGE_ORDER_NUMBER'] = StructNew();
		this.members['CHANGE_ORDER_NUMBER'].type = "text";
		this.members['CHANGE_ORDER_NUMBER'].label = "Change order number";

		this.members['AUDIT_DATE'] = StructNew();
		this.members['AUDIT_DATE'].type = "date";
		this.members['AUDIT_DATE'].label = "Audit date";

		this.members['EMPLOYEE_ID'] = StructNew();
		this.members['EMPLOYEE_ID'].type = "object";
		this.members['EMPLOYEE_ID'].label = "Change made by";
		this.members['EMPLOYEE_ID'].class = "OBJ_EMPLOYEE";

		this.members['COMMENT'] = StructNew();
		this.members['COMMENT'].type = "text";
		this.members['COMMENT'].label = "Comment";

		this.members['WHAT_CHANGED'] = StructNew();
		this.members['WHAT_CHANGED'].type = "text";
		this.members['WHAT_CHANGED'].label = "Changes included";

	</cfscript>
	
	
	<cfset this.written = false>
	
	<cffunction name="create" returntype="ptarmigan.audit" access="public" output="false">
		<cfset this.id = CreateUUID()>
		
		<cfquery name="q_create_audit" datasource="#session.company.datasource#">
			INSERT INTO audits
							(id,
							table_name,
							table_id,
							change_order_number,
							employee_id,
							comment,
							what_changed)
			VALUES			('#this.id#',
							'#this.table_name#',
							'#this.table_id#',
							'#this.change_order_number#',
							'#this.employee_id#',
							'#this.comment#',
							'#this.what_changed#')
		</cfquery>
		
		<cfset obj = CreateObject("component", "ptarmigan.object")>
		<cfset obj.id = this.id>
		<cfset obj.parent_id = this.table_id>
		<cfset obj.class_id = "OBJ_AUDIT">
		<cfset obj.deleted = 0>
		<cfset obj.create()>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>

	<cffunction name="open" returntype="ptarmigan.audit" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		
		<cfquery name="oa" datasource="#session.company.datasource#">
			SELECT * FROM audits WHERE id='#id#'
		</cfquery>
		
		<cfif oa.recordcount EQ 0>
			<cfthrow>
		</cfif>
		
		<cfset this.id = id>
		<cfset this.table_name = oa.table_name>
		<cfset this.table_id = oa.table_id>
		<cfset this.change_order_number = oa.change_order_number>
		<cfset this.employee_id = oa.employee_id>
		<cfset this.comment = oa.comment>
		<cfset this.what_changed = oa.what_changed>
		<cfset this.audit_date = oa.audit_date>
		
		<cfset this.written = true>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="delete" returntype="void" access="public" output="false">
		<cfquery name="d_audit" datasource="#session.company.datasource#">
			DELETE FROM audits WHERE id='#this.id#'
		</cfquery>
	</cffunction>
	
	<cffunction name="object_name" returntype="string" access="public" output="false">
		<cfreturn this.comment>
	</cffunction>
</cfcomponent>