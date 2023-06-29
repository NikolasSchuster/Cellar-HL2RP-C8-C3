
ix.chatLanguages = ix.chatLanguages or {}
ix.chatLanguages.list = ix.chatLanguages.list or {}
ix.chatLanguages.chatTypesList = ix.chatLanguages.chatTypesList or {}

function ix.chatLanguages.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		CHAT_LANGUAGE = ix.chatLanguages.list[niceName] or {}
			if (PLUGIN) then
				CHAT_LANGUAGE.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory .. "/" .. v)

			CHAT_LANGUAGE.name = CHAT_LANGUAGE.name or "Unknown"
			CHAT_LANGUAGE.messageIcon = CHAT_LANGUAGE.messageIcon or Material("icon16/flag_blue.png")
			CHAT_LANGUAGE.panelIcon = CHAT_LANGUAGE.panelIcon or Material("icon16/flag_blue.png", "smooth")
			CHAT_LANGUAGE.bNotLearnable = CHAT_LANGUAGE.bNotLearnable or false
			CHAT_LANGUAGE.words = CHAT_LANGUAGE.words or {}

			ix.chatLanguages.list[niceName] = CHAT_LANGUAGE
		CHAT_LANGUAGE = nil
	end
end

function ix.chatLanguages.GetAll()
	return ix.chatLanguages.list
end

function ix.chatLanguages.Get(uniqueID)
	return ix.chatLanguages.list[uniqueID]
end

function ix.chatLanguages.AddChatType(uniqueID)
	if (ix.chat.classes[uniqueID]) then
		ix.chatLanguages.chatTypesList[uniqueID] = true

		return true
	end

	return false
end

function ix.chatLanguages.IsChatTypeValid(uniqueID)
	return ix.chatLanguages.chatTypesList[uniqueID] == true
end
