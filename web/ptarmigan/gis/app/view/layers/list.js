Ext.define('pt_gis.view.layers.list' ,{
	extend: 'Ext.grid.Panel',
	alias: 'widget.layerlist',
	store: 'layers',
	title: 'Layers',
	id: 'layers-list',	
	plugins: [
	 	Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1
        })
	],
	initComponent: function() {
		this.columns = [
			{
				header: 'On', 
				dataIndex: 'layer_enabled', 
				flex: 0, 
				width: 40,
				xtype: 'checkcolumn'						
			},
			{
				header: 'Color', 
				dataIndex: 'layer_color', 
				flex: 0, 
				width: 50,
				renderer: function (value) {
					return Ext.String.format('<div style="width:16px;height:16px;background-color:{0}"></div>', value);
				}
			},
			{header: 'Name', dataIndex: 'layer_name', flex: 1},
			{header: 'Projection', dataIndex: 'layer_projection_name', flex: 1, hidden:true}
			
		];
		
		
		this.callParent(arguments);
	}
}); /* Ext.define */
