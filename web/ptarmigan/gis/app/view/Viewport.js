var __pt_status_network = Ext.create('Ext.toolbar.TextItem', {text: 'Network Idle', width:180});
var __pt_status_layer = Ext.create('Ext.toolbar.TextItem', {text: 'No Layer', width:180});
var __pt_status_latitude = Ext.create('Ext.toolbar.TextItem', {text: '--', width:180});
var __pt_status_longitude = Ext.create('Ext.toolbar.TextItem', {text: '--', width:180});
var __pt_status_feature_id = Ext.create('Ext.toolbar.TextItem', {text: 'No Feature', width:180});
var __pt_status_feature_count = Ext.create('Ext.toolbar.TextItem', {text: '0 Features', width:180});

Ext.define('pt_gis.view.Viewport', {
	extend: 'Ext.container.Viewport',
	requires: [
		'pt_gis.view.search.search_tools',
		'pt_gis.view.layers.list',
		'pt_gis.view.feature_attributes.feature_attributes'
	],
    layout: 'border',
    initComponent: function () {    
    		
    	this.items = [{
    			xtype: 'panel',
    			region: 'north',
    			height: 50,
    			dockedItems: [{
    				dock: 'top',
    				xtype: 'toolbar',
    				height: 50,
    				items: [{
    					xtype: 'searchtools'    					
    				}, 
    				'-',
    				{
    					xtype: 'splitbutton',
    					text: 'Research'
    				},
    				{
    					xtype: 'button',
    					text: 'Documents'
    				},
    				{
    					xtype: 'button',
    					text: 'Measure'
    				}, '-', {
    					xtype: 'button',
    					text: 'Tour'
    				}
    				]
    			}]
    		}, {
    			region: 'south',
    			contentEl: 'status-bar',
    			split: false,
    			height: 45,
    			collapsible: false,
    			collapsed: false,
    			margins: '0 0 0 0',
    			bbar: Ext.create('Ext.ux.statusbar.StatusBar', {
    				id: 'system-message',
    				defaultText: 'Ptarmigan GIS',
    				height: 45,
    				items: [__pt_status_network, '-', __pt_status_layer, '-', __pt_status_feature_id, '-', __pt_status_feature_count, '-', __pt_status_latitude, '-', __pt_status_longitude]
    			})    					    			    	    				    	
    		}, { 
    			region: 'west',
    			contentEl: 'sidebar',    			
    			title: 'Area',
    			width: 300,
    			minWidth: 300,
    			maxWidth: 300,
    			collapsible: true,
    			animCollapse: true,
    			margins: '0 0 0 0',
    			split:true,
    			items: [{
    				xtype: 'panel',    				   			
    				html: '<div id="area-overview" style="width:100%;height:250px;"></div>'	
    			},{
    				xtype: 'layerlist'    				
    			}]    			
    		}, {
    			region: 'east',
    			title: 'Feature Attributes',
    			id: 'feature-attributes-container',
    			margins: '0 0 0 0',
    			collapsible: true,
    			animCollapse: true,
    			collapsed: true,
    			width:400,
    			autoScroll: true,
    			items: [{
    				xtype: 'panel',
    				id: 'plugin-box'    							    		
    			}]
    		},	Ext.create('Ext.tab.Panel', {
    				region: 'center',
    				deferredRender: false,
    				activeTab: 0,
    				items: [{
    					contentEl: 'map-container',
    					title: 'Map',
    					closable: false,
    					autoScroll: false
    				}] /* tab items */
    			}) /* Ext.create() */
    		];    	    
    	//console.log('Viewport.initComponent() pre-callParent()');	
    	this.callParent();
    	//console.log('Viewport.initComponent() post-callParent()');	
    	
    } /* initComponent */
});
    	
    	
			

