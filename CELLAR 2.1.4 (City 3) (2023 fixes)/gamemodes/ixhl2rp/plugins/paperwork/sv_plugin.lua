local PLUGIN = PLUGIN

do
	local F1 = "<.*>(.*)</.*>"
	local F2 = "%1"
	local SIGN = "[sign]"
	local FIELD = "[field]"
	local SIGNF = "$s$%s$/s$"
	local FIELDF = "<span class=\"textarea\" contenteditable></span>$f$"

	function PLUGIN:ParseText(character, text)
		text = string.gsub(text, F1, F2)
		text = string.Replace(text, "$s$", "")
		text = string.Replace(text, "$/s$", "")
		text = string.Replace(text, "$f$", "")
		text = string.utf8sub(text, 1, self.maxLength)
		text = string.Replace(text, SIGN, Format(SIGNF, character:GetName()))
		text = string.Replace(text, FIELD, FIELDF)

		return text
	end
end

do
	local FIELD = "[field]"
	local FIELDF = "<span class%=%ptextarea%p contenteditable><%/span>%$f%$"

	function PLUGIN:ParseFields(character, text, fields)
		local i = 1
		for field in string.gmatch(text, FIELDF) do
			local replacement = FIELD
			
			if fields[i] and #fields[i] != 0 and !string.match(fields[i], "^s*$") then
				replacement = "[u]"..self:ParseText(character, fields[i]).."[/u]"
			end
			
			text = string.gsub(text, FIELDF, replacement, 1)

			i = i + 1
		end

		text = string.Replace(text, FIELD, "<span class=\"textarea\" contenteditable></span>$f$")

		return text
	end
end

netstream.Hook("ixWritePaper", function(client, itemID, title, text, pickup)
	local character = client:GetCharacter()

	if !character then return end

	local item = ix.item.instances[itemID]

	if !item then return end
	if !item.user[client] then return end

	local owner = item:GetData("O", 0)
	local time = item:GetData("canEdit", nil)

	if owner == 0 then
		item:SetData("canEdit", os.time() + 600)
	elseif owner != 0 and (time and os.time() > time) then 
		return 
	end

	text = PLUGIN:ParseText(character, text)

	item:Write(title, text, character)
	item:SetData("D", pickup)

	item.user[client] = nil
end)

netstream.Hook("ixEditPaper", function(client, itemID, fields)
	local character = client:GetCharacter()

	if !character then return end

	local item = ix.item.instances[itemID]

	if !item then return end

	if !item.user[client] then return end

	local owner = item:GetData("O", 0)

	if owner == 0 then return end

	local text = item:GetData("T", "")

	text = PLUGIN:ParseFields(character, text, fields)

	item:Write(nil, text, nil)

	item.user[client] = nil
end)

netstream.Hook("ixWritePaperClosed", function(client, itemID)
	local item = ix.item.instances[itemID]

	if !item then return end
	if item.user[client] then
		item.user[client] = nil
	end
end)