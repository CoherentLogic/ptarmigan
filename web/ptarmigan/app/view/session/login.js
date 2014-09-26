Ext.define('pt_gis.view.session.login', {
	extend: 'Ext.window.Window',
	alias: 'widget.login',
	title: 'Log In',	
	layout: 'absolute',
	width: 425,
	height: 282,
	initComponent: function() {	
		this.items = [{
			xtype: 'form',
			layout: 'absolute',
			bodyStyle: 'background-image:url(/images/signin-gis.png)',
			width: 415,
			height: 282,
			bodyPadding:10,
			items: [{
				xtype: 'label',
				text: 'Username:',
				x: 165,
				y: 80,
				style: 'color: black; font-weight: bold; font-size: 12px;'
			}, {
				xtype: 'textfield',
				name: 'username',
				x: 160,
				y: 98,
				height: 28,
				width: 200
			}, {
				xtype: 'label',
				text: 'Password:',
				x: 165,
				y: 136,
				style: 'color: black; font-weight: bold; font-size: 12px;'
			}, {
				xtype: 'textfield',
				inputType: 'password',
				name: 'password',
				height: 28,
				width: 200,
				x: 160,
				y: 154			
			}, {
				xtype: 'label',
				text: 'Copyright \u00A9 2014 Geodigraph',
				x: 5,
				y: 190,
				style: 'color: #c0c0c0; font-weight: light; font-size: 10px;'
			}]
		}];
		
		this.buttons = [{
			text: 'Log In',
			action: 'login'			
		}, {
			text: 'Continue as Guest',
			scope: this,
			handler: this.close
		}];
		
		this.callParent(arguments);
	}
});
