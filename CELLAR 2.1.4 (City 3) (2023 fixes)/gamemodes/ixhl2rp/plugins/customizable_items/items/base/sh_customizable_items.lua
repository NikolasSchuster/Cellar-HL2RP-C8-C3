
ITEM.name = "Customizable Item Base"
ITEM.width = 1
ITEM.height = 1
ITEM.business = false
ITEM.hasProperties = {}
ITEM.properties = { -- we'll keep this as an array to retain order
	{"name", ix.type.string, "My Customizable Item"},
	{"description", ix.type.string, "A brand-spankin' new item."},
	{"model", ix.type.string, "models/props_junk/watermelon01.mdl"},
	{"skin", ix.type.number, 0, 0, 100},
	{"material", ix.type.string, ""},
	{"rarity", ix.type.number, 0, 0, 4},
}

function ITEM:HasProperty(name)
	for i = 1, #self.properties do -- @todo not THIS!!!
		if (self.properties[i][1] == name) then
			return true
		end
	end

	return false
end

function ITEM:AddProperty(name, type, default, min, max)
	if (self:HasProperty(name)) then
		return
	end

	self.properties[#self.properties + 1] = {name, type, default, min or 0, max or 100}
end

function ITEM:OnSendData()
	-- if we don't have name property we probably don't have the others
	if (!self:GetData("name")) then
		return
	end

	for i = 1, #self.properties do
		local property = self.properties[i]
		self[property[1]] = ix.util.SanitizeType(property[2], self:GetData(property[1]))
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	-- only transfer if we've been populated with some data
	return self:GetData("name") != nil or !newInventory
end

function ITEM:OnRegistered()
	-- add property functions
	for i = 1, #self.properties do
		local property = self.properties[i]
		local name = property[1]
		local type = property[2]
		local functionName = name:sub(1, 1):upper() .. name:sub(2)

		self["Get" .. functionName] = function(item)
			return ix.util.SanitizeType(type, item:GetData(name) or item[name])
		end
	end
end
