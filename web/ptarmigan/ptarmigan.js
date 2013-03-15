/*
 * ptarmigan.js
 *   ptarmigan JavaScript support
 *
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */


var perm_root = "";

function about_ptarmigan()
{
	var url = perm_root + "/about.cfm";
	open_dialog(url, 'About Ptarmigan', 650, 450);
}

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

function add_link(source_object_id, source_object_class)
{
	var url = perm_root + "/objects/associate_object.cfm?source_object_id=" + escape(source_object_id);
	url += "&source_object_class=" + escape(source_object_class);
	
	window.location.replace(url);
}

function object_search(object_class, search_term, results_control)
{
	var url = perm_root + "/objects/object_search.cfm?object_class=" + escape(object_class);
	url += "&search_term=" + escape(search_term);
	
	var response = request(url);
	$('#' + results_control).html(response);
}

//
// REPORTS
//
function add_report(root_url)
{
	var url = root_url + "/reports/add_report.cfm";
	window.location.replace(url);
}

function refresh_filters(root_url, report_id)
{
	var add_url = root_url + "/reports/criteria.cfm?mode=add&id=" + escape(report_id);
	var edit_url = root_url + "/reports/criteria.cfm?mode=edit&id=" + escape(report_id);

	$("#add_filter_iframe").attr("src", add_url);
	$("#report_filters").html(request(edit_url));	

	$(".filter_actions").hide();
	$(".buttons").button();
}

function delete_criteria(report_id, criteria_id)
{
	var url = perm_root + "/reports/delete_criteria.cfm?id=" + escape(criteria_id) + "&report_id=" + escape(report_id);
	var resp = request(url);

	refresh_filters(perm_root, report_id);
	

}

function quick_open_report()
{
	var url = perm_root + "/reports/quick_open_dialog.cfm";
	open_dialog(url, 'Quick Report', 330, 200, function () {		
			var available_tags = eval(request(perm_root + "/reports/report_keys.cfm"));
			$("#report_key").autocomplete({ 
				source: available_tags
			});	
			$(".first_focus").bind('keydown', 'return', do_quick_report);			
		});
	
}

function do_quick_report()
{
	var url = perm_root + "/reports/quick.cfm?key=" + escape($("#report_key").val().toUpperCase());

	open_dialog_resize(url, "Quick Report", 600, 600, function () {
		$(".quick_report_viewer").dataTable();	
	});
	
}

function render_report(root_url, selector, id, mode)
{
	var url = root_url + "/reports/view_report.cfm?id=" + escape(id);
	$(selector).html(request(url));

	if (mode != "dashboard") {
		$(".report_viewer").dataTable({
        		"bJQueryUI": true,
        		"sPaginationType": "full_numbers"
			});
	}
	else {
		$(".report_viewer").dataTable();
	}
}

function update_filter(root_url, filter_id)
{
	var member_name = $("#member_name_" + filter_id).val();
	var operator = $("#operator_" + filter_id).val();
	var literal_a = $("#literal_a_" + filter_id).val();
	var url = root_url + "/reports/update_filter.cfm?id=" + escape(filter_id);
	url += "&member_name=" + escape(member_name);
	url += "&operator=" + escape(operator);
	url += "&literal_a=" + escape(literal_a);

	var response = request(url);	
}

function set_column(root_url, ctl_id, report_id, member_name)
{
	var included = 0;

	if (is_checked(ctl_id)) {
		included = 1;		
	}

	var url = root_url + "/reports/set_column.cfm?report_id=" + escape(report_id);
	url = url + "&member_name=" + escape(member_name) + "&included=" + escape(included);

	var response =  request(url);
	
	return response;
}

//
// EMPLOYEES
//
function add_employee(root_url)
{
	var url = root_url + "/employee/add_employee.cfm?suppress_headers";

	window.location.replace(url);
}

function open_employee(root_url)
{
	var url = root_url + "/employee/choose_employee.cfm";

	window.location.replace(url);

}

function edit_employee(root_url, id)
{
	var url = root_url + "/employee/edit_employee.cfm?id=" + escape(id);
	//alert(request(url));

	window.location.replace(url);
}

//
// CUSTOMERS
//
function add_customer(root_url)
{
	var url = root_url + "/customer/add_customer.cfm";
	window.location.replace(url);
}

function open_customer(root_url)
{
	var url = root_url + "/customer/choose_customer.cfm";
	window.location.replace(url);
}

function edit_customer(root_url, id)
{
	var url = root_url + "/customer/edit_customer.cfm?id=" + escape(id);
	window.location.replace(url);
}


//
// PROJECTS
//

function add_project(root_url)
{
	var url = root_url + "/project/add_project.cfm";
	window.location.replace(url);
}

function open_project(root_url)
{
	var url = root_url + "/project/choose_project.cfm?action=edit";
	open_dialog(url, 'Open Project', 630, 460);
}



function render_gantt(root_url, project_id)
{
	var url = root_url + "/project/json/gantt.cfm?id=" + escape(project_id);		
	//alert(request(url));	
	var source_var =  eval('(' + request(url) + ')');

		
	
	$(".gantt").gantt({
		source: source_var.json,
		navigate: "scroll",
		scale: "days",
		maxScale: "months",
		minScale: "days",
		itemsPerPage: 20,
		onItemClick: function(data) {
			select_element(root_url, data.element_table, data.element_id);
		},
		onAddClick: function(dt, rowId) {
		}
	});				
}

function select_element(root_url, table, id)
{

	switch(table) {
	case 'projects':
		window.location.replace(root_url + "/project/edit_project.cfm?id=" + escape(id));
		break;
	case 'milestones':
		window.location.replace(root_url + "/project/manage_milestone.cfm?id=" + escape(id));
		break;
	case 'tasks':
		window.location.replace(root_url + "/project/manage_task.cfm?id=" + escape(id));
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
// TASKS
//
function add_task(root_url, project_id)
{
	var url = root_url + "/project/add_task.cfm?project_id=" + escape(project_id);
	window.location.replace(url);
}

function delete_predecessor(task_id, predecessor_id)
{
	var url = perm_root + "/project/delete_predecessor.cfm?task_id=" + escape(task_id);
	url += "&predecessor_id=" + escape(predecessor_id);

	var response = request(url);
	window.location.reload();
}

function add_predecessor(task_id, predecessor_id, type)
{
	var url = perm_root + "/project/add_predecessor.cfm?task_id=" + escape(task_id);
	url += "&predecessor_id=" + escape(predecessor_id);
	url += "&type=" + escape(type);

	var response = request(url);
	window.location.reload();
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

function add_expense(root_url, return_to, element_table, element_id)
{
	var url = root_url + "/project/add_expense.cfm?element_table=" + escape(element_table) + "&element_id=" + escape(element_id) + "&return_to=" + escape(return_to);
	window.location.replace(url);	
}

function edit_expense(root_url, expense_id)
{
	var url = root_url + "/project/edit_expense.cfm?id=" + escape(expense_id) + "&suppress_headers";
	open_dialog(url, 'Edit Expense', 400, 480);
}

//
// DOCUMENTS
//
function add_document(root_url, return_to, source_object_id, source_object_class)
{
	var url = root_url + "/documents/add_document.cfm?return_to=" + escape(return_to);

	if (source_object_id) {
		url += "&source_object_id=" + escape(source_object_id);
		url += "&source_object_class=" + escape(source_object_class);
	}	
	
	window.location.replace(url);
}

function search_documents(root_url, parcel_to_attach)
{
	var url = root_url + "/documents/document_search.cfm";
	
	if(parcel_to_attach) {
		url += "?parcel_id=" + escape(parcel_to_attach);
	}	
	
	window.location.replace(url);
}	

function preview_show_page(page_number)
{
	alert(page_number);
}

//
// PARCELS
//
function search_parcels(root_url, document_to_attach)
{
	var url = root_url + "/parcels/parcel_search.cfm";

	if(document_to_attach) {
		url += "?document_id=" + escape(document_to_attach);
	}	

	window.location.replace(url);
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
function email_chart(root_url, project_id)
{
	var url = root_url + "/project/email_chart.cfm?project_id=" + escape(project_id);


	open_dialog(url, 'E-Mail Chart', 500, 300);
}

function print_chart(root_url, project_id)
{
	var url = root_url + "/project/print_chart.cfm?project_id=" + escape(project_id);
	window.open(url);	
}

function download_chart(root_url, project_id)
{
	var url = root_url + "/project/download_chart.cfm?project_id=" + escape(project_id);
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
// PAGE UTILITIES
//
function init_page()
{
	$(".pt_tabs").tabs();
	$(".pt_dates").datepicker();
	$(".pt_buttons").button();
	$(".first_focus").focus();
}

//
// DIALOG UTILITIES
//
function form_submit(form_id)
{
	document.getElementById('self_post').value = "submit";
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


function open_dialog(url, caption, width, height, on_loaded)
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
		//alert(responseText);               	
		dialog.removeClass('loading');
		$(".ui-dialog .ui-dialog-content").css("padding", "0");
		$(".pt_tabs").tabs();
		$(".pt_dates").datepicker();
		$(".pt_buttons").button();
		$(".first_focus").focus();
		$(".pt_tables").dataTable();		
		if(on_loaded) {
			on_loaded();
		}
            }
        );

	
	

        //prevent the browser from following the link
        return false;
}

function open_dialog_resize(url, caption, width, height, on_loaded)
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
	    minWidth: width,
	    minHeight: height,
	    show: "fold",
	    hide: "fade",
	    title: caption,
	    resizable: true
        });
        // load remote content
        dialog.load(
            url,		
	    null,
            function (responseText, textStatus, XMLHttpRequest) {		     
		// remove the loading class
		//alert(responseText);               	
		dialog.removeClass('loading');
		$(".ui-dialog .ui-dialog-content").css("padding", "0");
		$(".pt_tabs").tabs();
		$(".pt_dates").datepicker();
		$(".pt_buttons").button();
		$(".first_focus").focus();

		if(on_loaded) {
			on_loaded();
		}
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

//
// BOUND FIELDS
//

function bound_fields_init()
{
	$(".bound-control-date").datepicker();
	$(".bound-field-button").button().css("float", "right");
}

function bound_field_show_pencil(base_id) 
{
	var pencil = "#bound-field-pencil-" + base_id;
	$(pencil).show();
}

function bound_field_hide_pencil(base_id) 
{
	var pencil = "#bound-field-pencil-" + base_id;
	$(pencil).hide();
}
	
function bound_field_activate(base_id)
{
	var value_id = "#bound-value-" + base_id;
	var edit_id = "#bound-edit-div-" + base_id;
	var edit_control = "#bound-edit-" + base_id;	
	var wrapper = "#bound-control-wrapper-" + base_id;
	$("#dynamic_field_editor").append($(wrapper));	
	$(wrapper).addClass("bound-control-wrapper-editing");

	
	$(value_id).hide();
	$(edit_id).fadeIn();
	$(edit_control).focus();
	$(edit_control).select();

}

function bound_field_township_update(base_id)
{
	var value_id = "#bound-value-" + base_id;
	var edit_id = "#bound-edit-div-" + base_id;
	var edit_control = "#bound-edit-" + base_id;	
	var edit_conum = "#bound-edit-conum-" + base_id;
	var edit_comment = "#bound-edit-comment-" + base_id;
	var edit_original = "#bound-edit-original-" + base_id;

	var township_direction = "#bound-township-direction-" + base_id;
	var township = "#bound-township-" + base_id;

	$(edit_control).val($(township).val() + $(township_direction).val());

}

function bound_field_range_update(base_id)
{
	var value_id = "#bound-value-" + base_id;
	var edit_id = "#bound-edit-div-" + base_id;
	var edit_control = "#bound-edit-" + base_id;	
	var edit_conum = "#bound-edit-conum-" + base_id;
	var edit_comment = "#bound-edit-comment-" + base_id;
	var edit_original = "#bound-edit-original-" + base_id;

	var range_direction = "#bound-range-direction-" + base_id;
	var range = "#bound-range-" + base_id;

	$(edit_control).val($(range).val() + $(range_direction).val());


}

function bound_field_submit(base_id, object_id, member, full_refresh)
{
	var value_id = "#bound-value-" + base_id;
	var edit_id = "#bound-edit-div-" + base_id;
	var edit_control = "#bound-edit-" + base_id;	
	var edit_conum = "#bound-edit-conum-" + base_id;
	var edit_comment = "#bound-edit-comment-" + base_id;
	var edit_original = "#bound-edit-original-" + base_id;
	
	var original_value = $(edit_original).val();
	var new_value = $(edit_control).val();
	var conum = $(edit_conum).val();
	var comment = $(edit_comment).val();

	var wrapper = "#bound-control-wrapper-" + base_id;
	
	
	$(wrapper).removeClass("bound-control-wrapper-editing");
	
	var url = perm_root + "/objects/update_bound_field.cfm?id=" + escape(object_id);
	url += "&member_name=" + escape(member);
	url += "&value=" + escape(new_value);
	url += "&original=" + escape(original_value);
	url += "&conum=" + escape(conum);
	url += "&comment=" + escape(comment);

	$(value_id).html(request(url));
	$(edit_id).hide();	
	$(value_id).fadeIn();	

	if(full_refresh == true) {
		window.location.reload();
	}
}

function bound_field_revert(base_id, original_value)
{
	var value_id = "#bound-value-" + base_id;
	var edit_id = "#bound-edit-div-" + base_id;
	var edit_control = "#bound-edit-" + base_id;	
	var wrapper = "#bound-control-wrapper-" + base_id;
	$(wrapper).removeClass("bound-control-wrapper-editing");
	$(value_id).html(original_value);
	$(edit_id).hide();	
	$(value_id).fadeIn();		
}


//
// FIXES FOR CFCHART WEIRDNESS
//

var __xx_set_visible = {};
function xx_set_visible(imgId, tipId, e, show){
    // get the table we're going to show
    var $tip = $("#" + tipId);
    if( !__xx_set_visible[tipId] ){
        // move to the body and make visible
        $tip.appendTo("body").css("visibility", "visible");
        __xx_set_visible[tipId] = true;
    }
    $tip[show ? "show" : "hide"]();
    // make sure we place the tip in the correct location
    xx_move_tag(imgId, tipId, e);
}
function xx_move_tag(imgId, tipId, e){
    // get the table we're going to show
    var $tip = $("#" + tipId);
    // get the scroll offsets
    var scroll = {top: $(window).scrollTop(), left: $(window).scrollLeft()};
    // if we're IE we need to create the e.pageX/pageY events    
    if( !e.pageY ){
        e.pageY = e.clientY + scroll.top;
        e.pageX = e.clientX + scroll.left;
    }
    var pos = {top: e.pageY + 20, left: e.pageX + 10}; // add padding for cursor
    var tip = {width: $tip.outerWidth() + 10, height: $tip.outerHeight() + 10}; // add padding for edge
    var screen = {right: scroll.left + $("body").width(), bottom: scroll.top + $(window).height()};
    // if we're going to be off the screen, adjust the position
    if( pos.left + tip.width > screen.right ){
        // don't move past most right of screen
        pos.left = screen.right - tip.width; // pos.left - tip.width || screen.right - tip.width - 10;
    }
    if( pos.top + tip.height > screen.bottom ){
        // don't move past most right of screen
        pos.top = pos.top - tip.height - 15; // since we're moving tip above we need adjust for the original padding we add
    }
    // position the
    $tip.css(pos);
} 
