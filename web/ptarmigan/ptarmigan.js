/*
 * ptarmigan.js
 *   ptarmigan JavaScript support
 *
 * Copyright (C) 2012 Coherent Logic Development LLC
 *
 */

function creator_win(url)
{
	window.open(url, "creator", "location=0,menubar=0,resizable=0,status=0,height=600,width=800");
}

function refresh_parent() 
{
  window.opener.location.href = window.opener.location.href;  
  //window.close();
}


function refresh_parent_no_close()
{
	window.opener.location.href = window.opener.location.href; 
}
