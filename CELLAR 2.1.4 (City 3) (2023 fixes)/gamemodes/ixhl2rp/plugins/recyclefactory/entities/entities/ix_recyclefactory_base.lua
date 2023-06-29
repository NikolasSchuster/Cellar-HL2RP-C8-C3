AddCSLuaFile()

ENT.PrintName = "Base Recycler"
ENT.Category = "HL2 RP Recycle Factory"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.IsFactory = true
ENT.MaxRenderDistance = math.pow(512, 2)

local WORK_ITEM = "paper"
local WORK_TIME = 15
local METAL_GARBAGE_COUNT_START = 4
local GARBAGE_ITEMS = {
	["empty_carton"] = 2,
	["empty_takeout_carton"] = 1,
	["empty_chinese_takeout"] = 1,
}
local mat = Material("models/props_combine/tprotato2_sheet")

function ENT:SetupDataTables()
	self:NetworkVar("Vector", "0", "ProductPos")
	self:NetworkVar("Float", "2", "GarbageCount")
	self:NetworkVar("Bool", "0", "IsWorking")
	self:NetworkVar("Float", "0", "StartWorkTime")
	self:NetworkVar("Float", "1", "NextWorkTime")
	self:NetworkVar("Int", "0", "EjectStorage")
	self:NetworkVar("Float", "3","StopWorkTime")
end

function ENT:GetWorkTime()
	return 5
end
function ENT:Use(player)
	netstream.Start(player, "aw_recyclemenu", self:EntIndex())
end

function ENT:GetStartCost()
	return 5
end

function ENT:GetWorkItem()
	return ""
end

function ENT:GetDisplay()
	return ""
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props/cs_militia/microwave01.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		-- self:SetMaterial(mat)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:SetMass(120)
			phys:Wake()
		end

		self:SetGarbageCount(0)
		self.Garbages = {}
		self:SetIsWorking(false)
		self:SetProductPos(self:GetPos() + self:GetUp() * 20 )
		self:SetEjectStorage(0)

		self.NextWorkSound = nil
		self.NextRandomSound = nil
		self.StopWorkTime = nil
	else
		self.RT = GetRenderTargetEx("_cmb_FIndicatorRT"..self:EntIndex()..CurTime(), 128, 85, RT_SIZE_DEFAULT, MATERIAL_RT_DEPTH_SHARED, 0x0001, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_DEFAULT)
		self.RTMat = CreateMaterial("_cmb_FIndicatorRTMAT" .. self:EntIndex() .. CurTime(), "UnlitTwoTexture", {
			["$selfilium"] = "1",
			["$texture2"] = "dev/dev_scanline",
			["Proxies"] = 
			{
				["TextureScroll"] =
				{
					["texturescrollvar"] = "$texture2transform",
					["texturescrollrate"] = "3",
					["texturescrollangle"] = "90"
				}
			}
		})
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end

	function ENT:CanGarbageUsed(item)
		return false
	end

	function ENT:StartWork()
		if self:GetStopWorkTime() <= 0 then 
			if self:GetGarbageCount() < self:GetStartCost() then
				return
			end

			self:SetStartWorkTime(CurTime())
			self:SetNextWorkTime(CurTime() + self:GetWorkTime())
		else
			local i = self:GetWorkTime() - self:GetStopWorkTime()
			self:SetStartWorkTime( CurTime() - i )
			self:SetNextWorkTime((CurTime() + self:GetWorkTime()) - i)
		end

		self:SetIsWorking(true)
		self:EmitSound("plats/elevator_large_start1.wav")
		self.NextWorkSound = CurTime() + 1.4
	end
	function ENT:Eject()
		if self:GetIsWorking() then return end
		if self:GetStopWorkTime() > 0 then return end

		local pos = self:GetProductPos()

		for k,v in pairs(self.Garbages)do
			ix.item.Spawn(v, self:GetProductPos())
			pos = pos + Vector(0,2,2)
		end

		self:SetGarbageCount(0)
		self.Garbages = {}
	end

	function ENT:StopWork()
		self:SetStopWorkTime(self:GetNextWorkTime() - CurTime())
		self:SetIsWorking(false)
		self.WorkSound:Stop()
		self:EmitSound("plats/elevator_large_stop1.wav")
		self.NextRandomSound = nil
		self.NextGarbageDecrease = nil
	end

	function ENT:EndWork()
		self:SetIsWorking(false)
		self.WorkSound:Stop()
		self:EmitSound("plats/elevator_large_stop1.wav")
		self.NextRandomSound = nil
		self.NextGarbageDecrease = nil
		self:SetStopWorkTime(0)

		ix.item.Spawn(self:GetWorkItem(), self:GetProductPos())
	end

	function ENT:OnRemove()
		if self.WorkSound then
			self.WorkSound:Stop()
		end
	end

	function ENT:Touch(ent)
		if !self.LastTouch or CurTime() > self.LastTouch then
			if self:GetIsWorking() then
				return
			end

			if self:GetStopWorkTime() > 0 then
				return
			end

			if !ent.GetItemID then
				return
			end

			local item = ent:GetItemTable()

			if !self:CanGarbageUsed(item.uniqueID) then
				return
			end

			ent:Remove()

			-- self:SetGarbageCount(self:GetGarbageCount() + self:GetGarbageCost(item.uniqueID))\
			self:SetGarbageCount(self:GetGarbageCount() + (item.weight and item.weight > 1 and item.weight or 1))
			self.Garbages[#self.Garbages + 1] = item.uniqueID
			self.LastTouch = CurTime() +.1
		end
	end

	function ENT:Think()
		if self.NextWorkSound and CurTime() > self.NextWorkSound then
			self.WorkSound = CreateSound(self, "plats/rackmove1.wav")
			self.WorkSound:Play()
			self.NextRandomSound = CurTime() + 0.65
			self.NextWorkSound = nil
		end

		if self.NextRandomSound and CurTime() > self.NextRandomSound then
			if math.Rand(0,1) > 0.8 then
				self:EmitSound("plats/hall_elev_stop.wav")
			end
			self.NextRandomSound = CurTime() + 0.65
		end

		if self:GetIsWorking() then
			if !self.NextGarbageDecrease then
				self.NextGarbageDecrease = CurTime() + ((self:GetNextWorkTime() - self:GetStartWorkTime()) - 5) / self:GetStartCost()
			elseif self.NextGarbageDecrease and CurTime() > self.NextGarbageDecrease then
				self:SetGarbageCount(math.Clamp(self:GetGarbageCount() - 1, 0, self:GetStartCost())) 
				table.remove(self.Garbages)
				self.NextGarbageDecrease = nil
			end
			if CurTime() > self:GetNextWorkTime() then
				self:EndWork()
			end
		else
			if self.WorkSound and self.WorkSound:IsPlaying() then
				self.WorkSound:Stop()
			end
			if self:GetStopWorkTime() > 0 then
				local i = self:GetWorkTime() - self:GetStopWorkTime()
				self:SetStartWorkTime(CurTime() - i)
				self:SetNextWorkTime((CurTime() + self:GetWorkTime()) - i)
				self.NextGarbageDecrease = CurTime() + ((self:GetNextWorkTime() - (self:GetStartWorkTime() + i)) - 5) / self:GetStartCost()
			end
		end
	end
else
	local colors = {
		[0] = Color(50, 50, 50, 255),
		[1] = Color(50, 120, 230, 255),
		[2] = Color(65, 65, 65, 255),
		[3] = Color(50, 240, 50, 255),
	}

	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()

		if (LocalPlayer():GetPos():DistToSqr(pos) > self.MaxRenderDistance) then
			return
		end

		local ang = self:GetAngles()

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)

		pos = pos + self:GetForward() * 10.2 + self:GetUp() * 18.85 + self:GetRight() * 17

		render.PushRenderTarget(self.RT)
			render.Clear(0, 0, 0, 255)
			cam.Start2D()
				surface.SetDrawColor(colors[0])
				surface.DrawRect(0, 0, 385, 256)
				surface.SetTextColor(color_white)
				surface.SetFont("_GR_CMB_FONT_1")
				surface.SetTextPos(8, 5)
				surface.DrawText("Garbage Recycler")
				surface.SetFont("_GR_CMB_FONT_2")
				surface.SetTextPos(8, 20)
				surface.DrawText(self:GetDisplay())

				local isWorking = self:GetIsWorking()
				local stopped = self:GetStopWorkTime() > 0
				local hasMaterial = self:GetGarbageCount() < self:GetStartCost()

				local text = isWorking and "RECYCLING..." or (stopped and "STOPPED" or (hasMaterial and "NOT ENOUGH GARBAGE" or "READY")) 
				local red = isWorking and 0 or (stopped and 255 or (hasMaterial and 255 or 0))
				local green = isWorking and 255 or (stopped and 0 or (hasMaterial and 0 or 255))
				surface.SetTextColor(red, green, 0, math.abs(math.cos(RealTime() * 2) * 255))
				surface.SetFont("_GR_CMB_FONT_3")
				local w, h = surface.GetTextSize(text)
				surface.SetTextPos(6, 31)
				surface.DrawText(text)

				local var = self:GetGarbageCount() / self:GetStartCost()
				local _cur = CurTime() - self:GetStartWorkTime()
				local _end = self:GetNextWorkTime() - self:GetStartWorkTime()
				local var2 = math.Clamp( (_cur / _end), 0, 1 )
				if !self:GetIsWorking() then
					if self:GetStopWorkTime() > 0 then
						local i = self:GetWorkTime() - self:GetStopWorkTime()
						_cur = 0 - (0 - i)
						_end = ((0 + self:GetWorkTime()) - i) - (0 - i)
						var2 = math.Clamp((_cur / _end), 0, 1)
					else
						var2 = 0
					end
				end
				
				surface.SetDrawColor(colors[2])
				surface.DrawRect(7, 42, 114, 16)
				surface.SetDrawColor(colors[1])
				local bar = math.Clamp((var * 114) - 2, 0, 114)
				surface.DrawRect(6, 43, bar, 14)

				text = self:GetGarbageCount() .. "/" .. self:GetStartCost()
				surface.SetTextColor(255, 255, 255, 150)
				surface.SetFont("_GR_CMB_FONT_1")
				w, h = surface.GetTextSize(text)

				surface.SetTextPos(65 - w / 2, 50 - h / 2)
				surface.DrawText(text)

				surface.SetDrawColor(colors[2])
				surface.DrawRect(7, 62, 114, 16)
				surface.SetDrawColor(colors[3])

				local bar = math.Clamp((var2 * 114) - 2, 0, 114)
				surface.DrawRect(8, 63, bar, 16 - 2)

				text = math.Round((var2 * 100))  .. "%"

				surface.SetTextColor(255, 255, 255, 150)
				surface.SetFont("_GR_CMB_FONT_1")

				w, h = surface.GetTextSize(text)

				surface.SetTextPos(64 - w / 2, 70 - h / 2)
				surface.DrawText(text)
			cam.End2D()
		render.PopRenderTarget()

		self.RTMat:SetTexture("$basetexture", self.RT)

		cam.Start3D2D(pos, ang, 0.064)
			render.PushFilterMin(TEXFILTER.NONE)
			render.PushFilterMag(TEXFILTER.NONE)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.RTMat)
			surface.DrawTexturedRect(0, 0, 385, 269)

			render.PopFilterMin()
			render.PopFilterMag()
		cam.End3D2D()

		if IsValid(LocalPlayer():GetActiveWeapon()) then
			if LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then
				render.DrawLine(self:GetProductPos(), self:GetPos(), color_white, true)
			end
		end
	end
end
