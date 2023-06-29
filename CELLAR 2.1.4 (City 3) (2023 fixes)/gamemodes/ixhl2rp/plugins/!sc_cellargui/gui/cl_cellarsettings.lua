PANEL = {}
local background = Material('cellar/main/tab/backgroundtabmirrored.png')
local television = Material('cellar/main/tvtexture.png')
local staticborder = Material('cellar/main/tab/tabbordersmirrored.png')

function PANEL:Init()
	if IsValid(cellar_tab_settings) then
		cellar_tab_settings:Remove()
	end

	cellar_tab_settings = self

	local parent = self:GetParent()
	self.closing = false
	self.removed = false
	self.noAnchor = CurTime() + 0.4
	self.anchorMode = true
	local frameH, frameW, animTime, animDelay, animEase = ScrW(), ScrH(), 1, 0, .1
	local isAnimating = true
	self:MakePopup()
	self:SetSize(0, ScrH())
    self:SetPos(ScrW(), ScrH() - ScrH())
	self:SetAlpha(0)
	self:AlphaTo(255, .5, 0)
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
    self:MoveTo(0, 0, .8, .1, .1)
	LocalPlayer():EmitSound('Helix.Whoosh')
	LocalPlayer():EmitSound('cellar.tab.amb2')


    self.canvas = self:Add("Panel")
    self.canvas:SetPos(ScrW() - ScrW() * .916, ScrH() - ScrH() * .90)
    self.canvas:SetSize(1000, 0)
    self.canvas:SizeTo(ScrW() * .8333, ScrH() * .7778, .5, .1, .1)
    self.canvas.Paint = function(me, w, h)
    end

    local panel = self.canvas:Add("ixSettings")
	panel:SetSearchEnabled(true)

	for category, options in SortedPairs(ix.option.GetAllByCategories(true)) do
		category = L(category):utf8upper()
		local cat = panel:AddCategory(category)
		cat.Paint = function(me, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(43, 157, 189, 43))
			-- left & right --
			draw.RoundedBox(0, 0, 0, 1, h, cellar_blue)
			draw.RoundedBox(0, w - 1, 0, 1, h, cellar_blue)
			draw.RoundedBox(0, 1, 0, 1, h, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - 2, 0, 1, h, Color(43, 157, 189, 43))
			-- bottom --
			draw.RoundedBox(0, 0, h - 1, w, 1, cellar_blue)
			draw.RoundedBox(0, 0, h - 2, w, 1, cellar_blue)
			draw.RoundedBox(0, 0, h - 3, w, 1, Color(43, 157, 189, 43))
			-- top --
			draw.RoundedBox(0, 0, 0, w, 2, cellar_blue)

			-- frame --
			draw.RoundedBox(0, w/4.675, 0, w - w/2.3375, 2, cellar_blue)
			draw.RoundedBox(0, w/4.65, 1, w - w/2.325, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.625, 3, w - w/2.3125, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.6, 5, w - w/2.3, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.575, 7, w - w/2.2875, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.55, 9, w - w/2.275, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.525, 11, w - w/2.2625, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.5, 13, w - w/2.25 - 1, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.465, 15, w - w/2.2325 + 1, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.445, 17, w - w/2.2225, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.420, 19, w - w/2.21, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.395, 21, w - w/2.1975, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.370, 23, w - w/2.185, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.345, 25, w - w/2.1725 + 1, 2, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w/4.320, 27, w - w/2.16 + 1, 2, Color(43, 157, 189, 43))
			surface.SetDrawColor(cellar_blue)
			surface.DrawLine(w/4.675, 0, w/4.320, 29)
			surface.DrawLine(w/4.675 - 1, 0, w/4.320, 28)
			surface.SetDrawColor(cellar_blue)
			surface.DrawLine(w - w/4.675 - 1, 0, w - w/4.32 - 2, 29)
			surface.DrawLine(w - w/4.675 - 2, 0, w - w/4.32 - 2, 28)
			surface.DrawLine(w/4.320, 29, w - w/4.32 - 1, 29)
			surface.DrawLine(w/4.320, 28, w - w/4.32 - 1, 28)


			surface.SetTextColor(cellar_blur_blue)
			surface.SetFont('cellar.derma.blur')
			surface.SetTextPos(w * .5 - surface.GetTextSize(category) * .5, 3)
			surface.DrawText(category)


			surface.SetTextColor(cellar_blue)
			surface.SetFont('cellar.derma')
			surface.SetTextPos(w * .5 - surface.GetTextSize(category) * .5, 3)
			surface.DrawText(category)
			
		end

		-- sort options by language phrase rather than the key
		table.sort(options, function(a, b)
			return L(a.phrase) < L(b.phrase)
		end)

		for _, data in pairs(options) do
			local key = data.key
			local row = panel:AddRow(data.type, category)
			local value = ix.util.SanitizeType(data.type, ix.option.Get(key))

			row:SetText(L(data.phrase))
			row:Populate(key, data)
			row.Paint = function(me, w, h)
				draw.SimpleText(L(data.phrase), 'cellar.derma.medium.blur', 4, h/2, cellar_blur_blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			-- type-specific properties
			if (data.type == ix.type.number) then
				row:SetMin(data.min or 0)
				row:SetMax(data.max or 10)
				row:SetDecimals(data.decimals or 0)
			end

			row:SetValue(value, true)
			row:SetShowReset(value != data.default, key, data.default)
			row.OnValueChanged = function()
				local newValue = row:GetValue()

				row:SetShowReset(newValue != data.default, key, data.default)
				ix.option.Set(key, newValue)
			end

			row.OnResetClicked = function()
				row:SetShowReset(false)
				row:SetValue(data.default, true)

				ix.option.Set(key, data.default)
			end

			row:GetLabel():SetHelixTooltip(function(tooltip)
				local title = tooltip:AddRow("name")
				title:SetImportant()
				title:SetText(key)
				title:SizeToContents()
				title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

				local description = tooltip:AddRow("description")
				description:SetText(L(data.description))
				description:SizeToContents()
			end)
		end
	end

	panel:SizeToContents()
    self.canvas.panel = panel
	self.canvas.panel.searchEntry:RequestFocus()


    local menu = self:Add("cellar.btnlist")
	menu:SetPos(ScrW() - ScrW()/2 - 301, ScrH() - ScrH() * .0888)
	menu:SetText('МЕНЮ')
	menu:SetSize(300, 0)
	menu:SizeTo(300, 40, .3, (0.1))
	menu.Think = function(me)
		if self.closing then
			me:SizeTo(300, 0, .2, 0)
		end
		--if isAnimating then
		--	self:Center()
		--end
	end
	menu.DoClick = function()
        vgui.Create('cellar.tab')
		self:Remove()
	end

	local close = self:Add("cellar.btnlistmirrored")
	close:SetPos(ScrW() - ScrW()/2 + 1, ScrH() - ScrH() * .0888)
	close:SetText('ЗАКРЫТЬ')
	close:SetSize(300, 0)
	close:SizeTo(300, 40, .3, (0.1))
	close.Think = function(me)
		if self.closing then
			me:SizeTo(300, 0, .2, 0)
		end
	end
	close.DoClick = function()
		self:Remove()
	end
	----------------------------------
end

function PANEL:Paint(w, h)
	local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
    local helpframe = Material('cellar/main/tab/helpframe1604x754.png')

	DrawBlurIndependent(self)
	surface.SetDrawColor(ColorAlpha(color_white, 190))
	surface.SetMaterial(background)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_black, 170))
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_white, 90))
	surface.SetMaterial(television)
	surface.DrawTexturedRect(0, 0, w, h)


	surface.SetDrawColor(ColorAlpha(color_white, 240))
	surface.SetMaterial(staticborder)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_black, 255))
	surface.SetMaterial(vignette)
	surface.DrawTexturedRect(0, 0, w, h)

    local scoreboarder = Material('cellar/main/tab/scoreboarder1642x880.png')
    surface.SetDrawColor(color_white)
    surface.SetMaterial(scoreboarder)
    surface.DrawTexturedRect(ScrW() - ScrW() * .9276, ScrH() - ScrH() * .915, ScrW() * .8547, ScrH() * .8148)

	local animslide1 = TimedSin(.32, ScrH() * .8391/1.666, ScrH() * .8391*1.49, 0)
    local animsize1 = TimedCos(.32, 15, 25, 0)

    surface.SetDrawColor(Color(56, 207, 248, 25))
	surface.DrawLine(self.canvas:GetX() - 7, animslide1 + 5, self.canvas:GetWide() * 1.10233 + 7, animslide1 + 5)
	surface.DrawLine(self.canvas:GetX() - 7, animslide1 + 6, self.canvas:GetWide() * 1.10233 + 7, animslide1 + 6)

    surface.SetDrawColor(Color(56, 207, 248, 255))
	surface.DrawRect(self.canvas:GetX() - 8, animslide1, 1, animsize1)
	surface.DrawRect(self.canvas:GetWide() * 1.10233 + 8, animslide1, 1, animsize1)

end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

    if (key == KEY_TAB) then 
		LocalPlayer():StopSound('cellar.info.amb')
		LocalPlayer():EmitSound('Helix.Whoosh')
		self:Remove()
	end
end

function PANEL:Think()
	local bTabDown = input.IsKeyDown(KEY_TAB)
    local esc, console = input.IsKeyDown(KEY_ESCAPE), input.IsKeyDown(KEY_FIRST)

	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.closing = true
		self.anchorMode = false
		self:Remove()
	end

	if (esc or console) and (gui.IsGameUIVisible()) then
		if self.removed == false then
			self:Remove()
		end
	end
end

function PANEL:Remove()
	self.closing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	--CloseDermaMenus()
	--gui.EnableScreenClicker(false)
    local isAnimating = true
    self:MoveTo(ScrW() + ScrW(), ScrH() - ScrH(), 2, .1, .1, function()
        isAnimating = false
		timer.Simple(.1, function() self:SetVisible(false) self.removed = true end)
    end)
	self:SetSize(ScrW(), ScrH())
	self:AlphaTo(35, .15, 0)
	LocalPlayer():StopSound('cellar.tab.amb2')

end

vgui.Register("cellar.tab.settings", PANEL, "EditablePanel")

if IsValid(cellar_tab_settings) then
	cellar_tab_settings:Remove()
	cellar_tab_settings = nil
end