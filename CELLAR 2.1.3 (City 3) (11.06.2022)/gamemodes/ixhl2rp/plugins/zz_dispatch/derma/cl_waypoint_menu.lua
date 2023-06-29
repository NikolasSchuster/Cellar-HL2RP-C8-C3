local function MaskInclude(maskFunc, renderFunc)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.DepthRange(0, 1)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	maskFunc()

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	renderFunc()

	render.DepthRange(0, 1)
	render.SetStencilEnable(false)
	render.ClearStencil()
end

local function PrecacheArc(cx, cy, radius, thickness, startang, endang, roughness)
	local triarc = {}
	-- local deg2rad = math.pi / 180
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	if startang > endang then
		step = math.abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*r), cy+(-math.sin(rad)*r)
		table.insert(inner, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
		table.insert(outer, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
	-- Return a table of triangles to draw.
	return triarc
end

local function Arc(cx, cy, radius, thickness, startang, endang, roughness,color)
	surface.SetDrawColor(color)

	local arc = PrecacheArc( 
		cx,
		cy,
		radius,
		thickness,
		startang,
		endang,
		roughness
	)

	for i, vertex in pairs(arc) do
		surface.DrawPoly(vertex)
	end
end

local blur = Material("pp/blurscreen")
local function Blur(panel, intensivity, d)
	local x, y = panel:LocalToScreen()
	surface.SetDrawColor(color_white)
	surface.SetMaterial(blur)

	for i = 1, intensivity do
		blur:SetFloat("$blur", (i / d) * intensivity)
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end

local function Circle(sx, sy, radius, vertexCount, color, angle)
	local vertices = {}
	local ang = -math.rad(angle or 0)
	local c = math.cos(ang)
	local s = math.sin(ang)
	for i = 0, 360, 360 / vertexCount do
		local radd = math.rad(i)
		local x = math.cos(radd)
		local y = math.sin(radd)

		local tempx = x * radius * c - y * radius * s + sx
		y = x * radius * s + y * radius * c + sy
		x = tempx

		vertices[#vertices + 1] = {
			x = x, 
			y = y, 
			u = u, 
			v = v 
		}
	end

	if vertices and #vertices > 0 then
		draw.NoTexture()
		surface.SetDrawColor(color)
		surface.DrawPoly(vertices)
	end
end

local icons = {
	[1] = {
		mat = Material("cellar/ui/dispatch/ico/gun"),
		type = "gun",
		color = Color(255, 50, 70),
	},
	[2] = {
		mat = Material("cellar/ui/dispatch/ico/attack"),
		type = "attack",
		color =  Color(255, 50, 70)
	},
	[3] = {
		mat = Material("cellar/ui/dispatch/ico/hazard"),
		type = "hazard",
		color =  Color(175, 200, 125),
	},
	[4] = {
		mat = Material("cellar/ui/dispatch/ico/factory"),
		type = "factory",
		color =  Color(31, 171, 125),
	},
	[5] = {
		mat = Material("cellar/ui/dispatch/ico/poi"),
		type = "poi",
		color =  Color(255, 200, 64)
	},
	[6] = {
		mat = Material("cellar/ui/dispatch/ico/protect"),
		type = "protect",
		color =  Color(0, 225, 255)
	},
	[7] = {
		mat = Material("cellar/ui/dispatch/ico/regroup"),
		type = "regroup",
		color =  Color(0, 225, 255)
	},
	[8] = {
		mat = Material("cellar/ui/dispatch/ico/death"),
		type = "death",
		color = Color(200, 64, 64)
	},
	[9] = {
		mat = Material("cellar/ui/dispatch/ico/warn"),
		type = "warn",
		color = Color(255, 50, 70)
	},
}

local PANEL = {}
local WheelScale = 1

BLOCK_WAYPOINT_USE = 0

function PANEL:Init()
	if IsValid(ix.gui.waypoints) then ix.gui.waypoints:Remove() end
	
	ix.gui.waypoints = self

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	self.Radius = 225 * WheelScale

	self.Center = {
		X = ScrW() / 2,
		Y = ScrH() / 2
	}

	self.Buttons = {}

	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)
	self:SetKeyboardInputEnabled(false)

	for k, v in ipairs(icons) do
		local panel = self:Add("Panel")
		panel.Paint = function(_, w, h)
			surface.SetDrawColor(v.color)
			surface.SetMaterial(v.mat)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		panel.data = v

		self.Buttons[#self.Buttons + 1] = panel
	end

	self.Sections = #self.Buttons

	local lastClick = 0

	hook.Add("quickmenu.rightclick", self, function(self)
		if !self.selectedArea and self.HasMovedSlightly then return end

		local CT = CurTime()

		if lastClick > CT then return end
		lastClick = CT + 0.2

		self:Close()
	end)

	hook.Add("quickmenu.leftclick", self, function(self)
		if !self.selectedArea then return end

		local CT = CurTime()

		if lastClick > CT then return end
		lastClick = CT + 0.2

		self:Select(self.selectedArea)
	end)
end

function PANEL:Think()
	if input.IsMouseDown(MOUSE_RIGHT) or (self.KeyCode and not input.IsKeyDown(self.KeyCode)) then
		self:Close()
		return
	end
end

function PANEL:Close()
	if self.FadingOut then return end

	self.FadingOut = true

	BLOCK_WAYPOINT_USE = CurTime() + 0.5

	self:AlphaTo(0, 0.2, nil, function()
		self:Remove()
	end)
end

function PANEL:PerformLayout(w, h)
	local sectionSize = 360 / self.Sections
	local rad = self.Radius * 0.4

	for i, v in pairs(self.Buttons) do
		local ang = (i - 1) * sectionSize
		ang = math.rad(ang)

		local size = self.Sections > 12 and self.Radius * 2 / self.Sections or (96 * WheelScale)

		if self.selectedArea and self.selectedArea + 1 == i then
			size = size * 1.25
		end

		local r = self.Radius - rad / 2
		local sin = math.sin(ang) * r
		local cos = math.cos(ang) * r
		local x = self.Center.X - size / 2 + sin
		local y = self.Center.Y - size / 2 - cos

		v:SetSize(size, size)
		v:SetPos(x, y)
	end
end

function PANEL:Select(id)
	if self.FadingOut then return end

	local panel = self.Buttons[id + 1]

	if IsValid(panel) then
		if self.isDispatch then
			net.Start("dispatch.waypoint")
				net.WriteString(panel.data.type)
				net.WriteVector(self.pos)
			net.SendToServer()
		else
			ix.command.Send("Waypoint", panel.data.type)
		end
	end
	
	--surface.PlaySound(soundSelect)
	self:Close()
end

function PANEL:Paint(w, h)
	local rad = self.Radius * 0.4
	local cursorAng = 180 - (math.deg(math.atan2(gui.MouseX() - self.Center.X, gui.MouseY() - self.Center.Y)))

	MaskInclude(function()
		Arc(self.Center.X, self.Center.Y, self.Radius, rad, 0, 360, 1, Color(0, 0, 0, 150))
	end, function()
		Blur(self, 6, 4)

		draw.NoTexture()
		Circle(self.Center.X, self.Center.Y, self.Radius, 90, Color(0, 0, 0, 150))
	end)

	Arc(self.Center.X, self.Center.Y, self.Radius - rad, 3, 0, 360, 1, Color(188, 188, 188))

	if self.HasMovedSlightly then
		Circle(self.Center.X, self.Center.Y, self.Radius - rad - 3, 90, Color(0, 0, 0, 200))

		local sectionSize = 360 / self.Sections
		local selectedArea = math.abs(cursorAng + sectionSize / 2) / sectionSize
		selectedArea = math.floor(selectedArea)

		if selectedArea >= self.Sections then
			selectedArea = 0
		end

		if self.selectedArea != selectedArea then
			if #self.Buttons > 0 then
				--surface.PlaySound(soundHover)
			end

			self.selectedTbl = self.Buttons[selectedArea + 1]

			self:InvalidateLayout()
		end

		self.selectedArea = selectedArea

		local selectedAng = selectedArea * sectionSize
		local outerArcScale = math.Round(4 * WheelScale)

		Arc(self.Center.X, self.Center.Y, self.Radius + outerArcScale, outerArcScale, 90 - selectedAng - sectionSize / 2, 90 - selectedAng + sectionSize / 2, 1, color_white)
		Arc(self.Center.X, self.Center.Y, self.Radius, rad, 90 - selectedAng - sectionSize / 2, 90 - selectedAng + sectionSize / 2, 1, Color(0, 0, 0, 180))

		local innerArcScale = math.Round(6 * WheelScale)
		Arc(self.Center.X, self.Center.Y, self.Radius - rad, innerArcScale, -cursorAng - 21 + 90 - 0, -cursorAng + 90 + 21, 1, color_white)


		local str = "ЛКМ — ВЫБОР"
		surface.SetFont("dispatch.radialmenu")
		local tw, th = surface.GetTextSize(str)

		local iconSize = th
		local x = w / 2
		local y = h / 2 + (56 * WheelScale)

		draw.SimpleText(str, "dispatch.radialmenu", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		local str = "ПКМ — ОТМЕНА"
		local tw, th = surface.GetTextSize(str)
		y = y + th

		draw.SimpleText(str, "dispatch.radialmenu", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	else    
		local xDist = math.abs(self.Center.X - gui.MouseX())
		local yDist = math.abs(self.Center.Y - gui.MouseY())
		local dist = math.sqrt(xDist ^ 2 + yDist ^ 2)

		if dist > 20 then
			self.HasMovedSlightly = true
		end
	end
end

vgui.Register("dispatch.radial.menu", PANEL)

do
	hook.Add("VGUIMousePressed", "dispatch.radialmenu", function(pnl, code)
		if IsValid(ix.gui.waypoints) and pnl == ix.gui.waypoints then
			if code == MOUSE_LEFT then
				hook.Run("quickmenu.leftclick")
			elseif code == MOUSE_RIGHT then
				hook.Run("quickmenu.rightclick")
			end
		end
	end)
end
