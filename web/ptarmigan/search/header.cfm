<cfinclude template="#session.root_url#/navigation.cfm">
<!--- BEGIN LAYOUT --->	
<div id="container" class="panel">
	<h1>Search Results</h1>
	<cfoutput><div class="search_result_count">#attributes.result_count# results (#attributes.result_time# seconds)</div></cfoutput>