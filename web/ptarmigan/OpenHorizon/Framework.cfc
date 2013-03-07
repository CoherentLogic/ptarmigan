<!--- Open Horizon Framework.cfc $Revision: 1.2 $ --->

<cfcomponent displayName="Framework" hint="Open Horizon Base">
	
	<cfset this.BaseDatasource = session.system.datasource>
    <cfset this.SitesDatasource = session.system.datasource>    		
	<cfset this.URLBase = session.system.root_url>
	<cfset this.ThumbnailCache = session.system.thumbnail_cache>
	<cfset this.BaseHost = session.system.base_url>
</cfcomponent>
