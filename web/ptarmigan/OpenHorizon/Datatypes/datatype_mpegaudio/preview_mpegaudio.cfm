<cfset mp3 = CreateObject("component", "ptarmigan.OpenHorizon.Audio.MP3").init()>
<cfset mp3.Open(attributes.fpath)>

<cfset prid = CreateUUID()>

<cfoutput>
	<table>
    <tr>
    <td>
	<img id="play_sound_#prid#" src="/graphics/AppIconResources/crystal_project/32x32/actions/player_play.png" style="display:inherit;" onclick="ORMSPlaySound('#attributes.turl#', '#prid#'); hideDiv('play_sound_#prid#'); showDiv('stop_sound_#prid#');">
	<img id="stop_sound_#prid#" src="/graphics/AppIconResources/crystal_project/32x32/actions/player_stop.png" style="display:none;" onclick="ORMSStopSound('#prid#'); showDiv('play_sound_#prid#'); hideDiv('stop_sound_#prid#');">
    </td>
    <td>
    <span class="LandingHeaderText">#mp3.SongTitle()#</span><br />
    #mp3.Artist()# - #mp3.AlbumTitle()#
    </td>
    </tr>
    </table>
</cfoutput>