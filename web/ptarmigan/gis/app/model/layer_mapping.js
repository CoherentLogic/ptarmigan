Ext.define('pt_gis.model.layer_mapping', {
	extend: 'Ext.data.Model',
	fields: [
		'source_layer_id',
		'source_attribute',
		'attribute_name',		
		'column_type',
		'id',
		'operator',
		'value',
		'use_in_search'
	]	
});