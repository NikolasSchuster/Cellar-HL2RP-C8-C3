local PANEL = {}

AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "boostValue", "Boost", FORCE_NUMBER)
AccessorFunc(PANEL, "max", "Max", FORCE_NUMBER)

function PANEL:Init()
	self:SetTall(20)

	self.add = self:Add("DImageButton")
	self.add:SetSize(20, 20)
	self.add:SetImage("icon16/add.png")
	self.add:Dock(RIGHT)
	self.add:DockMargin(4, 0, 0, 0)
	self.add.OnMousePressed = function()
		self.pressing = 1
		self:DoChange()
		self.add:SetAlpha(150)
	end
	self.add.OnMouseReleased = function()
		if (self.pressing) then
			self.pressing = nil
			self.add:SetAlpha(255)
		end
	end
	self.add.OnCursorExited = self.add.OnMouseReleased

	self.sub = self:Add("DImageButton")
	self.sub:SetSize(20, 20)
	self.sub:SetImage("icon16/delete.png")
	self.sub.OnMousePressed = function()
		self.pressing = -1
		self:DoChange()
		self.sub:SetAlpha(150)
	end
	self.sub.OnMouseReleased = function()
		if (self.pressing) then
			self.pressing = nil
			self.sub:SetAlpha(255)
		end
	end
	self.sub.OnCursorExited = self.sub.OnMouseReleased

	self.value = 0
	self.deltaValue = self.value
	self.max = 10

	self.bar = self:Add("DPanel")
	self.bar:Dock(FILL)
	self.bar:DockMargin(self:GetParent().offset or 0,0,0,0)
	self.sub:SetPos(self:GetParent().offset - 24, 0)
	self.bar.Paint = function(this, w, h)
		surface.SetDrawColor(ColorAlpha(cellar_blue, 35))
		surface.DrawRect(0, 0, w, h)
		

		local value = self.deltaValue / self.max

		if (value > 0) then
			local color = self.color and self.color or ColorAlpha(cellar_blue, 35)
			local boostedValue = self.boostValue or 0
			local add = 0

			if (self.deltaValue != self.value) then
				add = 35
			end

			-- your stat
			do
				if !(boostedValue < 0 and math.abs(boostedValue) > self.value) then
					surface.SetDrawColor(color.r + add, color.g + add, color.b + add, 35)
					surface.DrawRect(0, 0, w * value, h)
				end
			end

			-- boosted stat
			do
				local boostValue

				if (boostedValue != 0) then
					if (boostedValue < 0) then
						local please = math.min(self.value, math.abs(boostedValue))
						boostValue = ((please or 0) / self.max) * (self.deltaValue / self.value)
					else
						boostValue = ((boostedValue or 0) / self.max) * (self.deltaValue / self.value)
					end

					if (boostedValue < 0) then
						surface.SetDrawColor(200, 40, 40, 80)

						local bWidth = math.abs(w * boostValue)
						surface.DrawRect(w * value - bWidth, 0, bWidth, h)
					else
						surface.SetDrawColor(40, 200, 40, 80)
						surface.DrawRect(w * value, 0, w * boostValue, h)
					end
				end
			end
		end

		surface.SetDrawColor(cellar_blue)
		surface.DrawRect(0, 0, h * .5, 1)
		surface.DrawRect(0, 0, 1, h * .5)
		surface.DrawRect(w - h * .5, h - 1, h * .5, 1)
		surface.DrawRect(w - 1, h - h * .5, 1, h * .5)
	end

	self.label = self:Add("DLabel")
	self.label:SetFont("cellar.mini")
	self.label:SetTextColor(cellar_blue)

	self.label2 = self.bar:Add("DLabel")
	self.label2:SetFont("cellar.mini")
	self.label2:SetTextColor(cellar_blue)
	self.label2:DockMargin(2, 0, 0, 0)
	self.label2:Dock(FILL)
	self.label2:SetContentAlignment(0)

	self.descTitle = ""
end

function PANEL:Think()
	if (self.pressing) then
		if ((self.nextPress or 0) < CurTime()) then
			self:DoChange()
		end
	end

	self.deltaValue = math.Approach(self.deltaValue, self.value, FrameTime() * 15)
end

function PANEL:DoChange()
	if ((self.value == 0 and self.pressing == -1) or (self.value == self.max and self.pressing == 1)) then
		return
	end

	self.nextPress = CurTime() + 0.2

	if (self:OnChanged(self.pressing) != false) then
		self.value = math.Clamp(self.value + self.pressing, 0, self.max)
	end
end

function PANEL:OnChanged(difference)
end

function PANEL:SetText(text, value)
	self.descTitle = text
	self.label:SetText(text)
	self.label:SizeToContents()

	self.label2:SetText(value)
end

function PANEL:SetReadOnly()
	self.sub:Remove()
	self.add:Remove()
end

function PANEL:SetDesc(desc)
	self.label:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(self.descTitle)
		title:SizeToContents()
		title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

		if self.xp and self.skill then
			local skills = LocalPlayer():GetCharacter():GetSkills()
			local skill = ix.skills.list[self.skill]

			local tooltip = tooltip:AddRow("description")
			tooltip:SetText(L("levelXP", math.Round(skills[self.skill][2]), math.Round(skill:GetRequiredXP(skills, skills[self.skill][1]))))
			tooltip:SizeToContents()
		end

		local description = tooltip:AddRow("description")
		description:SetText(desc)
		description:SizeToContents()
	end)

	self.label2:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(self.descTitle)
		title:SizeToContents()
		title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

		if self.xp and self.skill then
			local skills = LocalPlayer():GetCharacter():GetSkills()
			local skill = ix.skills.list[self.skill]

			local tooltip = tooltip:AddRow("description")
			tooltip:SetText(L("levelXP", math.Round(skills[self.skill][2]), math.Round(skill:GetRequiredXP(skills, skills[self.skill][1]))))
			tooltip:SizeToContents()
		end

		local description = tooltip:AddRow("description")
		description:SetText(desc)
		description:SizeToContents()
	end)
end

function PANEL:Paint()

end

vgui.Register("ixStatBar", PANEL, "DPanel")
