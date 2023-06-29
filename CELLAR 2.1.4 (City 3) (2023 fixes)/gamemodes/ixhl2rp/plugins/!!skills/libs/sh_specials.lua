ix.specials = ix.specials or {}
ix.specials.list = ix.specials.list or {}

function ix.specials.LoadFromDir(directory)
	for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
		local niceName = v:sub(4, -5)

		ATTRIBUTE = ix.specials.list[niceName] or {}
			if (PLUGIN) then
				ATTRIBUTE.plugin = PLUGIN.uniqueID
			end

			ix.util.Include(directory.."/"..v)

			ATTRIBUTE.name = ATTRIBUTE.name or "Unknown"
			ATTRIBUTE.description = ATTRIBUTE.description or "No description availalble."

			ix.specials.list[niceName] = ATTRIBUTE
		ATTRIBUTE = nil
	end
end

function ix.specials.Setup(client)
	local character = client:GetCharacter()

	if (character) then
		for k, v in pairs(ix.specials.list) do
			if (v.OnSetup) then
				v:OnSetup(client, character:GetSpecial(k, 0))
			end
		end
	end
end

do
	local charMeta = ix.meta.character

	if (SERVER) then
		util.AddNetworkString("ixSpecialUpdate")

		function charMeta:UpdateSpecial(key, value)
			local attribute = ix.specials.list[key]
			local client = self:GetPlayer()

			if (attribute) then
				local attrib = self:GetSpecials()

				attrib[key] = math.min((attrib[key] or 0) + value, attribute.maxValue or 10)

				if (IsValid(client)) then
					net.Start("ixSpecialUpdate")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(key)
						net.WriteFloat(attrib[key])
					net.Send(client)

					if (attribute.Setup) then
						attribute.Setup(attrib[key])
					end
				end

				self:SetSpecials(attrib)
			end

			hook.Run("CharacterSpecialUpdated", client, self, key, value)
		end

		function charMeta:SetSpecial(key, value)
			local attribute = ix.specials.list[key]
			local client = self:GetPlayer()

			if (attribute) then
				local attrib = self:GetSpecials()

				attrib[key] = value

				if (IsValid(client)) then
					net.Start("ixSpecialUpdate")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(key)
						net.WriteFloat(attrib[key])
					net.Send(client)

					if (attribute.Setup) then
						attribute.Setup(attrib[key])
					end
				end

				self:SetSpecials(attrib)
			end

			hook.Run("CharacterSpecialUpdated", client, self, key, value)
		end

		function charMeta:AddSpecialBoost(boostID, attribID, boostAmount)
			local boosts = self:GetVar("specialboosts", {})

			boosts[attribID] = boosts[attribID] or {}
			boosts[attribID][boostID] = boostAmount

			hook.Run("CharacterSpecialBoosted", self:GetPlayer(), self, attribID, boostID, boostAmount)

			return self:SetVar("specialboosts", boosts, nil, self:GetPlayer())
		end

		function charMeta:RemoveSpecialBoost(boostID, attribID)
			local boosts = self:GetVar("specialboosts", {})

			boosts[attribID] = boosts[attribID] or {}
			boosts[attribID][boostID] = nil

			hook.Run("CharacterSpecialBoosted", self:GetPlayer(), self, attribID, boostID, true)

			return self:SetVar("specialboosts", boosts, nil, self:GetPlayer())
		end
	else
		net.Receive("ixSpecialUpdate", function()
			local id = net.ReadUInt(32)
			local character = ix.char.loaded[id]

			if (character) then
				local key = net.ReadString()
				local value = net.ReadFloat()

				character:GetSpecials()[key] = value
			end
		end)
	end

	function charMeta:GetSpecialBoost(attribID)
		local boosts = self:GetSpecialBoosts()

		return boosts[attribID]
	end

	function charMeta:GetSpecialBoosts()
		return self:GetVar("specialboosts", {})
	end

	function charMeta:GetSpecial(key, default)
		local att = self:GetSpecials()[key] or default
		local boosts = self:GetSpecialBoosts()[key]
		local lLimit, uLimit = 0, ix.config.Get("maxAttributes", 10)

		if (boosts) then
			for _, v in pairs(boosts) do
				local newAtt = att + v

				if (newAtt < lLimit) then
					att = lLimit

					break
				elseif (newAtt > uLimit) then
					att = uLimit

					break
				end

				att = newAtt
			end
		end

		return att
	end
end
