PLUGIN.name = "Spawn Notifications"
PLUGIN.author = "Riggs"
PLUGIN.description = "A notification which tells the player their status on loading the character."

-- Feel free to change any of these messages.
local wakeupmessages = {
	"Вы просыпаетесь после долгого сна и пытаетесь восстановить свои силы.",
	"Вы встаете и пытаетесь вдохнуть воздух этого мира полной грудью.",
	"Вы поднимаетесь и стараетесь открыть глаза после долгого сна.",
	"Вы чуствуете, словно вам приснился какой-то кошмар, опять, после чего просыпаетесь.",
	"Вам кто-то снился, но услышав какой-то странный голос - тут же проснулись.",
	"Вы услышали едва заметные шаги и шептания где-то вдали, после чего просыпаетесь от ужаса.",
	"Вы слышите звон сирены и странный топот, после чего просыпаетесь.",
	"Вы проснулись с урчанием в животе и усталостью от всего, что вас окружает.",
	"Вы проснулись после того, как услышали какой-то пугающий, но до боли знакомый звук.",
}

function PLUGIN:PlayerSpawn(ply)
	local char = ply:GetCharacter()
	if not (ply:IsValid() or ply:Alive()) then return end
	if (not char) then return end
	if char:IsDispatch() then return end
	ply:ConCommand("play music/stingers/hl1_stinger_song16.mp3")
	ply:ScreenFade(SCREENFADE.IN, color_black, 3, 2)
	ply:ChatPrint(table.Random(wakeupmessages))
end
