Ext.define('pt_gis.model.session', {
	extend: 'Ext.data.Model',
	fields: [
		{name: 'logged_in', type: 'boolean'},
		{name: 'message', type: 'string'},
		{name: 'initial_center_latitude', mapping: 'system.center_latitude', type: 'string' },
		{name: 'initial_center_longitude', mapping: 'system.center_longitude', type: 'string' },
		{name: 'cloudmade_api_key', mapping: 'system.cloudmade_api_key', type: 'string'},
		{name: 'company_name', mapping: 'company.company_name', type: 'string'},
		{name: 'service', mapping: 'company.service', type: 'int'}
	]	
});