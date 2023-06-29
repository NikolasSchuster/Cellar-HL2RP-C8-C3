
local PLUGIN = PLUGIN

PLUGIN.name = "Character Height"
PLUGIN.author = "LegAz"
PLUGIN.description = "Adds ability to chose character height on creation."
PLUGIN.gendersHeight = {
	[GENDER_MALE or 1] = {0.97, 1.03},
	[GENDER_FEMALE or 2] = {0.96, 1.04}
}

ix.util.Include("sv_character.lua")
ix.util.Include("cl_character.lua")
ix.util.Include("cl_charload.lua")

ix.lang.AddTable("russian", {
	height = "Рост"
})

--[[
ix.command.Add("CharSetHeight", {
	description = "@cmdCharSetHeight",
	superAdminOnly = true,
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnRun = function(self, client, target, newHeight)
		target:SetHeight(newHeight)
	end
})
]]
