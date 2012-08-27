/*
 * ptarmigan.js
 *   ptarmigan JavaScript support
 *
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */


function edit_milestone(root_url, id)
{
	var url = root_url + "/project/edit_milestone.cfm?id=" + escape(id) + "&suppress_headers";
	
	ColdFusion.Window.create('edit_milestone', 'Edit Milestone',
	        url,
	        {height:530,width:630,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
	
}

function add_task(root_url, project_id, milestone_id)
{
	var url = root_url + "/project/add_task.cfm?id=" + escape(project_id) + "&milestone_id=" + escape(milestone_id) + "&suppress_headers";


	ColdFusion.Window.create('add_task', 'Add Task',
	        url,
	        {height:530,width:630,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});

	
}

function add_document(root_url, id)
{

}

function view_audit_log(root_url, table_name, table_id)
{
	var url = root_url + "/project/view_audit_log.cfm?table_name=" + escape(table_name) + "&table_id=" + escape(table_id) + "&suppress_headers";


	ColdFusion.Window.create('view_audit_log', 'View Audit Log',
	        url,
	        {height:530,width:900,modal:true,closable:false,
	        draggable:true,resizable:true,center:true,initshow:true});
}

function email_chart(root_url, project_id, durations)
{
	var url = root_url + "/project/email_chart.cfm?project_id=" + escape(project_id) + "&durations=" + escape(durations) + "&suppress_headers";


	ColdFusion.Window.create('email_chart', 'E-Mail Chart',
	        url,
	        {height:300,width:500,modal:true,closable:false,
	        draggable:true,resizable:true,center:true,initshow:true});

}
