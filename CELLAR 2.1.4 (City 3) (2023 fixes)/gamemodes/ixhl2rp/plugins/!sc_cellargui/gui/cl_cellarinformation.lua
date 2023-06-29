PANEL = {}
local background = Material('cellar/main/tab/otherbackground.png')
local television = Material('cellar/main/tvtexture.png')
local staticborder = Material('cellar/main/tab/otherborders.png')
local infoicon = Material("cellar/main/info.png")

local function CalculateWidestName(tbl)
	local highest = 0
	do
		local highs = {}
		for k, v in pairs(tbl) do
			surface.SetFont("cellar.derma.light")
			local w1 = surface.GetTextSize(L(v.name))
			highs[#highs+1] = w1

			highest = math.max(unpack(highs))
		end
	end

	return highest
end

function PANEL:Init()
	if IsValid(cellar_tab_information) then
		cellar_tab_information:Remove()
	end

	cellar_tab_information = self

	local parent = self:GetParent()
    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self.closing = false
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

    self.model = self:Add("cellar.tab.modelpanel")
    self.model:SetCharacter(LocalPlayer():GetCharacter())
    self.model:SetPos(ScrW() - ScrW(), ScrH() - ScrH() * .90)
    self.model.Paint = function(me, w, h)
		/*local card = character:GetIDCard()
		local frameline = Material('cellar/main/tab/characterline.png')
        surface.SetDrawColor(color_white)
		surface.SetMaterial(frameline)
		surface.DrawTexturedRectRotated(w - 32 + 26, h/2, 32, h, 180)

        local cid
		if not card then
			cid = '#NO DATA'
        elseif (card:GetData("cid", 0)) then
            cid = '#'..card:GetData("cid", 0)
        elseif character:GetFaction() == FACTION_MPF then
            local cpuid = string.match(character:GetName(), "%d%d%d%d")
            cid = '#'..cpuid
		elseif not character:GetFaction() == FACTION_MPF and character:IsCombine() then
			cid = '#'..character:GetCPInfo()
        else
            cid = '#NO DATA'
        end

		local otacid
		if character:GetFaction() == FACTION_OTA then
			local id = string.match(character:GetName(), "-%d%d")
			local idfinal = string.match(id, "%d%d")
            otacid = '#'..idfinal
        end

		if character:GetFaction() == FACTION_OTA then
			draw.SimpleText(otacid, "cellar.derma.light.blur", me:GetWide() - 16, me:GetTall()/2 - 5, cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(otacid, "cellar.derma.light", me:GetWide() - 16, me:GetTall()/2 - 5, cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(cid, "cellar.derma.light.blur", me:GetWide() - 16, me:GetTall()/2 - 5, cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(cid, "cellar.derma.light", me:GetWide() - 16, me:GetTall()/2 - 5, cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		--ix.infoMenu.Add("Уровень: " .. character:GetLevel())*/
    end

    self.canvas = self:Add("Panel")
    self.canvas:SetPos(ScrW() - ScrW() * .916, ScrH() - ScrH() * .90)
    self.canvas:SetSize(1000, 0)
    self.canvas:SizeTo(ScrW() * .80, ScrH() * .7778, .5, .1, .1)
    self.canvas.Paint = function(me, w, h)
    end
    self.canvas.OnMouseReleased = function(this, key)
        if (key == MOUSE_RIGHT) then
            properties.OpenEntityMenu(LocalPlayer())
        end
    end

    local format = "%A, %B %d, %Y. %H:%M"

	local time = self:Add("DLabel")
	time:SetFont("cellar.derma.light")
    time:SetWide(16)
	time:SetTall(22)
    time:SetPos(ScrW() *.3396, ScrH() *.4722)
	time:SetText('  ')
	time:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(contents)
		title:SizeToContents()
		title:SetMaxWidth(ScrW() * .2969)
	end)
    /*time.Paint = function(me, w, h)
        local contents = ix.date.GetFormatted(format):utf8upper()
        
        draw.SimpleText(contents, "cellar.derma.light.blur", self.model:GetWide() * .5, 0, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(contents, "cellar.derma.light", self.model:GetWide() * .5, 0, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end*/
	time.Think = function(this)
		if ((this.nextTime or 0) < CurTime()) then
			contents = (ix.date.GetFormatted(format):utf8upper())
			this.nextTime = CurTime() + 0.5
		end
	end

    self.name = self:Add('cellar.information.name')
    self.name:SetPos(ScrW() * .48, self.model:GetTall()/4 - self.name:GetTall()/2)

    self.gender = self:Add('cellar.information.gender')
    self.gender:SetPos(ScrW() * .48, self.model:GetTall()/2.75 - self.gender:GetTall()/2)

    self.money = self:Add('cellar.information.money')
    self.money:SetPos(ScrW() * .48, self.model:GetTall()/2.1 - self.money:GetTall()/2)

    self.desc = self:Add('cellar.information.desc')
    self.desc:SetPos(ScrW() * .48, self.model:GetTall()/1.6 - self.desc:GetTall()/2)

    self.level = self:Add('cellar.information.level')
    self.level:SetPos(ScrW() * .48, self.model:GetTall()/1.3 - self.level:GetTall()/2)
    
    self.faction = self:Add('cellar.information.faction')
    self.faction:SetPos(ScrW() * .48, self.model:GetTall()/1 - self.faction:GetTall()/2)

    self.class = self:Add('cellar.information.class')
    self.class:SetPos(ScrW() * .48, self.model:GetTall()/1.13 - self.class:GetTall()/2)

	if LocalPlayer():GetCharacter():GetFaction() == FACTION_ZOMBIE or LocalPlayer():GetCharacter():GetFaction() == FACTION_SYNTH then
		local calsses = self:Add("DButton")
		calsses:SetPos(ScrW() * .48435, ScrH() - ScrH() * .33)
		calsses:SetText("")
		calsses:SetSize(32, 32)
		calsses.OnCursorEntered = function(me)
			if me:IsHovered() then
				LocalPlayer():EmitSound("Helix.Rollover")
			end
		end
		calsses.DoClick = function(me)
			LocalPlayer():EmitSound('Helix.Press')
			vgui.Create('cellar.tab.classes')
			self:Remove()
		end
		calsses.Paint = function(self, w, h)
			local bHovered = self:IsHovered() and Color(255, 30, 30, 35)
			draw.RoundedBox(255, 0, 0, w, h, bHovered or Color(56, 207, 248, 35))
			surface.SetDrawColor(ColorAlpha(color_black, 255))
			draw.SimpleText('C', 'cellar.derma.light', w/2, h/2, self:IsHovered() and cellar_red or cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end



	self.stats = self:Add("ixStatsPanel")
		self.stats:SetPos(ScrW() * .6980, ScrH() * .2639)
        self.stats:SetSize(ScrW() * .2350, ScrH() * .4444)
        self.stats.Paint = function(me, w, h)
        end

		self.attributes = self.stats:Add("ixStatsPanelCategory")
		self.attributes:SetText(L("attributes"):upper())
		self.attributes:Dock(BOTTOM)

		self.skills = self.stats:Add("ixStatsPanelCategory")
		self.skills:SetText(L("skills"):upper())
		self.skills:Dock(TOP)
		--self.skills:DockMargin(0, 0, 10, 0)

		local boost = character:GetSpecialBoosts()
		local skillboost = character:GetSkillBoosts()
		local w1 = CalculateWidestName(ix.specials.list)
		local w2 = CalculateWidestName(ix.skills.list)

		local bFirst = true

		self.attributes.offset = w1 * 1.2
		self.attributes:SetWide(w1 * 2)
		
		for k, v in SortedPairsByMemberValue(ix.specials.list, "weight") do
			local attributeBoost = 0

			if (boost[k]) then
				for _, bValue in pairs(boost[k]) do
					attributeBoost = attributeBoost + bValue
				end
			end

			local bar = self.attributes:Add("ixStatBar")
			bar:Dock(TOP)

			if (!bFirst) then
				bar:DockMargin(4, 1, 4, 0)
			else
				bar:DockMargin(4, 0, 4, 0)
				bFirst = false
			end

			local value = character:GetSpecial(k, 0)

			if (attributeBoost) then
				bar:SetValue(value - attributeBoost or 0)
			else
				bar:SetValue(value)
			end

			local maximum = v.maxValue or 10
			bar:SetMax(maximum)
			bar:SetReadOnly()
			bar:SetText(L(v.name), value, maximum)
			bar:SetDesc(L(v.description))

			if (attributeBoost) then
				bar:SetBoost(attributeBoost)
			end
		end

		self.limbs = self.attributes:Add("EditablePanel")
		self.limbs:Dock(TOP)
		self.limbs:DockMargin(0, 0, 0, 8)
		self.limbs:SetTall(260)

		self.limbsS = self.limbs:Add("ixLimbStatus")
		self.limbsS:SetPos(self.stats:GetWide() * 0.5 - self.limbsS:GetWide() * 0.5, 8)

		self.attributes:SizeToContents()

		self.skills.offset = w2 * 1.25
		self.skills:SetWide(w2 * 2)

		local bFirst = true

		for i = 1, 6 do
			self.skills.categories = self.skills.categories or {}
			self.skills.categories[i] = self.skills:Add("ixStatsPanel")
			self.skills.categories[i].offset = self.skills.offset
			self.skills.categories[i]:Dock(TOP)
			self.skills.categories[i]:DockMargin(0, 0, 0, 8)
		end

		local categories = {}
		for k, v in pairs(ix.skills.list) do
			categories[v.category] = categories[v.category] or {}
			categories[v.category][k] = L(v.name)
		end

		for k, v in pairs(categories) do
			for z, x in SortedPairs(v) do
				v = ix.skills.list[z]
				local sboost = 0

				if (skillboost[z]) then
					for _, bValue in pairs(skillboost[z]) do
						sboost = sboost + bValue
					end
				end

				local bar = self.skills.categories[k]:Add("ixStatBar")
				bar:Dock(TOP)


				if (!bFirst) then
					bar:DockMargin(4, 1, 4, 0)
				else
					bar:DockMargin(4, 0, 4, 0)
					bFirst = false
				end

				local value = character:GetSkillModified(z)

				if (sboost) then
					bar:SetValue(value - sboost or 0)
				else
					bar:SetValue(value)
				end

				local maximum = v:GetMaximum(character, character:GetSkills())
				bar.skill = z
				bar.xp = true
				bar:SetMax(maximum)
				bar:SetReadOnly()
				bar:SetText(L(v.name), Format("%i / %i", value, maximum))
				bar:SetDesc(L(v.description))

				if (sboost) then
					bar:SetBoost(sboost)
				end
			end
		end

		local y = 0
		for i = 1, 6 do
			self.skills.categories[i]:SizeToContents()

			local _, top, _, bottom = self.skills.categories[i]:GetDockMargin()
			y = y + self.skills.categories[i]:GetTall() + top + bottom
		end

		if (self.attributes:GetTall() < (y + 4)) then
			self.attributes:SetTall(0)
		end

		self.skills:SetTall(self.skills:GetTall() + y + 4)

		self.stats:SizeToContents()

    local menu = self:Add("cellar.btnlist")
	menu:SetPos(ScrW() - ScrW()/2 - 301, ScrH() - ScrH() * .0888)
	menu:SetText('МЕНЮ')
	menu:SetSize(300, 0)
	menu:SizeTo(300, 40, .3, (0.1))
	menu.Think = function(me)
		if self.closing then
			me:SizeTo(300, 0, .2, 0)
		end
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

function PANEL:UpdateModel()
	if (IsValid(self.model)) then
		self.model:SetModel(self:GetCharacter().model or self:GetCharacter():GetPlayer():GetModel(), self:GetCharacter().vars.skin or self:GetCharacter():GetData("skin", 0))

		for i = 0, (self:GetCharacter():GetPlayer():GetNumBodyGroups() - 1) do
			self.model.Entity:SetBodygroup(i, self:GetCharacter():GetPlayer():GetBodygroup(i))
		end

		self.model.Entity.ProxyOwner = LocalPlayer()
	end
end

function PANEL:Paint(w, h)
	local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
    local helpframe = Material('cellar/main/tab/helpframe1604x754.png')
	local skillsline = Material('cellar/main/tab/skillsline452x16.png')

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

    surface.SetDrawColor(cellar_blue)
    surface.DrawCircle(self.model:GetWide() * 1, self.model:GetTall()/1.6, 10)
    draw.RoundedBox(0, ScrW() * .48, ScrH() * .4435, 1, ScrH() * .0759, cellar_blue)
    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .48 - 1, self.model:GetTall()/1.6)

    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .47, self.model:GetTall()/4)
    surface.DrawLine(ScrW() * .47, self.model:GetTall()/4, ScrW() * .48 - 1, self.model:GetTall()/4)

    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .47, self.model:GetTall()/2.75)
    surface.DrawLine(ScrW() * .47, self.model:GetTall()/2.75, ScrW() * .48 - 1, self.model:GetTall()/2.75)

    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .47, self.model:GetTall()/2.1)
    surface.DrawLine(ScrW() * .47, self.model:GetTall()/2.1, ScrW() * .48 - 1, self.model:GetTall()/2.1)

    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .47, self.model:GetTall()/1.3)
    surface.DrawLine(ScrW() * .47, self.model:GetTall()/1.3, ScrW() * .48 - 1, self.model:GetTall()/1.3)

    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .47, self.model:GetTall()/1.13)
    surface.DrawLine(ScrW() * .47, self.model:GetTall()/1.13, ScrW() * .48 - 1, self.model:GetTall()/1.13)

    surface.DrawLine(self.model:GetWide() * 1, self.model:GetTall()/1.6, ScrW() * .47, self.model:GetTall()/1)
    surface.DrawLine(ScrW() * .47, self.model:GetTall()/1, ScrW() * .48 - 1, self.model:GetTall()/1)

	/*surface.DrawLine(ScrW() * .7083 - 1, ScrH() * .1935, ScrW() * .74, ScrH() * .1361)
	surface.DrawLine(ScrW() * .74, ScrH() * .1361, ScrW() * .77, ScrH() * .1361)
	surface.DrawLine(ScrW() * .77, ScrH() * .1361, self.stats:GetX() + self.stats:GetWide()/2, ScrH() * .2407)*/

	surface.SetDrawColor(color_white)
	surface.SetMaterial(skillsline)
	surface.DrawTexturedRectRotated(self.stats:GetX() - 16, self.model:GetTall()/1.6, ScrH() * .50, 16, 90)
   

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
        LocalPlayer():ConCommand('stopsound')
		self:Remove()
	end

	if (esc or console) and (gui.IsGameUIVisible()) then
        LocalPlayer():ConCommand('stopsound')
		self:Remove()
	end
end

function PANEL:Remove()
	self.closing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)

	CloseDermaMenus()
	gui.EnableScreenClicker(false)
    local isAnimating = true
    self:MoveTo(ScrW() + ScrW(), ScrH() - ScrH(), 2, .1, .1, function()
        isAnimating = false
        timer.Simple(.1, function() self:SetVisible(false) end)
    end)
	self:SetSize(ScrW(), ScrH())
	self:AlphaTo(35, .15, 0)
    LocalPlayer():EmitSound('Helix.Whoosh')
	LocalPlayer():StopSound('cellar.tab.amb2')

end

vgui.Register("cellar.tab.information", PANEL, "EditablePanel")

if IsValid(cellar_tab_information) then
	cellar_tab_information:Remove()
	cellar_tab_information = nil
end


PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()

    cellar_information_name = self

	self:SetFont("cellar.derma")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
    self:SetText('')
    self:SetSize(ScrW() * .2083, ScrH() * .0370)
	--self:SetPadding(8)

    
end

function PANEL:Paint(w, h)

    surface.SetDrawColor(cellar_blue)
    /*surface.DrawLine(w - w * .0500, h * .7000, w - w * .0360, h/2 + 3)
    surface.DrawLine(w - w * .0150, h * .6650, w, h/2)
    draw.RoundedBox(0, w - w * .0360, h/2 + 4, w * .0300, 1, cellar_darker_blue)
    draw.RoundedBox(0, w - w * .0360 - 1, h/2 + 5, w * .0300, 1, cellar_darker_blue)
    draw.RoundedBox(0, w - w * .0360 - 2, h/2 + 6, w * .0300, 1, cellar_darker_blue)*/

    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local label = Material('cellar/main/tab/charinfoline.png')
    local name = LocalPlayer():GetName():utf8upper()

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText(name, 'cellar.derma.light.blur', w/2., h/2.7, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(name, 'cellar.derma.light', w/2., h/2.7, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end

vgui.Register("cellar.information.name", PANEL, "DLabel")


PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()

    cellar_information_name = self

	self:SetFont("cellar.derma")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
    self:SetText('')
    self:SetSize(ScrW() * .2083, ScrH() * .0370)

    
end

function PANEL:Paint(w, h)

    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local label = Material('cellar/main/tab/charinfoline.png')
    local gender = character:GetGender()--:utf8upper()
    if gender == 0 then
        gender = "AGENDER"
    elseif gender == 1 then
        gender = "MALE"
    elseif gender == 2 then
        gender = "FEMALE"
    end

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText(gender, 'cellar.derma.light.blur', w/2, h/2.7, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(gender, 'cellar.derma.light', w/2., h/2.7, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    

end

vgui.Register("cellar.information.gender", PANEL, "DLabel")


PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()

    cellar_information_name = self

	self:SetFont("cellar.derma")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
    self:SetText('')
    self:SetSize(ScrW() * .2083, ScrH() * .0370)

    
end

function PANEL:Paint(w, h)

    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local label = Material('cellar/main/tab/charinfoline.png')
    local money = ix.currency.Get(character:GetMoney()):utf8upper()
    if money == '0 TOKENS' then
        money = 'NO MONEY'
    end

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)

    
    draw.SimpleText(money, "cellar.derma.light.blur", w/2, h/2.7, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(money, "cellar.derma.light", w/2, h/2.7, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    

end

vgui.Register("cellar.information.money", PANEL, "DLabel")


PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()
    local parent = self:GetParent()
    local textW, textH = self:GetTextSize()

    cellar_information_desc = self

    self:SetFont("cellar.derma.light.blur")
    self:SetSize(ScrW() * .2083, ScrH() * .1111)
    self:SetText('')
    self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

    self.textparent = self:Add('DLabel')
	self.textparent:SetFont("cellar.derma.light.blur")
	self.textparent:SetTextColor(cellar_blur_blue)
    self.textparent:SetTextInset(6, 8)
    self.textparent:SetText(LocalPlayer():GetCharacter():GetDescription())
    self.textparent:SetPos(self:GetWide() * .1150, self:GetTall() * .125)
    self.textparent:SetSize(ScrW() * .1745, ScrH() * .0741)
    if self.textparent:GetTextSize() > self:GetSize() then
        self.textparent:SetContentAlignment(8)
        self.textparent:SetWrap(true)
    elseif self.textparent:GetTextSize() <= self:GetSize() then
        self.textparent:SetContentAlignment(5)
        self.textparent:SetWrap(false)
    end

    self.textparent2 = self:Add('DLabel')
	self.textparent2:SetFont("cellar.derma.light")
	self.textparent2:SetTextColor(cellar_blue)
    self.textparent2:SetTextInset(6, 8)
    self.textparent2:SetText(LocalPlayer():GetCharacter():GetDescription())
    self.textparent2:SetPos(self:GetWide() * .1150, self:GetTall() * .125)
    self.textparent2:SetSize(ScrW() * .1745, ScrH() * .0741)
    if self.textparent2:GetTextSize() > self:GetSize() then
        self.textparent2:SetContentAlignment(8)
        self.textparent2:SetWrap(true)
    elseif self.textparent2:GetTextSize() <= self:GetSize() then
        self.textparent2:SetContentAlignment(5)
        self.textparent2:SetWrap(false)
    end
    
end

function PANEL:OnMousePressed(code)
    if (code == MOUSE_LEFT) then
        ix.command.Send("CharDesc")

        if (IsValid(cellar_tab_information)) then
            cellar_tab_information:Remove()
        end
    end
end

function PANEL:Paint(w, h)
    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local label = Material('cellar/main/tab/chardescline.png')

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("cellar.information.desc", PANEL, "DLabel")

PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()

    cellar_information_name = self

	self:SetFont("cellar.derma")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
    self:SetText('')
    self:SetSize(ScrW() * .2083, ScrH() * .0370)

    
end

function PANEL:Paint(w, h)

    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local label = Material('cellar/main/tab/charinfolinemir.png')
    local lvl = character:GetLevel()
    local level = 'LEVEL: '..lvl

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText(level, 'cellar.derma.light.blur', w/2, h/1.525, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(level, 'cellar.derma.light', w/2., h/1.525, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    

end

vgui.Register("cellar.information.level", PANEL, "DLabel")

PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()

    cellar_information_name = self

	self:SetFont("cellar.derma")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
    self:SetText('')
    self:SetSize(ScrW() * .2083, ScrH() * .0370)
    
end

function PANEL:Paint(w, h)

    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local label = Material('cellar/main/tab/charinfolinemir.png')
    local faction = ix.faction.indices[character:GetFaction()]
    local contents = L(faction.name):utf8upper()

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText(contents, 'cellar.derma.light.blur', w/2, h/1.525, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(contents, 'cellar.derma.light', w/2., h/1.525, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    

end

vgui.Register("cellar.information.faction", PANEL, "DLabel")

PANEL = {}
DEFINE_BASECLASS('DLabel')
function PANEL:Init()

    cellar_information_name = self

	self:SetFont("cellar.derma")
	self:SetContentAlignment(5)
	self:SetTextColor(color_white)
    self:SetText('')
    self:SetSize(ScrW() * .2083, ScrH() * .0370)

    
end

function PANEL:Paint(w, h)

    local character = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
    local faction = ix.faction.indices[character:GetFaction()]
	local class = ix.class.list[character:GetClass()]
    local label = Material('cellar/main/tab/charinfolinemir.png')
    local contents
    if (class and class.name != faction.name) then
        contents = L(class.name):utf8upper()
    else
        contents = 'NO CLASS'
    end

    surface.SetDrawColor(color_white)
    surface.SetMaterial(label)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText(contents, 'cellar.derma.light.blur', w/2, h/1.525, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(contents, 'cellar.derma.light', w/2., h/1.525, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    

end

vgui.Register("cellar.information.class", PANEL, "DLabel")