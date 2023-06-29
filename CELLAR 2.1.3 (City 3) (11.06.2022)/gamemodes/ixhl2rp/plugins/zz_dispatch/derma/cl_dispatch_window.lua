local function scale(px)
	return math.ceil(math.max(480, ScrH()) * (px / 1080))
end

do
	local PANEL = {}
	function PANEL:Init()
		self.label = self:Add("DLabel")
		self.label:SetFont("dispatch.stat.label")
		self.label:Dock(FILL)
		self.label:SetContentAlignment(1)

		self.value = self:Add("DLabel")
		self.value:SetFont("dispatch.stat.value")
		self.value:Dock(RIGHT)
		self.value:SetContentAlignment(3)

		self:DockPadding(0, 0, 0, 2)
		self:DockMargin(0, 0, 0, 13)
	end

	function PANEL:SetLabel(label)
		self.label:SetText(label)
		self.label:SizeToContents()
	end

	function PANEL:SetLabelColor(clr)
		self.label:SetTextColor(clr)
	end
	
	function PANEL:SetValue(value)
		self.value:SetText(value)
		self.value:SizeToContents()
	end
	
	local clr = Color(255, 255, 255, 255 * 0.08)
	function PANEL:Paint(w, h)
		surface.SetDrawColor(clr)
		surface.DrawLine(0, h - 1, w, h - 1)
	end

	vgui.Register("dispatch.window.stat", PANEL, "EditablePanel")

	local button_h = scale(16)
	local colors = {
		[1] = Color(0, 56, 64, 255 * 0.4),
		[2] = Color(0, 255, 255, 255 * 0.1),
		[3] = Color(0, 226, 255, 255)
	}

	PANEL = {}

	function PANEL:Init()
		self.oldSetWide = self.oldSetWide or self.SetWide
		self.SetWide = function(this, n)
			self.container:SetWide(n - 13 * 2)
			this:oldSetWide(n)
		end

		self.state = false

		self.container = self:Add("Panel")
		self.container:Dock(FILL)
		self.container:DockPadding(13, 13, 13, 13)
		self.container.Paint = function(_, w, h)
			surface.SetDrawColor(colors[2])
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetDrawColor(colors[1])
			surface.DrawRect(0, 0, w, h)
		end

		self.button_poly = {
			{x = 0, y = 0},
			{x = 64, y = 0},
			{x = 64 - 8, y = 8},
			{x = 8, y = 8}
		}

		self.button = self:Add("DButton")
		self.button:SetFont("dispatch.window")
		self.button:SetTextColor(color_black)
		self.button:DockMargin(0, 2, 0, 0)
		self.button:Dock(BOTTOM)
		self.button:SetTall(button_h)
		self.button.Paint = function(_, w, h)
			surface.SetDrawColor(colors[3])
			surface.DrawRect(0, 0, w, 2)

			draw.NoTexture()
			surface.DrawPoly(self.button_poly)
		end
		self.button.DoClick = function()
			self:Open()
		end

		self:SetTall(button_h + 2)

		
	end

	function PANEL:SetWindowName(value)
		surface.SetFont("dispatch.window")
		local win_w, win_h = self:GetWide()
		local w, h = surface.GetTextSize(value)

		self.button:SetText(value)
		self.button_poly = {
			{x = win_w / 2 - w / 2 - button_h - 2, y = 0},
			{x = win_w / 2 + w / 2 + button_h + 2, y = 0},
			{x = win_w / 2 + w / 2 + 2, y = button_h},
			{x = win_w / 2 - w / 2 - 2, y = button_h}
		}
	end
	
	function PANEL:Insert(class)
		local obj = self.container:Add(class)

		return obj
	end

	function PANEL:UpdateContainer()
		self.container:InvalidateLayout(true)
		self.container:SizeToChildren(false, true)
	end


	function PANEL:Open()
		if self.animating then
			return
		end
		
		local w, h = self.container:ChildrenSize()

		self.animating = true
		self:SizeTo(-1, self.state and (button_h + 2) or (h + button_h + 2), 0.25, 0, -1, function()
			self.animating = false
		end)

		self.state = !self.state
	end
	
	vgui.Register("dispatch.window", PANEL, "EditablePanel")
end

do
	local color_hover = Color(0, 226, 255, 255)
	local color_inactive = Color(0, 226, 255, 128)
	local color_selected = Color(0, 226, 255, 255)
	local color_hover_bg = Color(0, 255, 255, 4)
	local color_active_bg = Color(0, 255, 255, 16)

	local PANEL = {}
	function PANEL:Init()
		self:SetFont("dispatch.tab")
		self:SetTextColor(color_inactive)

		self.active = false
	end

	function PANEL:OnCursorEntered()
		self.isHovered = true
		self:SetTextColor(self.active and color_selected or color_hover)
	end

	function PANEL:OnCursorExited()
		self.isHovered = false
		self:SetTextColor(self.active and color_selected or color_inactive)
	end
	
	function PANEL:DoClick()
		for k, v in ipairs(self:GetParent().buttons) do if v == self then continue end v.active = false end
		
		self.active = !self.active

		self:SetTextColor(self.active and color_selected or color_inactive)

		self:DoSwitch()
	end

	function PANEL:Paint(w, h)
		surface.SetDrawColor(self.active and color_selected or color_inactive)
		surface.DrawRect(0, h - 2, w, 2)

		if self.isHovered and !self.active then
			surface.SetDrawColor(color_hover_bg)
			surface.DrawRect(0, 0, w, h)
		elseif self.active then
			surface.SetDrawColor(color_active_bg)
			surface.DrawRect(0, 0, w, h)
		end
	end

	function PANEL:DoSwitch()
	end
	
	vgui.Register("dispatch.window.tab", PANEL, "DButton")
end

do
	local color_inactive = Color(0, 0, 0, 255)
	local color_inactive_bg = Color(0, 226, 255, 200)
	local color_hover_bg = Color(0, 255, 255, 255)

	local PANEL = {}
	function PANEL:Init()
		self:SetFont("dispatch.tabfunc")
		self:SetTextColor(color_inactive)
	end

	function PANEL:OnCursorEntered()
		self.isHovered = true
	end

	function PANEL:OnCursorExited()
		self.isHovered = false
	end
	
	function PANEL:Paint(w, h)
		surface.SetDrawColor(self.isHovered and color_hover_bg or color_inactive_bg)
		surface.DrawRect(0, 0, w, h)
	end
	
	vgui.Register("dispatch.window.tabfunc", PANEL, "DButton")
end

do
	local color_bg = Color(0, 255, 255, 15)
	local high = Color(0, 100, 64, 2)
	local focus_color = Color(0, 0, 0, 225)
	local header_colors = {Color(0, 255, 255), Color(0, 255, 255, 19)}
	local ico = Material("cellar/ui/dispatch/camera.png")
	local PANEL = {}

	function PANEL:GetHeaderColor(isText)
		return (self.hovered and isText) and focus_color or (self.hovered and header_colors[1] or (isText and header_colors[1] or header_colors[2]))
	end

	function PANEL:GetTextColors()
		local clr = self:GetHeaderColor(true)

		self.text:SetTextColor(clr)
		self.class_text:SetTextColor(clr)
	end

	function PANEL:PaintBG(w, h)
		surface.SetDrawColor(self.parent:GetHeaderColor())
		surface.DrawRect(0, 0, w, h)
	end

	function PANEL:PaintLeader(w, h)
		if LocalPlayer():GetViewEntity() != self.parent.entity then return end
		
		surface.SetDrawColor(self.parent:GetHeaderColor(true))
		surface.SetMaterial(ico)
		surface.DrawTexturedRect(w - 16, h / 2 - 8, 16, 16)
	end

	function PANEL:Paint(w, h) end

	function PANEL:Init()
		self:SetText("")
		self:SetTall(25)

		self.hovered = false

		self.class = self:Add("Panel")
		self.class:Dock(RIGHT)
		self.class:DockMargin(2, 0, 0, 0)
		self.class:SetMouseInputEnabled(false)

		self.class_text = self.class:Add("DLabel")
		self.class_text:Dock(FILL)
		self.class_text:SetContentAlignment(5)

		self.header = self:Add("Panel")
		self.header:Dock(FILL)
		self.header:SetMouseInputEnabled(false)

		self.indicator = self.header:Add("Panel")
		self.indicator:Dock(LEFT)
		self.indicator:DockMargin(0, 0, 5, 0)
		self.indicator:SetWide(self:GetTall())

		self.text = self.header:Add("DLabel")
		self.text:Dock(FILL)
		self.text:SetContentAlignment(4)

		self.text:SetFont("dispatch.camera.button")
		self.class_text:SetFont("dispatch.camera.button")

		self.class.parent = self
		self.header.parent = self
		self.indicator.parent = self

		self.class.Paint = self.PaintBG
		self.header.Paint = self.PaintBG
		self.indicator.Paint = self.PaintLeader
	end

	function PANEL:OnCursorEntered()
		self.hovered = true

		self:GetTextColors()
	end

	function PANEL:OnCursorExited()
		self.hovered = false

		self:GetTextColors()
	end

	function PANEL:SetEntity(entity)
		self.entity = entity

		self.DoClick = function()
			ix.gui.dispatch:RequestCamera(entity)
		end

		local data = entity:GetCameraData()

		self.text:SetText(entity:GetNetVar("cam") or data:Name(entity) or "UNKNOWN")
		self.class_text:SetText(data:Type())

		self:GetTextColors()
	end
	
	function PANEL:PerformLayout(w, h)
		self.class:SetWide(w * 0.3)

		self.header:SetWide(w - self.class:GetWide())
	end

	vgui.Register("dispatch.camera.button", PANEL, "DButton")
end

do
	local PANEL = {}
	PANEL.HeaderSize = 28
	PANEL.clr = {
		Color(0, 240, 255, 255),
		Color(0, 0, 0, 255),
		Color(255, 255, 255, 200),
		Color(255, 255, 255)
	}

	function PANEL:Init()
		self.HeaderSize = PANEL.HeaderSize

		self.header = self:Add("Panel")
		self.header:Dock(TOP)
		self.header:SetTall(PANEL.HeaderSize)
		self.header.Paint = function(_, w, h)
			self:HeaderPaint(w, h)
		end

		self.btn = self.header:Add("DButton")
		self.btn:Dock(FILL)
		self.btn:SetText("")
		self.btn.Paint = function() end
		self.btn.DoClick = function()
			self:OnExpand()
		end

		self.subcontainer = self:Add("Panel")
		self.subcontainer:Dock(FILL)
		self.subcontainer:DockMargin(0, 0, 0, 0)

		self:SetTall(PANEL.HeaderSize)

		self.squad = nil
		self.expanded = false
		self.targetSize = PANEL.HeaderSize
		self.lastTargetSize = self.targetSize
		self.ents = {}
	end

	function PANEL:OnExpand()
		self:SizeTo(-1, self.expanded and PANEL.HeaderSize or self.targetSize, 0.025, 0, -1, function()
			self.expanded = !self.expanded
		end)
	end

	function PANEL:RemoveEntity(entity)
		if IsValid(self.ents[entity]) then
			self.ents[entity]:Remove()
			self.ents[entity] = nil
		end
		
		self.subcontainer:InvalidateLayout(true)
		self.subcontainer:SizeToChildren(false, true)

		self.targetSize = PANEL.HeaderSize + self.subcontainer:GetTall()

		self:SetTall(self.targetSize)

		self.lastTargetSize = self.targetSize

		if self.expanded then
			self:SetTall(self.targetSize)
		end

		self:SetVisible(!table.IsEmpty(self.ents))
		self:SortEntities()
	end

	function PANEL:SortEntities()
		local x = 1
		local sorted = {}

		for k, v in pairs(self.ents) do
			table.insert(sorted, {panel = v, label = v.text:GetText()})
		end

		for k, v in SortedPairsByMemberValue(sorted, "label") do
			if v.panel then
				v.panel:SetZPos(-x)

				x = x + 1
			end
		end
	end

	function PANEL:ClearEntities()
		for k, v in pairs(self.ents) do
			v:Remove()
		end

		self.subcontainer:InvalidateLayout(true)
		self.subcontainer:SizeToChildren(false, true)

		self.targetSize = PANEL.HeaderSize + self.subcontainer:GetTall()

		if self.expanded then
			self:SetTall(self.targetSize)
		end

		self.lastTargetSize = self.targetSize

		self.ents = {}

		self:SetVisible(!table.IsEmpty(self.ents))
	end
	
	function PANEL:AddEntity(entity)
		if !IsValid(entity) then
			return
		end
		
		local a = self.subcontainer:Add("dispatch.camera.button")
		a:Dock(TOP)
		a:DockMargin(0, 2, 16, 0)
		a:SetEntity(entity)

		self.subcontainer:InvalidateLayout(true)
		self.subcontainer:SizeToChildren(false, true)

		self.targetSize = PANEL.HeaderSize + self.subcontainer:GetTall()

		if self.expanded then
			self:SetTall(self.targetSize)
		end

		self.lastTargetSize = self.targetSize

		self.ents[entity] = a

		self:SetVisible(!table.IsEmpty(self.ents))
	end

	function PANEL:SetupCategory(type)
		self.type = type
	end

	function PANEL:HeaderPaint(w, h)
		surface.SetDrawColor(self.clr[1])
		surface.DrawRect(0, h - 1, w, 1)

		draw.SimpleText(self.type, "ixSquadTitle", 8, h / 2, self.clr[1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	vgui.Register("dispatch.camera.category", PANEL, "EditablePanel")
end

do
	local PANEL = {}
	local background = Material("cellar/ui/dispatch/bg.png", "smooth")
	local border_size = scale(64)
	local x2, y2 = 0, 0

	function PANEL:Init()
		if IsValid(ix.gui.dispatch) then
			ix.gui.dispatch:Remove()
		end

		ix.gui.dispatch = self

		local scrW, scrH = ScrW(), ScrH()

		self:SetSize(scrW, scrH)

		local stability_w, stability_h = scale(385), scale(52)
		local stability = self:Add("dispatch.stablity")
		stability:SetSize(stability_w, stability_h)
		stability:SetPos(scrW - stability_w - border_size, border_size / 2 - stability_h / 2)
		stability.DoClick = function()
			self:SwitchStability()
		end
		--stability.Paint = function(_, w, h)
		--	surface.SetDrawColor(color_white)
		--	surface.DrawRect(0, 0, w, h)
		--end

		do
			self.manpower = self:Add("dispatch.window")
			self.manpower:SetWide(stability_w)
			self.manpower:SetPos(scrW - stability_w - border_size, border_size)
			self.manpower:SetWindowName("СОСТАВ")
			self.manpower.stats = {}

			for i = 1, 5 do
				local stat = self.manpower:Insert("dispatch.window.stat")
				stat:Dock(TOP)
				stat:SetLabel("")
				stat:SetValue("")

				self.manpower.stats[i] = stat

				self.manpower:UpdateContainer()
			end
		end

		self.manpower.stats[1]:SetLabel("ПАТРУЛЬНЫЕ ГРУППЫ")
		self.manpower.stats[1]:SetValue(string.format("%i/15", table.Count(dispatch.squads) - 1))

		self.manpower.stats[2]:SetLabel("ПОТОКОВ ИИ")
		self.manpower.stats[2]:SetValue(0)

		self.manpower.stats[3]:SetLabel("НАДЗИРАТЕЛЕЙ")
		self.manpower.stats[3]:SetLabelColor(Color(251, 213, 0))
		self.manpower.stats[3]:SetValue(0)

		self.manpower.stats[4]:SetLabel("СИЛ ГО")
		self.manpower.stats[4]:SetLabelColor(Color(0, 226, 255))
		self.manpower.stats[4]:SetValue(0)

		self.manpower.stats[5]:SetLabel("СИЛ СТАБИЛИЗАЦИИ")
		self.manpower.stats[5]:SetLabelColor(Color(255, 29, 93))
		self.manpower.stats[5]:SetValue(0)

		timer.Create("dispatch.stats", 1, 0, function()
			local self = ix.gui.dispatch

			if !IsValid(self) then
				timer.Remove("dispatch.stats")
				return
			end

			stability:UpdateStability()

			local dispatch, overseer, mpf, ota = 0, 0, 0, 0

			for k, v in ipairs(player.GetAll()) do
				local char = v:GetCharacter()
				if !char then continue end
				
				if char:GetFaction() == FACTION_DISPATCH then
					dispatch = dispatch + 1
				elseif char:GetFaction() == FACTION_MPF2 then
					overseer = overseer + 1
				elseif char:GetFaction() == FACTION_MPF then
					mpf = mpf + 1
				elseif char:IsOTA() then
					ota = ota + 1
				end
			end

			self.manpower.stats[2]:SetValue(dispatch)
			self.manpower.stats[3]:SetValue(overseer)
			self.manpower.stats[4]:SetValue(mpf)
			self.manpower.stats[5]:SetValue(ota)
		end)

		do
			local frame = self:Add("dispatch.window")
			frame:SetWide(scrH * 0.65)
			frame:SetPos(border_size, border_size)
			frame:SetWindowName("ПГ И НАБЛЮДЕНИЕ")

			local test = frame:Insert("Panel")
			test:Dock(TOP)
			test:SetTall(32)
			test.buttons = {}

			local w, h = frame.container:GetWide()

			local tab1 = test:Add("dispatch.window.tab")
			tab1:Dock(LEFT)
			tab1:SetText("ГРУППЫ")
			tab1:SetWide(w / 3)
			tab1.DoSwitch = function()
				self.patrols:SetVisible(true)
				self.cameras:SetVisible(false)
			end

			local tab2 = test:Add("dispatch.window.tab")
			tab2:Dock(LEFT)
			tab2:SetWide(w / 3)
			tab2:SetText("КАМЕРЫ")
			tab2.DoSwitch = function()
				self:BuildCameras(true)

				self.patrols:SetVisible(false)
				self.cameras:SetVisible(true)
			end

			local tab3 = test:Add("dispatch.window.tabfunc")
			tab3:Dock(LEFT)
			tab3:SetWide(w / 3)
			tab3:SetText("ВЫЗВАТЬ СКАНЕР")
			tab3.DoClick = function()
				self:DeployScanner()
			end

			test.buttons[1] = tab1
			test.buttons[2] = tab2

			local container = frame:Insert("EditablePanel")
			container:Dock(TOP)
			container:SetTall((scrH - border_size * 2) / 2)
			container:InvalidateParent(true)

			local x2, y2, w2, h2 = container:GetBounds()

			self.patrols = container:Add("DScrollPanel")
			self.patrols:SetSize(w, h2)
			self.cameras = container:Add("DScrollPanel")
			self.cameras:SetSize(w, h2)

			self.cameras:SetVisible(false)
			self.patrols:SetVisible(false)

			frame:UpdateContainer()
		end

		gui.EnableScreenClicker(true)
		self:SetMouseInputEnabled(true)
		self:SetKeyboardInputEnabled(true)
		self:RequestFocus()

		self:BuildCameras()
		self:BuildSquads()

		hook.Add("VGUIMousePressed", "dispatch.ui", function(pnl, code)
			if IsValid(ix.gui.dispatch) and pnl == ix.gui.dispatch then
				if code == MOUSE_RIGHT then
					timer.Simple(0, function() pnl:OpenWorldInteraction() end)
				end
			end
		end)

		local Picture = {
			w = 580,
			h = 420,
			w2 = 580 * 0.5,
			h2 = 420 * 0.5,
			delay = 15
		}

		self.startPicture = false
		self.prepareScreen = false
		local time = 0
		hook.Add("HUDPaint", "dispatch.ui", function()
			if !IsValid(ix.gui.dispatch) then
				hook.Remove("HUDPaint", "dispatch.ui")
				return
			end
			
			if !self.prepareScreen then
				return
			end
			
			local scrW, scrH = x2, y2
			local x, y = scrW - Picture.w2, scrH - Picture.h2

			local client = LocalPlayer()

			if (time or 0) >= CurTime() then
				local percent = math.Round(math.TimeFraction(time - 5, time, CurTime()), 2) * 100
				local glow = math.sin(RealTime() * 15) * 25

				draw.SimpleText(string.format("RE-CHARGING: %d%%", percent), "ixScannerFont", x, y - 24, Color(255 + glow, 100 + glow, 25, 250))
			end

			draw.SimpleText(string.format("(%s)", client:Name()), "ixScannerFont", x + 8, y + 8, color_white)

			surface.SetDrawColor(235, 235, 235, 230)
			surface.DrawLine(x, y, x + 128, y)
			surface.DrawLine(x, y, x, y + 128)

			x = scrW + Picture.w2

			surface.DrawLine(x, y, x - 128, y)
			surface.DrawLine(x, y, x, y + 128)

			x = scrW - Picture.w2
			y = scrH + Picture.h2

			surface.DrawLine(x, y, x + 128, y)
			surface.DrawLine(x, y, x, y - 128)

			x = scrW + Picture.w2

			surface.DrawLine(x, y, x - 128, y)
			surface.DrawLine(x, y, x, y - 128)

			surface.DrawLine(scrW - 48, scrH, scrW - 8, scrH)
			surface.DrawLine(scrW + 48, scrH, scrW + 8, scrH)
			surface.DrawLine(scrW, scrH - 48, scrW, scrH - 8)
			surface.DrawLine(scrW, scrH + 48, scrW, scrH + 8)
		end)

		hook.Add("PostRender", "dispatch.ui", function()
			if !IsValid(ix.gui.dispatch) then
				hook.Remove("PostRender", "dispatch.ui")
				return
			end

			if self.startPicture then
				self.startPicture = false

				local x = math.Clamp(x2 - Picture.w2, 0, ScrW())
				local y = math.Clamp(y2 - Picture.h2, 0, ScrH())
				
				local data = util.Compress(render.Capture({
					format = "jpeg",
					h = Picture.h,
					w = Picture.w,
					quality = 50,
					x = x,
					y = y
				}))

				net.Start("dispatch.scannerphoto")
					net.WriteUInt(#data, 16)
					net.WriteData(data, #data)
				net.SendToServer()

				time = CurTime() + 5

				vgui.GetWorldPanel():SetVisible(true)
				timer.Simple(0, function() input.SetCursorPos(x2, y2) end)
			end
		end)

		hook.Add("OnScannerControls", self, function(_, panel)
			panel:Remove()

			local eject = vgui.Create("cwTrButton", self)
			eject:SetWide(130)
			eject:SetText("EXIT")
			eject.DoClick = function()
				ix.command.Send("ScannerEject")
			end
			eject:SetPos(ScrW() - 130, ScrH() - eject:GetTall())

			self.ScannerEject = eject
		end)

		hook.Add("OnScannerControlsRemove", self, function(_)
			self.ScannerEject:Remove()
		end)

		hook.Add("OnScannerPhotoReceived", self, function(_, panel)
			panel:MoveToBack()
		end)
	end

	function PANEL:BuildSquads()
		self.squads = {}

		for tag = 1, #dispatch.available_tags do
			local a = self.patrols:Add("squadCategoryBtn")
			a:DockMargin(0, 1, 16, 0)
			a:Dock(TOP)
			
			a.join:SetVisible(false)

			if !dispatch.squads[tag] then
				a:SetupSquad(tag)
			else
				a:SetupSquadFull(dispatch.squads[tag])
			end

			self.squads[tag] = a
		end

		timer.Create("dispatch.window", 1.5, 0, function()
			if !IsValid(ix.gui.dispatch) then
				timer.Remove("dispatch.window")
				return
			end

			for k, v in pairs(dispatch.GetSquads()) do
				local category = self.squads[v.tag]
				if !IsValid(category) then continue end
				
				for character, _ in pairs(v.members) do
					local panel = category.members[character]
					if !IsValid(panel) then continue end

					panel:UpdateHealth()
				end
			end
		end)
	end

	function PANEL:BuildCameras(update)
		if update then
			for k, v in pairs(self.camera_types or {}) do
				v:ClearEntities()
			end
		end
		
		self.camera_types = self.camera_types or {}
		local sorted, categories = {}, {}

		for k, v in pairs(dispatch.FindCameras()) do
			if !IsValid(v) then continue end

			local data = v:GetCameraData()
			local type = data:Type()

			if !categories[type] then
				local x = table.insert(sorted, {label = data:Type(), ents = {}})
				categories[type] = x
			end
			
			table.insert(sorted[categories[type]].ents, {entity = v, name = (v:GetNetVar("cam") or data:Name(v) or "UNKNOWN")})
		end

		for k, v in SortedPairsByMemberValue(sorted, "label", true) do
			if !IsValid(self.camera_types[v.label]) then
				local a = self.cameras:Add("dispatch.camera.category")
				a:DockMargin(0, 1, 16, 0)
				a:Dock(TOP)
				a:SetupCategory(v.label)

				self.camera_types[v.label] = a
			end

			for _, data in SortedPairsByMemberValue(v.ents, "name", true) do
				self.camera_types[v.label]:AddEntity(data.entity)
			end

			self.camera_types[v.label]:SortEntities()
		end
	end
	
	function PANEL:OnSpectate() end
	function PANEL:OnStopSpectate() end

	function PANEL:OnSquadSync(id, squad, full)
		if !IsValid(self.squads[id]) then
			return
		end
		
		self.squads[id]:SetupSquadFull(squad)
		self.squads[id]:SetVisible(squad.member_counter > 0)
		self.squads[id]:UpdateSquadInfo()

		self.manpower.stats[1]:SetValue(string.format("%i/15", table.Count(dispatch.squads) - 1))
	end
	function PANEL:OnSquadDestroy(id, squad)
		if !IsValid(self.squads[id]) then
			return
		end

		for char, _ in pairs(self.squads[id].members) do
			self.squads[id]:RemoveMember(char)
		end

		self.squads[id]:UpdateSquadInfo()
		self.squads[id]:SetVisible(false)
	end
	function PANEL:OnSquadMemberJoin(id, squad, character)
		if !IsValid(self.squads[id]) then
			return
		end

		self.squads[id]:AddMember(character)

		if squad.member_counter > 0 then
			self.squads[id]:SetVisible(true)
		end

		self.squads[id]:UpdateSquadInfo()
	end
	function PANEL:OnSquadMemberLeft(id, squad, character)
		if !IsValid(self.squads[id]) then
			return
		end

		self.squads[id]:RemoveMember(character)

		if squad.member_counter <= 0 then
			self.squads[id]:SetVisible(false)
		end

		self.squads[id]:UpdateSquadInfo()
	end
	function PANEL:OnSquadChangedLeader(id, squad, character)
		if !IsValid(self.squads[id]) then
			return
		end
		
		self.squads[id]:SetLeader(character)
	end

	function PANEL:DeployScanner() 
		net.Start("dispatch.scanner")
		net.SendToServer()
	end
	function PANEL:SwitchStability() 
		local menu = DermaMenu()

		for k, v in ipairs(dispatch.stability_codes) do
			menu:AddOption(v.name, function()
				Derma_Query(string.format("Вы точно уверены и хотите сменить текущий статус-код на %s?", v.name), "Смена статус-кода", "Применить", function()
					ix.command.Send("StabilityCode", k)
				end, "Отмена")
			end)
		end

		menu:Open()
	end
	function PANEL:RequestCamera(entity)
		net.Start("dispatch.spectate.request")
			net.WriteEntity(entity)
		net.SendToServer()
	end
	function PANEL:OpenWorldInteraction()
		dispatch.OpenWorldAction()
	end

	function PANEL:Paint(w, h)
		if !dispatch.IsSpectating(LocalPlayer()) then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(background)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end

	local click = false
	function PANEL:Think() 
		if LocalPlayer():IsPilotScanner() then
			return
		end
		
		x2, y2 = input.GetCursorPos()

		if input.IsKeyDown(KEY_LSHIFT) then
			self.prepareScreen = true

			if input.IsMouseDown(MOUSE_LEFT) and !click then
				click = true
				vgui.GetWorldPanel():SetVisible(false)
				
				self.startPicture = true
			elseif !input.IsMouseDown(MOUSE_LEFT) and click then
				click = false
			end
		else
			self.prepareScreen = false
		end
	end

	vgui.Register("dispatch.main", PANEL, "EditablePanel")
end

