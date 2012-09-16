
<cflayout type="tab">
  <cflayoutarea title="Create Timesheet" style="padding:20px; background-color:white;">
    <cfform name="Login" width="400" format="xml" preservedata="true" action="/OpenHorizon/Identity/Forms/Login.cfm" method="post">
        <cfformgroup type="fieldset" label="Timesheet Info">
            <cfformgroup type="vertical">
                <cfinput type="text" size="20" name="Name" label="Your Name" value="#session.User.FullName()#" required="yes">
                <cfinput type="datefield" name="date" label="Timesheet Date" required="yes">        
				<cfinput type="text" name="tcdesc" label="Timesheet Description" required="yes">
				<cfinput type="text" name="timein" label="Time In" required="yes">
				
                <cfinput type="submit" name="submit" label="Create Timesheet" value="Submit" align="right" style="float:right;">
            </cfformgroup>
         </cfformgroup>
    </cfform>  
  </cflayoutarea>
  
 </cflayout>
