var __pt_disclaimer = new pt_plugin({
		plugin_name: '__pt_disclaimer',
		
		on_installed: function () {			
			return(true);
		},
		
		on_activate: function () {
			var disclaimer = request('disclaimer.html');
			
			var disclaimer_window = new Ext.Window({
				title: 'Disclaimer',
				autoScroll: true,
				bodyStyle: 'background:white',
				width: 640,
				height: 480,
				html: disclaimer,
				closable: false,
				modal: true,
				buttons: [{
					text: 'Accept',
					handler: function (button, e) {						
						this.up('.window').close();
					}
				}, { 
					text: 'Decline',
					handler: function() {
						location.replace("http://www.google.com");
					}
				}]
			});
			
			disclaimer_window.show();
			return(true);
			
		},
				
		selectable: false,
		text: 'Disclaimer'
	}
);