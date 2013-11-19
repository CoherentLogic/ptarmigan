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
				renderer: function (val, meta, rec, rowIdx, colIdx, store, view) {					
					var checkedVal = '';
					if(val === 1) {
						checkedVal = 'checked="checked"';
					}
					var chkID = 'id="LAYER_ENABLED_' + rec.data.id + '"'; 
					var chkOnClick = 'onclick="pt_toggle_layer(\'' + rec.data.id + '\')"';
					var input = '<input type="checkbox" ' + chkOnClick + ' ' + checkedVal + ' ' + chkID + '>';					
					return(input); 					
				}							
			},
			{
				header: 'Color', 
				dataIndex: 'layer_color', 
				flex: 0, 
				width: 50,
				renderer: function (value) {
					return Ext.String.format('<div style="width:16px;height:16px;background-color:{0}"></div>', value);
				}
			}, {
				header: 'Name', dataIndex: 'layer_name', flex: 1
			}, {
				header: 'Tools',
				renderer: function (val, meta, rec, rowIdx, colIdx, store, view) {
					var layer_id = rec.data.id;
					var on_click = 'onclick="pt_search_layer(\'' + layer_id + '\')"';
					var search_layer_button = '<button ' + on_click + ' title="Search for features on this layer"><img src="/OpenHorizon/Resources/Graphics/Silk/find.png"></button>';
					var on_click = 'onclick="pt_layer_zoom_extents(\'' + layer_id + '\')"';					
					var zoom_extents_button = '<button ' + on_click + ' title="Zoom to layer extents"><img src="/OpenHorizon/Resources/Graphics/Silk/zoom_extents.png"></button>';
					
					return(search_layer_button + zoom_extents_button);
				}			
			}, {
				header: 'Projection', 
				dataIndex: 'layer_projection_name', 
				flex: 1, hidden:true
			}, {
				header: 'ID', 
				dataIndex: 'id', 
				flex:1, 
				hidden:true
			}			
		]; /* columns */
		
		
		this.callParent(arguments);
	}
}); /* Ext.define */
