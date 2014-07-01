Ext.define('pt_gis.model.layer', {
	extend: 'Ext.data.Model',
	fields: [
		'id',
		'layer_type',
		'layer_name',
		'layer_table',
		'layer_key_name',
		'layer_key_abbreviation',
		'layer_key_field',
		'layer_color',
		'layer_public',
		'layer_projection',
		'layer_projection_name',
		'layer_geom_field',
		'layer_enabled'
	]	
});