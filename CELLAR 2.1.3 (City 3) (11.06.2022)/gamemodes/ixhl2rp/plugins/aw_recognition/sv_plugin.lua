local PLUGIN = PLUGIN 

local character = ix.meta.character

function character:Recognize(id,NameToReg)
    if (!isnumber(id) and id.GetID) then
        id = id:GetID()
    end

    if !NameToReg then
        local recognized = self:GetData("rgn", "")

        if (recognized != "" and recognized:find(","..id..",")) then
            return false
        end

        self:SetData("rgn", recognized..","..id..",")

        return true
    end

    local CurFakeNames = self:GetData("aw_KnowFakeNames",{})

    CurFakeNames[id] = NameToReg

    self:SetData("aw_KnowFakeNames",CurFakeNames)

    return true
end

util.AddNetworkString("ixRecognize")
util.AddNetworkString("ixRecognizeMenu")
util.AddNetworkString("ixRecognizeDone")

function PLUGIN:ShowSpare1(client)
	if (client:GetCharacter()) then
		net.Start("ixRecognizeMenu")
		net.Send(client)
	end
end

net.Receive("ixRecognize", function(length, client)
	local level = net.ReadUInt(2)
	local name = net.ReadString()
	name = client:Name() != name and name

	if (isnumber(level)) then
		local targets = {}
		if (level < 1) then
			local entity = client:GetEyeTraceNoCursor().Entity
			if (IsValid(entity) and entity:IsPlayer() and entity:GetCharacter()
			and ix.chat.classes.ic:CanHear(client, entity)) then
				targets[1] = entity
			end
		else
			local class = "w"
			if (level == 2) then
				class = "ic"
			elseif (level == 3) then
				class = "y"
			end
			class = ix.chat.classes[class]
			for _, v in ipairs(player.GetAll()) do
				if (client != v and v:GetCharacter() and class:CanHear(client, v)) then
					targets[#targets + 1] = v
				end
			end
		end
		if (#targets > 0) then
			local id = client:GetCharacter():GetID()
			local i = 0
			for _, v in ipairs(targets) do
				if (v:GetCharacter():Recognize(id,name)) then
					i = i + 1
				end
			end
			if (i > 0) then
				net.Start("ixRecognizeDone")
				net.Send(client)
				hook.Run("CharacterRecognized", client, id)
			end
		end
	end
end)

netstream.Hook("aw_ActionName",function(player,table)
	if !isstring(table[1]) or table[1] == player:Name() then return end
	local char = player:GetCharacter()
	if !char then return end
	local usednames = char:GetData("aw_UsedNames",{})
	usednames[table[1]] = !table[2] or nil
	char:SetData("aw_UsedNames",usednames)
end)