<!--- Open Horizon ChangeSite.cfm $Revision: 1.2 $ --->
<cfset tmpMember = createObject("component", "OpenHorizon.Identity.SiteMembership").LoadByID(URL.MembershipID)>
<cfset session.User.LoginSession.ActiveMembership = tmpMember>

<cflocation url="/OpenHorizon/exec.cfm?p=#session.RL#" addtoken="no">