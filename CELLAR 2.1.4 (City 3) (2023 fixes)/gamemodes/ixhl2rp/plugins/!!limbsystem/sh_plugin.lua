local PLUGIN = PLUGIN

PLUGIN.name = "Limb System"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = "Adds a limb damage system."

ix.util.Include("sh_config.lua")
ix.util.Include("sh_limbsystem.lua")
ix.util.Include("meta/sh_limbobject.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_limbdata.lua")

ix.char.RegisterVar("limbData", {
	field = "limbData",
	fieldType = ix.type.text,
	default = {},
	isLocal = true,
	bNoDisplay = true
})

function PLUGIN:CharacterLoaded(character)
	local gender = character:GetGender()

	if gender == GENDER_MALE then
		character.limbobject = LDATA_HUMAN_MALE
	elseif gender == GENDER_FEMALE then
		character.limbobject = LDATA_HUMAN_FEMALE
	end
end
