
PLUGIN.name = "Textbook Base"
PLUGIN.author = "LegAz"
PLUGIN.description = "Add \"!textbook\" item base to fill any need of making learnable stuff."

ix.char.RegisterVar("studyProgresses", {
	field = "study_progresses",
	fieldType = ix.type.text,
	default = {},
	isLocal = true,
	bNoDisplay = true
})

ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sv_character.lua")
ix.util.Include("meta/sv_player.lua")
