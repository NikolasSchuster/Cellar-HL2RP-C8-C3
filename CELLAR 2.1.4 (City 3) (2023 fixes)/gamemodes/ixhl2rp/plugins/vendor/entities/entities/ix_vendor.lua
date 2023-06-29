
ENT.Type = "anim"
ENT.PrintName = "Vendor"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.isVendor = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "NoBubble")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/Humans/Group02/male_08.mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))
		self:SetBloodColor(BLOOD_COLOR_RED)

		self.password = ""
		self.card_access = ""
		self.items = {}
		self.messages = {}
		self.factions = {}
		self.classes = {}
		self.Sessions = {}

		self:SetDisplayName("Le Happy Merchant")
		self:SetDescription("Constantly rubs his hands")
		self:OnChangedAnim("Idlepackage")

		self.receivers = {}

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	else
		self:SetIK(false)
	end
end

function ENT:CanAccess(client)
	local bAccess = false
	local uniqueID = ix.faction.indices[client:Team()].uniqueID
	local free_access = true

	if (self.password != "") then
		free_access = false
	end

	if (self.card_access != "") then
		free_access = false
		if (client:GetCharacter():HasIDAccess(self.card_access)) then
			return true
		end
	end

	if (self.factions and !table.IsEmpty(self.factions)) then
		free_access = false
		if (self.factions[uniqueID]) then
			bAccess = true
		end
	end

	if (bAccess and self.classes and !table.IsEmpty(self.classes)) then
		local class = ix.class.list[client:GetCharacter():GetClass()]
		local classID = class and class.uniqueID

		if (classID and !self.classes[classID]) then
			bAccess = false
		end
	end
	if (free_access or bAccess) then
		return true
	end
	if (self.password == "") then
		return false
	end
	if (self.Sessions[client:GetCharacter():GetID()]) then
		return true
	end
	return false
end

function ENT:GetStock(uniqueID)
	if (self.items[uniqueID] and self.items[uniqueID][VENDOR_MAXSTOCK]) then
		return self.items[uniqueID][VENDOR_STOCK] or 0, self.items[uniqueID][VENDOR_MAXSTOCK]
	end
end

function ENT:GetPrice(uniqueID, selling)
	local price = ix.item.list[uniqueID] and self.items[uniqueID] and
		self.items[uniqueID][VENDOR_PRICE] or ix.item.list[uniqueID].cost or ix.item.list[uniqueID].price or 0

	if (selling) then
		price = math.floor(price * (self.scale or 0.5))
	end

	return price
end

function ENT:CanSellToPlayer(client, uniqueID)
	local data = self.items[uniqueID]

	if (!data or !client:GetCharacter() or !ix.item.list[uniqueID]) then
		return false
	end

	if (data[VENDOR_MODE] == VENDOR_BUYONLY) then
		return false
	end

	if (!client:GetCharacter():HasMoney(self:GetPrice(uniqueID))) then
		return false
	end

	if (data[VENDOR_STOCK] and data[VENDOR_STOCK] < 1) then
		return false
	end

	return true
end

function ENT:CanBuyFromPlayer(client, uniqueID)
	local data = self.items[uniqueID]

	if (!data or !client:GetCharacter() or !ix.item.list[uniqueID]) then
		return false
	end

	if (data[VENDOR_MODE] != VENDOR_SELLONLY) then
		return false
	end

	if (!self:HasMoney(data[VENDOR_PRICE] or ix.item.list[uniqueID].cost or ix.item.list[uniqueID].price or 0)) then
		return false
	end

	return true
end

function ENT:HasMoney(amount)
	-- Vendor not using money system so they can always afford it.
	if (!self.money) then
		return true
	end

	return self.money >= amount
end

if (SERVER) then
	local PLUGIN = PLUGIN

	function ENT:SpawnFunction(client, trace)
		local angles = (trace.HitPos - client:GetPos()):Angle()
		angles.r = 0
		angles.p = 0
		angles.y = angles.y + 180

		local entity = ents.Create("ix_vendor")
		entity:SetPos(trace.HitPos)
		entity:SetAngles(angles)
		entity:Spawn()

		PLUGIN:SaveData()

		return entity
	end

	function ENT:OnChangedAnim(anim)
		self.anim = anim

		if self.anim then
			self:ResetSequence(self:LookupSequence(anim))
		end
	end

	function ENT:OnChangedBodyGroups(bgs)
		for i = 0, 9 do
			local number = string.sub(bgs, i, i)

			if number and number != "" then
				self:SetBodygroup(i, tonumber(number))
			end
		end
	end

	function ENT:OnChangedAccess(access)
		self.card_access = access
	end

	function ENT:OnChangedPassword(password)
		self.password = password
	end

	function ENT:onEnteredPassword(client, password)
		if (self.password == "") then
			return
		end
		if (password and password == self.password) then
			self.Sessions[client:GetCharacter():GetID()] = true
		end
	end
	
	function ENT:Use(activator)
		local character = activator:GetCharacter()

		if (!self:CanAccess(activator) or hook.Run("CanPlayerUseVendor", activator) == false) then
			if (self.messages[VENDOR_NOTRADE]) then
				activator:ChatPrint(self:GetDisplayName()..": "..self.messages[VENDOR_NOTRADE])
			else
				activator:NotifyLocalized("vendorNoTrade")
			end

			return
		end

		self.receivers[#self.receivers + 1] = activator

		if (self.messages[VENDOR_WELCOME]) then
			activator:ChatPrint(self:GetDisplayName()..": "..self.messages[VENDOR_WELCOME])
		end

		local items = {}

		-- Only send what is needed.
		for k, v in pairs(self.items) do
			if (!table.IsEmpty(v) and (CAMI.PlayerHasAccess(activator, "Helix - Manage Vendors", nil) or v[VENDOR_MODE])) then
				items[k] = v
			end
		end

		self.scale = self.scale or 0.5

		activator.ixVendor = self

		-- force sync to prevent outdated inventories while buying/selling
		if (character) then
			character:GetInventory():Sync(activator, true)
		end

		net.Start("ixVendorOpen")
			net.WriteEntity(self)
			net.WriteUInt(self.money or 0, 16)
			net.WriteTable(items)
			net.WriteFloat(self.scale or 0.5)
		net.Send(activator)

		ix.log.Add(activator, "vendorUse", self:GetDisplayName())
	end

	function ENT:SetMoney(value)
		self.money = value

		net.Start("ixVendorMoney")
			net.WriteUInt(value and value or -1, 16)
		net.Send(self.receivers)
	end

	function ENT:GiveMoney(value)
		if (self.money) then
			self:SetMoney(self:GetMoney() + value)
		end
	end

	function ENT:TakeMoney(value)
		if (self.money) then
			self:GiveMoney(-value)
		end
	end

	function ENT:SetStock(uniqueID, value)
		if (!self.items[uniqueID][VENDOR_MAXSTOCK]) then
			return
		end

		self.items[uniqueID] = self.items[uniqueID] or {}
		self.items[uniqueID][VENDOR_STOCK] = math.min(value, self.items[uniqueID][VENDOR_MAXSTOCK])

		net.Start("ixVendorStock")
			net.WriteString(uniqueID)
			net.WriteUInt(value, 16)
		net.Send(self.receivers)
	end

	function ENT:AddStock(uniqueID, value)
		if (!self.items[uniqueID][VENDOR_MAXSTOCK]) then
			return
		end

		self:SetStock(uniqueID, self:GetStock(uniqueID) + (value or 1))
	end

	function ENT:TakeStock(uniqueID, value)
		if (!self.items[uniqueID][VENDOR_MAXSTOCK]) then
			return
		end

		self:AddStock(uniqueID, -(value or 1))
	end
else
	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.05))
			bubble:SetRenderAngles(Angle(0, realTime * 100, 0))
		end

		self:DrawModel()
	end

	function ENT:Think()
		local noBubble = self:GetNoBubble()

		if (IsValid(self.bubble) and noBubble) then
			self.bubble:Remove()
		elseif (!IsValid(self.bubble) and !noBubble) then
			self:CreateBubble()
		end

		self:SetNextClientThink(CurTime() + 0.25)

		return true
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetDisplayName())
		name:SizeToContents()

		local descriptionText = self:GetDescription()

		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(self:GetDescription())
			description:SizeToContents()
		end
	end
end

function ENT:GetMoney()
	return self.money
end

properties.Add("ixvendor_anim", {
	MenuLabel = "Set Vendor Anim",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_vendor") then return false end
		if (!gamemode.Call("CanProperty", client, "ixvendor_anim", entity)) then return false end

		return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Animation", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:OnChangedAnim(text)
	end
})

properties.Add("ixvendor_bg", {
	MenuLabel = "Set Vendor Bodygroups",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_vendor") then return false end
		if (!gamemode.Call("CanProperty", client, "ixvendor_bg", entity)) then return false end

		return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Bodygroups 00000", "", "", function(text)
			self:MsgStart()
				net.WriteEntity(entity)
				net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:OnChangedBodyGroups(text)
	end
})

properties.Add("ixvendor_access", {
	MenuLabel = "Set Vendor Access",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_vendor") then return false end
		if (!gamemode.Call("CanProperty", client, "ixvendor_access", entity)) then return false end

			return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Card Access", "", "cmbMpfAll", function(text)
			self:MsgStart()
			net.WriteEntity(entity)
			net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:OnChangedAccess(text)
	end
})

properties.Add("ixvendor_password_set", {
	MenuLabel = "Set Vendor Password",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_vendor") then return false end
		if (!gamemode.Call("CanProperty", client, "ixvendor_password_set", entity)) then return false end

			return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Specify Password", "", "qwerty", function(text)
			self:MsgStart()
			net.WriteEntity(entity)
			net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:OnChangedPassword(text)
	end
})

properties.Add("ixvendor_password_enter", {
	MenuLabel = "Enter Vendor Password",
	Order = 400,
	MenuIcon = "icon16/tag_blue_edit.png",
	-- self.Sessions[activator:GetCharacter():GetID()]
	-- self.Sessions[activator:GetCharacter():GetID()] = true

	Filter = function(self, entity, client)
		if (entity:GetClass() != "ix_vendor") then return false end
		-- if (!gamemode.Call("CanProperty", client, "ixvendor_password_set", entity)) then return false end

			return true
	end,

	Action = function(self, entity)
		Derma_StringRequest("Enter Password", "", "", function(text)
			self:MsgStart()
			net.WriteEntity(entity)
			net.WriteString(text)
			self:MsgEnd()
		end)
	end,

	Receive = function(self, length, client)
		local entity = net.ReadEntity()

		if (!IsValid(entity)) then return end
		if (!self:Filter(entity, client)) then return end

		local text = net.ReadString()

		entity:onEnteredPassword(client, text)
	end
})