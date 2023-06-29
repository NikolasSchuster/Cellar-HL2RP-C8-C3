ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sign Plaque"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_sign_plaque", {
	-- General data
	general = {
		text = {d = "Cool Casino", t = "string"} -- The text to show
	}
},
"models/freeman/owain_casinosign_text.mdl")