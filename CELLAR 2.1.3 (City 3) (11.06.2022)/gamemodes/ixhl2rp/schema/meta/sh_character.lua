local CHAR = ix.meta.character

function CHAR:IsDispatch()
	return self:GetFaction() == FACTION_DISPATCH
end

function CHAR:GetIDCard()
	if !self:GetEquipment() then
		return
	end
	
	return self:GetEquipment():HasItemOfBase("base_cards", {equip = true})
end

function CHAR:GetIDData(data, default)
	local cid = self:GetIDCard()

	if !cid then 
		return false
	end

	return cid:GetData(data, default)
end

function CHAR:HasIDAccess(access)
	if self:IsOTA() then
		return true
	end
	
	local cid = self:GetIDCard()

	if !cid then 
		return false 
	end

	access = istable(access) and access or {access}

	local marks = {}
	for k, v in pairs(cid:GetData("access", {})) do
		if k:find("*") then
			marks[#marks + 1] = k
		else
			continue
		end
	end

	for k, v in ipairs(access) do
		if cid:GetData("access", {})[v] then
			continue
		else
			if #marks > 0 then
				local found = false
				for _, mark in ipairs(marks) do
					if v:match("^"..mark) then
						found = true
						break
					end
				end

				if found then continue end
			end

			return false
		end
	end

	return true
end