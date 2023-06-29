local PLUGIN = PLUGIN

PLUGIN.name = "Damage System"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = ""

PLUGIN.RANGE_CLOSE = 1
PLUGIN.RANGE_MEDIUM = 2
PLUGIN.RANGE_LONG = 3
PLUGIN.RANGE_FAR = 4

ix.char.RegisterVar("shock", {
	field = "shock",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("blood", {
	field = "blood",
	fieldType = ix.type.number,
	default = -1,
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("dmgData", {
	field = "dmgData",
	fieldType = ix.type.string,
	default = {
		isBleeding = 0,
		isPain = false,
		bleedBone = 0,
		bleedDmg = 0
	},
	isLocal = true,
	bNoDisplay = true
})

do
	local PLAYER = FindMetaTable("Player")
	local CHAR = ix.meta.character

	function PLAYER:IsUnconscious()
		return self:GetLocalVar("knocked", false)
	end

	function CHAR:IsBleeding()
		return self:GetDmgData().isBleeding or false
	end

	function CHAR:IsFeelPain()
		return self:GetDmgData().isPain or false
	end

	function CHAR:GetBleedingBone()
		return self:GetDmgData().bleedBone or 0
	end
end

PLUGIN.hitBones = {
	[HITGROUP_HEAD] = {
		"ValveBiped.Bip01_Head1",
		"ValveBiped.Bip01_Neck1",
	},
	[HITGROUP_CHEST] = {
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
	},
	[HITGROUP_STOMACH] = {
		"ValveBiped.Bip01_Spine1",
		"ValveBiped.Bip01_Spine",
	},
	[HITGROUP_LEFTARM] = {
		"ValveBiped.Bip01_L_UpperArm",
		"ValveBiped.Bip01_L_Forearm",
		"ValveBiped.Bip01_L_Hand",
	},
	[HITGROUP_RIGHTARM] = {
		"ValveBiped.Bip01_R_UpperArm",
		"ValveBiped.Bip01_R_Forearm",
		"ValveBiped.Bip01_R_Hand",
	},
	[HITGROUP_LEFTLEG] = {
		"ValveBiped.Bip01_L_Thigh",
		"ValveBiped.Bip01_L_Calf",
	},
	[HITGROUP_RIGHTLEG] = {
		"ValveBiped.Bip01_R_Thigh",
		"ValveBiped.Bip01_R_Calf",
	},
	[HITGROUP_GENERIC] = {
		"ValveBiped.Bip01_Spine4",
		"ValveBiped.Bip01_Spine2",
	},
}

do
	local clrRed = Color(255, 100, 100, 255)

	ix.chat.Register("dmgMsg", {
		OnCanHear = function(self, speaker, listener)
			return true
		end,
		CanSay = function(self, speaker)
			return !IsValid(speaker)
		end,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			if data.t == 1 then
				chat.AddText(clrRed, string.format("Вас добивает игрок %s (%s)!", data.attacker:Name(), data.attacker:GetAnonID()))
			elseif data.t == 2 then
				chat.AddText(color_white, "После игровой смерти, Вы потеряли 30% своих вещей и жетонов.")
			elseif data.t == 3 then
				chat.AddText(color_white, "Вас прекратили добивать!")
			end
		end
	})

	ix.chat.Register("dmgAdminMsg", {
		OnCanHear = function(self, speaker, listener)
			if CAMI.PlayerHasAccess(listener, "Helix - Admin Chat", nil) then
				return true
			end

			return false
		end,
		CanSay = function(self, speaker)
			return !IsValid(speaker)
		end,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			if !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Admin Chat", nil) then
				return
			end

			if data.t == 1 then
				chat.AddText(clrRed, string.format("Игрок %s (%s) пытается добить игрока %s (%s)!", data.attacker:Name(), data.attacker:GetAnonID(), data.crit:Name(), data.crit:GetAnonID()))
			elseif data.t == 2 then
				chat.AddText(clrRed, string.format("%s (%s) был добит игроком %s (%s)!", data.crit:Name(), data.crit:GetAnonID(), data.attacker:Name(), data.attacker:GetAnonID()))
			end
		end
	})
end

function PLUGIN:CanTransferItem(itemTable, curInv, inventory)
	if !itemTable.Dropped then
		if curInv.vars and curInv.vars.isDrop and inventory:GetID() == curInv:GetID() then
			return false
		end
		
		if inventory.vars and inventory.vars.isDrop then
			return false
		end
	else
		return true
	end
end

function PLUGIN:OnItemTransferred(itemTable, curInv, inventory)
	if curInv.vars and curInv.vars.isDrop and table.IsEmpty(curInv:GetItems()) then
		itemTable.Dropped = nil

		local container = curInv.vars.entity

		if IsValid(container) then
			container:Remove()
		end
	end
end

function PLUGIN:PlayerTraceAttack(client, dmgInfo, dir, trace)
	if dmgInfo:GetDamage() <= 0 then
		return true
	end

	if CLIENT then
		return true
	end
end

ix.util.Include("meta/sh_damage.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")

