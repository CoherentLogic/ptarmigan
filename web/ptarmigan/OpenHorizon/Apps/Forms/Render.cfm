<cfajaximport tags="cfajaxproxy,cfgrid,cfform,cflayout-border,cftree,cflayout-tab,cfwindow">

<cflayout type="border">

    <cflayoutarea position="top">
    <!--- 	<div style="width:100%; height:50px; background-image:url(/graphics/LightBlueGradient.jpg); background-repeat:repeat-x;">
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/filenew.png" class="_PPM_TOOLBAR_IMAGE"/>
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/fileprint.png" class="_PPM_TOOLBAR_IMAGE" />
        <img src="http://us-production-r1g1s1.prefiniti.com/graphics/AppIconResources/crystal_project/32x32/actions/find.png"  class="_PPM_TOOLBAR_IMAGE"/>
        </div>
     --->    
    
    </cflayoutarea>

	<cflayoutarea position="center">
		<cfinclude template="/OpenHorizon/HomeView/Toolbar.cfm">		
			
        <cflayout type="tab" name="Project">
            <cflayoutarea name="Information" title="Information" style="height:200px;">
            	<cfdump var="#url#">
                
            </cflayoutarea>          
        </cflayout>
	</cflayoutarea>

	<cflayoutarea position="left" splitter="true" collapsible="true" size="200" maxsize="200" initCollapsed="false">
	        
		<!---><cfpod height="300" width="180" title="Messaging">
		bloop
		</cfpod> --->     
    
	</cflayoutarea>
	
	<cflayoutarea position="bottom" style="background-color:##c0c0c0; text-align:right; height:20px;">
		<cfset img = createObject("component", "OpenHorizon.Graphics.Image")>
		<cfoutput><img src="#img.Silk('Email Open', 16)#"></cfoutput>
	</cflayoutarea>


</cflayout>