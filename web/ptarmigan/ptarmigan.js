/*
 * ptarmigan.js
 *   ptarmigan JavaScript support
 *
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */


//
// MILESTONES
//
function add_milestone(root_url, project_id)
{
	var url = root_url + "/project/add_milestone.cfm?id=" + escape(project_id) + "&suppress_headers";
	
	ColdFusion.Window.create('add_milestone', 'Add Milestone',
	        url,
	        {height:530,width:630,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
	
}

function edit_milestone(root_url, id)
{
	var url = root_url + "/project/edit_milestone.cfm?id=" + escape(id) + "&suppress_headers";
	
	ColdFusion.Window.create('edit_milestone', 'Edit Milestone',
	        url,
	        {height:530,width:830,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
	
}

//
// TASKS
//
function add_task(root_url, project_id, milestone_id)
{
	var url = root_url + "/project/add_task.cfm?id=" + escape(project_id) + "&milestone_id=" + escape(milestone_id) + "&suppress_headers";


	ColdFusion.Window.create('add_task', 'Add Task',
	        url,
	        {height:530,width:630,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
}

function edit_task(root_url, task_id, milestone_id)
{
	var url = root_url + "/project/edit_task.cfm?id=" + escape(task_id) + "&milestone_id=" + escape(milestone_id) + "&suppress_headers";


	ColdFusion.Window.create('edit_task', 'Edit Task',
	        url,
	        {height:530,width:830,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
}

//
// EXPENSES
//

function add_expense(root_url, element_table, element_id)
{
	var url = root_url + "/project/add_expense.cfm?element_table=" + escape(element_table) + "&element_id=" + escape(element_id) + "&suppress_headers";


	ColdFusion.Window.create('add_expense', 'Add Expense',
	        url,
	        {height:480,width:400,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
	
}

function edit_expense(root_url, expense_id)
{

}

//
// DOCUMENTS
//
function add_document(root_url)
{
	var url = root_url + "/documents/add_document.cfm?suppress_headers";

	ColdFusion.Window.create('add_document', 'Add Document',
	        url,
	        {height:370,width:500,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	


}

//
// PARCELS
//
function search_parcels(root_url)
{
	var url = root_url + "/parcels/parcel_search_wrapper.cfm?suppress_headers"

	ColdFusion.Window.create('parcel_search', 'Parcel Search',
	        url,
	        {height:780,width:1024,modal:true,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	


}	

function select_parcel(id, apn)
{
	document.getElementById("selected_parcel").value = id;
	document.getElementById("selected_parcel_apn").innerHTML = "Parcel " + apn + " selected.";
}

function associate_parcel_with_document(root_url, parcel_id, document_id)
{
	var url = root_url + "/documents/set_association.cfm?document_id=" + escape(document_id);
	url = url + "&element_table=parcels&element_id=" + escape(parcel_id);
	url = url + "&assoc=1&suppress_headers";

	var ret_val = request(url);

	window.location.reload();
}

function associate_parcel(root_url, ctl_id, parcel_id, element_table, element_id)
{
	var assoc = 0;

	if (is_checked(ctl_id)) {
		assoc = 1;		
	}

	var url = root_url + "/parcels/set_association.cfm?parcel_id=" + escape(parcel_id);
	url = url + "&element_table=" + escape(element_table) + "&element_id=" + escape(element_id);
	url = url + "&assoc=" + escape(assoc) + "&suppress_headers";

	
	return request(url);
}



//
// AUDITS
//
function view_audit_log(root_url, table_name, table_id)
{
	var url = root_url + "/project/view_audit_log.cfm?table_name=" + escape(table_name) + "&table_id=" + escape(table_id) + "&suppress_headers";


	ColdFusion.Window.create('view_audit_log', 'View Audit Log',
	        url,
	        {height:530,width:900,modal:true,closable:false,
	        draggable:true,resizable:true,center:true,initshow:true});
}

//
// GANTT CHART TOOLBAR
//
function email_chart(root_url, project_id, durations)
{
	var url = root_url + "/project/email_chart.cfm?project_id=" + escape(project_id) + "&durations=" + escape(durations) + "&suppress_headers";


	ColdFusion.Window.create('email_chart', 'E-Mail Chart',
	        url,
	        {height:300,width:500,modal:true,closable:false,
	        draggable:true,resizable:true,center:true,initshow:true});

}

//
// FILE ASSOCIATION
//
function associate_file(root_url, ctl_id, document_id, element_table, element_id)
{
	var assoc = 0;

	if (is_checked(ctl_id)) {
		assoc = 1;		
	}

	var url = root_url + "/documents/set_association.cfm?document_id=" + escape(document_id);
	url = url + "&element_table=" + escape(element_table) + "&element_id=" + escape(element_id);
	url = url + "&assoc=" + escape(assoc) + "&suppress_headers";

	return request(url);
}


//
// AJAX
//

function http_request_object()
{
        var xmlHttp;
        
        try {
                xmlHttp = new XMLHttpRequest();
        }
        catch (e) {
                try {
                        xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                        try {
                                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                        }
                        catch (e) {
                                return false;
                        }
                }
        }
        
        return xmlHttp;
}

function request(url)
{
        var xmlHttp;
        xmlHttp = http_request_object();
        xmlHttp.open("GET", url, false);
        xmlHttp.send(null);
        
	return xmlHttp.responseText;
}

function is_checked(ctl_id)
{
        return document.getElementById(ctl_id).checked;
}



