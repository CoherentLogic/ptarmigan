Ext.define('pt_gis.controller.layers', {
	extend: 'Ext.app.Controller',
	
	init: function() {
		
		this.control({
			'#layers-list': {
				render: this.onListRendered
			}			
		});
		
	},
	
	onListRendered: function() {
		
	}		
});
