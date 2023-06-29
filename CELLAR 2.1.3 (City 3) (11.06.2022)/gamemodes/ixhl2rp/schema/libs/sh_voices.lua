Schema.voices = {}
Schema.voices.stored = {}
Schema.voices.classes = {}
Schema.voices.counts = {}

function Schema.voices.Add(class, key, text, sound, global)
	class = string.utf8lower(class)
	key = string.utf8lower(key)

	Schema.voices.stored[class] = Schema.voices.stored[class] or {}
	Schema.voices.stored[class][key] = {
		text = text,
		sound = sound,
		global = global
	}

	Schema.voices.counts[class] = (Schema.voices.counts[class] or 0) + 1
end

function Schema.voices.Get(class, key)
	if (class and key) then
		class = string.utf8lower(class)
		key = string.utf8lower(key)
	end

	if (Schema.voices.stored[class]) then
		return Schema.voices.stored[class][key]
	end
end

function Schema.voices.GetCount(class)
	class = string.utf8lower(class)
	return Schema.voices.counts[class] or 0
end

function Schema.voices.AddClass(class, condition, chatTypes)
	class = string.utf8lower(class)

	local types

	if (isstring(chatTypes)) then
		types = {
			[chatTypes] = true
		}
	elseif (istable(chatTypes)) then
		types = {}

		-- convert chatTypes array to set
		for i = 1, #chatTypes do
			types[chatTypes[i]] = true
		end
	end

	Schema.voices.classes[class] = {
		condition = condition,
		chatTypes = types
	}
end

function Schema.voices.GetClass(client, chatType)
	local classes = {}

	for k, v in pairs(Schema.voices.classes) do
		if ((!v.chatTypes or v.chatTypes[chatType]) and v.condition(client)) then
			classes[#classes + 1] = k
		end
	end

	return classes
end
