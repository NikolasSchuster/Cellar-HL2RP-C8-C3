ENT.Type = 'anim'
ENT.PrintName = 'Dissolver'
ENT.Category = 'HL2 RP'
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 0, 'Dummy')
	self:NetworkVar('Bool', 0, 'Toggle')

	self:NetworkVar("String", 0, "Access", {
		KeyName = "Access",
		Edit = {
			type = "String",
			order = 1
		}
	})
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel('models/props_combine/combine_fence01b.mdl')
		self:DrawShadow(false)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysicsInit(SOLID_VPHYSICS)
		--self:SetPersistent(true)
		self:SetToggle(true)
		-- local data = {}
		-- data = {}
		-- data.start = self:GetPos()
		-- data.endpos = self:GetPos() - Vector(0, 0, 300)
		-- data.filter = self
		-- local trace = util.TraceLine(data)
		-- if trace.Hit and util.IsInWorld(trace.HitPos) and self:IsInWorld() then
		--   self:SetPos(trace.HitPos + Vector(0, 0, 39.9))
		-- end
		-- data = {}
		-- data.start = self:GetPos()
		-- data.endpos = self:GetPos() + Vector(0, 0, 150)
		-- data.filter = self
		-- trace = util.TraceLine(data)
		-- if trace.Hit then
		--   self:SetPos(self:GetPos() - Vector(0, 0, trace.HitPos:Distance(self:GetPos() + Vector(0, 0, 151))))
		-- end
		-- data = {}
		-- data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16
		-- data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600
		-- data.filter = self
		-- trace = util.TraceLine(data)
		local data = {}
		data.start = self:GetPos() + self:GetRight() * -16
		data.endpos = self:GetPos() + self:GetRight() * -480
		data.filter = self
		local trace = util.TraceLine(data)
		local angles = self:GetAngles()
		angles:RotateAroundAxis(angles:Up(), 90)
		self.dummy = ents.Create('prop_physics')
		self.dummy:SetModel('models/props_combine/combine_fence01a.mdl')
		-- self.dummy:SetPos(trace.HitPos - Vector(0, 0, 50))
		-- self.dummy:SetAngles(Angle(0, self:GetAngles().y, 0))
		self.dummy:SetPos(trace.HitPos)
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:Spawn()
		self.dummy:DrawShadow(false)
		self.dummy:DeleteOnRemove(self)
		self.dummy:MakePhysicsObjectAShadow(false, false)
		self:DeleteOnRemove(self.dummy)
		self:SetDummy(self.dummy)
		local physics_object = self:GetPhysicsObject()

		if IsValid(physics_object) then
			physics_object:EnableMotion(false)
		end

		physics_object = self.dummy:GetPhysicsObject()

		if IsValid(physics_object) then
			physics_object:EnableMotion(false)
		end
	end

	function ENT:SpawnFunction(client, trace)
		local angles = (client:GetPos() - trace.HitPos):Angle()
		angles.p = 0
		angles.r = 0
		angles:RotateAroundAxis(angles:Up(), 270)
		local entity = ents.Create(self.ClassName)
		entity:SetPos(trace.HitPos + Vector(0, 0, 40))
		entity:SetAngles(angles:SnapTo("y", 90))
		entity:Spawn()
		entity:Activate()
		entity:SetAccess("cmbMpfAll")
		Schema:SaveForceFields()

		return entity
	end

	function ENT:DissolvePlayer(pl, pos)
		local ragdoll = ents.Create("prop_ragdoll")
		ragdoll:SetModel(pl:GetModel())
		ragdoll:SetPos(pos)
		ragdoll:SetAngles(pl:GetAngles() + Angle(5, 4, 3))
		ragdoll:Spawn()

		timer.Simple(0.1, function()
			ragdoll:GetPhysicsObject():EnableGravity(false)
		end)

		pl:Kill()
		pl:SetPos(pl:GetPos() + self:GetForward() * 50)
		self:EmitSound("ambient/levels/citadel/zapper_warmup1.wav")
		self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1, 4) .. ".wav")

		timer.Simple(0.1, function()
			self:EmitSound("hl2rp/walloflight/wol1.wav", 90)
			self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1, 4) .. ".wav")

			timer.Create(ragdoll:EntIndex() .. "_dissolveloop", 0.5, 2, function()
				self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1, 4) .. ".wav")
			end)

			local diss = ents.Create("env_entity_dissolver")
			ragdoll:SetName(tostring(ragdoll))
			diss:SetPos(ragdoll:GetPos())
			diss:SetKeyValue("target", ragdoll:GetName())
			diss:SetKeyValue("magnitude", 2)
			diss:SetKeyValue("dissolvetype", 1)
			diss:Spawn()
			diss:Fire("Dissolve", "", 0)
			diss:Fire("kill", "", 0.1)
		end)
	end

	function ENT:Confiscate(model, pos, ang)
		local weapon = ents.Create("prop_physics")
		weapon:SetModel(model)
		weapon:SetPos(pos)
		weapon:SetAngles(ang)
		weapon:Spawn()

		timer.Simple(0.2, function()
			weapon:GetPhysicsObject():EnableGravity(false)
		end)

		self:EmitSound("npc/overwatch/cityvoice/fcitadel_confiscating.wav")
		self:EmitSound("ambient/energy/zap" .. math.random(1, 3) .. ".wav")

		timer.Simple(2.5, function()
			self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1, 4) .. ".wav")

			timer.Create(self:EntIndex() .. "_dissolveloop", 0.5, 4, function()
				self:EmitSound("ambient/levels/citadel/weapon_disintegrate" .. math.random(1, 4) .. ".wav")
			end)

			local diss = ents.Create("env_entity_dissolver")
			weapon:SetName(tostring(weapon))
			diss:SetPos(weapon:GetPos())
			diss:SetKeyValue("target", weapon:GetName())
			diss:SetKeyValue("magnitude", 0)
			diss:SetKeyValue("dissolvetype", 2)
			diss:Spawn()
			diss:Fire("Dissolve", "", 0)
			diss:Fire("kill", "", 0.1)
		end)
	end

	local dissolve_entity_types = {
		['ix_item'] = function(entity) --entity:GetPhysicsObject():EnableGravity(false)
return entity end,
		['ix_money'] = function(entity) --entity:GetPhysicsObject():EnableGravity(false)
return entity end
	}

	local beep_delay = 1
	local beep_occurrence = -beep_delay

	function ENT:Think()
		local cur_time = CurTime()
		local beep_time_elapsed = cur_time - beep_occurrence

		if self:GetToggle() then
			local entities = ents.FindInBox(self:GetPos() - Vector(0, 0, 55), self:GetDummy():GetPos() + self:GetUp() * 150 + Vector(5, 5, 0))

			for i = 1, #entities do
				local entity = entities[i]

				if IsValid(entity) and dissolve_entity_types[entity:GetClass()] and not entity.dissolve_cooldown then
					local correct_entity = dissolve_entity_types[entity:GetClass()](entity)

					if correct_entity then
						self:Confiscate(entity:GetModel(), entity:GetPos(), entity:GetAngles())
						entity:Remove()
					end
				end

				if entity:GetClass() == "player" and not entity:GetNetVar("dissolve") then
					if not entity:GetCharacter():HasIDAccess(self:GetAccess()) and not entity.ixObsData then
						if entity:IsDispatch() then return end

						entity:SetNetVar("dissolve", true)

						timer.Simple(10, function()
							entity:SetNetVar("dissolve", false)
						end)

						self:DissolvePlayer(entity, entity:GetPos())
					end
				end
			end
		end

		-- disgusting
		if not self.sound_loop then
			self.sound_loop = CreateSound(self, 'ambient/machines/combine_shield_loop3.wav')
			self.sound_loop:Play()
			self.sound_loop:ChangeVolume(0.8, 0)
		else
			if self:GetToggle() then
				self.sound_loop:Play()
			else
				self.sound_loop:FadeOut(1)
			end
		end

		if self:GetToggle() and self:GetNetVar("light") then
			if (not self.Beep or CurTime() >= self.Beep) then
				self:EmitSound("hl2rp/walloflight/wol1.wav")
				self:GetDummy():EmitSound("hl2rp/walloflight/wol1.wav")
				self.Beep = CurTime() + 2
			end
		end

		if self:GetToggle() then
			local data = {}

			for k, v in pairs(ents.FindInSphere(self:GetPos() + self:GetRight() * -(self:GetPos():Distance(self:GetDummy():GetPos()) / 2), 200)) do
				table.insert(data, v:GetClass())
			end

			if table.HasValue(data, "player") then
				for k, v in pairs(ents.FindInSphere(self:GetPos() + self:GetRight() * -(self:GetPos():Distance(self:GetDummy():GetPos()) / 2), 200)) do
					if v:IsPlayer() and v:Alive() then
						if not v:GetCharacter():HasIDAccess(self:GetAccess()) and not v.ixObsData then
							if v:IsDispatch() then continue end
							if not self:GetNetVar("light") then
								if (not self.Warning or CurTime() >= self.Warning) then
									self:EmitSound("hlacomvoice/alarms/combine_alarm_02_01_lp.mp3")
									self:GetDummy():EmitSound("hlacomvoice/alarms/combine_alarm_02_01_lp.mp3")
									self.Warning = CurTime() + 5
								end

								self:SetNetVar("light", true)
								self.BeepDouble = true
							end
						end
					end
				end
			else
				if self:GetNetVar("light") then
					self:SetNetVar("light", false)

					if self.BeepDouble then
						if (not self.Beep2 or CurTime() >= self.Beep2) then
							self:EmitSound("hl2rp/walloflight/wol2.wav")
							self:GetDummy():EmitSound("hl2rp/walloflight/wol2.wav")
							self.BeepDouble = false
							self.Beep2 = CurTime() + 15 -- fix spam (W and S)
						end
					end
				end
			end
		end
	end

	function ENT:OnRemove()
		if self.sound_loop then
			self.sound_loop:Stop()
			self.sound_loop = nil
		end
	end

	function ENT:set_id(id)
		self:SetNetVar('id', id)
	end

	function ENT:toggle(boolean)
		self:SetToggle(boolean)

		if self:GetToggle() then
			self:SetSkin(0)
			self.dummy:SetSkin(0)
			self:EmitSound('hl2rp/forcefield/enable.mp3')
			self:GetDummy():EmitSound('hl2rp/forcefield/enable.mp3')
		else
			self:SetSkin(1)
			self.dummy:SetSkin(1)
			self:EmitSound('hl2rp/forcefield/enable.mp3')
			self:GetDummy():EmitSound('hl2rp/forcefield/disable.mp3')
		end
		--[[-------------------------------------------------------------------------
		self:SetSkin(self:GetToggle() and 0 or 1)
		self.dummy:SetSkin(self:GetToggle() and 0 or 1)
		self:EmitSound(self:GetToggle() and 'ambient/machines/thumper_startup1.wav' or 'ambient/machines/thumper_shutdown1.wav')
		---------------------------------------------------------------------------]]
	end
else
	surface.CreateFont("cp_hud3", {
		font = "Arial AMU",
		size = 150,
		weight = 100
	})

	surface.CreateFont("cp_hud4", {
		font = "Arial AMU",
		extended = false,
		size = 170,
		weight = 10,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	function ENT:Initialize()
		self.alpha = 0
	end

	local material = Material('effects/com_shield003a')

	function ENT:Draw()
		self:DrawModel()
		local dummy = self:GetDummy()
		local angles = self:GetAngles()
		local matrix = Matrix()
		matrix:Translate(self:GetPos() + self:GetUp() * -40 + self:GetForward() * -2)
		matrix:Rotate(angles)

		if IsValid(dummy) and self:GetToggle() then
			local vertex = self:WorldToLocal(dummy:GetPos())
			self:SetRenderBounds(vector_origin - Vector(0, 0, 40), vertex + self:GetUp() * 150)
			render.SetMaterial(material)
			cam.PushModelMatrix(matrix)
			self:draw_shield(vertex)
			cam.PopModelMatrix()
			matrix:Translate(vertex)
			matrix:Rotate(Angle(0, 180, 0))
			cam.PushModelMatrix(matrix)
			self:draw_shield(vertex)
			cam.PopModelMatrix()
		end

		if self:GetNetVar("light") then
			self.alpha = math.Clamp(self.alpha + 5, 0, 200)
		else
			self.alpha = math.Clamp(self.alpha - 5, 0, 200)
		end

		if self:GetToggle() then
			cam.Start3D2D(self:GetPos() + Vector(0, 0, 150), self:GetAngles() + Angle(0, 90, 90), 0.06)

			-- surface.SetDrawColor(255,255,255,50) 
			-- surface.SetMaterial(Material("hl2rp/alyx/combinelines.png")) 
			-- surface.DrawTexturedRect(0,0,self:GetPos():Distance(dummy:GetPos()) * 16.5,3150)
			if self.alpha > 0 then
				draw.SimpleText("ГРАЖДАНИН, ПРОХОД ДАЛЕЕ ЗАПРЕЩЕН", "cp_hud4", (self:GetPos():Distance(dummy:GetPos()) * 16.5) / 2, 2120, Color(255, 255, 255, self.alpha), TEXT_ALIGN_CENTER, 1)
			end

			draw.SimpleText("ВНИМАНИЕ", "cp_hud4", (self:GetPos():Distance(dummy:GetPos()) * 16.5) / 2, 1550, Color(255, 255, 255, math.abs(math.sin(CurTime())) * 200), TEXT_ALIGN_CENTER, 1)
			draw.SimpleText("ЛОКАЦИЯ ОГРАНИЧЕНА", "cp_hud4", (self:GetPos():Distance(dummy:GetPos()) * 16.5) / 2, 1750, Color(255, 255, 255, math.random(150, 255)), TEXT_ALIGN_CENTER, 1)
			cam.End3D2D()
			cam.Start3D2D(dummy:GetPos() + Vector(0, 0, 150), self:GetAngles() + Angle(0, -90, 90), 0.06)

			-- surface.SetDrawColor(255,255,255,50) 
			-- surface.SetMaterial(Material("hl2rp/alyx/combinelines.png")) 
			-- surface.DrawTexturedRect(0,0,self:GetPos():Distance(dummy:GetPos()) * 16.5,3150)
			if self.alpha > 0 then
				surface.SetDrawColor(0, 0, 255, self.alpha)
				surface.DrawRect(0, 2000, self:GetPos():Distance(dummy:GetPos()) * 16.5, 250)
				draw.SimpleText("ГРАЖДАНИН, ПРОХОД ДАЛЕЕ ЗАПРЕЩЕН", "cp_hud4", (self:GetPos():Distance(dummy:GetPos()) * 16.5) / 2, 2120, Color(255, 255, 255, self.alpha), TEXT_ALIGN_CENTER, 1)
			end

			surface.SetDrawColor(255, 0, 0, math.abs(math.sin(CurTime())) * 100)
			surface.DrawRect(0, 1400, self:GetPos():Distance(dummy:GetPos()) * 16.5, 500)
			draw.SimpleText("ВНИМАНИЕ", "cp_hud4", (self:GetPos():Distance(dummy:GetPos()) * 16.5) / 2, 1550, Color(255, 255, 255, math.abs(math.sin(CurTime())) * 200), TEXT_ALIGN_CENTER, 1)
			draw.SimpleText("ЛОКАЦИЯ ОГРАНИЧЕНА", "cp_hud4", (self:GetPos():Distance(dummy:GetPos()) * 16.5) / 2, 1750, Color(255, 255, 255, math.random(150, 255)), TEXT_ALIGN_CENTER, 1)
			cam.End3D2D()
		end
	end

	function ENT:draw_shield(vertex)
		local dist = self:GetDummy():GetPos():Distance(self:GetPos())
		local mat_fac = 45
		local height = 5
		local width = dist / mat_fac
		mesh.Begin(MATERIAL_QUADS, 1)
		mesh.Position(vector_origin)
		mesh.TexCoord(0, 0, 0)
		mesh.AdvanceVertex()
		mesh.Position(self:GetUp() * 190)
		mesh.TexCoord(0, 0, height)
		mesh.AdvanceVertex()
		mesh.Position(vertex + self:GetUp() * 190)
		mesh.TexCoord(0, width, height)
		mesh.AdvanceVertex()
		mesh.Position(vertex)
		mesh.TexCoord(0, width, 0)
		mesh.AdvanceVertex()
		mesh.End()
	end

	function ENT:Think()
		if self:GetToggle() and self:GetNetVar("light") then
			local dlight = DynamicLight(self:EntIndex())
			dlight.pos = self:GetPos()
			dlight.r = 255
			dlight.g = 2
			dlight.b = 0
			dlight.brightness = 3
			dlight.Decay = 1000
			dlight.Size = 400
			dlight.DieTime = CurTime() + 1
			local dlight2 = DynamicLight(self:EntIndex() + 1)
			dlight2.pos = self:GetDummy():GetPos()
			dlight2.r = 255
			dlight2.g = 2
			dlight2.b = 0
			dlight2.brightness = 3
			dlight2.Decay = 1000
			dlight2.Size = 400
			dlight2.DieTime = CurTime() + 1
		end
	end
end

function ENT:id()
	return self:GetNetVar('id', 0)
end