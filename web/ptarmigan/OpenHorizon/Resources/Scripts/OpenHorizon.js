/*
 * Open Horizon
 *  OpenHorizon.js
 *  Basic routines for Open Horizon to run
 * 
 * Created by John Willis
 * Copyright (C) 2010 Coherent Logic Development LLC
 *
 * $Revision: 1.2 $
 */
function LogOut()
{
	ColdFusion.Window.show("LogoutDialog");
}

function AboutOH()
{
	var win = ColdFusion.Window.create("AboutOH", "About Open Horizon", "/OpenHorizon/Apps/Forms/AboutOH.cfm", {center:true,closable:true,draggable:true, resizable:false,modal:false,width:600,height:350,initshow:true});	
}

function OHRun()
{
	var win = ColdFusion.Window.create("OHRun", "Open Horizon", "/OpenHorizon/Apps/Forms/OHRun.cfm", {center:true,closable:true,draggable:true, resizable:false,modal:false,width:600,height:260,initshow:true});
}