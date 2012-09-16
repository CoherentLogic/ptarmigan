<!--- Open Horizon Login.cfm $Revision: 1.5 $ --->
<html>
<head>
	<title>Open Horizon</title>
	<link rel="stylesheet" href="/OpenHorizon/Resources/Styles/OpenHorizon.css">
</head>
    
<body>

<cfif IsDefined("form.Submit")>
	
    <cfscript>
		
	
		 	tmpUser = createObject("component", "OpenHorizon.Identity.User");
			tmpUser.Open(form.username);
			
			if(tmpUser.Authenticate(form.password)) {
				
				tmpUser.OpenSession(CGI.REMOTE_ADDR, CGI.REMOTE_HOST, CGI.HTTP_USER_AGENT);
				
				session.User = tmpUser;
			
			}
			else {
				WriteOutput("Authentication failed.");
			}
	
	
			
		
		
	</cfscript>
    
	
    <cflocation url="/OpenHorizon/exec.cfm?p=Prefiniti.Community.Basic.Home.0" addtoken="no">
<cfelse>

<div style="color:black;width:550px; height:500px; background-color:white; margin-left:auto; margin-right:auto; margin-top:40px" align="center" >
   
	<img src="/OpenHorizon/Resources/Graphics/OpenHorizon/prefiniti.png" style="margin:20px;">

<cflayout type="tab" tabheight="175" style="width:450px; margin-left:auto; margin-right:auto; background-color:white;" align="center" tabposition="bottom">
  <cflayoutarea title="Existing Account" style="padding:20px; background-color:white;">
    <cfform name="Login" width="400" format="xml" preservedata="true" action="/OpenHorizon/Identity/Forms/Login.cfm" method="post">
        <cfformgroup type="fieldset" label="Please enter your username and password">
            <cfformgroup type="vertical">
                <cfinput type="text" size="20" name="username" label="Username" required="yes">
                <cfinput type="password" name="password" label="Password" required="yes">        
                <cfinput type="submit" name="submit" label="Submit" value="Submit" align="right" style="float:right;">
            </cfformgroup>
         </cfformgroup>
    </cfform>  
  </cflayoutarea>
  <cflayoutarea title="New Account">tab 2 content</cflayoutarea>
   
 </cflayout>

 <br>
 <p style="color:black; font-size:8px;">Copyright &copy; 2010</p>
 
 </div>


</cfif>
</body>
</html>
