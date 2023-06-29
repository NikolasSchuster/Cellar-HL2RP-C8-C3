ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sign Interior Wall"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_sign_interior_wall", {
	-- General data
	general = {
		text = {d = "Roulette Tables", t = "string"} -- The text to show
	}
},
"models/freeman/owain_interiorsign_wall.mdl")