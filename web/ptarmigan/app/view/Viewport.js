var __pt_status_network = Ext.create('Ext.toolbar.TextItem', {text: 'Network Idle', width:180});
var __pt_status_layer = Ext.create('Ext.toolbar.TextItem', {text: 'No Layer', width:180});
var __pt_status_latitude = Ext.create('Ext.toolbar.TextItem', {text: '--', width:180});
var __pt_status_longitude = Ext.create('Ext.toolbar.TextItem', {text: '--', width:180});
var __pt_status_feature_id = Ext.create('Ext.toolbar.TextItem', {text: 'No Feature', width:180});
var __pt_status_feature_count = Ext.create('Ext.toolbar.TextItem', {text: '0 Features', width:180});

Ext.define('pt_gis.view.Viewport', {
	extend: 'Ext.container.Viewport',
	alias: 'widget.ptviewport',
	requires: [		
		'pt_gis.view.layers.list',
		'pt_gis.view.feature_attributes.feature_attributes',
		'pt_gis.view.search.search',
		'pt_gis.view.search.search_results'
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
    				id: 'main-toolbar',
    				height: 50,
    				items: [{
    					xtype: 'toolbar',
    					border: false,
    					id: '__pt_menu_bar'
    				}, /*'-', {
    					xtype: 'button',
    					icon: '/OpenHorizon/Resources/Graphics/Silk/zoom.png',
    					text: 'Address Search',
    					handler: function () {
    						pt_gis.getApplication().__ptarmigan_gis.activate_plugin('__pt_geocoding', {}); 
    					}
    				}, */'-', {
    					text: 'Zoom In',
    					xtype: 'button',
    					icon: '/OpenHorizon/Resources/Graphics/Silk/zoom_in.png',
    					handler: function () {
					    var sess = pt_gis.getApplication().__ptarmigan_session.s.system;
					    var max_zoom = parseInt(sess.maximum_zoom_level);
					    var cur_zoom = pt_gis.getApplication().__ptarmigan_gis.leaflet_map.getZoom();

					    if (cur_zoom < max_zoom) {
    						pt_gis.getApplication().__ptarmigan_gis.leaflet_map.zoomIn();
						cur_zoom = pt_gis.getApplication().__ptarmigan_gis.leaflet_map.getZoom();
					    }
					    
    					}
    				}, {
    					text: 'Zoom Out',
    					xtype: 'button',
    					icon: '/OpenHorizon/Resources/Graphics/Silk/zoom_out.png',
    					handler: function () {
					    var sess = pt_gis.getApplication().__ptarmigan_session.s.system;
					    var min_zoom = parseInt(sess.minimum_zoom_level);
					    var cur_zoom = pt_gis.getApplication().__ptarmigan_gis.leaflet_map.getZoom();

					    if (cur_zoom > min_zoom) {
    						pt_gis.getApplication().__ptarmigan_gis.leaflet_map.zoomOut();
					    }
    					}
    				}, {
    					xtype: 'button',
    					text: 'Measure',
    					icon: '/OpenHorizon/Resources/Graphics/Silk/ruler_2.png',
    					menu: {
    						items: [{
    							text: 'Polyline Length',
    							icon: '/images/link.png',
    							handler: function () {
    								pt_gis.getApplication().__ptarmigan_gis.activate_plugin('__pt_mensuration', {mode: 'polyline'});
    							}    					
    						}, {
    							text: 'Polygon Area',
    							icon: '/images/parcel.png',
    							handler: function () {
    								pt_gis.getApplication().__ptarmigan_gis.activate_plugin('__pt_mensuration', {mode: 'polygon'});
    							}
    						}, '-', {
    							text: 'Remove Measurement Shapes',
    							icon: '/OpenHorizon/Resources/Graphics/Silk/chart_line_delete.png', 
       							handler: function () {
    								pt_gis.getApplication().__ptarmigan_gis.clear_shape();
    							}
    						}]
    					}
    					
    				}, {
    					xtype: 'toolbar',
    					border: false,
    					id: '__pt_plugins_bar'
    				}]
    			}]
    		}, {
    			region: 'south',
    			//contentEl: 'status-bar',
    			split: false,
    			height: 45,
    			collapsible: false,
    			collapsed: false,
    			margins: '0 0 0 0',
    			bbar: Ext.create('Ext.ux.statusbar.StatusBar', {
    				id: 'system-message',
    				defaultText: 'Geodigraph',
    				height: 45,
    				items: [__pt_status_network, '-', __pt_status_layer, '-', __pt_status_feature_id, '-', __pt_status_feature_count, '-', __pt_status_latitude, '-', __pt_status_longitude]
    			})    					    			    	    				    	
    		}, { 
    			region: 'west',
    			//contentEl: 'sidebar',    			
    			title: 'Area',
    			autoScroll: true,
    			width: 400,
    			minWidth: 400,
    			maxWidth: 400,
    			collapsible: true,
    			animCollapse: true,
    			margins: '0 0 0 0',
    			split:true,
    			items: [{
    				xtype: 'panel',    				   			
    				html: '<div id="area-overview" style="width:100%;height:250px;"></div>'	
    			}, {
    				xtype: 'layerlist'    				
    			}, {
    				xtype: 'panel',
    				id: 'latest-search'
    			}]    			
    		},	Ext.create('Ext.tab.Panel', {    				
    				listeners: {
    					resize: function () {
    						// fix to force leaflet to resize the map properly    						
    						var app = pt_gis.getApplication();
    						if (app.__ptarmigan_gis) {
    							app.__ptarmigan_gis.leaflet_map.invalidateSize(false);
    						}    						
    					}
    				},
    				region: 'center',
    				deferredRender: false,
    				activeTab: 0,
    				items: [{
    					contentEl: 'map-container',
    					title: 'Map',
    					closable: false,
    					autoScroll: false
    				}, {
					title: 'Documents',
					closable: false,
					autoScroll: true
				}] /* tab items */
    			}) /* Ext.create() */
    		];    	    
    	//console.log('Viewport.initComponent() pre-callParent()');	
    	this.callParent();
    	//console.log('Viewport.initComponent() post-callParent()');	
    	
    } /* initComponent */
});
    	
    	
			

