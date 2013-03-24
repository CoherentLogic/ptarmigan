/*
 * Ptarmigan UX elements
 */


function ux_menu_item (icon, caption, link)
{
	this.icon = icon;
	this.caption = caption;
	this.link = link;
	
	return(this);
}

function ux_menu (id)
{
	this.id = id;
	this.items = new Array();
	
	return(this);
}

ux_menu.prototype.add_item = function (menu_item) {
	this.items.push(menu_item);
}

ux_menu.prototype.display = function (x, y) {
	$('body').append('<div id="' + this.id + '" class="ux_menu"></div>');
	
	for(itm in this.items) {
		alert(itm.caption);
	}
}