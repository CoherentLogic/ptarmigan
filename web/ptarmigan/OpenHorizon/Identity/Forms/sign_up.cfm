<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<!---    <cffunction name="Create" access="public" returntype="OpenHorizon.Identity.User" output="no">    
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="password_question" type="string" required="yes">
		<cfargument name="password_answer" type="string" required="yes">		        
        <cfargument name="email" type="string" required="yes">
		<cfargument name="first_name" type="string" required="yes">
		<cfargument name="middle_initial" type="string" required="yes">
		<cfargument name="last_name" type="string" required="yes">
		<cfargument name="gender" type="string" required="yes">
		<cfargument name="birthday" type="string" required="yes">		
        <cfargument name="allow_search" type="boolean" required="yes">
		<cfargument name="zip_code" type="string" required="yes">       
--->		
<body>
	<form name="SignUp" id="SignUp" method="post" action="/OpenHorizon/Identity/Forms/sign_up.cfm">
	<table>
    	<tr>
        	<td align="right"><strong>Username</strong></td>
            <td align="left"><input type="text" name="username" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>Password</strong></td>
            <td align="left"><input type="password" name="password" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>Password Question</strong></td>
            <td align="left"><input type="text" name="password_question" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>Password Answer</strong></td>
            <td align="left"><input type="text" name="password_answer" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>E-Mail Address</strong></td>
            <td align="left"><input type="text" name="email" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>First Name</strong></td>
            <td align="left"><input type="text" name="first_name" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>Middle Initial</strong></td>
            <td align="left"><input type="text" name="middle_initial" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>Last Name</strong></td>
            <td align="left"><input type="text" name="last_name" /></td>
        </tr>
        <tr>
        	<td align="right"><strong>Gender</strong></td>
            <td align="left">
            	<select name="gender" id="gender" size="1">
                	<option value="F" selected>Female</option>
                    <option value="M">Male</option>
                </select>
            </td>
        </tr>
        <tr>
        	<td align="right"><strong>Birthday</strong></td>
            <td align="left"><cfmodule template="/controls/date_picker.cfm" startdate="#DateAdd('yyyy', -13, Now())#" ctlname="birthday"></td>
        </tr>
        <tr>
        	<td align="right"><strong>ZIP Code</strong></td>
            <td align="left"><input type="text" name="zip_code" /></td>
        </tr>        
	</table>   
    </form>             	                        
</body>
</html>
