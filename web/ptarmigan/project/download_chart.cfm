<cfset p = CreateObject("component", "ptarmigan.project").open(url.project_id)>
<cfset output_file = "#p.id#_#url.durations#.pdf">
<cfset output_file_path = "#session.upload_path#/#output_file#">
	
<cfdocument format="PDF" filename="#output_file_path#" overwrite="true" pagetype="custom" pagewidth="40" pageheight="36">
	<style type="text/css">
	<cfinclude template="#session.root_url#/ptarmigan.css">
	</style>
	<cfmodule template="gantt_chart.cfm" id="#url.project_id#" mode="view" durations="#url.durations#">
</cfdocument>
	
<cfheader name="Content-Disposition" value="attachment;filename=gantt_chart_#url.durations#.pdf">
<cfheader name="Content-Type" value="application/pdf">
<cfcontent type="application/x-unknown" file="#output_file_path#">