local PLUGIN = PLUGIN

PLUGIN.name = "Ambient Music"
PLUGIN.description = "Ambient Music"
PLUGIN.author = "Schwarz Kruppzo"

if SERVER then 
	return
end

local timerID = "ixAmbient"
local ambients = {
	[1] = {"cellar/music/01.mp3", 612},
	[2] = {"cellar/music/02.mp3", 157},
	[3] = {"cellar/music/03.mp3", 344},
	[4] = {"cellar/music/04.mp3", 310},
	[5] = {"cellar/music/05.mp3", 194},
	[6] = {"cellar/music/06.mp3", 104},
	[7] = {"cellar/music/07.mp3", 173},
	[8] = {"cellar/music/08.mp3", 306},
	[9] = {"cellar/music/09.mp3", 327},
	[10] = {"cellar/music/10.mp3", 80},
	[11] = {"cellar/music/11.mp3", 240},
	[12] = {"cellar/music/12.mp3", 350},
	[13] = {"cellar/music/13.mp3", 262},
	[14] = {"cellar/music/14.mp3", 305},
	[15] = {"cellar/music/15.mp3", 197},
	[16] = {"cellar/music/16.mp3", 252},
	[17] = {"cellar/music/17.mp3", 349},
	[18] = {"cellar/music/18.mp3", 295},
	[19] = {"cellar/music/19.mp3", 154},
	[20] = {"cellar/music/20.mp3", 306},
	[21] = {"cellar/music/21.mp3", 205},
	[22] = {"cellar/music/22.mp3", 129},
	[23] = {"cellar/music/23.mp3", 565},
	[24] = {"cellar/music/24.mp3", 292},
	[25] = {"cellar/music/25.mp3", 406},
	[26] = {"cellar/music/26.mp3", 255},
	[27] = {"cellar/music/27v.mp3", 64},
	[28] = {"cellar/music/28v.mp3", 189},
	[29] = {"cellar/music/29v.mp3", 79}
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