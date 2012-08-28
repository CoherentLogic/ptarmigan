<style type="text/css">
	#toolbar {
		width:100%;
		height:auto;
		background-color:gainsboro;
		border-bottom:1px solid white;
		padding:3px;
	}
	#toolbar img
	{
		margin:3px;
		border:1px solid gainsboro;
		padding:3px;
		
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