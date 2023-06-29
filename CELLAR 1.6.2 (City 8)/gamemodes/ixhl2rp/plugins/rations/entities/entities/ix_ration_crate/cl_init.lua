include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnPopulateEntityInfo(tooltip)
	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(L("objRCrate"))
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	local status = tooltip:AddRow("status")
	status:SetText(L("rCrateStatus", self:GetCount() or 0))
	status:SizeToContents()
end