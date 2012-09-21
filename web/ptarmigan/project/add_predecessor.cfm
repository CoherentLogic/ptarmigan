<cfmodule template="#session.root_url#/security/require.cfm" type="project">
<cfset task = CreateObject("component", "ptarmigan.task").open(url.task_id)>
<cfset pred = CreateObject("component", "ptarmigan.task").open(url.predecessor_id)>
<cfset task.add_predecessor(url.predecessor_id)>
<cfset session.message = "Predecessor #pred.task_name# [FS] added to #task.task_name#.">