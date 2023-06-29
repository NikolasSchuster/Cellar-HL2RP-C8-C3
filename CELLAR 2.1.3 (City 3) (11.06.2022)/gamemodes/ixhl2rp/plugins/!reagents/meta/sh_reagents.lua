Schema.reagents = {}
Schema.reagents.stored = {}
Schema.reagents.reactions = {}

local REAGENT = {}
REAGENT.__index = REAGENT
REAGENT.uniqueID = nil
REAGENT.name = "Unnamed"
REAGENT.clr = Color(255, 255, 255)

function REAGENT:__tostring()
	return string.format("REAGENT[%s]", self.uniqueID)
end

function Schema.reagents:New(uniqueID, name, clr, onConsume)
	local object = setmetatable({}, REAGENT)
	object.uniqueID = uniqueID
	object.name = name
	object.clr = clr
	object.OnConsume = onConsume or function() end

	Schema.reagents.stored[uniqueID] = object
end

function Schema.reagents:All()
	return self.stored
end

function Schema.reagents:Get(uniqueID)
	return self.stored[uniqueID]
end




function Schema.reagents:AddReaction(result, data)
	for k, v in pairs(data[2]) do
		self.reactions[k] = self.reactions[k] or {}
		self.reactions[k][#self.reactions[k] + 1] = data
	end
end

local function BlendRGB(RGB1, RGB2, amount)
	local r = math.Round(RGB1.r + (RGB2.r - RGB1.r) * amount, 1)
	local g = math.Round(RGB1.g + (RGB2.g - RGB1.g) * amount, 1)
	local b = math.Round(RGB1.b + (RGB2.b - RGB1.b) * amount, 1)

	return Color(r, g, b)
end
function Schema.reagents:UpdateColor(contains)
	local mixcolor
	local vol_counter = 0
	local vol_temp = 0

	for type, volume in pairs(contains) do
		if isbool(self.stored[type].clr) and self.stored[type].clr == true then continue end
		
		vol_temp = volume
		vol_counter = vol_counter + vol_temp

		if !mixcolor then
			mixcolor = self.stored[type].clr
		else
			mixcolor = BlendRGB(mixcolor, self.stored[type].clr, vol_temp/vol_counter)
		end
	end

	return mixcolor or Color(0, 0, 0)
end

function Schema.reagents:UpdateTotal(item, contains)
	local contains = contains or item:GetData("contains", {})
    local total = 0

    for type, volume in pairs(contains) do
        if volume <= 0.1 then
            contains[type] = nil
        else
            total = total + volume
        end
    end

    item:SetData("contains", contains)

    local entity = item:GetEntity()

    if IsValid(entity) then
    	local clr = self:UpdateColor(contains)
    	entity:SetNetVar("clr", Vector(clr.r / 255, clr.g / 255, clr.b / 255))
    end
    
    return total
end

function Schema.reagents:HandleReactions(item, contains, volume)
	local possible_reaction

	for id, _ in pairs(contains) do
		for numID, reaction in pairs(self.reactions[id] or {}) do
			local totalRequiredReagents = table.Count(reaction[2])
			local totalReagents = 0

			for k, v in pairs(reaction[2]) do
				if math.Round(contains[k] or 0) < v then
					break
				end
				
				totalReagents = totalReagents + 1
			end

			if totalReagents == totalRequiredReagents then
				possible_reaction = reaction
				break
			end
		end
	end

	if possible_reaction then
		local mul = math.huge

		for reagentID, value in pairs(possible_reaction[2]) do
			mul = math.min(mul, math.Round(contains[reagentID] / value))

			local amount = (mul * value)
			amount = math.Clamp(amount, 0, volume)

			contains[reagentID] = contains[reagentID] - amount
		end

		for resultID, value in pairs(possible_reaction[1]) do
			mul = math.max(mul, 1)
			contains[resultID] = (contains[resultID] or 0) + (value * mul)
		end
	end

	return contains
end

function Schema.reagents:Transfer(item, amount, type)
	local cachedTotal = self:UpdateTotal(item)

	if cachedTotal + amount > item.volume then
		amount = (item.volume - cachedTotal)

		if amount <= 0 then 
			return
		end
	end

	local contains = item:GetData("contains", {})

	contains[type] = (contains[type] or 0) + amount

	contains = self:HandleReactions(item, contains, item.volume)

	item:SetData("value", self:UpdateTotal(item, contains))
	item:SetData("contains", contains)
end


function Schema.reagents:TransferContainer(target, amount, this)
	local value = this:GetData("value", 0)

	amount = math.min(math.min(amount, value), target.volume - target:GetData("value", 0))

	local part = amount / value
	local contains = this:GetData("contains", {})

	for type, v in pairs(contains) do
		local transfer_amount = v * part

		if target then
			self:Transfer(target, transfer_amount, type)
		end

		if contains[type] - transfer_amount <= 0.1 then
            contains[type] = nil
        else
			contains[type] = contains[type] - transfer_amount
		end
	end

	contains = self:HandleReactions(this, contains, this.volume)

	this:SetData("value", self:UpdateTotal(this, contains))
end


if SERVER then
	util.AddNetworkString("ixHandUse")
	util.AddNetworkString("ixLiquidDispense")
	util.AddNetworkString("ixLiquidEject")
	util.AddNetworkString("ixLiquidUpdate")

	net.Receive("ixHandUse", function(len, client)
		local target = net.ReadEntity()

		if target:GetPos():Distance(client:GetShootPos()) > 99 then
			return
		end

		local wep = client:GetActiveWeapon()

		if wep and wep.IsHoldingObject and wep:IsHoldingObject() then
			if IsValid(wep.heldEntity) and wep.heldEntity.ixItemID then
				net.Start("ixHandUse")
					net.WriteUInt(wep.heldEntity.ixItemID, 32)
	    			net.WriteEntity(wep.heldEntity)
				net.Send(client)

				client.handUseTarget = target
				client.handUseEntity = wep.heldEntity
				client.handUseItemID = wep.heldEntity.ixItemID
			end
		end
	end)

	net.Receive("ixLiquidDispense", function(len, client)
		if !IsValid(client.handUseTarget) or client.handUseTarget:GetPos():Distance(client:GetShootPos()) > 99 then
			return
		end

		local value = net.ReadUInt(16)
		local reagent = net.ReadString()
		local item = ix.item.instances[client.handUseItemID]

		if !item then
			return
		end
		
		Schema.reagents:Transfer(item, value, reagent)

		net.Start("ixLiquidUpdate")
		net.Send(client)
	end)

	net.Receive("ixLiquidEject", function(len, client)
		if !IsValid(client.handUseTarget) or client.handUseTarget:GetPos():Distance(client:GetShootPos()) > 99 then
			return
		end

		local amount = net.ReadUInt(16)
		local item = ix.item.instances[client.handUseItemID]

		if !item then
			return
		end
		
		local value = item:GetData("value", 0)

		if value <= 0 then
			return
		end
		
		local part = amount / value
		local contains = item:GetData("contains", {})

		for type, v in pairs(contains) do
			local transfer_amount = v * part

			if contains[type] - transfer_amount <= 0.1 then
	            contains[type] = nil
	        else
				contains[type] = contains[type] - transfer_amount
			end
		end

		item:SetData("value", Schema.reagents:UpdateTotal(item, contains))

		net.Start("ixLiquidUpdate")
		net.Send(client)
	end)
else
	surface.CreateFont("ixDispenser", {
		font = "Roboto",
		size = 16,
		weight = 500,
		antialias = true,
		extended = true
	})
	surface.CreateFont("ixDispenserTitle", {
		font = "Roboto Lt",
		size = 18,
		weight = 500,
		antialias = true,
		extended = true
	})

	local PANEL = {}
	local dispense = {
		5, 10, 20, 25, 30, 50, 100
	}

	local availableLiquids = {
		"absinthe",
		"ale",
		"jaloe",
		"japple",
		"jbanana",
		"beer",
		"jberry",
		"jcarrot",
		"champ",
		"coffee", 
		"cognac",
		"ccocon",
		"cmenthe", 
		"ccacao",
		"gin",
		"jgranat",
		"cider",
		"jlemon",
		"lemlim",
		"jlime",
		"milk",
		"cream",
		"jorange",
		"jpeach",
		"jpine",
		"rum", 
		"sake",
		"soda",
		"cola",
		"kahlua",
		"tripsec",
		"tea",
		"tequil",
		"jtomat",
		"tonic",
		"vermout",
		"vodka",
		"water",
		"jmelon",
		"whiski",
		"wine",
		"ice",
		"sugar",
		"gold",
		"silver"
	}

	local btnClr = Color(74, 169, 191)
	local btnHoverClr = Color(87, 199, 244)
	local btnPressedClr = Color(99, 226, 255)
	local btnActiveClr = Color(93, 194, 76)

	function PANEL:InitButtonSkin(btn, toggle)
		if toggle then
			toggle[btn] = true

			btn.active = false
		end
		
		btn.pressed = false
		btn.OnMousePressed = function(self)
			self.pressed = true

			if toggle and !self.active then
				for btn, _ in pairs(toggle) do
					btn.active = false
				end

				self.active = true
			end

			self:DoClick()
		end

		btn.OnMouseReleased = function(self)
			self.pressed = false
		end

		btn.Paint = function(self, w, h)
			surface.SetDrawColor(self.active and btnActiveClr or (self.pressed and btnPressedClr or (self:IsHovered() and btnHoverClr or btnClr)))
			surface.DrawRect(0, 0, w, h)
		end
	end
	function PANEL:Init()
		if IsValid(ix.gui.liquidDisp) then
			ix.gui.liquidDisp:Remove()
			ix.gui.liquidDisp = nil
		end

		ix.gui.liquidDisp = self

		local scrH = ScrH()
		local w = math.max(scrH * 0.8, 600)
		local h = math.max(scrH * 0.5, 500)

		self:SetTitle("Автомат")
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self:DockPadding(1, 24, 1, 1)

		self.reagents = Schema.reagents:All()
		self.dispenseButtons = {}
		self.availableDispense = {}

		self.scroll = self:Add("DScrollPanel")
		self.scroll:Dock(FILL)
		self.scroll.Paint = function(self, w, h)
			surface.SetDrawColor(30, 30, 30, 250)
			surface.DrawRect(0, 0, w, h)
		end

		self.tab1 = self.scroll:Add("DIconLayout")
		self.tab1:Dock(TOP)
		self.tab1:SetSpaceY(5)
		self.tab1:SetSpaceX(5)
		self.tab1:SetBorder(5)
			local header = self.tab1:Add("Panel")
			header.OwnLine = true
			header:Dock(TOP)
			header:SetTall(24)
			local label = header:Add("DLabel")
			label:SetFont("ixDispenserTitle")
			label:Dock(LEFT)
			label:DockMargin(5, 0, 0, 0)
			label:SetText("Налить")
			label:SizeToContents()

			for k, v in ipairs(dispense) do
				local btn = header:Add("DButton")

				self:InitButtonSkin(btn, self.dispenseButtons)

				btn:SetFont("ixDispenser")
				btn:Dock(RIGHT)
				btn:DockMargin(0, 3, 5, 3)
				btn:SetZPos(-k)
				btn:SetText("+ "..v)
				btn:SizeToContents()
				btn.value = v

				if k == 1 then
					btn.active = true
				end
			end
		self.tab1:InvalidateLayout(true)
		self.tab1:SizeToChildren(false, true)

		local header2 = self.scroll:Add("Panel")
		header2:Dock(TOP)
		header2:DockMargin(0, 22, 0, 0)
		header2:SetTall(24)
			local label = header2:Add("DLabel")
			label:SetFont("ixDispenserTitle")
			label:Dock(LEFT)
			label:DockMargin(5, 0, 0, 0)
			label:SetText("Контейнер")
			label:SizeToContents()

			for k, v in ipairs(dispense) do
				local btn = header2:Add("DButton")

				self:InitButtonSkin(btn)

				btn:SetFont("ixDispenser")
				btn:Dock(RIGHT)
				btn:DockMargin(0, 3, 5, 3)
				btn:SetZPos(-k)
				btn:SetText("- "..v)
				btn:SizeToContents()
				btn.DoClick = function(btn)
					self:DoEject(v)
				end
			end

		self.tab2 = self.scroll:Add("Panel")
		self.tab2:Dock(TOP)
			self.tab2.label = self.tab2:Add("DLabel")
			self.tab2.label:SetFont("ixDispenser")
			self.tab2.label:Dock(LEFT)
			self.tab2.label:DockMargin(5, 0, 0, 0)
			self.tab2.label:SetText("Содержит: ")
			self.tab2.label:SetTextColor(btnClr)
			self.tab2.label:SizeToContents()

		self.tab3 = self.tab2:Add("Panel")
		self.tab3:Dock(FILL)
			self.liquidText = self.tab3:Add("DLabel")
			self.liquidText:SetFont("ixDispenser")
			self.liquidText:Dock(TOP)
			self.liquidText:DockMargin(5, 0, 0, 0)
			self.liquidText:SetText("")
			self.liquidText:SizeToContents()
			self.reagentPanels = {}

		self.tab3:InvalidateLayout(true)
		self.tab3:SizeToChildren(false, true)

		self.tab2:InvalidateLayout(true)
		self.tab2:SizeToChildren(false, true)

		self:BuildDispenseItems(availableLiquids)

		if LIQUID then
			local data = LIQUID[1]:GetNetVar("data", {})
			self:UpdateContainer(LIQUID[2].name, data.value or 0, LIQUID[2].volume, data.contains or {})
		end
	end
	function PANEL:UpdateContainer(name, value, max, reagents)
		self.liquidText:SetText(string.format("%s (%i / %iмл)", name, value, max))
		self.liquidText:SizeToContents()

		for id, btn in pairs(self.reagentPanels) do
			if !reagents[id] then
				btn:Remove()

				self.reagentPanels[id] = nil
			end
		end

		for id, value in pairs(reagents) do
			local name = self.reagents[id].name

			if !self.reagentPanels[id] then
				local liquid = self.tab3:Add("DLabel")
				liquid:SetFont("ixDispenser")
				liquid:Dock(TOP)
				liquid:DockMargin(25, 0, 0, 0)
				liquid:SetText("0мл "..name)
				liquid:SizeToContents()
				liquid.value = 0
				liquid.targetValue = value
				liquid.Think = function(self)
					if self.value != self.targetValue then
						if self.targetValue > self.value then
							self.value = math.Clamp(self.value + 0.125, 0, self.targetValue)
						else
							self.value = math.Clamp(self.value - 0.125, 0, self.value)
						end

						self:SetText(math.Round(self.value).."мл "..name)
					else
						self.Think = nil
					end
				end

				self.reagentPanels[id] = liquid
			else
				self.reagentPanels[id].targetValue = value
				self.reagentPanels[id].Think = function(self)
					if self.value != self.targetValue then
						if self.targetValue > self.value then
							self.value = math.Clamp(self.value + 0.125, 0, self.targetValue)
						else
							self.value = math.Clamp(self.value - 0.125, 0, self.value)
						end

						self:SetText(math.Round(self.value).."мл "..name)
					else
						self.Think = nil
					end
				end
			end
		end

		self.tab3:InvalidateLayout(true)
		self.tab3:SizeToChildren(false, true)

		self.tab2:SetTall(self.tab3:GetTall())
	end
	function PANEL:BuildDispenseItems(list)
		for btn, _ in pairs(self.availableDispense) do
			btn:Remove()
		end

		self.availableDispense = {}

		local newList = {}
		for k, v in ipairs(list) do
			local reagent = self.reagents[v]
			if !reagent then continue end

			newList[reagent.name] = v
		end

		for k, v in SortedPairs(newList) do
			local btn = self.tab1:Add("DButton")

			self:InitButtonSkin(btn)

			btn:SetFont("ixDispenser")
			btn:SetText(k)
			btn:SizeToContents()
			btn:SetWide(128)
			btn.DoClick = function(btn)
				self:DoDispense(v)
			end

			self.availableDispense[btn] = true
		end

		self.tab1:InvalidateLayout(true)
		self.tab1:SizeToChildren(false, true)
	end
	function PANEL:DoDispense(id)
		local dispenseValue = 5
		for btn, _ in pairs(self.dispenseButtons) do
			if btn.active then
				dispenseValue = btn.value
				break
			end
		end

		net.Start("ixLiquidDispense")
			net.WriteUInt(dispenseValue, 16)
			net.WriteString(id)
		net.SendToServer()
	end
	function PANEL:DoEject(value)
		net.Start("ixLiquidEject")
			net.WriteUInt(value, 16)
		net.SendToServer()
	end
	vgui.Register("ixLiquidDispenser", PANEL, "DFrame")



	hook.Add("PlayerButtonDown", "Liquids", function(ply, button)
		if button == KEY_LALT then
			hook.Run("OnHandMenuOpen")
		end
	end)

	hook.Add("PlayerButtonUp", "Liquids", function(ply, button)
		if button == KEY_LALT then
			hook.Run("OnHandMenuClose")
		end
	end)

	hook.Add("OnHandMenuOpen", "Liquids", function()
		HANDMENU_OPEN = true
		gui.EnableScreenClicker(true)
	end)

	hook.Add("OnHandMenuClose", "Liquids", function()
		HANDMENU_OPEN = false
		gui.EnableScreenClicker(false)
	end)

	hook.Add("GUIMousePressed", "Liquids", function(code, vector)
		if ( !IsValid( vgui.GetHoveredPanel() ) || vgui.GetHoveredPanel():IsWorldClicker() or IsValid(ix.gui.liquidDisp)) then return end

		if (code == MOUSE_LEFT && !input.IsButtonDown(MOUSE_RIGHT)) then
			local entity = properties.GetHovered(EyePos(), vector)

			if IsValid(entity) then
				HAND_ENTITY = entity

				net.Start("ixHandUse")
					net.WriteEntity(entity)
				net.SendToServer()
			end
		end
	end)

	local c = Color(255, 255, 255, 255)
	hook.Add("PreDrawHalos", "Liquids", function()
		if !HANDMENU_OPEN then return end
		if !IsValid(vgui.GetHoveredPanel()) || vgui.GetHoveredPanel():IsWorldClicker() then return end

		local ent = properties.GetHovered(EyePos(), gui.ScreenToVector(gui.MousePos()))

		if !IsValid(ent) then return end

		halo.Add({ent}, c, 2, 2, 2, true, false)
	end)

	net.Receive("ixHandUse", function()
		local itemID = net.ReadUInt(32)
		local entity = net.ReadEntity()
		local item = entity:GetItemTable()

		if item.volume and IsValid(HAND_ENTITY) and HAND_ENTITY:GetModel():lower() == "models/props_equipment/fountain_drinks.mdl" then
			if HAND_ENTITY:GetPos():Distance(LocalPlayer():GetShootPos()) < 100 then
				LIQUID = {entity, item}
				vgui.Create("ixLiquidDispenser")
			end
		end
	end)

	net.Receive("ixLiquidUpdate", function()
		if ix.gui.liquidDisp and LIQUID then
			local data = LIQUID[1]:GetNetVar("data", {})
			ix.gui.liquidDisp:UpdateContainer(LIQUID[2].name, data.value or 0, LIQUID[2].volume, data.contains or {})
		end
	end)
end