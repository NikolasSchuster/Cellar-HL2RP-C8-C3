ITEM.name = "Base Reagent Holder"
ITEM.description = ""
ITEM.model = Model("models/props_junk/watermelon01.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.volume = 1
ITEM.value = nil
ITEM.contains = nil
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"}
ITEM.category = "[LoveRP] Experimental"

function ITEM:GetName()
	local t = self:GetData("contains", {})
	local key = next(t)
	local max = t[key]

	for k, v in pairs(t) do
		if t[k] and t[k] > max then
			key, max = k, v
		end
	end

	return key and (Schema.reagents:All()[key] or {}).name or self.name
end

function ITEM:GetRarity()
	return self:GetValue() > 0 and 1 or 0
end

function ITEM:GetValue()
	return self:GetData("value", 0)
end

if CLIENT then
	function ITEM:PopulateTooltip(tooltip)
		if self.LoveRP then
			local filled = tooltip:AddRowAfter("name")
			filled:SetBackgroundColor(derma.GetColor("Error", tooltip))
			filled:SetText("Уникальный для локации")
		end

		/*
		local text = "DEBUG:\n"
		for k, v in pairs(self:GetData("contains", {})) do
			text = text .. string.format("%s = %sml\n", k, v)
		end

		local debug = tooltip:AddRow("debug")
		debug:SetBackgroundColor(color_white)
		debug:SetText(text)
		debug:SizeToContents()
		*/
	end
end

function ITEM:Consume(client, drinkValue)
	drinkValue = drinkValue or self.volume

	local value = self:GetData("value", 0)

	if value <= 0 then
		return
	end
	
	local part = drinkValue / value
	local contains = self:GetData("contains", {})

	for type, v in pairs(contains) do
		local transfer_amount = v * part

		if contains[type] - transfer_amount <= 0.1 then
            contains[type] = nil
        else
			contains[type] = contains[type] - transfer_amount
		end
	end

	self:SetData("value", Schema.reagents:UpdateTotal(self, contains))

	client:EmitSound(self.useSound[math.random(1, #self.useSound)])
end

ITEM.functions.Use = {
	name = "useDrink",
	OnRun = function(item)
		local client = item.player

		item:Consume(client, 20)

		return false
	end,
	OnCanRun = function(item)
		return item:GetValue() > 0
	end
}

ITEM.functions.UseAll = {
	name = "useDrinkAll",
	OnRun = function(item)
		local client = item.player

		item:Consume(client)

		return false
	end,
	OnCanRun = function(item)
		return item:GetValue() > 0
	end
}

ITEM.combine = {}
ITEM.combine.Transfer = {
	OnClick = function(from, to)
		Derma_StringRequest("Transfer Amount", "", "0", function(amount)
			amount = tonumber(amount) or 0

			net.Start("ixReagentTransferAction")
				net.WriteFloat(amount)
			net.SendToServer()
		end)
	end,
	OnRun = function(from, to) 
		local client = from.player
		-- write char
		client.reagentTrans1 = from
		client.reagentTrans2 = to

		return false
	end
}

local function RemapMulti(value, dataTbl)
	if (value <= dataTbl[1][1]) then
		return dataTbl[1][2]
	elseif (value >= dataTbl[#dataTbl][1]) then
		return dataTbl[#dataTbl][2]
	else
		for k, v in ipairs(dataTbl) do
			if (value >= v[1] and value < dataTbl[k + 1][1]) then
				return math.Remap(value, v[1], dataTbl[k + 1][1], v[2], dataTbl[k + 1][2])
			end
		end
	end
end

function ITEM:OnEntityCreated(entity)
	timer.Simple(0, function()
		local clr = Schema.reagents:UpdateColor(self:GetData("contains", {}))
		entity:SetNetVar("clr", Vector(clr.r / 255, clr.g / 255, clr.b / 255))
	end)
end

function ITEM:OnEntityInstanced(entity)
	if !self.LiquidPhysData then 
		return
	end

	timer.Simple(0, function()
		entity.SetLiquidLevel = function(this, level)
			for k, v in ipairs(self.LiquidPhysData) do
				if !v[4] then
					local frac = v[2] * (1 - level)
					this:ManipulateBonePosition(v[1], self.LiquidRevertedZ and Vector(0, frac, 0) or Vector(0, 0, frac))
				end
				
				if v[3] then
					local f = 1 + RemapMulti(level, v[3])
					local c = v[5] and (1 + RemapMulti(level, v[5])) or 1

					this:ManipulateBoneScale(v[1], self.LiquidXZY and Vector(f, c, f) or Vector(f, f, c))
				end
			end
		end
		entity.liquidFrac = self:GetValue() / self.volume
		entity.Think = function(this)
			this.liquidFrac = Lerp(10 * FrameTime(), this.liquidFrac, (this:GetNetVar("data", {})["value"] or 0) / self.volume)
			this:SetLiquidLevel(this.liquidFrac)
		end
	end)
end

if SERVER then
	util.AddNetworkString("ixReagentTransferAction")

	net.Receive("ixReagentTransferAction", function(length, client)
		local amount = net.ReadFloat() or 0
		local itemFrom = client.reagentTrans1
		local itemTo = client.reagentTrans2

		if !itemFrom or !itemTo then
			return
		end

		Schema.reagents:TransferContainer(itemTo, amount, itemFrom)

		client.reagentTrans1 = nil
		client.reagentTrans2 = nil
	end)
end

function ITEM:OnInstanced(invID, x, y, item)
	item:SetData("value", self.value or self.volume)

	local contains = {}
	if isstring(self.contains) then
		contains[self.contains] = self.volume
	elseif istable(self.contains) then
		for k, v in pairs(self.contains) do
			contains[k] = self.volume * v
		end
	end

	item:SetData("contains", contains)
end

if CLIENT then
    function ITEM:PaintOver(item, w, h)
		local amount = item:GetValue()

        if amount then
            surface.SetDrawColor(35, 35, 35, 225)
            surface.DrawRect(2, h-9, w-4, 7)

			local filledWidth = (w - 5) * (amount / item.volume)
			
            surface.SetDrawColor(93, 122, 229, 255)
            surface.DrawRect(3, h - 8, filledWidth, 5)

            --self.useLabel:SetText(item:GetData("currentAmount", 0) .. " mL")   
		end
	end
end