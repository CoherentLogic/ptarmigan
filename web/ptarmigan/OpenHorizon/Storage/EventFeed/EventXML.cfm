<!---

$Id$

Copyright (C) 2011 John Willis
 
This file is part of Prefiniti.

Prefiniti is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Prefiniti is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.

<eventdata>
	<event id="id">
		<date></date>		
		<text> notify_text </text>
		<user> user_id </user>
		<object> orms_id </object>
	</event>
</eventdata>	

--->
<cfif session.loggedin EQ false>
	<cfthrow message="Security violation.">
</cfif>
<cfquery name="get_events" datasource="#session.framework.BaseDatasource#">
	SELECT * FROM orms_site_notifications WHERE user_id=#URL.user_id# AND received=#url.received# AND acknowledged=#url.acknowledged# ORDER BY event_date DESC
</cfquery>
<cfset user = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(URL.user_id)>
<cfxml variable="events">
<?xml version="1.0" encoding="iso-8859-1"?>
<eventdata>
<cfoutput query="get_events">
	<cfset user.ReceiveNotification(id)>
	<event received="#received#" acknowledged="#acknowledged#">    	
        <id>#id#</id>
        <text>#notify_text#</text>
        <user>#user_id#</user>
        <object>#orms_id#</object>
        <timestamp>#DateFormat(event_date, "m/dd/yyyy")# #TimeFormat(event_date, "h:mm tt")#</timestamp>
        <objectevent>#event_id#</objectevent>
	</event>
</cfoutput>
</eventdata>
</cfxml>
<cfset xml_string = ToString(events)>
<cfcontent type="text/xml" reset="yes"><cfoutput>#xml_string#</cfoutput>            
        