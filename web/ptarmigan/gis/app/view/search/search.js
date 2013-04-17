Ext.define('pt_gis.view.search.search', {
	extend: 'Ext.window.Window',
	alias: 'widget.featuresearch',
	title: 'Search Features',
	bodyPadding: 5,
	layout: 'column',
	
	initComponent: function() {	
		this.cellEditing = new Ext.grid.plugin.CellEditing({
        	clicksToEdit: 1
        });	
        	
		Ext.apply(this, {
			width: 950,		
			fieldDefaults: {
				labelAlign: 'left',
				labelWidth: 90,
				anchor: '100%',
				msgTarget: 'side'
			},
			
			items: [{
				columnWidth: 0.7,
				xtype: 'gridpanel',
				id: 'search-grid',
				plugins: [this.cellEditing],
				height: 400,
				forceFit: true,
				store: this.store,
				columns: [{
					text: '<input type="checkbox" checked="checked" readonly>',
					xtype: 'checkcolumn',
					dataIndex: 'use_in_search',
					flex: 0,
					width: 40					
				}, {
					text: 'Attribute',
					dataIndex: 'attribute_name'				
				}, {
					text: 'Search Type',
					width: 80,
					dataIndex: 'operator',
					editor: {
						xtype: 'combo',
						listClass: 'x-combo-list-small',
						width: 80,
						store: new Ext.data.ArrayStore({
							fields: ['id', 'operator'],
							data: [								
								['CONTAINS', 'CONTAINS'],
								['BEGINS WITH', 'BEGINS WITH'],
								['IS EQUAL TO', 'IS EQUAL TO'],
								['IS GREATER THAN', 'IS GREATER THAN'],
								['IS LESS THAN', 'IS LESS THAN'],
								['IS NOT EQUAL TO', 'IS NOT EQUAL TO'],
								['DOES NOT CONTAIN', 'DOES NOT CONTAIN'],
								['DOES NOT BEGIN WITH', 'DOES NOT BEGIN WITH']
							]
						}),
						displayField: 'operator',
						valueField: 'id',
						mode: 'local',
						typeAhead: false,
						triggerAction: 'all',
						lazyRender: true,
						emptyText: 'Select operator'
					}
				}, {
					text: 'Value',
					dataIndex: 'value',
					editor: {
						allowBlank: false
					}		
				}]
			}, {
				columnWidth: 0.3,
				margin: '0 0 0 10',
				xtype: 'fieldset',
				title: 'Options',
				layout: 'anchor',
				defaultType: 'textField',
				items: [{
					xtype: 'radiogroup',
					fieldLabel: 'Match',
					id: 'search-type',
					columns: 1,
					defaults: {
						name: 'rating'
					},
					items: [{
						inputValue: 'OR',
						boxLabel: 'Any attributes',
						checked: true,
						id: 'search-type-any'
					}, {
						inputValue: 'AND',
						boxLabel: 'All attributes',
						id: 'search-type-all'
					}]
				}]
			}],
			buttons: [{
                text: 'Search',
                scope: this,
                action: 'search',
                handler: function () {
                	var grid_control = Ext.getCmp('search-grid');
                	var grid_store = grid_control.store;
                	var layer_id = grid_store.getProxy().extraParams.layer_id;
                	
                	var search_type_any = Ext.getCmp('search-type-any');
                	var search_type_all = Ext.getCmp('search-type-all');                	         	
                	var search_type = 'any';
                	
                	if(search_type_all.checked === true) {
                		search_type = 'all';
                	}
                	
                	var pt_search_obj = new pt_search(layer_id, search_type);
                	                	
                	grid_store.each(function (r) {
                		var src_attribute = r.get('source_attribute');
                		var operator = r.get('operator');
                		var use_in_search = r.get('use_in_search');
                		var search_value = r.get('value');
                		var column_type = r.get('column_type');
                		
                		if (use_in_search) {
                			var search_col = new pt_search_column({
                				src_attribute: src_attribute,
                				operator: operator,
                				search_value: search_value,
                				column_type: column_type  
                			});
                			pt_search_obj.add_column(search_col);
                		}
                		                		
                	});
					pt_search_obj.exec();
					this.close();
                }
            }, {
                text: 'Cancel',
                scope: this,
                handler: this.close
            }]      			
		});
		
		this.callParent();
	}
});
