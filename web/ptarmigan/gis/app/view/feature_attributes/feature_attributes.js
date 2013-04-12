Ext.define('pt_gis.view.feature_attributes.feature_attributes' ,{
	extend: 'Ext.grid.Panel',
	alias: 'widget.featureattributes',
	forceFit: true,	
	
	
	initComponent: function() {
		this.columns = [
			{ text: 'Attribute', dataIndex: 'attribute'},
			{ text: 'Value', dataIndex: 'value'},
			{ text: 'Derived', dataIndex: 'derived', hidden:true}
		],
		
		this.features = [
			{
				ftype: 'grouping',
				groupHeaderTpl: [					
					'<div>{name:this.formatName}</div>',
					{
						formatName: function (name) {
							switch(name) {
								case true: return('Derived'); break;
								case false: return('Normal'); break;
							}
						}
					}
				]
			}
		];
		
		this.callParent();		
	}
}); /* Ext.define */
