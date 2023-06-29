function Schema:AddCombineDisplayMessage(text, color, exclude, ...)
	color = color or color_white

	local arguments = {...}
	local receivers = {}

	-- we assume that exclude will be part of the argument list if we're using
	-- a phrase and exclude is a non-player argument
	if (type(exclude) != "Player") then
		table.insert(arguments, 1, exclude)
	end

	for _, v in ipairs(player.GetAll()) do
		if (v:IsCombine() and v != exclude) then
			receivers[#receivers + 1] = v
		end
	end

	netstream.Start(receivers, "CombineDisplayMessage", text, color, arguments)
end

local loyalTable = {
	["Anti-Citizen"] = -1,
	["Citizen"] = 0,
	["Black"] = 1,
	["Brown"] = 2,
	["Red"] = 3,
	["Blue"] = 4,
	["Green"] = 5,
	["Gold"] = 6,
	["Platinum"] = 7,
}

function Schema:GetCitizenRationTypes(character)
	if character:GetPlayer().ixDatafile and character:GetPlayer().ixDatafile != 0 then
		local dID, datafile, genericdata = ix.plugin.list["datafile"]:ReturnDatafileByID(character:GetPlayer().ixDatafile)
		local level = loyalTable[genericdata.status] or 0

		if level >= 5 then
			return "ration_tier_4"
		elseif level >= 3 then
			return "ration_tier_1"
		end
	end

	return "ration_tier_0"
end

-- data saving
function Schema:SaveRationDispensers()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationdispenser")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetEnabled()}
	end

	ix.data.Set("rationDispensers", data)
end

function Schema:SaveVendingMachines()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_vendingmachine")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetAllStock()}
	end

	ix.data.Set("vendingMachines", data)
end

function Schema:SaveCombineMonitors()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_combineaccessmonitor")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetDTString(0), v:GetDTString(1), v:GetDTString(2), v:GetDTString(3), v:GetDTInt(0)}
	end

	ix.data.Set("combineAccMonitors", data)
end

-- data loading
function Schema:LoadRationDispensers()
	for _, v in ipairs(ix.data.Get("rationDispensers") or {}) do
		local dispenser = ents.Create("ix_rationdispenser")

		dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
		dispenser:Spawn()
		dispenser:SetEnabled(v[3])
	end
end

function Schema:LoadVendingMachines()
	for _, v in ipairs(ix.data.Get("vendingMachines") or {}) do
		local vendor = ents.Create("ix_vendingmachine")

		vendor:SetPos(v[1])
		vendor:SetAngles(v[2])
		vendor:Spawn()
		vendor:SetStock(v[3])
	end
end

function Schema:LoadCombineMonitors()
	for _, v in ipairs(ix.data.Get("combineAccMonitors") or {}) do
		local mon = ents.Create("ix_combineaccessmonitor")

		mon:SetPos(v[1])
		mon:SetAngles(v[2])
		mon:Spawn()
		mon:SetDTString(0,v[3])
		mon:SetDTString(1,v[4])
		mon:SetDTString(2,v[5])
		mon:SetDTString(3,v[6])
		mon:SetDTInt(0,v[7])
	end
end

function Schema:SearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local name = hook.Run("GetDisplayedName", target) or target:Name()
	local inventory = target:GetCharacter():GetInventory()

	ix.storage.Open(client, inventory, {
		entity = target,
		name = name
	})

	return true
end
