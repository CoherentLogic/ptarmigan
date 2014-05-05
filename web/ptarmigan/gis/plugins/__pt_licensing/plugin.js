var __pt_licensing = new pt_plugin({
		plugin_name: '__pt_licensing',
		
		on_installed: function () {
			var ptarmigan_license = request('ptarmigan_license.html');
			
			var ptarmigan_license_window = new Ext.Window({
				title: 'Ptarmigan License',
				autoScroll: true,
				bodyStyle: 'background:white',
				width: 640,
				height: 480,
				html: ptarmigan_license,
				closable: false,
				modal: true,
				buttons: [{
					text: 'Accept',
					handler: function (button, e) {						
						var plugin_options = {noOptions: true};
						this.up('.window').close();
						
						pt_gis.getApplication().__ptarmigan_gis.activate_plugin('__pt_disclaimer', plugin_options);
					}
				}, { 
					text: 'Decline',
					handler: function() {
						location.replace("http://www.google.com");
					}
				}]
			});
			
			ptarmigan_license_window.show();
			
			return(true);
		},
		
		on_activate: function () {
			return(true);
		},
				
		selectable: false,
		text: 'Licensing'
	}
);