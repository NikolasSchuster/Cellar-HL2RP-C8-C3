
local PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.customItem)) then
		ix.gui.customItem:Remove()
	end

	ix.gui.customItem = self

	self:SetTitle(L("ciCreate"))
	self:SetSize(ScrW() * 0.5, ScrH() * 0.5)

	self.properties = {}

	-- base selector
	self.baseSelector = self:Add("DComboBox")
	self.baseSelector:Dock(TOP)
	self.baseSelector.OnSelect = function(panel, index, value)
		self:Populate(value)
	end

	for _, v in pairs(ix.item.list) do
		if (v.base == "base_customizable_items") then
			self.baseSelector:AddChoice(v.uniqueID)
		end
	end

	self.baseSelector:SizeToContents()

	-- settings
	self.settings = self:Add("ixSettings")
	self.settings:Dock(FILL)

	-- spawn button
	self.spawn = self:Add("DButton")
	self.spawn:Dock(BOTTOM)
	self.spawn:SetText(L("ciSpawn"))
	self.spawn:SizeToContents()
	self.spawn.DoClick = function()
		if (!self.base) then
			return
		end

		local properties = {}

		for _, v in ipairs(self.settings:GetRows()) do
			properties[v:GetText()] = ix.util.SanitizeType(v.type, v:GetValue())
		end

		net.Start("ixCreateCustomItem")
			net.WriteString(self.base)
			net.WriteTable(properties)
		net.SendToServer()

		self:Remove()
	end

	self:Center()
	self:MakePopup()
end

function PANEL:Populate(base)
	base = ix.item.list[base]

	self.settings:Clear()
	self.base = base.uniqueID

	for _, v in ipairs(base.properties) do
		local name, type, default, min, max = v[1], v[2], v[3], v[4], v[5]

		local panel = self.settings:AddRow(type)
		panel.type = type
		panel:SetText(name)
		panel:SetValue(default, true)

		if (type == ix.type.number) then
			panel:SetMin(min or 0)
			panel:SetMax(max or 100)
		end
	end
end

vgui.Register("ixCreateCustomItem", PANEL, "DFrame")