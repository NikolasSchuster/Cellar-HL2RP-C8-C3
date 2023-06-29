local ICON_SIZE = 16
local ICONFRAME_SIZE = 32
local BAR_WIDTH = 384
local animTime = 2.3
local alphaTime = .6
local PLUGIN = PLUGIN

PANEL = {}

AccessorFunc(PANEL, "value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "delta", "Delta", FORCE_NUMBER)

function PANEL:Init()

	if IsValid(cellar_hud_main) then
		cellar_hud_main:Remove()
	end

	cellar_hud_main = self

	self.client = LocalPlayer()
	self.notCellarAlive = self.client:Health() <= 1
	self.opening = true
	self.closing = false
	self.removed = false
	self.value = 0
	self.delta = 0
	self.lifetime = 0

	self.health = 1
	self.blood = 1
	self.hunger = 1
	self.stamina = 1
	self.thirst = 1
	self.radlevel = 1
	self.filter = 1
	self.oldhealth = 1
	self.newhealth = 1
	
	self:SetSize(ScrW() * .5, ScrH() * .5)
	self:SetPos(0, 0)
	self:ParentToHUD()

	self.critAlpha = TimedSin(.65, 45, 155, 0)
	self.barBackground = ColorAlpha(cellar_darker_blue, 43)
	self.barCritBackground = ColorAlpha(cellar_red, 25)
	self.healthBarBackground = ColorAlpha(cellar_red, 25)
	self.healthBarInside = ColorAlpha(cellar_red, 135)
	self.barInside = ColorAlpha(cellar_darker_blue, 135)
	self.barCritInside = ColorAlpha(cellar_red, self.critAlpha)
	self.barBorders = ColorAlpha(cellar_blue, 155)
	self.barCritBorders = ColorAlpha(cellar_red, 225)
	self.barIcon = ColorAlpha(cellar_blue, 43)
	self.barCritIcon = ColorAlpha(cellar_red, 43)

	local critAlpha = TimedSin(.65, 45, 155, 0)
	local barBackground = ColorAlpha(cellar_darker_blue, 43)
	local barCritBackground = ColorAlpha(cellar_red, 25)
	local healthBarBackground = ColorAlpha(cellar_red, 135)
	local healthBarInside = ColorAlpha(cellar_red, 255)
	local barInside = ColorAlpha(cellar_darker_blue, 135)
	local barCritInside = ColorAlpha(cellar_red, self.critAlpha)
	local barBorders = ColorAlpha(cellar_blue, 155)
	local barCritBorders = ColorAlpha(cellar_red, 225)
	local barIcon = ColorAlpha(cellar_blue, 43)
	local barCritIcon = ColorAlpha(cellar_red, 43)

	local parent = self:GetParent()

	if not self.client:GetCharacter() then return end

	self.levelframe = self:Add('DPanel')
	self.levelframe:SetPos(ScrW() * .016, ScrH() * .03)
	self.levelframe:SetSize(32, 32)
	self.levelframe:SetAlpha(0)
	self.levelframe:AlphaTo(255, .6, .1)
	self.levelframe.Paint = function(me, w, h)

		surface.SetDrawColor(ColorAlpha(cellar_blue, 135))
		surface.DrawRect(0, 0, w, 1)
		surface.DrawRect(w - 1, 0, 1, h)
		surface.DrawRect(0, 0, 1, h * .66)
		surface.DrawRect(w * .33, h - 1, w, 1)

		surface.DrawLine(0, h * .66, w * .33, h - 1)

		local lvl = LocalPlayer():GetCharacter():GetLevel()
		
		draw.SimpleText(lvl, "cellar.derma.light", w/2, h/2, cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(lvl, "cellar.derma.light.blur", w/2, h/2, cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

	self.bloodlevel = self:Add('DPanel')
	self.bloodlevel:SetPos(ScrW() * .016 + 32 + 8, ScrH() * .03)
	self.bloodlevel:SetSize(20, 10)
	self.bloodlevel:SetAlpha(0)
	self.bloodlevel:AlphaTo(255, .6, .1)
	if self.opening then
		self.bloodlevel:SizeTo(BAR_WIDTH, 10, 2.3, .7, .1, function()
			self.opening = false
		end)
	end
	self.bloodlevel.Paint = function(me, w, h)
		local insde = self.health

		draw.RoundedBox(0, 0, 0, w, h * .5, healthBarBackground)
		draw.RoundedBox(0, 0, h * .5, w - 1, h * .1, healthBarBackground)
		draw.RoundedBox(0, 0, h * .6, w - 2, h * .1, healthBarBackground)
		draw.RoundedBox(0, 0, h * .7, w - 3, h * .1, healthBarBackground)
		draw.RoundedBox(0, 0, h * .8, w - 4, h * .1, healthBarBackground)
		draw.RoundedBox(0, 0, h * .9, w - 5, h * .1, healthBarBackground)
		draw.RoundedBox(0, 0, h, w - 6, h * .1, healthBarBackground)
		

		surface.SetDrawColor(healthBarInside)
		surface.DrawRect(0, 0, w * insde, h * .5)
		surface.DrawRect(0, h * .5, w * insde - 1, h * .1)
		surface.DrawRect(0, h * .6, w * insde - 2, h * .1)
		surface.DrawRect(0, h * .7, w * insde - 3, h * .1)
		surface.DrawRect(0, h * .8, w * insde - 4, h * .1)
		surface.DrawRect(0, h * .9, w * insde - 5, h * .1)
		surface.DrawRect(0, h, w * insde - 6, h * .1)
	end

	self.staminalevel = self:Add('DPanel')
	self.staminalevel:SetPos(ScrW() * .016 + 32 + 8, ScrH() * .03 + self.bloodlevel:GetTall() + 2)
	self.staminalevel:SetSize(15, 3)
	self.staminalevel:SetAlpha(0)
	self.staminalevel:AlphaTo(255, .6, .1)
	if self.opening then
		self.staminalevel:SizeTo(BAR_WIDTH - 6, 3, 2.3, .7, .1, function()
			self.opening = false
		end)
	end
	self.staminalevel.Paint = function(me, w, h)
		local idside = self.stamina


		local barBackground = ColorAlpha(color_white, 43)
		local barInside = ColorAlpha(color_white, 255)

		draw.RoundedBox(0, 0, 0, w - 2, 1, self.stamina < 0.4 and LerpColor(self.critAlpha/100, barBackground, barCritBackground) or barBackground)
		draw.RoundedBox(0, 0, 1, w - 3, 1, self.stamina < 0.4 and LerpColor(self.critAlpha/100, barBackground, barCritBackground) or barBackground)
		draw.RoundedBox(0, 0, 2, w - 4, 1, self.stamina < 0.4 and LerpColor(self.critAlpha/100, barBackground, barCritBackground) or barBackground)

		surface.SetDrawColor(barInside)
		surface.DrawRect(0, 0, w * self.stamina - 2, 1)
		surface.DrawRect(0, 1, w * self.stamina - 3, 1)
		surface.DrawRect(0, 2, w * self.stamina - 4, 1)

	end

end

function PANEL:Paint(w, h)

	self.critAlpha = TimedSin(.65, 45, 155, 0)
	self.barCritInside = ColorAlpha(cellar_red, self.critAlpha)
	
end

function PANEL:Think()

	if self.client:GetNetVar("crit") or self.notCellarAlive or !self.client:Alive() then
		if self.removed == false then
			self:Remove()
		end
	end

	if self.client.ixRagdoll then 
		if self.removed == false then
			self:Remove()
		end
	end

	local character = self.client:GetCharacter()
	if not character then return end

	self.health = Lerp(1 * FrameTime(), self.health, math.max(character:GetBlood() / 5000, 0))
	self.stamina = Lerp(1 * FrameTime(), self.stamina, math.Clamp((ix.plugin.list["stamina"].predictedStamina or 100) / LocalPlayer():GetCharacter():GetMaxStamina(), 0, 1))

end

function PANEL:Remove()
	self.closing = true
	self.removed = true

	self.bloodlevel:SetSize(BAR_WIDTH, self.bloodlevel:GetTall())
	self.bloodlevel:SizeTo(20, 10, 2.3, .1, .1)
	self.bloodlevel:SetAlpha(255)
	self.bloodlevel:AlphaTo(0, .6, 2.3)

	self.staminalevel:SetSize(BAR_WIDTH - 6, self.staminalevel:GetTall())
	self.staminalevel:SizeTo(15, 3, 2.3, .1, .1)
	self.staminalevel:SetAlpha(255)
	self.staminalevel:AlphaTo(0, .6, 2.3)

	self.levelframe:SetAlpha(255)
	self.levelframe:AlphaTo(0, .6, 2.3, function()
		self:SetVisible(false)
	end)

end

vgui.Register('cellar.hud', PANEL, 'Panel')


PANEL = {}
function PANEL:Init()

	self.client = LocalPlayer()

	if IsValid(cellar_hud_ammo) then
		cellar_hud_ammo.ammocount:SetVisible(false)
		cellar_hud_ammo:Remove()
	end

	cellar_hud_ammo = self

	self.notAlive = not self.client:Alive()
	self.notAliveCellar = self.client:Health() <= 1
	self.removed = false
	self.weapon = self.client:GetActiveWeapon()
	self.clip = 1
	self.clipMax = self.weapon:GetMaxClip1()
	self.delay = CurTime()
	self.isValidAmmo = nil

	self:SetPos(ScrW() - ScrW() * .25, ScrH() * .5)
	self:SetSize(ScrW() * .25, ScrH() * .5)
	self:SetAlpha(0)
	self:AlphaTo(255, .6, .1)
	self:ParentToHUD()

	self.critAlpha = TimedSin(.65, 45, 155, 0)
	self.barBackground = ColorAlpha(cellar_darker_blue, 43)
	self.barCritBackground = ColorAlpha(cellar_red, 25)
	self.barInside = ColorAlpha(cellar_darker_blue, 107)
	self.barCritInside = ColorAlpha(cellar_red, critAlpha)
	self.barBorders = ColorAlpha(cellar_blue, 155)
	self.barCritBorders = ColorAlpha(cellar_red, 225)
	self.barIcon = ColorAlpha(cellar_blue, 43)
	self.barCritIcon = ColorAlpha(cellar_red, 43)


	self:SetPos(ScrW() - ScrW() * .016 - ICONFRAME_SIZE - 8 - BAR_WIDTH - 2, ScrH() - ScrH() * .03 - 36)
	self:SetSize(8 + ICONFRAME_SIZE + 8 + BAR_WIDTH + 2, 36)
	self:SetAlpha(0)
	self:AlphaTo(255, alphaTime, .1)

	self.icon = self:Add('DPanel')
	self.icon:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE, 2)
	self.icon:SetSize(ICONFRAME_SIZE, ICONFRAME_SIZE)
	self.icon.Paint = function(me, w, h)
		local icon = Material('cellar/main/hud/bullets.png')
		
		surface.SetDrawColor(self.clip < 0.3 and LerpColor(self.critAlpha/100, ColorAlpha(cellar_blue, 135), self.barCritInside) or ColorAlpha(cellar_blue, 135))
		surface.SetMaterial(icon)
		surface.DrawTexturedRectRotated(w * .5 - 1, h * .5 - 1, ICON_SIZE, ICON_SIZE, 0)

		surface.DrawRect(0, 0, 1, h)
		surface.DrawRect(0, 0, w, 1)
		surface.DrawRect(0, h - 1, w * .66, 1)
		surface.DrawRect(w - 1, 0, 1, h * .66)
		surface.DrawLine(w * .66, h - 1, w - 1, h * .66)

		
	end

	self.line = self:Add('DPanel')
	self.line:SetPos(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2)
	self.line:SetSize(12, 32)
	self.line:MoveTo(0, 2, animTime, .7, .1)
	self.line:SizeTo(self:GetWide() - 16 - ICONFRAME_SIZE, 32, animTime, .7, .1)
	self.line.Paint = function(me, w, h)

		if self.client:Alive() then


			surface.SetDrawColor(self.clip < 0.3 and LerpColor(self.critAlpha/100, self.barBackground, self.barCritBackground) or self.barBackground)
			surface.DrawRect(0, 21, w, (h * .375)/2)
			surface.DrawRect(1, 27, w, 1)
			surface.DrawRect(2, 28, w, 1)
			surface.DrawRect(3, 29, w, 1)
			surface.DrawRect(4, 30, w, 1)
			surface.DrawRect(5, 31, w, 1)


			surface.DrawRect(0, 19, w, 1)
			surface.DrawRect(0, 16, 1, 4)
			surface.DrawRect(w - 1, 16, 1, 4)

			surface.DrawRect(w * .1, 16, 1, 3)
			surface.DrawRect(w * .2, 16, 1, 3)
			surface.DrawRect(w * .3, 16, 1, 3)
			surface.DrawRect(w * .4, 16, 1, 3)
			surface.DrawRect(w * .5, 16, 1, 3)
			surface.DrawRect(w * .6, 16, 1, 3)
			surface.DrawRect(w * .7, 16, 1, 3)
			surface.DrawRect(w * .8, 16, 1, 3)
			surface.DrawRect(w * .9, 16, 1, 3)

			
			surface.SetDrawColor(self.clip < 0.3 and LerpColor(self.critAlpha/100, self.barInside, self.barCritInside) or self.barInside)
			w = w * self.clip + 1
			surface.DrawRect(BAR_WIDTH - (w - 3), 21, w, (h * .375)/2)
			surface.DrawRect(1 + BAR_WIDTH - (w - 3), 27, w, 1)
			surface.DrawRect(2 + BAR_WIDTH - (w - 3), 28, w, 1)
			surface.DrawRect(3 + BAR_WIDTH - (w - 3), 29, w, 1)
			surface.DrawRect(4 + BAR_WIDTH - (w - 3), 30, w, 1)
			surface.DrawRect(5 + BAR_WIDTH - (w - 3), 31, w, 1)

			if self.clip >= 0.3 then
				surface.DrawLine(BAR_WIDTH - (w - 3), 10, BAR_WIDTH - (w - 3), 14)
			end

		end
	end


	self.ammocount = self:Add('DPanel')
	self.ammocount:SetPos(0, 2)
	self.ammocount:SetSize(self:GetWide() - 16 - ICONFRAME_SIZE, 32)
	self.ammocount:SetAlpha(0)
	self.ammocount:AlphaTo(255, .6, alphaTime + .4)
	self.ammocount.Paint = function(me, w, h)

		if self.client:Alive() then

			if (IsValid(self.weapon) and hook.Run("CanDrawAmmoHUD", self.weapon) != false and self.weapon.DrawAmmo != false) then

				local count = self.client:GetAmmoCount(self.weapon:GetPrimaryAmmoType())
				local secondary = self.client:GetAmmoCount(self.weapon:GetSecondaryAmmoType())
				self.isValidAmmo = true

				if self.weapon:Clip1() >= 0 then
					draw.SimpleText(self.weapon:Clip1().."/"..self.weapon:GetMaxClip1(), "cellar.derma.light", w - 2, -3, self.clip < 0.3 and LerpColor(self.critAlpha/100, cellar_blue, cellar_red) or cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
					draw.SimpleText(self.weapon:Clip1().."/"..self.weapon:GetMaxClip1(), "cellar.derma.light.blur", w - 2, -3, self.clip < 0.3 and LerpColor(self.critAlpha/100, cellar_blur_blue, cellar_red) or cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				end

				if self.client:GetAmmoCount(self.weapon:GetSecondaryAmmoType()) > 0 then
					draw.SimpleText(secondary, "cellar.derma.light", w - 12, -3, self.clip < 0.3 and LerpColor(self.critAlpha/100, cellar_blue, cellar_red) or cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
					draw.SimpleText(secondary, "cellar.derma.light.blur", w - 12, -3, self.clip < 0.3 and LerpColor(self.critAlpha/100, cellar_blur_blue, cellar_red) or cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				end
			else
				self.isValidAmmo = false
				draw.SimpleText("--/--", "cellar.derma.light", w - 2, -3, self.clip < 0.3 and LerpColor(self.critAlpha/100, cellar_blue, cellar_red) or cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				draw.SimpleText("--/--", "cellar.derma.light.blur", w - 2, -3, self.clip < 0.3 and LerpColor(self.critAlpha/100, cellar_blur_blue, cellar_red) or cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end

		end
	
	end

end

function PANEL:Think()
	if self.client:GetNetVar("crit") or self.notAliveCellar or self.notAlive == true then
		if self.removed == false then
			self:Remove()
		end
	end

	if self.client.ixRagdoll then 
		if self.removed == false then
			self:Remove()
		end
	end

	if self.isValidAmmo == false then
		self:Remove()
	end


	if self.client:Alive() and IsValid(self.weapon) and hook.Run("CanDrawAmmoHUD", self.weapon) != false then
		self.clip = Lerp(2.5 * FrameTime(), self.clip, self.weapon:Clip1()/self.weapon:GetMaxClip1())
		self.weapon = self.client:GetActiveWeapon()
		if self.weapon.GetMaxClip1 then 
			self.clipMax = self.weapon:GetMaxClip1()
		else
			self.clipMax = -1
		end
	end

	if self.notAlive == false then 
		if IsValid(self.weapon) then
			if self.client and self.weapon:Clip1() then
				if (self.client:Alive() and self.weapon:Clip1() < 0) then
					if self.removed == false then
						self:Remove()
					end
				end
			end
		end
	end
end

function PANEL:Paint(w, h)

	self.critAlpha = TimedSin(.65, 45, 155, 0)
	self.barCritInside = ColorAlpha(cellar_red, critAlpha)
end

function PANEL:Remove()
	self.removed = true

	self.ammocount:SetAlpha(255)
	self.ammocount:AlphaTo(0, .3, 0)

	self.line:MoveTo(self:GetWide() - 8 - ICONFRAME_SIZE - 8 - 12, 2, animTime, .1, .1)
	self.line:SizeTo(10, 32, animTime, .1, .1)

	self:SetAlpha(255)
	self:AlphaTo(0, alphaTime, animTime, function() self:SetVisible(false) end)

	if cellar_hud_main and PLUGIN.tickbrake == true then
		cellar_hud_main:Remove()
	end

end

vgui.Register('cellar.ammo', PANEL, "Panel")
