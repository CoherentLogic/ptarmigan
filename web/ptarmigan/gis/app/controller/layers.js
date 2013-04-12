Ext.define('pt_gis.controller.layers', {
	extend: 'Ext.app.Controller',
	
	init: function() {
		this.control({
			'#layers-list': {
				render: this.onListRendered
			}			
		});
		console.log('Ptarmigan GIS Layers Controller (V0.02-EXP) [Initialized]');
	},
	
	onListRendered: function() {
		
	}		
});
