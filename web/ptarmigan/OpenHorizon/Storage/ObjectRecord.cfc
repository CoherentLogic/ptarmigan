<cfcomponent displayname="ObjectRecord" hint="ORMS record" extends="OpenHorizon.Framework">
	<cfset this.r_id = "">
	<cfset this.r_type = "">
	<cfset this.r_owner = 0>
	<cfset this.r_site = 0>
	<cfset this.r_name = "">
	<cfset this.r_edit = "">
	<cfset this.r_view = "">
	<cfset this.r_delete = "">
	<cfset this.r_thumb = "">
	<cfset this.r_created = "">
	<cfset this.r_pk = 0>
	<cfset this.r_status = "">
	<cfset this.r_parent = "">
    <cfset this.generic_thumbnail = "">
    <cfset this.sidebar_path = "">    
	<cfset this.r_latitude = 0>
    <cfset this.r_longitude = 0>
    <cfset this.r_ask_location = 1>
    <Cfset this.r_has_location = 0>
    
    <cffunction name="SetThumbnail" access="public" returntype="void" output="no">
    	<cfargument name="t_url" type="string" required="yes">
        
        <cfset this.r_thumb = t_url>
        
        <cfquery name="setthumb" datasource="#this.BaseDatasource#">
        	UPDATE orms SET r_thumb='#this.r_thumb#' WHERE id='#this.r_id#'
		</cfquery>
        
        <cfif this.r_pk EQ session.user.ObjectRecord().r_pk>        
        	<cfset session.user = CreateObject("component", "OpenHorizon.Identity.User").Open(session.username)>
       		<cfset session.site = CreateObject("component", "OpenHorizon.Identity.Site").OpenByMembershipID(session.current_association)>
        	<cfset session.active_membership = CreateObject("component", "OpenHorizon.Identity.SiteMembership").OpenByPK(session.current_association)>
		</cfif>                    
    </cffunction>
    
	
	<cffunction name="Crup" hint="Create or update an ORMS record"  returntype="OpenHorizon.Storage.ObjectRecord" access="public">
		<cfargument name="r_type" type="string" required="yes">
		<cfargument name="r_owner" type="numeric" required="yes">
		<cfargument name="r_site" type="numeric" required="yes">
		<cfargument name="r_name" type="string" required="yes">
		<cfargument name="r_edit" type="string" required="yes">
		<cfargument name="r_view" type="string" required="yes">
		<cfargument name="r_delete" type="string" required="yes">
		<cfargument name="r_thumb" type="string" required="yes">
		<cfargument name="r_pk" type="numeric" required="yes">
		<cfargument name="r_status" type="string" required="yes">
		<cfargument name="r_parent" type="string" required="yes">
		
		<cfset this.r_type = r_type>
		<cfset this.r_owner = r_owner>
		<cfset this.r_site = r_site>
		<cfset this.r_name = r_name>
		<cfset this.r_edit = r_edit>
		<cfset this.r_view = r_view>
		<cfset this.r_delete = r_delete>
		<cfset this.r_thumb = r_thumb>
		<cfset this.r_pk = r_pk>
		<cfset this.r_status = r_status>
		<cfset this.r_parent = r_parent>
		
		<cfquery name="existsp" datasource="#this.BaseDatasource#">
			SELECT id FROM orms WHERE r_type='#r_type#' AND r_pk=#r_pk#
		</cfquery>
		
		<cfif existsp.RecordCount GT 0>
			<cfset rexists = true>
		<cfelse>
			<cfset rexists = false>
		</cfif>
		
		<cfif NOT rexists>
			<cfset this.r_id = CreateUUID()>
			<cfquery name="CreateORMSRecord" datasource="#this.BaseDatasource#">
				INSERT INTO orms
					(id,
					r_type,
					r_owner,
					r_site,
					r_name,
					r_edit,
					r_view,
					r_delete,
					r_thumb,
					r_pk,
					r_status,
					r_parent,
                    r_latitude,
                    r_longitude,
                    r_ask_location,
                    r_has_location)
				VALUES
					('#this.r_id#',
					'#this.r_type#',
					#this.r_owner#,
					#this.r_site#,
					'#this.r_name#',
					'#this.r_edit#',
					'#this.r_view#',
					'#this.r_delete#',
					'#this.r_thumb#',
					#r_pk#,
					'#this.r_status#',
					'#this.r_parent#',
                    #this.r_latitude#,
                    #this.r_longitude#,
                    #this.r_ask_location#,
                    #this.r_has_location#)
			</cfquery>			
			      
			<cftry>
				<cfset SEObject = this>
				<cfset SEUser = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.r_owner)>
 				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/View")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Edit")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Delete")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Share")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Copy")>
				
				<cfset this.Subscribe(SEUser)>			      			
				<cfset SEName = "Created this #this.r_type#">
				<cfset SECopy = 'Visit <a href="#this.URLBase#Prefiniti.cfm?View=#SEUser.ObjectRecord().r_id#">#SEUser.ObjectRecord().r_name#''''s profile</a>'>
				
				<cfset ObjEvent = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").Create(SEObject, SEUser, SEName, SECopy)>
				<cfset ObjEvent.Save()>
				
				<cfset UObject = SEUser.ObjectRecord()>
				<cfset UUser = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.r_owner)>
				<cfset UName = "Created a new #this.r_type#">
				<cfset UCopy = 'Open the <a href="#this.URLBase#Prefiniti.cfm?View=#this.r_id#">#this.r_name#</a> #this.r_type#'>
				
				<cfset UserEvent = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").Create(UObject, UUser, UName, UCopy)>
				<cfset UserEvent.Save()>	
				
				<cfcatch type="any">	
				
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset this.r_id = existsp.id>
			<cfquery name="UpdateORMSRecord" datasource="#this.BaseDatasource#">
				UPDATE 	orms
				SET		r_type='#this.r_type#',
						r_owner=#this.r_owner#,
						r_site=#this.r_site#,
						r_name='#this.r_name#',
						r_edit='#this.r_edit#',
						r_view='#this.r_view#',
						r_delete='#this.r_delete#',
						r_thumb='#this.r_thumb#',
						r_pk=#this.r_pk#,
						r_status='#this.r_status#',
						r_parent='#this.r_parent#',
                        r_latitude=#this.r_latitude#,
                        r_longitude=#this.r_longitude#,
                        r_ask_location=#this.r_ask_location#,
                        r_has_location=#this.r_has_location#                   
				WHERE	id='#this.r_id#'
			</cfquery>
		</cfif>		
		
							
		
		<cfreturn #this#>
	</cffunction>
	
    <cffunction name="Save" access="public" returntype="void" output="no">
    	<cfquery name="existsptwo" datasource="#this.BaseDatasource#">
			SELECT id FROM orms WHERE id='#this.r_id#'
		</cfquery>
		
		<cfif existsptwo.RecordCount GT 0>
			<cfset rexists = true>
		<cfelse>
			<cfset rexists = false>
		</cfif>
		
		<cfif NOT rexists>
			<cfset this.r_id = CreateUUID()>
			<cfquery name="CreateORMSRecord" datasource="#this.BaseDatasource#">
				INSERT INTO orms
					(id,
					r_type,
					r_owner,
					r_site,
					r_name,
					r_edit,
					r_view,
					r_delete,
					r_thumb,
					r_pk,
					r_status,
					r_parent,
                    r_latitude,
                    r_longitude,
                    r_ask_location,
                    r_has_location)
				VALUES
					('#this.r_id#',
					'#this.r_type#',
					#this.r_owner#,
					#this.r_site#,
					'#this.r_name#',
					'#this.r_edit#',
					'#this.r_view#',
					'#this.r_delete#',
					'#this.r_thumb#',
					#r_pk#,
					'#this.r_status#',
					'#this.r_parent#',
                    #this.r_latitude#,
                    #this.r_longitude#,
                    #this.r_ask_location#,
                    #this.r_has_location#)
			</cfquery>			
			<cftry>
				<cfset SEObject = this>
				<cfset SEUser = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.r_owner)>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/View")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Edit")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Delete")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Share")>
				<cfset SEUser.ObjectRecord().Relate(this.r_id, "Permission/Copy")>
				<cfset this.Subscribe(SEUser)>			      			

				<cfset SEName = "Created this #this.r_type#">
				<cfset SECopy = 'Visit <a href="#this.URLBase#Prefiniti.cfm?View=#SEUser.ObjectRecord().r_id#">#SEUser.ObjectRecord().r_name#''''s profile</a>'>
				
				<cfset ObjEvent = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").Create(SEObject, SEUser, SEName, SECopy)>
				<cfset ObjEvent.Save()>
				
				<cfset UObject = SEUser.ObjectRecord()>
				<cfset UUser = CreateObject("component", "OpenHorizon.Identity.User").OpenByPK(this.r_owner)>
				<cfset UName = "Created a new #this.r_type#">
				<cfset UCopy = 'Open the <a href="#this.URLBase#Prefiniti.cfm?View=#this.r_id#">#this.r_name#</a> #this.r_type#'>
				
				<cfset UserEvent = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").Create(UObject, UUser, UName, UCopy)>
				<cfset UserEvent.Save()>	
				
				<cfcatch type="any">	
				
				</cfcatch>
			</cftry>		
		<cfelse>
			
			<cfquery name="UpdateORMSRecord" datasource="#this.BaseDatasource#">
				UPDATE 	orms
				SET		r_type='#this.r_type#',
						r_owner=#this.r_owner#,
						r_site=#this.r_site#,
						r_name='#this.r_name#',
						r_edit='#this.r_edit#',
						r_view='#this.r_view#',
						r_delete='#this.r_delete#',
						r_thumb='#this.r_thumb#',
						r_pk=#this.r_pk#,
						r_status='#this.r_status#',
						r_parent='#this.r_parent#',
                        r_latitude=#this.r_latitude#,
                        r_longitude=#this.r_longitude#,
                        r_ask_location=#this.r_ask_location#,
                        r_has_location=#this.r_has_location#                   
				WHERE	id='#this.r_id#'
			</cfquery>
		</cfif>		
		
		<cfset sync_url="http://picasso.coherent-logic.com:8500/sync/resource.cfm?om_uuid=#this.r_id#">				
		<cfhttp url="#sync_url#">
    </cffunction>
    
	<cffunction name="Get" returntype="OpenHorizon.Storage.ObjectRecord" access="public" output="no">
		<cfargument name="r_id" type="string" required="yes">
		
		<cfquery name="gRes" datasource="#this.BaseDatasource#">
			SELECT * FROM orms WHERE id='#r_id#'
		</cfquery>
		
		<cfif gRes.RecordCount GT 0>
			<cfoutput query="gRes">
				<cfset this.r_id  = id>
				<cfset this.r_type = r_type>
				<cfset this.r_owner = r_owner>
				<cfset this.r_site = r_site>
				<cfset this.r_name = r_name>
				<cfset this.r_edit = r_edit>
				<cfset this.r_view = r_view>
				<cfset this.r_delete = r_delete>
				<cfset this.r_thumb = r_thumb>
				<cfset this.r_pk = r_pk>
				<cfset this.r_status = r_status>
				<cfset this.r_parent = r_parent>	
				<cfset this.r_created = r_created>		
				<cfset this.r_longitude = r_longitude>
                <cfset this.r_latitude = r_latitude>
                <cfset this.r_ask_location = r_ask_location>
				<cfset this.r_has_location = r_has_location>
			</cfoutput>
            
            <cfquery name="gc" datasource="#this.BaseDatasource#">
            	SELECT * FROM orms_creators WHERE r_type='#this.r_type#'
            </cfquery>
            
            <cfset this.sidebar_path = gc.sidebar>
            <cfset this.generic_thumbnail = gc.icon>
            
		<cfelse>
			<cfset this.Err("ORMS001")>
		</cfif>			
		
		<cfreturn #this#>
	</cffunction>		
	
	
	<cffunction name="GetByTypeAndPK" returntype="OpenHorizon.Storage.ObjectRecord" access="public">
		<cfargument name="r_type" type="string" required="yes">
		<cfargument name="r_pk" type="numeric" required="yes">
		
		<cfquery name="gu" datasource="#this.BaseDatasource#">
			SELECT id FROM orms WHERE r_type='#r_type#' AND r_pk=#r_pk#
		</cfquery>
		<cfif gu.RecordCount GT 0>
			<cfset p = this.Get(gu.id)>
		<cfelse>
        	<cfset ctx = "{" & r_type & "/" & r_pk & "}">
			<cfset this.Err("ORMS002", ctx)>
		</cfif>			
		<cfreturn #p#>
	</cffunction>
	
     <cffunction name="Picture" access="public" returntype="string" output="no">
    	<cfargument name="width" type="numeric" required="yes">
        <cfargument name="height" type="numeric" required="yes">
        
        <cfset pic_url = CreateObject("component", "Prefiniti").Config("Instance", "rooturl") & this.r_thumb>
    	<!---<cfset po = CreateObject("component", "OpenHorizon.Graphics.Image")>
        <cfset pic = po.Create(pic_url, width, height)> --->
        
		<cfreturn #pic_url#>    
    </cffunction>
    
	<cffunction name="GetByOwner" returntype="array" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		
		<cfset reserings = ArrayNew(1)>
		
		<cfquery name="gbo" datasource="#this.BaseDatasource#">
			SELECT id FROM orms WHERE r_owner=#user_id#
		</cfquery>
		
		<cfoutput query="gbo">
			<cfset ArrayAppend(reserings,  this.Get(id))>
		</cfoutput>						
		
		<cfreturn #reserings#>
	</cffunction>
	
	<cffunction name="DoAccess" returntype="void" access="public">		
		<cfargument name="a_type" type="string" required="yes">		
		<cfargument name="a_user_id" type="numeric" required="yes">
		
		<cfquery name="wal" datasource="#this.BaseDatasource#">
			INSERT INTO orms_access_log
				(r_id,
				a_type,
				a_date,
				a_user_id)
			VALUES
				('#this.r_id#',
				'#a_type#',
				#CreateODBCDateTime(Now())#,
				#a_user_id#)
		</cfquery>
	</cffunction>
	
	<cffunction name="Relate" returntype="void" access="public">
		<cfargument name="rel_target" type="string" required="yes">
		<cfargument name="rel_type" type="string" required="yes">
		<cfargument name="rel_expires" type="string" required="no">
		
        <cfquery name="chk_rel" datasource="#this.BaseDatasource#">
        	SELECT * FROM 	orms_relations
            WHERE			rel_source='#this.r_id#'
            AND				rel_target='#rel_target#'
            AND				rel_type='#rel_type#'
        </cfquery>
        
        <cfif chk_rel.RecordCount EQ 0>
            <cfquery name="rel" datasource="#this.BaseDatasource#">
                INSERT INTO orms_relations
                    (rel_source,
                    rel_target,
                    rel_type
                    <cfif IsDefined("rel_expires")>,rel_expires</cfif>)
                VALUES
                    ('#this.r_id#',
                    '#rel_target#',
                    '#rel_type#'
                    <cfif IsDefined("rel_expires")>,#CreateODBCDateTime(rel_expires)#</cfif>)										
            </cfquery>
        </cfif>
	</cffunction>	       
	
	<cffunction name="AddPair" returntype="void" access="public">
		<cfargument name="k_word" type="string" required="yes">
		<cfargument name="k_val" type="string" required="yes">
		
		<cfquery name="ap_ce" datasource="#this.BaseDatasource#">
			SELECT id FROM orms_keywords WHERE k_word='#k_word#' AND r_id='#this.r_id#'
		</cfquery>
						
		<cfif ap_ce.RecordCount GT 0>
			<cfquery name="ap_update" datasource="#this.BaseDatasource#">
				UPDATE 	orms_keywords
				SET		k_value='#k_val#'
				WHERE	k_word='#k_word#'
				AND		r_id='#this.r_id#'
			</cfquery>
		<cfelse>
			<cfquery name="ap_insert" datasource="#this.BaseDatasource#">							
				INSERT INTO orms_keywords
					(k_word,
					k_value,
					r_id)
				VALUES
					('#k_word#',
					'#k_val#',
					'#this.r_id#')
			</cfquery>
		</cfif>
	</cffunction>
	
	<cffunction name="GetPair" returntype="string" access="public">
		<cfargument name="k_word" type="string" required="yes">
		
		<cfquery name="gp" datasource="#this.BaseDatasource#">
			SELECT k_value FROM orms_keywords WHERE k_word='#k_word#' AND r_id='#this.r_id#'
		</cfquery>
		
		<cfif gp.RecordCount GT 0>
			<cfif gp.k_value NEQ "">
				<cfreturn #gp.k_value#>
			<cfelse>
				<cfreturn "[not set]">
			</cfif>
		<cfelse>
			<cfreturn "[not set]">
		</cfif>			
	</cffunction>
	
	<cffunction name="GetKeys" returntype="array" access="public">
		
		<cfparam name="keyArray" default="">
		<cfset keyArray=ArrayNew(1)>
		
		<cfquery name="gk" datasource="#this.BaseDatasource#">
			SELECT k_word FROM orms_keywords WHERE r_id='#this.r_id#'
		</cfquery>
	
		<cfoutput query="gk">
			<cfset ArrayAppend(keyArray, k_word)>
		</cfoutput>
		
		<cfreturn #keyArray#>
	</cffunction>
	
	<cffunction name="CanRead" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">

		<cfif this.IsPrefinitiAdmin(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsSiteAdmin(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsOwner(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsPeer(user_id, "Employee")>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsPeer(user_id, "Friend")>
			<cfreturn true>
		</cfif>
		
		<cfif this.r_type EQ "User Account">
			<cfquery name="CheckSearch" datasource="#this.BaseDatasource#">
				SELECT allowSearch FROM users WHERE id=#this.r_pk#
			</cfquery>
			<cfif CheckSearch.RecordCount NEQ 0>
				<cfreturn true>
			</cfif>
		</cfif>
		
		<cfreturn false>

	</cffunction>	
	
	<cffunction name="CanWrite" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		
		<cfif this.IsPrefinitiAdmin(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsSiteAdmin(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsOwner(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsPeer(user_id, "Employee")>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsPeer(user_id, "Friend")>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="CanDelete" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		
		<cfif this.IsPrefinitiAdmin(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsSiteAdmin(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfif this.IsOwner(user_id)>
			<cfreturn true>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="IsPrefinitiAdmin" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		
		<cfquery name="ipa_user" datasource="#this.BaseDatasource#">
			SELECT webware_admin FROM users WHERE id=#user_id#
		</cfquery>
		
		<cfif ipa_user.webware_admin EQ 0>
			<cfreturn false>
		<cfelse>			
			<cfreturn true>
		</cfif>		
	</cffunction>
	
	<cffunction name="IsSiteAdmin" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		
		<cfquery name="isa_get_site_admin" datasource="#this.SitesDatasource#">
			SELECT * FROM sites WHERE SiteID=#this.r_site#
		</cfquery>
		
		<cfif user_id EQ isa_get_site_admin.admin_id>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="IsOwner" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		
		<cfif user_id EQ this.r_owner>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>			
	</cffunction>
	
	<cffunction name="IsPeer" returntype="boolean" access="public">
		<cfargument name="user_id" type="numeric" required="yes">
		<cfargument name="assoc_type" type="string" required="yes">
		
		<cfswitch expression="#assoc_type#">
			<cfcase value="Customer">
				<cfset rat = 0>
			</cfcase>
			<cfcase value="Employee">
				<cfset rat = 1>
			</cfcase>
			<cfcase value="Friend">
				<cfset rat = 2>
			</cfcase>
		</cfswitch>
		<!---
			1.	Find out if user_id has a site_association of assoc_type to this.r_site
		--->
		
		<cfquery name="peer_check" datasource="#this.SitesDatasource#">
			SELECT 	* 
			FROM 	site_associations 
			WHERE 	user_id=#user_id# 
			AND 	site_id=#this.r_site# 
			AND 	assoc_type=#rat#
		</cfquery>
		
		<cfif peer_check.RecordCount GT 0>
			<cfreturn true>			
		<cfelse>
			<cfreturn false>
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetRating" returntype="numeric" access="public">
			
		<cfquery name="get_rcount" datasource="#this.BaseDatasource#">
			SELECT 	rating 
			FROM 	orms_ratings
			WHERE 	r_id='#this.r_id#'
			AND		rating>0
		</cfquery>
		
		<cfif get_rcount.RecordCount GT 0>
			<cfquery name="get_rating" datasource="#this.BaseDatasource#">
				SELECT 	AVG(rating) as arate
				FROM 	orms_ratings 
				WHERE 	r_id='#this.r_id#'
				AND		rating>0
			</cfquery>
			
			<cfreturn #get_rating.arate#>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
			
	<cffunction name="GetSections" returntype="query" access="public">

		<cfquery name="get_app_industry" datasource="#this.SitesDatasource#">
			SELECT industry FROM sites WHERE SiteID=#this.r_site#
		</cfquery>
		
		<cfparam name="tmpIndustry" default="">
		<cfif get_app_industry.RecordCount GT 0>
			<cfset tmpIndustry = get_app_industry.industry>
		<cfelse>
			<cfset tmpIndustry = 0>
		</cfif>

		<cfquery name="get_app_sections" datasource="#this.BaseDatasource#">
			SELECT 	* 
			FROM 	orms_app_sections 
			WHERE 	r_type='#this.r_type#'
			AND	 	(industry=0 OR industry=#tmpIndustry#)
			ORDER BY display_order ASC
		</cfquery>
		
		
		
		<cfreturn #get_app_sections#>
	
	</cffunction>
	
	<cffunction name="GetCreator" returntype="string" access="public">
		<cfargument name="r_type" type="string" required="yes">
		
		<cfquery name="get_creator" datasource="#this.BaseDatasource#">
			SELECT * FROM orms_creators WHERE r_type='#r_type#'
		</cfquery>
		
		<cfif get_creator.RecordCount GT 0>
			<cfreturn #get_creator.file_path#>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>		
									
	<cffunction name="Files" access="public" returntype="array" output="no">
		
        <cfquery name="gf" datasource="#this.BaseDatasource#">
        	SELECT om_uuid, file_uuid FROM orms_files WHERE om_uuid='#this.r_id#'
        </cfquery>
        
        <cfset ret_val = ArrayNew(1)>
      
		<cfoutput query="gf">
			<cfset tmp_file = CreateObject("component", "OpenHorizon.Storage.File").Open(file_uuid)>
            <cfset ArrayAppend(ret_val, tmp_file)>
		</cfoutput>
        
        <cfreturn #ret_val#> 
        

	</cffunction>	
	
	<cffunction name="LinkedDevices" returntype="array" access="public" output="no">
		
		<cfset retVal = ArrayNew(1)>
		
		<cfquery name="ld" datasource="#this.BaseDatasource#">
			SELECT * FROM orms_relations WHERE rel_source='#this.r_id#' AND rel_type='LocationProvider'
		</cfquery>				
		
		<cfoutput query="ld">
			<cfset t = CreateObject("component", "OpenHorizon.Storage.ObjectRecord").Get(rel_target)>
			<cfset ArrayAppend(retVal, t)>
		</cfoutput>
		
		<cfreturn retVal>
		
	</cffunction>
    
    <cffunction name="Events" access="public" returntype="array" output="no">
    	<cfargument name="starting_with" type="numeric" required="yes">
        <cfargument name="max_count" type="numeric" required="yes">
        
        <cfset ret_val = ArrayNew(1)>
        
        <cfquery name="e" datasource="#this.BaseDatasource#">
        	SELECT id FROM orms_events WHERE target_uuid='#this.r_id#' ORDER BY event_date DESC
        </cfquery>
        
        <cfoutput query="e" startrow="#starting_with#" maxrows="#max_count#">
        	<cfset t = CreateObject("component", "OpenHorizon.Storage.ObjectEvent").OpenByPK(id)>
            <cfset ArrayAppend(ret_val, t)>
        </cfoutput>
        
        <cfreturn #ret_val#>
    </cffunction>	
	
	<cffunction name="Subscribe" access="public" returntype="void" output="no">
		<cfargument name="SubUser" type="OpenHorizon.Identity.User" required="yes">
		
		<cfquery name="qrySubscribe" datasource="#this.BaseDatasource#">
			INSERT INTO	orms_subscriptions
						(target_uuid,
						user_id)
			VALUES
						('#this.r_id#',
						#SubUser.r_pk#)
		</cfquery>								
	</cffunction>
	
	<cffunction name="Unsubscribe" access="public" returntype="void" output="no">
		<cfargument name="UnSubUser" type="OpenHorizon.Identity.User" required="yes">
		
		<cfquery name="qryUnsubscribe" datasource="#this.BaseDatasource#">
			DELETE FROM orms_subscriptions
			WHERE		target_uuid='#this.r_id#'
			AND			user_id=#UnSubUser.r_pk#
		</cfquery>
	</cffunction>
	

</cfcomponent>