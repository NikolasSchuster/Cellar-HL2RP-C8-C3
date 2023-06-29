local PLUGIN = PLUGIN

PLUGIN.name = "Radiation System"
PLUGIN.description = "Adds a radiation system."
PLUGIN.author = "SchwarzKruppzo"

ix.char.RegisterVar("radLevel", {
	field = "rad",
	fieldType = ix.type.number,
	default = 0,
	isLocal = true,
	bNoDisplay = true
})

function PLUGIN:SetupAreaProperties()
	ix.area.AddType("rad")

	ix.area.AddProperty("radDamage", ix.type.number, 1)
end

do
	local CHAR = ix.meta.character

	function CHAR:GetRadResistance()
		local resist = 0 

		if self:GetFaction() == FACTION_VORTIGAUNT or self:GetFaction() == FACTION_ZOMBIE or self:IsOTA() then
			return 100
		else
			local armor = self:GetPlayer().ArmorItems

			for item, _ in pairs(armor) do 
				if !item.RadResist then continue end

				resist = resist + item.RadResist
			end
		end

		local gasmask = self:HasWearedFilter()
		local filter = self:HasWearedFilter()

		if gasmask then
			resist = resist + 10
		end

		if filter and filter:GetFilterQuality() > 0 then
			resist = resist + 89
		end

		return math.min(resist, 99)
	end

	function CHAR:HasWearedFilter()
		return self:GetInventory():HasItemOfBase("base_filter", {equip = true})
	end

	function CHAR:HasWearedGasmask()
		return self:GetInventory():HasItemOfBase("base_gasmask", {equip = true})
	end

	function CHAR:HasGeigerCounter()
		if self:GetFaction() == FACTION_OTA then
			return true
		elseif self:GetFaction() == FACTION_MPF then
			return true
		end

		return self:GetInventory():HasItem("geiger_counter")
	end
end

ix.command.Add("CharSetRad", {
	description = "Установить игроку уровень радиации",
	privilege = "Edit Rad Level",
	adminOnly = true,
	arguments = {ix.type.character, ix.type.number},
	OnRun = function(self, client, target, rad)
		target:SetRadLevel(rad)
		return "Rad level changed."
	end

})

ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")