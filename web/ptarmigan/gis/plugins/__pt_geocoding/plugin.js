var __pt_geocoding = new pt_plugin({
		plugin_name: '__pt_geocoding',
		
		on_installed: function () { return(true); },
		
		on_activate: function () {
			alert('Geocoding');
			return(true);
		},
				
		selectable: false,
		text: 'Address Search'
	}
);