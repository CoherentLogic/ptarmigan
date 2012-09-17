<!--- Open Horizon Framework.cfc $Revision: 1.2 $ --->

<cfcomponent displayName="Framework" hint="Open Horizon Base">
	
	<cfset this.BaseDatasource = session.company.datasource>
    <cfset this.SitesDatasource = "">    		
	<cfset this.URLBase = session.root_url>
	<cfset this.ThumbnailCache = session.thumbnail_cache>
	<cfset this.BaseHost = "http://localhost">
</cfcomponent>
