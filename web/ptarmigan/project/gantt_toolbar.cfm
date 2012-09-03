<style type="text/css">
	#toolbar {
		width:100%;
		height:auto;
		background-color:white;
		//border:1px solid navy;
		padding:3px;
		border-radius:4px;
		//background-image:url(/ptarmigan/jquery_ui/css/redmond/images/ui-bg_gloss-wave_55_5c9ccc_500x100.png);
		margin-bottom:5px;
	}
	#toolbar img
	{
		margin:3px;
		border:1px solid gainsboro;
		padding:3px;
		border-radius:4px;
		background-color:gainsboro;
		
	}
	
	#toolbar img:hover
	{
		border-left:1px solid white;
		border-top:1px solid white;
		border-right:1px solid gray;
		border-bottom:1px solid gray;
	}
	#toolbar img:active
	{
		border-left:1px solid gray;
		border-top:1px solid gray;
		border-right:1px solid white;
		border-bottom:1px solid white;
	}
</style>
<div id="toolbar">
	<cfoutput>
	<img src="../images/download.png" onclick="download_chart('#session.root_url#', '#attributes.project_id#', '#attributes.durations#')"  onmouseover="Tip('Download this chart');" onmouseout="UnTip();">
	<img src="../images/print.png" onclick="print_chart('#session.root_url#', '#attributes.project_id#', '#attributes.durations#')" onmouseover="Tip('Print this chart');" onmouseout="UnTip();"> 
	<img src="../images/e-mail.png" onclick="email_chart('#session.root_url#', '#attributes.project_id#', '#attributes.durations#')" onmouseover="Tip('E-mail this chart');" onmouseout="UnTip();">
	</cfoutput>
</div>