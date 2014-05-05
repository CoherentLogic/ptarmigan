function pt_session() 
{	
	this.s = "";
	this.load();	
	return(this);			
}

pt_session.prototype.load = function() {
	var req_json = request('app/data/session_read.cfm');
    this.s = eval('(' + req_json + ')');    
    this.set_tools();
    
    //console.log("session: %o", this.s);
};

pt_session.prototype.authenticated = function () {
	if (this.s.logged_in === false) {
		return(false);
	}
	else {
		return(true);
	}
};

pt_session.prototype.login = function() {
	var login_view = Ext.create('pt_gis.view.session.login').show();	
};

pt_session.prototype.set_tools = function() {
	var bar = Ext.getCmp('__pt_menu_bar');
	bar.removeAll();
	
	var closure = this;
	
	if(this.authenticated()) {
		session_button_text = this.s.user.first_name + ' ' + this.s.user.last_name;
		var session_menu = Ext.widget('menu', {
			items: [{
				text: 'Log out',
				handler: function () {
					var resp = request('/logout.cfm');
					closure.load();				
				}
			}]
		});
		
		var ptarmigan_menu = Ext.widget('menu', {
			items: [{
				text: 'User Accounts...',
				icon: silk('group_gear')				
			}, {
				text: 'Company Settings...',
				icon: silk('wrench') 
			}, '-', {
				text: 'About Ptarmigan GIS 2013...'
			}]
		});
		
		var layers_menu = Ext.widget('menu', {
			items: [{
				text: 'New Layer...',
				icon: silk('vector_add')				
			}, {
				text: 'Import Shapefile...',
				icon: silk('database_add')
			}, '-', {
				text: 'Hide All',
				icon: silk('vector_delete'),
				handler: function () {
					pt_gis.getApplication().__ptarmigan_gis.viewport.block_layers();
				}				
			}, {
				text: 'Show Enabled',
				icon: silk('vector_add'),
				handler: function () {
					pt_gis.getApplication().__ptarmigan_gis.viewport.unblock_layers();
				}				
			}]
		});
	
		var layers_button = Ext.widget('button', {
			text: 'Layers',
			icon: silk('layers'),
			menu: layers_menu
		});
		

	
	}
	else { // not authenticated
		var ptarmigan_menu = Ext.widget('menu', {
			items: [{
				text: 'About Ptarmigan GIS 2013...',
				handler: function () {
					alert('Ptarmigan GIS 2013. Copyright (C) 2013 Ptarmigan Geosystems LLC');
				}
			}]
		});
		
		session_button_text = 'Guest';
		var session_menu = Ext.widget('menu', {
			items: [{
				text: 'Log In',
				handler: function () {
					closure.login();
				}
			}]
		});
		
		var layers_menu = Ext.widget('menu', {
			items: [{
				text: 'Hide All',
				icon: silk('vector_delete'),
				handler: function () {
					pt_gis.getApplication().__ptarmigan_gis.viewport.block_layers();
				}				
			}, {
				text: 'Show Enabled',
				icon: silk('vector_add'),
				handler: function () {
					pt_gis.getApplication().__ptarmigan_gis.viewport.unblock_layers();
				}				
			}]
		});
	
		var layers_button = Ext.widget('button', {
			text: 'Layers',
			icon: silk('layers'),
			menu: layers_menu
		});
	} // if (this.authenticated()) {...}
	
	ptarmigan_button = Ext.widget('button', {
		text: 'Ptarmigan',
		icon: '/favicon.ico',
		menu: ptarmigan_menu
	});
	
	session_button = Ext.widget('button', {
		text: session_button_text,
		icon: silk('user'),
		menu: session_menu
	});
	
	bar.add(ptarmigan_button);
	if(this.s.system.anonymous_only != 'true') {		
		bar.add(session_button);	
	}
	bar.add(layers_button);	
};

function silk(icon) {
	var url = '/OpenHorizon/Resources/Graphics/Silk/' + icon + '.png';
	return(url);
}
