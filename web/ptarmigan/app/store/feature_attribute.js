Ext.define('pt_gis.store.feature_attribute', {
	extend: 'Ext.data.Store',
	model: 'pt_gis.model.feature_attribute',
	requires: 'pt_gis.model.feature_attribute',	
	autoLoad: false,
	groupField: 'derived',
	proxy: {
		type: 'ajax',
		extraParams: {
			'layer_id': '',
			'feature_id': ''
		},
		url: 'app/data/feature_read.cfm',
		reader: {
			type: 'json',
			root: 'feature_attributes'
		}
	}
});
