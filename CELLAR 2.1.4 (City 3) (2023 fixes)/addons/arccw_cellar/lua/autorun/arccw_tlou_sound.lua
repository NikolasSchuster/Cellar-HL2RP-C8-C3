local sadd = sound.Add -- :(
local ups = util.PrecacheSound -- yeah

local ARC_PRNARTST_PD2_FS = {} -- firing sounds

ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_9MM"] = "weapons/9mm/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_HNTRFL"] = "weapons/hunting/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_ASTRFL"] = "weapons/assaultrifle/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_SPC"] = "weapons/spectre/fire1.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_SM"] = "weapons/semiauto/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_EL"] = "weapons/ellies/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_FA"] = "weapons/fullauto/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_REV"] = "weapons/revolver/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_TLOU_BR"] = "weapons/burstrifle/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_PSG"] = "weapons/psg/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_LOCO"] = "weapons/loco/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_870"] = "weapons/870/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_S12"] = "weapons/iza/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_MOS"] = "weapons/mos/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_BRONCO"] = "weapons/bronco/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_BER"] = "weapons/ber/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_CROSS"] = "weapons/cross/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_CHIM"] = "weapons/chim/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_STK"] = "weapons/stk/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_DEAGLE"] = "weapons/deagle/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_MRK"] = "weapons/mrk/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_CM5"] = "weapons/cm5/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_CMP"] = "weapons/cmp/fire.wav"
ARC_PRNARTST_PD2_FS["ARC_PRNARTST_PD2_K90"] = "weapons/k90/fire.wav"

local ARC_PRNARTST_PD2_FSS = {} -- firing sounds suppressed

-- Suppressed sounds
ARC_PRNARTST_PD2_FSS["ARC_PRNARTST_PD2_AKSUP"] = "weapons/uni/aksup.wav"
ARC_PRNARTST_PD2_FSS["ARC_PRNARTST_PD2_ARSUP"] = "weapons/uni/arsup.wav"
ARC_PRNARTST_PD2_FSS["ARC_PRNARTST_PD2_PISTSUP"] = "weapons/uni/pistsup.wav"
ARC_PRNARTST_PD2_FSS["ARC_PRNARTST_PD2_REVSUP"] = "weapons/uni/revsup.wav"
ARC_PRNARTST_PD2_FSS["ARC_PRNARTST_PD2_SHOTGUNSUP"] = "weapons/uni/shotgunsup.wav"
ARC_PRNARTST_PD2_FSS["ARC_PRNARTST_PD2_SMGSUP"] = "weapons/uni/smgsup.wav"

local ARC_PRNARTST_PD2_FSD = {}-- firing sounds distant

-- Distant sounds
--[[ARC_PRNARTST_PD2_FSD["ARC_PRNARTST_PD2_YOUR_SHIT_HERE"] = "weapons/thisnuts/dist.wav
follow my formatting and add your distant sounds here]]

-- set them all up at once and save a lot of effort

local tbl = {channel = CHAN_AUTO, 
	volume = 1,
	soundlevel = 100,
	pitchstart = 92,
	pitchend = 112}

for k, v in pairs(ARC_PRNARTST_PD2_FS) do
	tbl.name = k
	tbl.sound = v
		
	sadd(tbl)
	
	if type(v) == "table" then
		for k2, v2 in pairs(v) do
			ups(v2)
		end
	else
		ups(v)
	end
end	

local tbl = {channel = CHAN_AUTO,
	volume = 1,
	soundlevel = 70,
	pitchstart = 92,
	pitchend = 112}

for k, v in pairs(ARC_PRNARTST_PD2_FSS) do
	tbl.name = k
	tbl.sound = v
		
	sadd(tbl)
	
	if type(v) == "table" then
		for k2, v2 in pairs(v) do
			ups(v2)
		end
	else
		ups(v)
	end
end	

--[[local tbl = {channel = CHAN_AUTO,
	volume = 0.5,
	soundlevel = 149,
	pitchstart = 92,
	pitchend = 112}

	for k, v in pairs(ARC_PRNARTST_PD2_FSD) do
	tbl.name = k
	tbl.sound = v
		
	sadd(tbl)
	
	if type(v) == "table" then
		for k2, v2 in pairs(v) do
			ups(v2)
		end
	else
		ups(v)
	end
end]]

--awesome and cool script by rzen1th