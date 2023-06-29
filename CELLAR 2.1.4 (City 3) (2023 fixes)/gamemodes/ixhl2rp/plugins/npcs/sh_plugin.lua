local PLUGIN = PLUGIN

PLUGIN.name = "NPC and Dialogue system"
PLUGIN.author = "SchwarzKruppzo"
PLUGIN.description = ""

DFLAG_GOODBYE = 1
DFLAG_ONCE = 2
DFLAG_CHALLENGE = 4
DFLAG_RUMOURS = 8
DFLAG_DYNAMIC = 16

ix.dialogues = ix.dialogues or {}
ix.dialogues.stored = {}

function ix.dialogues.Add(class, topicTable)
	ix.dialogues.stored[class] = topicTable
end

ix.lang.AddTable("english", {
	pressSpeak = "Press [E] to talk.",
})

ix.lang.AddTable("russian", {
	pressSpeak = "Нажмите [E] чтобы поговорить",
})

ix.char.RegisterVar("knownTopics", {
	field = "topics",
	fieldType = ix.type.string,
	default = {},
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("dialogData", {
	field = "dlgdata",
	fieldType = ix.type.string,
	default = {},
	isLocal = true,
	bNoDisplay = true
})

ix.util.Include("sh_rumours.lua")
ix.util.Include("sh_dialogues.lua")

ix.util.Include("meta/sh_dialogue.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sv_hooks.lua")