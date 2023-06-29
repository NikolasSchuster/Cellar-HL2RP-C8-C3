function Schema:CharacterVarChanged(character, key, oldVar, value)
	if key == "name" and oldVar != value then
		local query = mysql:Select("ix_items")
		query:Select("item_id")
		query:WhereLike("data", "\"owner\":"..character:GetID())
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				for k, v in ipairs(result) do
					v.item_id = tonumber(v.item_id)

					ix.item.instances[v.item_id]:SetData("name", value)
					
					hook.Run("OnIDCardUpdated", ix.item.instances[v.item_id])
				end
			end
		end)
		query:Execute()
	end
end

netstream.Hook("ixCitizenIDEdit", function(client, itemID, newData)
	if !client:IsSuperAdmin() and !client:IsAdmin() then return end

	local item = ix.item.instances[itemID]
	
	if !item then return end
	
	newData["type"] = tonumber(newData["type"]) or 0
	newData["type"] = math.Clamp(math.Round(newData["type"]), 0, 3)

	local access = {}
	for i, v in ipairs(newData["access"] or {}) do
		access[v] = true
	end

	item:SetData("name", newData["name"] or "nobody")
	item:SetData("cid", newData["cid"] or "0000")
	item:SetData("number", newData["number"] or "")
	item:SetData("access", access)
	item:SetData("type", newData["type"])

	hook.Run("OnIDCardUpdated", item)
end)

do
	local CHAR = ix.meta.character

	function CHAR:CreateIDCard(type)
		if type then
			local inventory = self:GetEquipment()

			if !inventory then
				timer.Simple(1, function()
					self:CreateIDCard(type)
				end)
			else
				local x, y, invID = inventory:Add(type, 1, {
					equip = true,
				}, 1, EQUIP_CID)

				if !self:IsOTA() then
					timer.Simple(1, function()
						self:GetPlayer().ixDatafile = self:GetIDCard():GetData("datafileID", 0)
					end)
				end
			end
		end
	end
end