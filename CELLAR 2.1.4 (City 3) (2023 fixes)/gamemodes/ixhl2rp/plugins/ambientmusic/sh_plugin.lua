local PLUGIN = PLUGIN

PLUGIN.name = "Ambient Music"
PLUGIN.description = "Ambient Music"
PLUGIN.author = "Schwarz Kruppzo"

if SERVER then
	return
end

local timerID = "ixAmbient"
local ambients = {
	[1] = {"cellar/music/01.mp3", 309},
	[2] = {"cellar/music/02.mp3", 305},
	[3] = {"cellar/music/03.mp3", 349},
	[4] = {"cellar/music/04.mp3", 261},
	[5] = {"cellar/music/05.mp3", 304},
	[6] = {"cellar/music/06.mp3", 251},
	[7] = {"cellar/music/07.mp3", 320},
	[8] = {"cellar/music/08.mp3", 332},
	[9] = {"cellar/music/09.mp3", 222},
	[10] = {"cellar/music/10.mp3", 563},
	[11] = {"cellar/music/11.mp3", 290},
	[12] = {"cellar/music/12.mp3", 405},
	[13] = {"cellar/music/13.mp3", 253},
	[14] = {"cellar/music/14v.mp3", 62},
	[15] = {"cellar/music/15v.mp3", 187},
	[16] = {"cellar/music/16v.mp3", 75},
	[17] = {"cellar/music/17.mp3", 230},
	[18] = {"cellar/music/18.mp3", 573},
	[19] = {"cellar/music/19.mp3", 290},
	[20] = {"cellar/music/20.mp3", 290},
	[21] = {"cellar/music/21.mp3", 341},
	[22] = {"cellar/music/22.mp3", 347},
	[23] = {"cellar/music/23.mp3", 190},
	[24] = {"cellar/music/24.mp3", 304},
	[25] = {"cellar/music/25.mp3", 46},
}

local function SetVolume(volume)
	if PLUGIN.snd then
		PLUGIN.snd:ChangeVolume(volume)
	end
end

local function StopAmbient()
	if timer.Exists(timerID) then
		timer.Remove(timerID)
	end

	if PLUGIN.snd then
		PLUGIN.snd:Stop()
		PLUGIN.snd = nil
	end
end

local function PlayAmbient(ambientData)
	if LocalPlayer():InOutlands() then
		ambientData = {
			"cellar_event/music_tno.mp3",
			223
		}
	end

	StopAmbient()

	PLUGIN.snd = CreateSound(LocalPlayer(), ambientData[1])
	PLUGIN.snd:Play()

	timer.Simple(0, function()
		PLUGIN.snd:ChangeVolume(ix.option.Get("ambientVol"), 0)
	end)

	timer.Create(timerID, ambientData[2] + ix.option.Get("ambientTime", 0), 1, function()
		PlayAmbient(ambients[math.random(1, #ambients)])
	end)
end

function PLUGIN:CharacterLoaded(character)
	if timer.Exists(timerID) or !ix.option.Get("ambientToggle") then
		return
	end

	PlayAmbient(ambients[math.random(1, #ambients)])
end

ix.option.Add("ambientToggle", ix.type.bool, true, {
	category = "Музыка",
	OnChanged = function(_, value)
		if !value then
			StopAmbient()
			return
		end

		PlayAmbient(ambients[math.random(1, #ambients)])
	end
})

ix.option.Add("ambientVol", ix.type.number, 1, {
	category = "Музыка",
	decimals = 2,
	min = 0.01,
	max = 1,
	OnChanged = function(_, value)
		SetVolume(value)
	end
})

ix.option.Add("ambientTime", ix.type.number, 0, {
	category = "Музыка",
	decimals = 0,
	min = 0,
	max = 600
})

ix.lang.AddTable("english", {
	optAmbientToggle = "Toggle music",
	optAmbientVol = "Music volume",
	optAmbientTime = "Time between music (sec)",
})

ix.lang.AddTable("russian", {
	optAmbientToggle = "Включить музыку",
	optAmbientVol = "Громкость музыки",
	optAmbientTime = "Время между музыкой (сек)"
})