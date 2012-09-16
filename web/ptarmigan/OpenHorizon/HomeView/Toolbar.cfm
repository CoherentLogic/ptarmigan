<!--- Open Horizon Toolbar.cfm $Revision: 1.3 $ ---> 
    <div style="width:100%;">
	<cfif session.User.SessionReady>
	      <cfset tEnum = createObject("component", "OpenHorizon.Identity.SiteMembership")>
	      <cfset tQry = tEnum.Enumerate(session.User)>
    	
		<cfset img = createObject("component", "OpenHorizon.Graphics.Image")>
		
        <cfset currentApp = createObject("component", "OpenHorizon.Apps.App").Open(URL.AppID)>
        
        <cfparam name="deptArray" default="">
        <cfset deptArray = session.User.LoginSession.ActiveMembership.Site.Departments()>
        
        <cfparam name="appArray" default="">
        <cfset appArray = session.User.LoginSession.ActiveMembership.InstalledApps()>
        
        <cfmenu type="horizontal" bgcolor="##2957A2" fontcolor="##EFEFEF" selectedfontcolor="white" selecteditemcolor="##3399CC" menustyle="overflow:visible; z-index:1000;" childstyle="overflow:visible; z-index:1000;">
        	<cfmenuitem display="&nbsp;" image="/OpenHorizon/Resources/Graphics/Silk/openhorizon_stamp.png">
           	<cfmenuitem display="Search..." image="#img.Silk('Zoom', 15)#"/>
                <cfmenuitem divider />
                <cfif ArrayLen(appArray) EQ 0>
                	<cfmenuitem display="No apps installed"/>
				<cfelse>
                	
                    
                	<cfloop array="#appArray#" index="app">
                    	
                    	<cfoutput>
                        	<cfmenuitem display="#app.AppName#" image="#app.Icon#" href="/OpenHorizon/default.cfm?AppID=#app.AppID#&View=Home">
                            	                                    
                            </cfmenuitem>
						</cfoutput>                                             
					</cfloop>
				</cfif>    
                <cfmenuitem divider />                
                <cfmenuitem display="Manage Apps" href="javascript:GetMoreApps()" />
                <cfmenuitem divider />
                <cfmenuitem display="About OpenHorizon" image="/OpenHorizon/Resources/Graphics/Silk/openhorizon_stamp.png" href="javascript:AboutOH()"/>
            </cfmenuitem>
            
        	<cfmenuitem display="#session.User.FullName()#" image="#img.Silk('User', 15)#">
            	<cfmenuitem display="My Files" image="#img.Silk('Folder', 15)#"/>
                <cfmenuitem display="My Memberships">  
                <cfmenuitem display="Find More Sites &amp; Companies" image="#img.Silk('Zoom', 15)#"/>
                <cfmenuitem divider />              
				<cfoutput query="tQry">
                	<cfmenuitem display="#SiteName# - #MembershipType#" href="/OpenHorizon/Identity/Forms/ChangeSite.cfm?MembershipID=#MembershipID#"/>
				</cfoutput>
                </cfmenuitem>
                <cfmenuitem divider />
                <cfmenuitem display="Edit Profile"/>
                <cfmenuitem display="View Profile"/>
				<cfmenuitem divider />
                <cfmenuitem display="Edit Account"/> 
                <cfmenuitem display="Change Password"/>              
                <cfmenuitem divider />
                <cfmenuitem display="Log Out" href="javascript:LogOut();" image="#img.Silk('Door Out', 15)#"/>                    
            </cfmenuitem>
            
            <cfmenuitem display="#session.User.LoginSession.ActiveMembership.SiteName#">
            	<cfmenuitem display="#session.User.FirstName#: <strong>#session.User.LoginSession.ActiveMembership.MembershipType#</strong> of this company"/>
           		<cfmenuitem divider />
                <cfmenuitem display="Departments">
                	<cfloop array="#deptArray#" index="dept">
	                    <cfoutput>
                        <cfmenuitem display="#dept.DepartmentName#"/>
                        </cfoutput>
                    </cfloop>
				</cfmenuitem>
                <cfmenuitem divider />
                <cfmenuitem display="Products and Services" image="#img.Silk('Cart', 15)#"/>
                <cfmenuitem display="Contact This Company" image="#img.Silk('EMail', 15)#"/>
                <cfmenuitem divider />
                <cfmenuitem display="Projects" image="#img.Silk('Timeline Marker', 15)#"/>
                <cfmenuitem display="Scheduling" image="#img.Silk('Calendar', 15)#"/> 
                <cfmenuitem display="Time Collection" image="#img.Silk('Clock', 15)#"/>                    
                    
            </cfmenuitem>
            
	    <cfparam name="appViews" default="">
            <!---<cfset appViews = session.User.LoginSession.CurrentApp.Connect(session.User.LoginSession.SessionToken).EnumViews()>--->
            <cfmenuitem display="#currentApp.AppName#" image="#currentApp.Icon#">
            	<cfmenuitem display="About #currentApp.AppName#" image="#img.Silk('Information', 15)#" href="javascript:AboutApp('#currentApp.AppID#');"
                />
                <cfmenuitem display="Preferences"/>
                <cfmenuitem display="Report Bug" image="#img.Silk('Bug Add', 15)#"/>                
                <cfmenuitem divider />
                <cfmenuitem display="Recent Documents" image="#img.Silk('Page White', 15)#">
                	<cfmenuitem display="Recent documents here"/>
                </cfmenuitem>				
                <!---<cfmenuitem display="Views">
                <cfloop array="#appViews#" index="view">
                   	<cfoutput>
                    <cfmenuitem display="#view#" href="/OpenHorizon/default.cfm?AppID=#URL.AppID#&View=#view#"/>
                    </cfoutput>
		</cfloop>            	                                        
                </cfmenuitem>--->
                <cfmenuitem divider />
                <cfoutput>
                <cfmenuitem display="Remove #currentApp.AppName#" image="#img.Silk('Application Delete', 15)#"/>
                </cfoutput>
            </cfmenuitem>
                 
    	</cfmenu>
        
     
    
    
    	
	<cfelse>
    	 <cfmenu type="horizontal">
        	<cfmenuitem display="" image="/graphics/pi-16x16.png">
           		<cfmenuitem display="Log In..." image="/graphics/door_in.png" href="/OpenHorizon/Identity/Forms/Login.cfm"/>
                <cfmenuitem display="Create New Account..." image="/graphics/user_add.png"/>
                <cfmenuitem divider />
                <cfmenuitem display="About Open Horizon..." image="/graphics/pi-16x16.png"/>
            </cfmenuitem>
            <cfmenuitem display="You are not logged in." image="/graphics/lock_break.png"/>
		</cfmenu>            
	</cfif>                  
    </div>

