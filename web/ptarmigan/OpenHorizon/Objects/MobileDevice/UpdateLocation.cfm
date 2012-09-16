<cfset md = CreateObject("component", "OpenHorizon.Objects.MobileDevice")>
<cfset md.Open(URL.DeviceCode)>
	
<cfset loc = CreateObject("component", "OpenHorizon.Objects.GISLocation")>
<cfset loc.Create(URL.provider, URL.devicecode, URL.comment, URL.latitude, URL.longitude, URL.elevation, URL.bearing, URL.speed, URL.accuracy)>

<cfset md.SetLocation(loc)>
