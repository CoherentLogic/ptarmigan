<cfparam name="ctx" default="">
<cfset ctx = CreateObject("component", "workFlow.PPM.ppm_context")>
<cfset ctx.Open("Project", url.ppm_project_id, session.user_id)>

<html>
<head>
	<link rel="stylesheet" href="/workFlow/PPM/ppm.css" />
	<title><cfoutput>#ctx.GetField('clsJobNumber')#</cfoutput> - Prefiniti Projects</title>

	<script type="text/javascript" src="/workFlow/PPM/ppm.js"></script>

</head>
<body>
<cfset session.user_id=url.user_id>
<cfset session.site_id=url.site_id>



<cfquery name="getProjects" datasource="webwarecl">
	SELECT * FROM projects WHERE site_id=#url.site_id# ORDER BY clsJobNumber DESC
</cfquery>

<cfajaximport tags="cfajaxproxy,cfgrid,cfform,cflayout-border,cftree,cflayout-tab,cfwindow">

<cflayout type="border">

    <cflayoutarea position="top" title="Project #ctx.GetField('clsJobNumber')#">
    	<div style="width:100%; height:50px; background-image:url(/graphics/LightBlueGradient.jpg); background-repeat:repeat-x;">
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/filenew.png" class="_PPM_TOOLBAR_IMAGE"/>
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/fileprint.png" class="_PPM_TOOLBAR_IMAGE" />
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/find.png"  class="_PPM_TOOLBAR_IMAGE"/>
        </div>
        
    
    </cflayoutarea>

	<cflayoutarea position="center">		
        <cflayout type="tab" name="Project">
            <cflayoutarea name="Information" title="Information" style="height:100%"  >
            	<cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="clsJobNumber" Label="Project Number">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="description" Label="Description">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="jobtype" Label="Job Type">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="specialinstructions" Label="Special Instructions">
                
                <!--- TESTING CODE --->
                <cfparam name="util" default="">
                <cfset util = CreateObject("component", "workFlow.PPM.util")>
                
                <cfparam name="ta" default="">
                <cfparam name="ts" default="">
                
                <cfset ts = 'FIELD REQUIRED OF Text:Plain FROM Form IN clsJobNumber DEFAULT NONE LABEL "Project Number"'>
                
                <cfset ta = util.parse_line(ts)>
                
                <cfdump var="#ta#">
               
            
                
            </cflayoutarea>
            <cflayoutarea name="Status" title="Status">
                   
            </cflayoutarea>
            <cflayoutarea name="Location" title="Location">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="address" Label="Address">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="city" Label="City">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="state" Label="State">
                <cfmodule template="/workFlow/PPM/FieldViewers/Text.cfm" Context="Project" Selector="#url.ppm_project_id#" Field="zip" Label="ZIP">
            
            </cflayoutarea>
            <cflayoutarea name="Billing" title="Billing">
                   
            </cflayoutarea>
        </cflayout>
	</cflayoutarea>

	<cflayoutarea position="left" title="Projects" splitter="true" collapsible="true" size="200" maxsize="200">
	<h3>Newest Projects</h3>
    <blockquote>
    	
		<cfoutput query="getProjects" maxrows="10">
        	<a href="/workFlow/PPM/View.cfm?ppm_project_id=#id#&user_id=#session.user_id#&site_id=#session.site_id#">#clsJobNumber#</a><br />
		</cfoutput>            
    
	</blockquote>
	</cflayoutarea>


</cflayout>

</body>
</html>
