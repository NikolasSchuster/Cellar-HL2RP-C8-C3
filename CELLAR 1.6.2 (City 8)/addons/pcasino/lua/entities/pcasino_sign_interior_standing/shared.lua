ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sign Interior Standing"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_sign_interior_standing", {
	-- General data
	general = {
		text = {d = "Welcome to the Cool Casino. We hope you enjoy your stay!", t = "string"} -- The text to show
	}
},
"models/freeman/owain_interiorsign_standing.mdl")