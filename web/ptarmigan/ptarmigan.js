/*
 * ptarmigan.js
 *   ptarmigan JavaScript support
 *
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */


//
// EMPLOYEES
//
function add_employee(root_url)
{
	var url = root_url + "/employee/add_employee.cfm?suppress_headers";
	
	ColdFusion.Window.create('add_employee', 'Add Employee',
	        url,
	        {height:550,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
}

//
// CUSTOMERS
//
function add_customer(root_url)
{
	var url = root_url + "/customer/add_customer.cfm";


	ColdFusion.Window.create('add_customer', 'Add Customer',
	        url,
	        {height:550,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});

}

//
// PROJECTS
//

function add_project(root_url)
{
	var url = root_url + "/project/add_project.cfm";
	
	ColdFusion.Window.create('add_project', 'Add Project',
	        url,
	        {height:560,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
}

function open_project(root_url)
{
	var url = root_url + "/project/choose_project.cfm?action=edit";

	
	ColdFusion.Window.create('add_project', 'Add Project',
	        url,
	        {height:460,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
}

function render_gantt(root_url, project_id, durations)
{
	var url = root_url + "/project/json/gantt.cfm?id=" + escape(project_id) + "&durations=" + escape(durations);
	var source_var =  eval('(' + request(url) + ')');
		
	$(".gantt").gantt({
		source: source_var.json,
		navigate: "scroll",
		scale: "days",
		maxScale: "months",
		minScale: "days",
		itemsPerPage: 20,
		onItemClick: function(data) {
			select_element(root_url, data.element_table, data.element_id, data.button_caption);
		},
		onAddClick: function(dt, rowId) {
		}
	});				
}

function select_element(root_url, table, id, button_caption)
{
	var url = root_url + "/project/element_menu.cfm?current_element_table=" + escape(table) + "&current_element_id=" + escape(id);

	$("#current_element_table").val(table);
	$("#current_element_id").val(id);
	$("#current_element_menu .ui-button-text").text(button_caption);

	$("#current_element_menubox").html(request(url));

}

function edit_current_element(root_url)
{
	var element_table = $("#current_element_table").val();
	var element_id = $("#current_element_id").val();
	

	switch(element_table) {
	case 'projects':
		break;
	case 'milestones':
		edit_milestone(root_url, element_id);
		break;
	case 'tasks':
		edit_task(root_url, element_id);
		break;
	}
	
}

function menu_current_element(root_url)
{
	
}

//
// MILESTONES
//
function add_milestone(root_url, project_id)
{
	var url = root_url + "/project/add_milestone.cfm?id=" + escape(project_id) + "&suppress_headers";
	
	ColdFusion.Window.create('add_milestone', 'Add Milestone',
	        url,
	        {height:530,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
	
}

function edit_milestone(root_url, id)
{
	var url = root_url + "/project/edit_milestone.cfm?id=" + escape(id) + "&suppress_headers";
	
	ColdFusion.Window.create('edit_milestone', 'Edit Milestone',
	        url,
	        {height:530+90,width:830,modal:false,closable:false,
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
	        {height:600,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
}

function edit_task(root_url, task_id, milestone_id)
{
	var url = root_url + "/project/edit_task.cfm?id=" + escape(task_id) + "&milestone_id=" + escape(milestone_id) + "&suppress_headers";


	ColdFusion.Window.create('edit_task', 'Edit Task',
	        url,
	        {height:650,width:830,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
}

//
// CHANGE ORDERS
//
function add_change_order(root_url, project_id)
{
	var url = root_url + "/project/add_change_order.cfm?id=" + escape(project_id);

	ColdFusion.Window.create('add_change_order', 'Add Change Order',
	        url,
	        {height:650-230,width:830-329,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
}

function edit_change_order(root_url)
{
	
}

function apply_change_order(root_url, project_id)
{
	var url = root_url + "/project/apply_change_order.cfm?project_id=" + escape(project_id);

	ColdFusion.Window.create('apply_change_order', 'Apply Change Order',
	        url,
	        {height:650,width:830-240,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});
	
}

function set_apply_controls() 
{
	var radio_obj = document.getElementsByName('apply_to');

	reset_apply_controls();

	switch(radio_checked(radio_obj)) 
	{
	case 'new_task':
		document.getElementById('new_task_controls').style.display = 'block';
		break;
	case 'existing_task':
		document.getElementById('existing_task_controls').style.display = 'block';
		break;
	case 'new_milestone':
		document.getElementById('new_milestone_controls').style.display = 'block';
		break;
	case 'existing_milestone':
		document.getElementById('existing_milestone_controls').style.display = 'block';
		break;
	}
}

function reset_apply_controls()
{
	document.getElementById('new_milestone_controls').style.display = "none";
	document.getElementById('new_task_controls').style.display = "none";
	document.getElementById('existing_milestone_controls').style.display = "none";
	document.getElementById('existing_task_controls').style.display = "none";

}

//
// EXPENSES
//

function add_expense(root_url, element_table, element_id)
{
	var url = root_url + "/project/add_expense.cfm?element_table=" + escape(element_table) + "&element_id=" + escape(element_id) + "&suppress_headers";


	ColdFusion.Window.create('add_expense', 'Add Expense',
	        url,
	        {height:480,width:400,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
	
}

function edit_expense(root_url, expense_id)
{
	var url = root_url + "/project/edit_expense.cfm?id=" + escape(expense_id) + "&suppress_headers";

	ColdFusion.Window.create('edit_expense', 'Edit Expense',
	        url,
	        {height:480,width:400,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});		
}

//
// DOCUMENTS
//
function add_document(root_url)
{
	var url = root_url + "/documents/add_document.cfm?suppress_headers";

	ColdFusion.Window.create('add_document', 'Add Document',
	        url,
	        {height:560,width:630,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	


}

function search_documents(root_url, parcel_to_attach)
{
	var url = root_url + "/documents/document_search.cfm";
	
	if(parcel_to_attach) {
		url += "?parcel_id=" + escape(parcel_to_attach);
	}	

	ColdFusion.Window.create('document_search', 'Document Search',
	        url,
	        {height:780-380,width:1024-350,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	
}	

function search_documents_complete(response_text)
{
	document.getElementById('results_area').innerHTML = response_text;
	document.getElementById('submit_link').style.display = "none";
	document.getElementById('cancel_button').innerHTML = "<span>Close</span>";
}

//
// PARCELS
//
function search_parcels(root_url, document_to_attach)
{
	var url = root_url + "/parcels/parcel_search_wrapper.cfm";

	if(document_to_attach) {
		url += "?document_id=" + escape(document_to_attach);
	}	

	ColdFusion.Window.create('parcel_search', 'Parcel Search',
	        url,
	        {height:850,width:1024,modal:false,closable:false,
	        draggable:true,resizable:false,center:true,initshow:true});	


}	

function search_parcels_complete(response_text)
{
	document.getElementById('results_area').innerHTML = response_text;
	document.getElementById('submit_link').style.display = "none";
	document.getElementById('cancel_button').innerHTML = "<span>Close</span>";
}


// documents only
function associate_parcel_with_document(root_url, parcel_id, document_id)
{
	var url = root_url + "/documents/set_association.cfm?document_id=" + escape(document_id);
	url = url + "&element_table=parcels&element_id=" + escape(parcel_id);
	url = url + "&assoc=1&suppress_headers";

	var ret_val = request(url);

	window.location.reload();
}

// for associating parcels with projects, etc.
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
	        {height:530,width:900,modal:false,closable:false,
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
	        {height:300,width:500,modal:false,closable:false,
	        draggable:true,resizable:true,center:true,initshow:true});

}

function print_chart(root_url, project_id, durations)
{
	var url = root_url + "/project/print_chart.cfm?project_id=" + escape(project_id) + "&durations=" + escape(durations);

	window.open(url);	


}

function download_chart(root_url, project_id, durations)
{
	var url = root_url + "/project/download_chart.cfm?project_id=" + escape(project_id) + "&durations=" + escape(durations);

	window.open(url);
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
// DIALOG UTILITIES
//
function form_submit(form_id)
{
	document.getElementById('self_post').value="submit";
	document.forms[form_id].submit();
}

function add_days(root_url, start_date_control, end_date_control, days_control, exclude_weekends_control)
{
	var start_date = document.getElementById(start_date_control).value;
	var days = document.getElementById(days_control).value;
	var exclude_weekends = is_checked(exclude_weekends_control);
	var url = root_url + "/utilities/add_days.cfm?start_date=" + escape(start_date) + "&days=" + escape(days) + "&exclude_weekends=" + escape(exclude_weekends);

	document.getElementById(end_date_control).value = request(url);
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

function radio_checked(radioObj) 
{
	if(!radioObj)
		return "";
	var radioLength = radioObj.length;
	if(radioLength == undefined)
		if(radioObj.checked)
			return radioObj.value;
		else
			return "";
	for(var i = 0; i < radioLength; i++) {
		if(radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
	return "";
}

//
// HELP
//

function open_help(root_url, page) 
{
	var url = "http://www.coherent-logic.com/ptarmigan/wiki/index.php/" + escape(page);

	window.open(url, page, "width=1024,height=768");

	/*ColdFusion.Window.create('add_document', 'Add Document',
	        url,
	        {height:560,width:630,modal:false,closable:false,
	        draggable:true,resizable:true,center:true,initshow:true});*/

}


