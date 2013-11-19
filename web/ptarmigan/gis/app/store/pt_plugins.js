Ext.define('pt_gis.store.pt_plugins', {
	extend: 'Ext.data.Store',
	model: 'pt_gis.model.pt_plugin',
	requires: 'pt_gis.model.pt_plugin',	
	autoLoad: true,
	proxy: {
		type: 'ajax',
		url: 'app/data/pt_plugins_read.cfm',
		reader: {
			type: 'json'			
		}
	},
	listeners: {
		load: function(store) {			
			var __pt_plugin_manager = new pt_plugin_manager(pt_gis.getApplication().__ptarmigan_gis);
			__pt_plugin_manager.load_all(store);
		}
	}
});
