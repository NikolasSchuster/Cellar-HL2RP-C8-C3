ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mysterly Wheel"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_mystery_wheel", {
	general = {
		useFreeSpins = {d = true, t = "bool"} -- Can you use free spins on this machine
	},
	buySpin = {
		buy = {d = false, t = "bool"}, -- Can you buy a spin on this machine
		cost = {d = 1000000, t = "int"}, 
	},
	-- Combo data
	wheel = { -- I know, 20 slots :O
		{n = "$1", f = "money", i = 1, p = "dolla"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "$250,000", f = "money", i = 250000, p = "dolla"},
		{n = "Spin Again", f = "prize_wheel", i = "nil", p = "mystery_1"},
		{n = "Crossbow", f = "weapon", i = "weapon_crossbow", p = "chest"},
		{n = "$1,000,000", f = "money", i = 1000000, p = "dolla"},
		{n = "100 Points", f = "ps1_points", i = 100, p = "coins"},
		{n = "Vehicle", f = "wcd_givecar", i = "alfa_stradaletdm", p = "car"},
		{n = "Die", f = "kill", i = "nil", p = "bell"},
		{n = "$50,000", f = "money", i = 50000, p = "dolla"},
		{n = "Cone Hat", f = "ps1_item", i = "conehat", p = "berry"},
		{n = "100% Armor", f = "armor", i = 100, p = "diamond"},
		{n = "SMG", f = "weapon", i = "weapon_smg1", p = "chest"},
		{n = "Nothing", f = "nothing", i = "nil", p = "melon"},
		{n = "100% Health", f = "health", i = 100, p = "diamond"},
		{n = "$100,000", f = "money", i = 100000, p = "dolla"},
		{n = "Be Alyx", f = "setmodel", i = "models/player/alyx.mdl", p = "cherry"},
		{n = "250 Points", f = "ps1_points", i = 250, p = "coins"},
		{n = "450 XP", f = "bwe_givexp", i = 450, p = "clover"},
		{n = "7 HP", f = "health", i = 7, p = "seven"},
	}
},
"models/freeman/owain_mystery_wheel.mdl")