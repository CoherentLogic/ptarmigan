Ext.define('pt_gis.store.layers', {
	extend: 'Ext.data.Store',
	model: 'pt_gis.model.layer',
	requires: 'pt_gis.model.layer',	
	autoLoad: true,
	proxy: {
		type: 'ajax',
		url: 'app/data/layers.cfm',
		reader: {
			type: 'json'
		}
	}
});
