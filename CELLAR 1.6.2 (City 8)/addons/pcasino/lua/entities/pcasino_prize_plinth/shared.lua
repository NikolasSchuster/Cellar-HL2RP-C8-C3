ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sign Wall Logo"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_prize_plinth", {
	general = {
		rope = {d = true, t = "bool"},
		model = {d = "models/buggy.mdl", t = "string"}, 
		spin = {d = true, t = "bool"}, 
		bow = {d = false, t = "bool"}, 
		bowOffset = {d = 0, t = "int"}, 
	},
},
"models/freeman/owain_prize_plinth.mdl")