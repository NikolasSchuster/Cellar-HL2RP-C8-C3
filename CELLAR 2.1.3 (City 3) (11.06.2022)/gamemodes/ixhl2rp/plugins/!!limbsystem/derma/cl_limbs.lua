local PANEL = {}
PANEL.colorBG = Color(255, 255, 255, 150)

function PANEL:Init()
	if IsValid(ix.gui.limbstatus) then
		ix.gui.limbstatus:Remove()
	end
	
	ix.gui.limbstatus = self

	self:SetSize(120, 240)

	self:BuildData()
end

function PANEL:BuildData()
	local character = LocalPlayer():GetCharacter()
	local limbs = character:Limbs()

	if !limbs then
		return
	end

	self.character = character
	self.texBG = limbs.bodytexture
	self.tex = {}

	for k, limb in pairs(limbs.stored or {}) do
		if limb:IsHidden() then continue end

		self.tex[#self.tex + 1] = {limb:Name(), limb:Texture()}
	end

	self:SetHelixTooltip(function(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(L"limbStatus")
		title:SizeToContents()
		title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

		if self.character then
			local text = ""
			for k, limb in pairs(limbs.stored or {}) do
				local name = limb:Name()
				local health = self.character:GetLimbHealth(name)
				
				text = text .. string.format("%s: %i%%", L(name), health) .. ((k != #limbs) and "\n" or "")
			end
				  
			local description = tooltip:AddRow("description")
			description:SetText(text)
			description:SizeToContents()
		end
	end)
end

function PANEL:Paint(w, h)
	if self.character then
		surface.SetDrawColor(self.colorBG)
		surface.SetMaterial(self.texBG)
		surface.DrawTexturedRect(0, 0, w, h)

		for k, v in pairs(self.tex) do
			local limbColor = ix.limb:GetColor(self.character:GetLimbHealth(v[1]))

			surface.SetDrawColor(limbColor.r, limbColor.g, limbColor.b, 150)
			surface.SetMaterial(v[2])
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end

vgui.Register("ixLimbStatus", PANEL, "EditablePanel")
