Ext.define('pt_gis.controller.raster_layers', {
	extend: 'Ext.app.Controller',
	
	init: function() {
		
		this.control({
			'#raster-layers-list': {
				render: this.onListRendered
			}			
		});
		
	},
	
	onListRendered: function() {
		
	}		
});
