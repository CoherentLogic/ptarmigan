Ext.define('pt_gis.controller.session', {
	extend: 'Ext.app.Controller',
	stores: ['session'],
	
	init: function() {
		this.control({
			'login button[action=login]': {
				click: this.login
			}			
		});						
	},
	login: function(button) {
		var win = button.up('window');
		var form = win.down('form');		
		var values = form.getValues();
		
		Ext.Ajax.request({
			url: 'app/data/login.cfm',
			success: function (response) {
				var auth_result = eval('(' + response.responseText + ')');
				
				if (auth_result.success === true) {					
					win.close();	
					pt_gis.getApplication().__ptarmigan_session.load();
				}
				else {
					alert(auth_result.message);
				}
				
			},
			failure: function (response) {
				console.log("failure: " + response.responseText);
			},
			jsonData: values
		});
		console.log("values: %o", values);
	}
					
});
