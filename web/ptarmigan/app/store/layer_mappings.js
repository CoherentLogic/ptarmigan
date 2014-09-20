Ext.define('pt_gis.store.layer_mappings', {
	extend: 'Ext.data.Store',
	model: 'pt_gis.model.layer_mapping',
	requires: 'pt_gis.model.layer_mapping',	
	autoLoad: false,	
	proxy: {
		type: 'ajax',
		extraParams: {
			'layer_id': ''
		},
		url: 'app/data/layer_mappings_read.cfm',
		reader: {
			type: 'json',
			root: 'layer_attributes'
		}
	}
});
