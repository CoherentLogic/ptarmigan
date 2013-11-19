Ext.define('pt_gis.store.session', {
	extend: 'Ext.data.Store',
	model: 'pt_gis.model.session',
	requires: 'pt_gis.model.session',	
	autoLoad: true,
	proxy: {
		type: 'ajax',
		url: 'app/data/session_read.cfm',
		reader: {
			type: 'json'			
		}
	}
});
