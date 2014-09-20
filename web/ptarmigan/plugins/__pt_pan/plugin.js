var __pt_pan = new pt_plugin({
		plugin_name: '__pt_pan',
		
		on_installed: function () {			
			return(true);
		},
		
		on_activate: function () {
			this.notify(this.text, 'Click and drag the map to pan.');			
			this.take_map_ownership();
			return(true);
			
		},
				
		on_deactivate: function () { 
			this.release_map_ownership();
			return (true); 
		},

		selectable: true,
		text: 'Pan'
	}
);