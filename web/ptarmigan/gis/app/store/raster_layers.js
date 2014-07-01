Ext.define('pt_gis.store.raster_layers', {
	extend: 'Ext.data.Store',
	model: 'pt_gis.model.raster_layer',
	requires: 'pt_gis.model.raster_layer',	
	autoLoad: true,
	proxy: {
		type: 'ajax',
		url: 'app/data/raster_layers_read.cfm',
		reader: {
			type: 'json'
		}
	}
});
