Ext.define('pt_gis.view.search.search_tools', {
	extend: 'Ext.container.Container',
	alias: 'widget.searchtools',
	layout: { type: 'hbox' },
	initComponent: function () {
		this.items = [
			Ext.create('Ext.form.field.Text', {
				width: 250
			}),
			Ext.create('Ext.button.Split', {
				text: 'Search',
				menu: new Ext.menu.Menu({
					items: [
						{text: 'Search Type 1', handler: function(){ alert("Item 1 clicked"); }}
					]
				})
			})
		];
		
		this.callParent();
	}
});
