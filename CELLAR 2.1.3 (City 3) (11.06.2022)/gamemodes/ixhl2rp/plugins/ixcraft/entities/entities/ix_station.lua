
local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Station"
ENT.Category = "Helix"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "StationID")

	if (SERVER) then
		self:NetworkVarNotify("StationID", self.OnVarChanged)
	end
end

if (SERVER) then
	util.AddNetworkString("ixOpenStationCraft")

	function ENT:Initialize()
		if (!self.uniqueID) then
			self:Remove()

			return
		end

		self:SetStationID(self.uniqueID)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysicsInit(SOLID_VPHYSICS)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end

	function ENT:OnVarChanged(name, oldID, newID)
		local stationTable = PLUGIN.craft.stations[newID]

		if (stationTable) then
			self:SetModel(stationTable:GetModel())
		end
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end

	function ENT:Use(client)
		local ct = CurTime()

		if (client.nextStationUse and ct < client.nextStationUse) or client:IsRestricted() then
			return
		end

		net.Start("ixOpenStationCraft")
			net.WriteEntity(self)
		net.Send(client)

		client.ixStation = self

		client.nextStationUse = ct + 0.5
	end

	net.Receive("ixOpenStationCraft", function(len, client)
		client.ixStation = nil
	end)
else
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local stationTable = self:GetStationTable()

		if (stationTable) then
			PLUGIN:PopulateStationTooltip(tooltip, stationTable)
		end
	end

	function ENT:Draw()
		self:DrawModel()
	end

	net.Receive("ixOpenStationCraft", function(len)
		local station = net.ReadEntity()
		local stationTable = station:GetStationTable()

		if IsValid(ix.gui.stationCraft) then
			ix.gui.stationCraft:Remove()
		end

		LocalPlayer().ixStation = station

		local h = math.max(math.min(ScrH() * 0.9, 900), 480)

			local craft = vgui.Create("DFrame")
			craft:SetTitle(stationTable.name)
			craft:SetSize(math.max(ScrW() * 0.6, h), h)
			craft:MakePopup()
			craft:Center()
			craft.OnClose = function()
				LocalPlayer().ixStation = nil
				net.Start("ixOpenStationCraft")
				net.SendToServer()
			end


			craft.container = craft:Add("Panel")
			craft.container:SetSize(h - 44, h - 27)
			craft.container:Dock(FILL)
			craft.container:DockPadding(22, 22, 22, 5)
			craft.container.station = stationTable.uniqueID
			craft.container:Add("ixCrafting")

		ix.gui.stationCraft = craft
	end)
end

function ENT:GetStationTable()
	return PLUGIN.craft.stations[self:GetStationID()]
end
