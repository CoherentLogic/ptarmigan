<cfset p = CreateObject("component", "ptarmigan.project").open(url.project_id)>
<cfset output_file = "#p.id#_print.pdf">
<cfset output_file_path = "#session.upload_path#/#output_file#">
	
<cfdocument format="PDF" filename="#output_file_path#" overwrite="true" pagetype="custom" pagewidth="14" pageheight="8.5">
	<style type="text/css">
	<cfinclude template="#session.root_url#/ptarmigan.css">
	</style>
	<cfmodule template="gantt.cfm" id="#url.project_id#" print="true">
</cfdocument>
	
<cfheader name="Content-Disposition" value="attachment;filename=gantt_chart_print.pdf">
<cfheader name="Content-Type" value="application/pdf">
<cfcontent type="application/x-unknown" file="#output_file_path#">