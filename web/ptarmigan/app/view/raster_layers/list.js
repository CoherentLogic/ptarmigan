Ext.define('pt_gis.view.raster_layers.list' ,{
	extend: 'Ext.grid.Panel',
	alias: 'widget.rasterlayerlist',
	store: 'raster_layers',
	title: 'Raster Layers',
	id: 'raster-layers-list',	
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
				renderer: function (val, meta, rec, rowIdx, colIdx, store, view) {					
					var checkedVal = '';
					if(val === '1') {
						checkedVal = 'checked="checked"';
					}
					var chkID = 'id="RASTER_ENABLED_' + rec.data.id + '"'; 
					var chkOnClick = 'onclick="pt_toggle_raster_layer(\'' + rec.data.id + '\')"';
					var input = '<input type="checkbox" ' + chkOnClick + ' ' + checkedVal + ' ' + chkID + '>';					
					return(input); 					
				}							
			}, {
				flex: 1,
				header: 'Name',
				dataIndex: 'name'
			}
		]; /* columns */
		
		
		this.callParent(arguments);
	}
}); /* Ext.define */
