/*
 * Open Horizon
 *  Apps.js
 *  Basic routines for apps to run
 * 
 * Created by John Willis
 * Copyright (C) 2010 Coherent Logic Development LLC
 *
 * $Revision: 1.2 $
 */
function AjaxGet(URL) {
  if (window.XMLHttpRequest) {              
    AJAX=new XMLHttpRequest();              
  } else {                                  
    AJAX=new ActiveXObject("Microsoft.XMLHTTP");
  }
  if (AJAX) {
     AJAX.open("GET", URL, false);                             
     AJAX.send(null);
     return AJAX.responseText;                                         
  } else {
     return false;
  }                                             
}


function GetMoreApps() 
{
	
	var win = ColdFusion.Window.create("ManageApps", "Manage Apps", "/OpenHorizon/Apps/Forms/GetMoreApps.cfm", {center:true,closable:true,draggable:true, resizable:true,modal:true,width:640,height:480,initshow:true});
}

function AboutApp(AppID)
{
	var win = ColdFusion.Window.create("About_" + AppID, "About", "/OpenHorizon/Apps/Forms/AboutApp.cfm?AppID=" + AppID, {center:true,closable:true,draggable:true, resizable:true,modal:false,width:400,height:400,initshow:true});
	
}

function NewApp()
{
    var win = ColdFusion.Window.create("NewApp", "Create New App", "/OpenHorizon/Apps/Forms/NewApp.cfm", {center:true,closable:true,draggable:false, resizable:false,modal:true,width:500,height:350,initshow:true});
}    

function OHApp (AppID, installed)
{
		this.AppID = AppID;
		this.AppObject = "";
		this.AppName = "";
		this.Vendor = "";
		this.Version = "";
		
		
		var url = "/OpenHorizon/Apps/Forms/GetApp.cfm?AppID=" + escape(this.AppID);
		this.AppObject = JSON.parse(AjaxGet(url));
		
		this.AppName = AppObject.APPNAME;
		this.Vendor = AppObject.VENDOR.SITENAME;
		this.Version = AppObject.VERSION;
		
		if(!installed) {
			var url = "/OpenHorizon/Apps/Forms/InstallApp.cfm?AppID=" + escape(AppID);
			
			var win = ColdFusion.Window.create("Install_" + this.AppID, "Install " + this.AppName, url, {center:true,closable:false,draggable:true, resizable:false,modal:true,width:640,height:400,initshow:true});
			
		}
}


OHApp.prototype.Render = function () {
	
}

function FollowLink(link, type, opener, opener_title)
{
	
	var url = "/OpenHorizon/exec.cfm?p=" + link;
	location.replace(url);
		
}