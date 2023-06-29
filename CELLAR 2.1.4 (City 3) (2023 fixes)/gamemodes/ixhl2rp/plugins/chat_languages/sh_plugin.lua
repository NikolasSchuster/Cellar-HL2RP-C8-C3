
PLUGIN.name = "Chat Languages"
PLUGIN.author = "LegAz"
PLUGIN.description = "Adds library, char var handling languages usage and message text loss on great distances."

ix.util.Include("sh_preperations.lua")

ix.util.Include("libs/sh_chat_languages.lua")
-- this is not the best way to create a char var, but we have no reasons to let it be stolen
ix.util.Include("libs/sv_character.lua")
ix.util.Include("libs/cl_character.lua")
ix.util.Include("meta/sv_character.lua")
ix.util.Include("meta/sh_character.lua")

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_commands.lua")

ix.chatLanguages.LoadFromDir(PLUGIN.folder .. "/chat_languages")

function PLUGIN:DoPluginIncludes(path)
	ix.chatLanguages.LoadFromDir(path .. "/chat_languages")
end

function PLUGIN:InitializedChatClasses()
	ix.chatLanguages.AddChatType("ic")
	ix.chatLanguages.AddChatType("w")
	ix.chatLanguages.AddChatType("y")
end

function PLUGIN:InitializedConfig()
	for k, v in pairs(ix.chatLanguages.list) do
		if (!v.bNotLearnable) then
			local preItemID = k .. "_textbook_volume"
			local preItemName = v.name .. " textbook #%d"

			for i = 1, ix.config.Get("languageTextbooksVolumeCount", 3) do
				local itemID = preItemID .. i

				ix.item.Register(itemID, "base_language_textbooks", false, nil)

				if (ix.item.list[itemID]) then
					ix.item.list[itemID].name = string.format(preItemName, i)
					ix.item.list[itemID].model = v.textbookModel or ix.item.list[itemID].model
					ix.item.list[itemID].languageID = k
					ix.item.list[itemID].volume = i
					ix.item.list[itemID].studyTime = ix.config.Get("languageTextbooksMinReadTime", 3600) * i
				end
			end
		end
	end
end

-- backward compatibility hack (we will not lose study progress twice)
if (SERVER) then
	function PLUGIN:PlayerLoadedCharacter(_, character)
		if (tonumber(character:GetCreateTime()) <= 1653963226 and !character:GetData("bLanguageStudyProgressRestored")) then
			local studyProgress = character:GetLanguagesStudyProgress()

			if (!table.IsEmpty(studyProgress)) then
				for k, v in pairs(studyProgress) do
					character:SetStudyProgress(k, v)
				end
	
				character:SetLanguagesStudyProgress()
			end

			character:SetData("bLanguageStudyProgressRestored", true)
		end
	end
end
