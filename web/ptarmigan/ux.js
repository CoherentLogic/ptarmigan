/*
 * Ptarmigan UX elements
 */


function ux_menu_item (icon, caption, link)
{
	ux_menu_item.icon = icon;
	ux_menu_item.caption = caption;
	ux_menu_item.link = link;
	
	return(this);
}

function ux_menu (id)
{
	ux_menu.id = id;
	ux_menu.items = new Array();
	
	return(this);
}

ux_menu.prototype.add_item = function (menu_item) {
	ux_menu.items.push(menu_item);
}

ux_menu.prototype.display = function (x, y) {
	$('body').append('<div id="' + this.id + '" class="ux_menu"></div>');
	
	for(itm in ux_menu.items) {
		alert(itm.caption);
	}
}