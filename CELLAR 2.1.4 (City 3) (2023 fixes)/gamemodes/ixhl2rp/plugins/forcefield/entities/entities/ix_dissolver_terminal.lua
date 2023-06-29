ENT.Type = 'anim'
ENT.PrintName = 'Dissolver Terminal'
ENT.Category = 'HL2 RP'
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.PhysgunDisabled = false
ENT.bNoPersist = true

if (SERVER) then
	function ENT:Initialize()
		self:SetModel('models/props_combine/combine_smallmonitor001.mdl')
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetNetVar('id', math.random(10000, 99999))
		local physics_object = self:GetPhysicsObject()

		if (IsValid(physics_object)) then
			physics_object:Sleep()
			physics_object:EnableMotion(false)
		end
	end

	function ENT:SpawnFunction(client, trace)
		local entity = ents.Create(self.ClassName)
		entity:SetPos(trace.HitPos)
		entity:SetAngles(trace.HitNormal:Angle())
		entity:Spawn()
		entity:Activate()

		return entity
	end

	local use_delay = 1
	local use_occurrence = -use_delay

	function ENT:Use(client)
		local cur_time = CurTime()
		local use_time_elapsed = cur_time - use_occurrence

		if use_time_elapsed > use_delay then
			if (client:IsCombine() or client:Team() == FACTION_ADMIN) and not self:GetNetVar('hacked', false) then
				for i = 1, #self:get_dissolvers() do
					local dissolver = self:get_dissolvers()[i]
					dissolver:toggle(not dissolver:GetToggle())
				end
			end

			use_occurrence = cur_time
		end
	end

	local default_delay = 10

	function ENT:hack(delay)
		self:EmitSound("hl2rp/forcefield/hacked.wav")

		for i = 1, #self:get_dissolvers() do
			local dissolver = self:get_dissolvers()[i]
			dissolver:toggle(false)
		end

		local spark = ents.Create('env_spark')
		spark:SetPos(self:GetPos() + Vector(0, 0, 10))
		spark:SetKeyValue('magnitude', 1)
		spark:SetKeyValue('maxdelay', 0.4)
		spark:SetKeyValue('traillength', 1)
		spark:Spawn()
		spark:Fire('StartSpark')
		self:SetNetVar('hacked', true)

		timer.Simple(15, function()
			spark:Fire('StopSpark')
			self:SetNetVar('hacked', false)

			for i = 1, #self:get_dissolvers() do
				local dissolver = self:get_dissolvers()[i]
				dissolver:toggle(true)
			end
		end)
	end
else
	local render_size = 256

	function ENT:Initialize()
		self.render_target = GetRenderTarget('RT_dissolver_' .. self:EntIndex() .. CurTime(), render_size, render_size, false)

		self.render_target_material = CreateMaterial('RTM_dissolver_' .. self:EntIndex() .. CurTime(), 'UnlitTwoTexture', {
			['$selfilium'] = '1',
			['$texture2'] = 'dev/dev_scanline',
			['Proxies'] = {
				['TextureScroll'] = {
					['texturescrollvar'] = '$texture2transform',
					['texturescrollrate'] = '3',
					['texturescrollangle'] = '90'
				}
			}
		})
	end

	local medium_font = 'ixMonoMediumFont'
	local small_font = 'ixMonoSmallFont'
	local text_terminal = 'Терминал #%s'
	local text_dissolver = 'Расщепитель #%s (%s)'

	local dissolver_status = {
		[true] = {'ОНЛАЙН', Color(0, 100, 0)},
		[false] = {'ОФФЛАЙН', Color(100, 0, 0)}
	}

	local material_glow = ix.util.GetMaterial('sprites/glow04_noz')

	function ENT:DrawTranslucent()
		self:DrawModel()
		local dissolver_toggle = false
		local position = self:GetPos()
		local angles = self:GetAngles()
		angles:RotateAroundAxis(angles:Forward(), 90)
		angles:RotateAroundAxis(angles:Right(), -90)
		position = position + self:GetForward() * 13 + self:GetUp() * 19 + self:GetRight() * 6.8
		render.PushRenderTarget(self.render_target)
		render.Clear(25, 25, 25, 255)
		cam.Start2D()

		if not self:GetNetVar('hacked', false) then
			surface.SetFont(medium_font)
			local text_w, text_h = surface.GetTextSize(text_terminal:format(self:id()))
			draw.SimpleText(text_terminal:format(self:id()), medium_font, render_size * 0.5 - text_w * 0.5, 6, color_white)
			surface.SetFont(small_font)
			local y = 32

			for i = 1, #self:get_dissolvers() do
				local dissolver = self:get_dissolvers()[i]
				dissolver_toggle = dissolver:GetToggle()
				surface.SetDrawColor(dissolver_status[dissolver:GetToggle()][2])
				local text_w, text_h = surface.GetTextSize(text_dissolver:format(dissolver:EntIndex(), dissolver_status[dissolver:GetToggle()][1]))
				surface.DrawRect(11, y, text_w, text_h)
				draw.SimpleText(text_dissolver:format(dissolver:EntIndex(), dissolver_status[dissolver:GetToggle()][1]), small_font, 12, y, color_white)
				y = y + text_h + 2
			end
		else
			render.Clear(80, 25, 25, 255)
			surface.SetFont(medium_font)
			local text_w, text_h = surface.GetTextSize(text_terminal:format('?????'))
			draw.SimpleText(text_terminal:format('?????'), medium_font, render_size * 0.5 - text_w * 0.5, 6, color_white)
		end

		cam.End2D()
		render.PopRenderTarget()
		self.render_target_material:SetTexture('$basetexture', self.render_target)
		cam.Start3D2D(position, angles, 0.064)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(self.render_target_material)
		surface.DrawTexturedRect(0, 0, render_size, render_size)
		cam.End3D2D()

		if next(self:get_dissolvers()) then
			render.SetMaterial(material_glow)
			render.DrawSprite(self:GetPos() + self:GetForward() * 13.5 + self:GetUp() * 4.5 + self:GetRight() * 4.8, 6, 6, dissolver_status[dissolver_toggle][2])
		end
	end

	local light_colours = {
		[true] = Color(0, 200, 0),
		[false] = Color(200, 0, 0)
	}

	local function glow_color(r, g, b, a, speed)
		speed = speed or 1
		local abs = math.abs(math.sin((RealTime() - 0.08) * speed))
		r = r * abs
		g = g * abs
		b = b * abs
		a = (a or 255) * abs

		return r, g, b, a
	end

	function ENT:Think()
		local cur_time = CurTime()
		local dynamic_light = DynamicLight(self:EntIndex())

		if dynamic_light and next(self:get_dissolvers()) then
			local dissolver_toggle = true

			for i = 1, #self:get_dissolvers() do
				dissolver_toggle = self:get_dissolvers()[i]:GetToggle()
				break
			end

			local r, g, b, a = glow_color(light_colours[dissolver_toggle].r, light_colours[dissolver_toggle].g, light_colours[dissolver_toggle].b, light_colours[dissolver_toggle].a, 1)
			dynamic_light.pos = self:GetPos() + self:GetForward() * 12 + self:GetUp() * 4.5 + self:GetRight() * 4.8
			dynamic_light.r = r
			dynamic_light.g = g
			dynamic_light.b = b
			dynamic_light.brightness = 1
			dynamic_light.Decay = 100
			dynamic_light.Size = 100
			dynamic_light.DieTime = CurTime() + 1
		end
	end
end

function ENT:id()
	return self:GetNetVar('id')
end

function ENT:get_dissolvers()
	local dissolvers = {}

	for _, v in ipairs(ents.FindByClass('ix_dissolver')) do
		if v:id() == self:id() then
			dissolvers[#dissolvers + 1] = v
		end
	end

	return dissolvers
end