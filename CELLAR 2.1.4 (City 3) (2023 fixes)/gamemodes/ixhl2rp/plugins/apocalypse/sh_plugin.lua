local PLUGIN = PLUGIN

PLUGIN.name = "Apocalypse"
PLUGIN.author = "maxxoft"
PLUGIN.description = "The end of times."

ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_anims.lua")

ix.command.Add("StartApocalypse", {
	description = "Start the apocalypse.",
	superAdminOnly = true,
	OnRun = function(self, client)
		PLUGIN:StartApocalypse()
	end
})

ix.command.Add("CharInfect", {
	description = "Infect the character.",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, character)
		PLUGIN:InfectCharacter(character)
	end
})

ix.command.Add("ZAdvance", {
	description = "Advance character's disease.",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, character)
		PLUGIN:AdvanceDisease(character)
	end
})

ix.command.Add("ZCure", {
	description = "Remove disease.",
	superAdminOnly = true,
	arguments = ix.type.character,
	OnRun = function(self, client, character)
		character:SetData("zombie", nil)
		character:SetData("zstage", nil)
		timer.Remove("ixInfection_" .. character:GetID())
	end
})

if SERVER then
	PLUGIN.models = {
		["models/cellar/characters/city3/citizens/female/c3_female_01.mdl"] = "models/freshdead/freshdead_05.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_02.mdl"] = "models/freshdead/freshdead_06.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_03.mdl"] = "models/freshdead/freshdead_07.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_04.mdl"] = "models/freshdead/freshdead_05.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_05.mdl"] = "models/freshdead/freshdead_06.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_06.mdl"] = "models/freshdead/freshdead_05.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_07.mdl"] = "models/freshdead/freshdead_06.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_08.mdl"] = "models/freshdead/freshdead_05.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_09.mdl"] = "models/freshdead/freshdead_05.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_10.mdl"] = "models/freshdead/freshdead_06.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_11.mdl"] = "models/freshdead/freshdead_05.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_12.mdl"] = "models/freshdead/freshdead_07.mdl",
		["models/cellar/characters/city3/citizens/female/c3_female_13.mdl"] = "models/freshdead/freshdead_07.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_01.mdl"] = "models/freshdead/freshdead_01.mdll",
		["models/cellar/characters/city3/citizens/male/c3_male_02.mdl"] = "models/freshdead/freshdead_02.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_03.mdl"] = "models/freshdead/freshdead_03.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_04.mdl"] = "models/freshdead/freshdead_04.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_05.mdl"] = "models/zombie/grabber_06.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_06.mdl"] = "models/zombie/seeker_02.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_07.mdl"] = "models/zombie/grabber_08.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_08.mdl"] = "models/zombie/junkie_03.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_09.mdl"] = "models/zombie/grabber_10.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_10.mdl"] = "models/zombie/grabber_07.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_11.mdl"] = "models/zombie/infected_07.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_12.mdl"] = "models/zombie/grabber_03.mdl",
		["models/cellar/characters/city3/citizens/male/c3_male_13.mdl"] = "models/zombie/grabber_06.mdl"
	}

	function PLUGIN:StartApocalypse()
		local players = player.GetAll()

		for _, ply in ipairs(players) do
			self:InfectCharacter(ply:GetCharacter())
		end
	end

	function PLUGIN:InfectCharacter(character)
		if character:IsOTA() then return end
		if character:GetFaction() == FACTION_VORTIGAUNT then return end
		if character:GetData("zombie") then return end
		if character:GetData("hasVaccine") then return end

		character:SetData("zombie", true)

		local timerID = "ixInfection_" .. character:GetID()
		timer.Create(timerID, 600, 3, function()
			if not character then
				timer.Remove(timerID)
			end
			self:AdvanceDisease(character)
		end)
	end

	function PLUGIN:AdvanceDisease(character)
		if character:IsOTA() then return end
		if character:GetFaction() == FACTION_VORTIGAUNT then return end
		if not character:GetData("zombie") then return end

		local stage = character:GetData("zstage", 0)
		stage = math.Clamp(stage + 1, 0, 3)
		character:SetData("zstage", stage)

		if stage == 1 then
			timer.Simple(40, function()
				ix.chat.Send(character:GetPlayer(), "me", "начинает непроизвольно кашлять.")
				timer.Simple(40, function()
					ix.chat.Send(character:GetPlayer(), "me", "дрожит и нервно осматривается, постукивая зубами.")
				end)
			end)
		elseif stage == 2 then
			timer.Simple(40, function()
				ix.chat.Send(character:GetPlayer(), "me", "кашляет кровью и тяжело дышит.")
			end)

		elseif stage == 3 then
			ix.chat.Send(character:GetPlayer(), "me", "теряет свой рассудок и впадает в бешенство.")
			local items = character:GetInventory():GetItemsByBase("base_weaponstest", true)
			character:HealLimbs(100)
			character:GetPlayer():SetHealth(100)
			character:SetBlood(10000)

			for _, item in pairs(items) do
				if isfunction(item.Unequip) then
					item:Unequip(character:GetPlayer(), true)
				end
			end

			if character:IsCombine() then
				character:SetModel("models/cpassic/cpassic.mdl")
			else
				character:SetModel(self.models[character:GetModel()] or table.Random(self.models))
			end
		end
	end
end


function PLUGIN:CanPlayerInteractEntity(client, entity)
	if IsValid(client) and client:GetCharacter():GetData("zstage") == 3 then
		return false
	end
end

local ENT = scripted_ents.GetStored("nz_base").t

local nb_npc = GetConVar("nb_npc")
local ai_ignoreplayers = GetConVar("ai_ignoreplayers")
local nb_targetmethod = GetConVar("nb_targetmethod")

function ENT:SearchForEnemy( ents )
	for k,v in pairs( ents ) do
		if nb_targetmethod:GetInt() == 1 then
			if not self:IsLineOfSightClear( v ) then

				return end

		end

		if nb_npc:GetInt() == 1 then

			local enemy = math.random(1,2)

			if enemy == 1 then
				if v:IsPlayer() and v:Alive() then
					if ai_ignoreplayers:GetInt() == 0 then
						if v:GetCharacter():GetData("zstage") != 3 then
							self:SetEnemy( v )
							return true
						end
					end
				else
					if v:IsNPC() and v != self and not string.find(v:GetClass(), "npc_nextbot_*") and not string.find(v:GetClass(), "npc_bullseye") and not string.find(v:GetClass(), "npc_grenade_frag") and not string.find(v:GetClass(), "animprop_generic") then
						self:SetEnemy( v )
						return true
					end
				end
			else
				if v:IsNPC() and v != self and not string.find(v:GetClass(), "npc_nextbot_*") and not string.find(v:GetClass(), "npc_bullseye") and not string.find(v:GetClass(), "npc_grenade_frag") and not string.find(v:GetClass(), "animprop_generic") then
					self:SetEnemy( v )
					return true
				end
			end

		else

			if v:IsPlayer() and v:Alive() then
				if ai_ignoreplayers:GetInt() == 0 then
					if v:GetCharacter():GetData("zstage") != 3 then
						self:SetEnemy( v )
						return true
					end
				end
			end

		end

	end

	self:SetEnemy( nil )
	return false
end
