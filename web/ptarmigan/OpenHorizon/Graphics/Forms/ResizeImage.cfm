<html>
<head>
	<title>Resize Image</title>
	<link rel="stylesheet" href="/OpenHorizon/Resources/Styles/OpenHorizon.css"/>
</head>	
<body>
<cfif IsDefined("form.Submit")>
	<cfparam name="img" default="">
	<cfset img = createObject('component', 'OpenHorizon.Graphics.Image')>
	<cfset outputImg = img.Create(Form.URL, Form.Width, Form.Height)>
	
	<div style="border:1px solid gray;">
		<h1>Resized Image</h1>
		<cfoutput>
		<p>#Form.URL#</p>
		<img src="#outputImg#">
		</cfoutput>
	</div>
	
	
<cfelse>
	<cfform name="Login" width="400" format="xml" preservedata="true" action="/OpenHorizon/Graphics/Forms/ResizeImage.cfm" method="post">
        <cfformgroup type="fieldset" label="Resize Image">
            <cfformgroup type="vertical">
                <cfinput type="text" size="20" name="URL" label="URL" required="yes">
                <cfinput type="text" name="width" label="Width" required="yes" value="0">        
                <cfinput type="text" name="height" label="height" required="yes" value="0">        
                
				<cfinput type="submit" name="submit" label="Submit" value="Submit" align="right" style="float:right;">
            </cfformgroup>
         </cfformgroup>
    </cfform>
</cfif>	

</body>
</html>
