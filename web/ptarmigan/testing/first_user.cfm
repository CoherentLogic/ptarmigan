<cfset nu = CreateObject("component", "ptarmigan.employee")>

<cfset nu.username = "jollis">
<cfset nu.password_hash = hash("VkrP15a1")>
<cfset nu.active = 1>
<cfset nu.honorific = "Mr.">
<cfset nu.first_name = "John">
<cfset nu.middle_initial = "P">
<cfset nu.last_name = "Willis">
<cfset nu.suffix = "">
<cfset nu.gender = "M">
<cfset nu.title = "Founder">
<cfset nu.create()>