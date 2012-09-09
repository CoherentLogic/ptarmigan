/*
 * ptarmigan.js
 *   ptarmigan JavaScript support
 *
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */

$.fx.speeds._default = 1000;

//
// OBJECTS (GENERAL)
//
function trash_object(root_url, id)
{
	var url = root_url + "/objects/trash_object.cfm?id=" + escape(id);
	open_dialog(url, 'Move to Trash', 500, 400);
}

function trash_can(root_url)
{
	var url = root_url + "/objects/trash_can.cfm";
	open_dialog(url, 'Trash Can', 700, 500);
}

function restore_trashcan_event(root_url, id)
{
	var url = root_url + "/objects/restore_trashcan_event.cfm?id=" + escape(id);
	var response = request(url);
	window.location.reload();
}

function empty_trash(root_url)
{
	var url = root_url + "/objects/empty_trash.cfm";
	var response = request(url);
	window.location.reload();
}

//
// EMPLOYEES
//
function add_employee(root_url)
{
	var url = root_url + "/employee/add_employee.cfm?suppress_headers";

	open_dialog(url, 'Add Employee', 630, 550);
}

function open_employee(root_url)
{
	var url = root_url + "/employee/choose_employee.cfm";

	open_dialog(url, 'Open Employee', 630, 460);

}

function edit_employee(root_url, id)
{
	var url = root_url + "/employee/edit_employee.cfm?id=" + escape(id);
	open_dialog(url, 'Edit Employee', 630, 550);
}

//
// CUSTOMERS
//
function add_customer(root_url)
{
	var url = root_url + "/customer/add_customer.cfm";
	open_dialog(url, 'Add Customer', 630, 550);
}

function open_customer(root_url)
{
	var url = root_url + "/customer/choose_customer.cfm";
	open_dialog(url, 'Open Customer', 630, 460);
}

function edit_customer(root_url, id)
{
	var url = root_url + "/customer/edit_customer.cfm?id=" + escape(id);
	open_dialog(url, 'Edit Customer', 630, 550);
}


//
// PROJECTS
//

function add_project(root_url)
{
	var url = root_url + "/project/add_project.cfm";
	open_dialog(url, 'Add Project', 630, 560);
}

function open_project(root_url)
{
	var url = root_url + "/project/choose_project.cfm?action=edit";
	open_dialog(url, 'Open Project', 630, 460);
}

function edit_project(root_url, project_id)
{
	var url = root_url + "/project/project_properties.cfm?id=" + escape(project_id);

	open_dialog(url, 'Edit Project', 630, 700);
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

	switch(table) {
	case 'projects':
		$("#edit_proj").button();
		$("#add_ms").button();
		$("#add_co").button();
		$("#apply_co").button();
		$("#delete_project").button();
		break;
	case 'milestones':
		$("#edit_ms").button();
		$("#add_task").button();
		$("#add_expense").button();
		$("#view_ms_audit_log").button();
		$("#delete_ms").button()
		break;
	case 'tasks':
		$("#edit_task").button();
		$("#add_expense_task").button();
		$("#view_task_audit_log").button();
		$("#delete_task").button()
		break;
	}
}

function durations()
{
	return radio_checked(document.getElementsByName("view_duration"));
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
	open_dialog(url, 'Add Milestone', 630, 530);
}

function edit_milestone(root_url, id)
{
	var url = root_url + "/project/edit_milestone.cfm?id=" + escape(id) + "&suppress_headers";
	open_dialog(url, 'Edit Milestone', 830, 530 + 90);
}

//
// TASKS
//
function add_task(root_url, project_id, milestone_id)
{
	var url = root_url + "/project/add_task.cfm?id=" + escape(project_id) + "&milestone_id=" + escape(milestone_id) + "&suppress_headers";
	open_dialog(url, 'Add Task', 630, 600);
}

function edit_task(root_url, task_id, milestone_id)
{
	var url = root_url + "/project/edit_task.cfm?id=" + escape(task_id) + "&milestone_id=" + escape(milestone_id) + "&suppress_headers";
	open_dialog(url, 'Edit Task', 830, 650);
}

//
// CHANGE ORDERS
//
function add_change_order(root_url, project_id)
{
	var url = root_url + "/project/add_change_order.cfm?id=" + escape(project_id);
	open_dialog(url, 'Add Change Order', 830 - 329, 650 - 230);	
}

function edit_change_order(root_url)
{
	
}

function apply_change_order(root_url, project_id)
{
	var url = root_url + "/project/apply_change_order.cfm?project_id=" + escape(project_id);
	open_dialog(url, 'Apply Change Order', 830- 240, 650);
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
	open_dialog(url, 'Add Expense', 400, 480);	
}

function edit_expense(root_url, expense_id)
{
	var url = root_url + "/project/edit_expense.cfm?id=" + escape(expense_id) + "&suppress_headers";
	open_dialog(url, 'Edit Expense', 400, 480);
}

//
// DOCUMENTS
//
function add_document(root_url)
{
	var url = root_url + "/documents/add_document.cfm?suppress_headers";
	open_dialog(url, 'Add Document', 630, 560);
}

function search_documents(root_url, parcel_to_attach)
{
	var url = root_url + "/documents/document_search.cfm";
	
	if(parcel_to_attach) {
		url += "?parcel_id=" + escape(parcel_to_attach);
	}	
	
	open_dialog(url, 'Search Documents', 1024-350, 780-380);
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

	open_dialog(url, 'Search Parcels', 1024, 850);
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

	open_dialog(url, 'View Audit Log', 900, 530);
}

//
// GANTT CHART FUNCTIONS
//
function email_chart(root_url, project_id, durations)
{
	var url = root_url + "/project/email_chart.cfm?project_id=" + escape(project_id) + "&durations=" + escape(durations) + "&suppress_headers";


	open_dialog(url, 'E-Mail Chart', 500, 300);
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


function open_dialog(url, caption, width, height)
{
	// show a spinner or something via css
	var dialog = $('<div style="display:none" class="loading"></div>').appendTo('body');
        // open the dialog
        dialog.dialog({
            // add a close listener to prevent adding multiple divs to the document
            close: function(event, ui) {
                // remove div with all data and events
                dialog.remove();
            },
            modal: false,
	    width: width,
	    height: height,
	    show: "fold",
	    hide: "fade",
	    title: caption,
	    resizable: false
        });
        // load remote content
        dialog.load(
            url,		
	    null,
            function (responseText, textStatus, XMLHttpRequest) {		     
		// remove the loading class
		alert(responseText);               	
		dialog.removeClass('loading');
		$(".ui-dialog .ui-dialog-content").css("padding", "0");
		$(".pt_tabs").tabs();
		$(".pt_dates").datepicker();
            }
        );

	
	

        //prevent the browser to follow the link
        return false;
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
}


