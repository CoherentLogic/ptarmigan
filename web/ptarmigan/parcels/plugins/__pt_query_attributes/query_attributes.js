var __pt_query_attributes = new pt_plugin({
		plugin_name: 'Query Attributes',
		
		on_activate: function () { 
			return (true); 
		},
		
		on_deactivate: function () { 
			return (true); 
		},
		
		on_feature_click: function (event_object, layer_object) {			
			var layer_id = layer_object.id;
			var feature_id =  event_object.target.feature._pt_feature_id;
			
			var feature_json = this.get_feature_data(layer_id, feature_id);
			
			feature_json.bJQueryUI = true;
			feature_json.bPaginate = false;
			feature_json.bFilter = false;
			feature_json.bSort = false;
			feature_json.bInfo = false;
			$("#plugin-output").html('<table cellpadding="0" cellspacing="0" border="0" class="display" id="feature-data"></table>');
			$("#feature-data").dataTable(feature_json);
			$("#plugin-output").dialog({
				width: 800,
				height: 400,
				title: 'Feature ' + feature_id + ' (' + layer_object.layer_name +  ')',
				resizable: true
			});
			
		}
	}
);

