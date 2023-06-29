local PLUGIN = PLUGIN


ENT.Type = "anim"
ENT.PrintName = "Water Collector"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = false
ENT.bNoPersist = true


if (SERVER) then

	function ENT:Initialize()

		self:SetNetVar("wamount", 0)

		self:SetModel("models/props_wasteland/laundry_basket001.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self.nextUseTime = 0

		self.timer_name = "watertimer" .. self:EntIndex()

		local conf_time = ix.config.Get("watertimer")
		local water_n = 0

		timer.Create( self.timer_name, conf_time, 0, function()

		local conf_limit = ix.config.Get("waterlimit")
		local conf_tick = ix.config.Get("watertick")
		
		local pos = self:GetPos()
		local skyhit = false
		local tr = util.TraceLine( {
			start = pos,
			endpos = pos + self:GetUp() * 10000,
			filter = self
		})

		if tr.HitSky then
				skyhit = true
			else
				skyhit = false 
		end

		if skyhit and (StormFox2.Weather:IsRaining() or StormFox2.Weather:IsSnowing()) then

			water_n = math.Clamp( water_n + conf_tick, 0, conf_limit)

			self:SetNetVar("wamount", water_n)
			
		end

		end)

	end
	
	local PLUGIN = PLUGIN
	function ENT:StartTouch(entity)
		
		local item = nil
	
		if isfunction(entity.GetItemTable) then
			item = entity:GetItemTable()
		else
			return
		end
	
		local capacity = PLUGIN.emptycont[item.uniqueID]
		local result = PLUGIN.fullcont[item.uniqueID]
	
		if capacity and result then
			if self:GetNetVar("wamount") >= capacity then
				self:SetNetVar("wamount", self:GetNetVar("wamount") - capacity)
				
				entity:Remove()
	
				local fixpos = self:GetPos() + Vector(0, 0, 30)
	
				ix.item.Spawn(result, fixpos)
			end
		end
	end

	function ENT:OnRemove()
		timer.Remove(self.timer_name)
	end

else

	function ENT:Draw()

		local conf_limit = ix.config.Get("waterlimit")

		local amount = (self:GetNetVar("wamount") .. "/" .. conf_limit)

		self:DrawModel()
		local fixedAng = self:GetAngles()
		fixedAng:RotateAroundAxis( self:GetRight(), -90 )
		fixedAng:RotateAroundAxis( self:GetForward(), 90 )
		-- text showing waterlevel over model
		if self:GetPos():Distance(LocalPlayer():GetPos()) >= 512 then return end

		local fixedPos = self:GetPos() + self:GetUp() * 5 + self:GetRight() * 5 + self:GetForward() * 26
		cam.Start3D2D(fixedPos, fixedAng, 0.1)
			draw.RoundedBox(4, 0, 0, 100, 100, Color(0,0,0,225))
			draw.SimpleText( "Количество воды:", "Default", 50, 0, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
			draw.SimpleText( amount, "Default", 50, 42, Color( 255, 255, 255, 155 ), TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end

end