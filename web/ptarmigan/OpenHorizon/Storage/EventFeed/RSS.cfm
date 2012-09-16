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
<cfset fw = CreateObject("component", "OpenHorizon.Framework")>

<cfquery name="get_events" datasource="#fw.BaseDatasource#">
	SELECT * FROM orms_events WHERE target_uuid='#URL.orms_id#' ORDER BY event_date DESC
</cfquery>

<cfset obj = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").Get(URL.orms_id)>
<cfset site = CreateObject("component", "OpenHorizon.Identity.Site").Open(obj.r_site)>


<cfxml variable="event_feed">
<?xml version="1.0" encoding="iso-8859-1"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
	<cfoutput>
    <atom:link href="#fw.URLBase#OpenHorizon/Storage/EventFeed/RSS.cfm?orms_id=#url.orms_id#" rel="self" type="application/rss+xml" />
    	<title>#site.site_name# - #obj.r_type# #obj.r_name#</title>
        <description>RSS Feed for the #obj.r_type# '#obj.r_name#'</description>
        <link>#fw.URLBase#OpenHorizon/Storage/EventFeed/RSS.cfm?orms_id=#url.orms_id#</link>
        <lastBuildDate>#GetHttpTimeString(Now())#</lastBuildDate>
        <pubDate>#GetHttpTimeString(Now())#</pubDate>                
    </cfoutput>
<cfoutput query="get_events">
	<cfset event = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").OpenByPK(id)>
	<item>
    	<title>#event.event_user.display_name# #LCase(event.event_name)#</title>
        <description>#event.body_copy#</description>
        <link>#fw.URLBase#Prefiniti.cfm?View=#URL.orms_id#</link>
        <guid isPermaLink="false">#CreateUUID()# #id#</guid>
        <pubDate>#GetHttpTimeString(event.event_date)#</pubDate>
    </item>
</cfoutput>
</channel>
</rss>
</cfxml>
<cfset xml_string = ToString(event_feed)>
<cfcontent type="text/xml" reset="yes"><cfoutput>#xml_string#</cfoutput>            
        