<!--- 

attributes:

text: link description
symbol: symbol
href: link target

--->

<cfoutput>
<span style="font-size:8px;">
<a href="#attributes.href#" style="display:inline;">

<table style=" padding:0px; display:inline; height:8px;" cellspacing="0" cellpadding="0">
	<tr>
		<td style="color:##666666;border:1px solid ##999999; font-size:8px;text-transform:uppercase;font-family:sans-serif;padding:0px;"><strong style="font-weight:bold;">#attributes.symbol#</strong></td>
		<td style="color:##666666;font-size:8px;text-transform:uppercase;font-family:sans-serif;padding:0px;">#attributes.text#</td>
	</tr>
</table>
</a>
</span>
</cfoutput>
