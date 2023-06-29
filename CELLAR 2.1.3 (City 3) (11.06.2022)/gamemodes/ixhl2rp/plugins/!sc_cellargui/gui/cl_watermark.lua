--	WATERMARK: PLEASE, DON'T TOUCH!!! || ВОДЯНОЙ ЗНАК: ПОЖАЛУЙСТА, НЕ ТРОГАЙТЕ!!! --
PANEL = {}

surface.CreateFont("cellar.tab", {
	font = "Nagonia",
	extended = true,
	size = ScrH() * .0370,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.tab.blur", {
	font = "Nagonia",
	extended = true,
	size = ScrH() * .0370,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})
sound.Add( {
	name = "cellar.tab.amb",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 80,
	pitch = {95, 110},
	sound = "cellar/ui/dronelooping.wav"
} )
sound.Add( {
	name = "cellar.tab.amb2",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 80,
	pitch = {95, 110},
	sound = "cellar/ui/otherlooping25.wav"
} )


surface.CreateFont("cellar.watermark", {
	font = "Nagonia",
	extended = true,
	size = ScrH() * .0259,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
sound.Add( {
	name = "cellar.info.amb",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 80,
	pitch = {95, 110},
	sound = "cellar/ui/info.mp3"
} )

surface.CreateFont("cellar.derma", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.derma.blur", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.derma.light", {
	font = "Nagonia",
	extended = true,
	size = 22,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.derma.light.blur", {
	font = "Nagonia",
	extended = true,
	size = 22,
	weight = 200,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.hud.light", {
	font = "Nagonia",
	extended = true,
	size = 14,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.hud.light.blur", {
	font = "Nagonia",
	extended = true,
	size = 14,
	weight = 200,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.hud.micro", {
	font = "Nagonia",
	extended = true,
	size = 10,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.hud.micro.blur", {
	font = "Nagonia",
	extended = true,
	size = 10,
	weight = 200,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.mini", {
	font = "Nagonia",
	extended = true,
	size = 20,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.mini.blur", {
	font = "Nagonia",
	extended = true,
	size = 20,
	weight = 200,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.derma.medium", {
	font = "Nagonia",
	extended = true,
	size = 36,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.derma.medium.blur", {
	font = "Nagonia",
	extended = true,
	size = 36,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.derma.large", {
	font = "Nagonia",
	extended = true,
	size = 36,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.derma.large.blur", {
	font = "Nagonia",
	extended = true,
	size = 36,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.help.logo", {
	font = "Nagonia",
	extended = true,
	size = 56,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
    bold = true,
})
surface.CreateFont("cellar.help.logo.blur", {
	font = "Nagonia",
	extended = true,
	size = 56,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
    bold = true,
})

surface.CreateFont("cellar.logo.2", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.logo.2.blur", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

surface.CreateFont("cellar.buttonsize", {
	font = "Nagonia",
	extended = true,
	size = 12,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.buttonsize.blur", {
	font = "Nagonia",
	extended = true,
	size = 12,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})

-- Blur function independent of settings
function DrawBlurIndependent(panel, amount, passes, alpha)
	local blur = ix.util.GetMaterial("pp/blurscreen")
	local surface = surface

	amount = amount or 5

	
	surface.SetMaterial(blur)
	surface.SetDrawColor(255, 255, 255, alpha or 255)

	local x, y = panel:LocalToScreen(0, 0)

	for i = -(passes or 0.2), 1, 0.2 do
		-- Do things to the blur material to make it blurry.
		blur:SetFloat("$blur", i * amount)
		blur:Recompute()

		-- Draw the blur material over the screen.
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end

end

function FadeColor(a, b, frac, alpha)
    local res, me
    res = Color(0, 0, 0, alpha )
    me = (1 - frac)

    res.r = (a.r * me) + (b.r * frac)
    res.g = (a.g * me) + (b.g * frac)
    res.b = (a.b * me) + (b.b * frac)
	
    return res
end

function LerpColor(frac, from, to)
	local col = Color(
		Lerp(frac, from.r, to.r),
		Lerp(frac, from.g, to.g),
		Lerp(frac, from.b, to.b),
		Lerp(frac, from.a, to.a)
	)

	return col
end


-- Watermark panel
function PANEL:Init()

	if IsValid(cellar_tab_info) then
		cellar_tab_info:Remove()
		cellar_tab_info = nil
	end

	cellar_tab_info = self

	if not IsValid(self:GetParent()) then
		self:Remove()
	end

	local parent = self:GetParent()
	self.closing = false
	local frameH, frameW, animTime, animDelay, animEase = ScrW(), ScrH(), .8, 0, .1
	self:Center()
	local isAnimating = true
	self:SetSize(0, 0)
	self:SetAlpha(0)
	self:AlphaTo(255, 1.2, 0)
	self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
		isAnimating = false
	end)
	self.Think = function(me)
		if isAnimating then
		me:Center()
		end
	end
	self.volume = 0
	LocalPlayer():EmitSound('Helix.Whoosh')
	LocalPlayer():EmitSound('cellar.info.amb')



	local back = self:Add("cellar.btnlist")
	back:SetPos(ScrW() - ScrW()/2 - 150, ScrH() - ScrH() * .1287)
	back:SetText('НАЗАД')
	back:SetSize(300, 0)
	back:SizeTo(300, 40, 1, (0.25 * 2))
	back.Think = function(me)
		if self.closing then
			me:SizeTo(300, 0, .3, 0)
		end
		if isAnimating then
			self:Center()
		end
	end
	back.DoClick = function()
		self.closing = true 
		LocalPlayer():StopSound('cellar.info.amb')
		surface.PlaySound('cellar/ui/infooutro25.mp3')
		self:Remove()
	end


end

function PANEL:Paint(w, h)
	DrawBlurIndependent(self)
	local doorlogo = Material('cellar/main/cellar256x64.png')
	local yufulogo = Material('cellar/main/yufucat.png')

	surface.SetDrawColor(ColorAlpha(color_black, 160))
	surface.DrawRect(0, 0, w, h)

	draw.RoundedBox(0, 0, ScrH() - ScrH()/1.56, ScrW(), ScrH()/3, ColorAlpha(color_black, 215))
	
	local tsin = TimedSin(.4, 10, 120, 0)
	surface.SetDrawColor(ColorAlpha(color_white, 90 + tsin))
	surface.SetMaterial(doorlogo)
	surface.DrawTexturedRect(12, ScrH()/2.75, 256, 64)
	/*raw.SimpleText("CELLAR PROJECT", "cellar.tab", ScrW() - ScrW()/2 + 36, ScrH()/3.9 + 30, Color(43, 157, 189, 90 + tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("CELLAR PROJECT", "cellar.tab.blur", ScrW() - ScrW()/2 + 36, ScrH()/3.9 + 30, Color(43, 157, 189,  90 + tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)*/

	surface.SetDrawColor(ColorAlpha(color_white, 90 + tsin))
	surface.SetMaterial(yufulogo)
	surface.DrawTexturedRect(ScrW() - 256 - 12, ScrH()/2.75, 256, 64)

	draw.SimpleText("Бета-версия: некоторые функции могут отсутствовать или работать некорректно.", "cellar.tab",  ScrW() - ScrW()/2, ScrH() - ScrH()/2.4, ColorAlpha(color_orange,  90 + tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Бета-версия: некоторые функции могут отсутствовать или работать некорректно.", "cellar.tab.blur",  ScrW() - ScrW()/2, ScrH() - ScrH()/2.4, ColorAlpha(color_orange,  90 + tsin), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



	draw.SimpleText("Дизайн и функционал оригинального пользовательского интерфейса", "cellar.watermark", ScrW() - ScrW()/2, ScrH() - ScrH()/1.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("был написан, оформлен и предоставлен Командой Cellar.", "cellar.watermark", ScrW() - ScrW()/2, ScrH() - ScrH()/1.7 + 24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("The original user interface design and functionality", "cellar.watermark", ScrW() - ScrW()/2, ScrH() - ScrH()/1.7 + 64, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("was written, designed and provided by Cellar Team.", "cellar.watermark", ScrW() - ScrW()/2, ScrH() - ScrH()/1.7 + 84, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	draw.SimpleText("CELLAR TEAM", "cellar.tab", 10, ScrH() - ScrH()/3, ColorAlpha(color_red, 7), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText("CELLAR TEAM", "cellar.tab.blur", 10, ScrH() - ScrH()/3, ColorAlpha(color_red, 7), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText("GUI BY SECTORIAL.COMMANDER", "cellar.tab", ScrW() - 10, ScrH() - ScrH()/3, ColorAlpha(color_red, 7), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText("GUI BY SECTORIAL.COMMANDER", "cellar.tab.blur", ScrW() - 10, ScrH() - ScrH()/3, ColorAlpha(color_red, 7), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.SimpleText("2021. ALL RIGHTS RESERVED", "cellar.tab", ScrW() - ScrW()/2, ScrH() - ScrH()/3, ColorAlpha(color_red, 7), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("2021. ALL RIGHTS RESERVED", "cellar.tab.blur", ScrW() - ScrW()/2, ScrH() - ScrH()/3, ColorAlpha(color_red, 7), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	
end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if (key == KEY_TAB) then
		LocalPlayer():StopSound('cellar.info.amb')
		surface.PlaySound('cellar/ui/infooutro25.mp3')
		self:Remove()
	end
end

function PANEL:Remove()
	self.closing = true
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)


	if self.closing then
		self:MakePopup()
		timer.Simple(2.3, function() self:SetMouseInputEnabled(false) self:SetKeyboardInputEnabled(false) end)
		local frameH, frameW, animTime, animDelay, animEase = 0, 0, .8, 3, .1
		self:SetSize(ScrW(), ScrH())
		local isAnimating = true
		self:SizeTo(frameH, frameW, animTime, animDelay, animEase, function()
			isAnimating = false
			timer.Simple(.1, function() self:SetVisible(false) end)
		end)
		self:AlphaTo(0, 2, .1)
		tsin = nil
		LocalPlayer():StopSound('cellar.info.amb')
	end
end

vgui.Register("cellar.tab.info", PANEL, "EditablePanel")





-- YOU button model panel
PANEL = {}
function PANEL:Init()
	cellar_tab_modelpanel = self

	self:SetSize(ScrW() * .3450, ScrH() * .7700)
end

function PANEL:SetCharacter(character)
	self.model = self:Add("ixModelPanel")
	self.model:Dock(FILL)
	self.model:SetFOV(50)
	self.model:SetAlpha(255)

	self.character = character

	self:UpdateModel()
end

function PANEL:GetCharacter()
	if(self.character) then
		return self.character
	end

	return nil
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

function PANEL:OnSubpanelRightClick()
	properties.OpenEntityMenu(LocalPlayer())
end

function PANEL:Think()
	--if(IsValid(cellar_tab) and cellar_tab.closing) then
	--	if(self.model) then
	--		self.model:Remove()
	--	end
	--end

	local character = self:GetCharacter()

	if(character and IsValid(self.model)) then
		if(character:GetPlayer():GetModel() != self.model:GetModel()) then
			self:UpdateModel()
		end
	end
end

vgui.Register('cellar.tab.modelpanel', PANEL, "EditablePanel")