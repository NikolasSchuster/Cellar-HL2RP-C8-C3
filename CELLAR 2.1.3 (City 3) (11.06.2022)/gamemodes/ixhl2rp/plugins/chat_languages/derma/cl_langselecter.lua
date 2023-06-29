
local languageHeightAddition = 4
local searchBarMargin = 4
local languageLeftMargin = 4

local PANEL = {}

AccessorFunc(PANEL, "font", "Font", FORCE_STRING)
AccessorFunc(PANEL, "selectedPanel", "SelectedPanel")
AccessorFunc(PANEL, "childrenHeight", "ChildrenHeight", FORCE_NUMBER)

function PANEL:Init()
	self.searchBar = self:Add("ixTextEntry")
	self.searchBar:Dock(TOP)
	self.searchBar:DockMargin(0, 0, 0, searchBarMargin)
	self.searchBar:SetUpdateOnType(true)
	self.searchBar:SetPlaceholderText(L("languageSearch"))
	self.searchBar:SetFont("ixMenuLanguageFont")
	self.searchBar:SetTextColor(cellar_blue)
	self.searchBar:SetZPos(-1)
	self.searchBar.OnValueChange = function(this, value)
		self:ReloadLanguageList(value)
	end

	self.canvas = self:Add("DScrollPanel")
	self.canvas:Dock(FILL)

	self.font = "ixMenuLanguageFont"
	self.languageHeight = draw.GetFontHeight(self.font) + languageHeightAddition
	self.childrenHeight = self.searchBar:GetTall() + searchBarMargin
	self.languages = {}
end

function PANEL:GetLanguageList()
	return self.languages
end

function PANEL:SetFont(newFont)
	self.font = newFont
	self.languageHeight = draw.GetFontHeight(self.font) + languageHeightAddition

	if (self.lastList) then
		self.SetLanguageList(self.lastList)
	end
end

function PANEL:SetLanguageList(newList)
	if (#self.languages > 0) then
		self.canvas:Clear()

		self.childrenHeight = self.searchBar:GetTall() + searchBarMargin
		self.languages = {}
	end

	for k, v in SortedPairsByMemberValue(newList, "name") do
		if (!v.bNotLearnable) then
			local panel = self.canvas:Add("Panel")
			panel:Dock(TOP)

			panel.Paint = function(this, width, height)
				if (self.selectedPanel == this and this:IsHovered()) then
					derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, ix.config.Get("color"))
				elseif (self.selectedPanel == this) then
					local color = ix.config.Get("color")

					if (!IsColor(color)) then
						color = Color(color.r, color.g, color.b, color.a)
					end

					color = ColorAlpha(color, color.a * 0.5)

					derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, color)
				elseif (this:IsHovered()) then
					derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
				end
			end
			panel.OnMousePressed = function(this, keyCode)
				if (keyCode == MOUSE_LEFT) then
					local previous = self.selectedPanel

					if (self.selectedPanel != this) then
						self.selectedPanel = this

						if (self.OnLanguageSelect) then self:OnLanguageSelect(k) end
					else
						self.selectedPanel = nil

						if (self.OnLanguageDeselect) then self:OnLanguageDeselect() end
					end
				end
			end
			panel.OnCursorEntered = function(this)
				this:SetCursor("hand")
			end
			panel.OnCursorExited = function(this)
				this:SetCursor("arrow")
			end

			panel.flag = panel:Add("DImage")
			panel.flag:SetMaterial(v.panelIcon)
			panel.flag:Dock(LEFT)
			panel.flag:DockMargin(languageLeftMargin, 0, 0, 0)
		
			panel.name = panel:Add("DLabel")
			panel.name:SetFont(self.font)
			panel.name:SetText(L(v.name))
			panel.name:SetTextColor(cellar_blue)
		--	panel.name:SetExpensiveShadow(1, color_black)
			panel.name:Dock(LEFT)
			panel.name:DockMargin(languageLeftMargin + 2, 0, 0, 0)
			panel.name:SizeToContents()

			local height = self.languageHeight
			local nameHeight = panel.name:GetTall()
			local iconSize = nameHeight - 4

			if (iconSize > 0) then
				local difference = (height - iconSize) * 0.5

				panel.flag:DockMargin(languageLeftMargin, difference, 0, difference)
				panel.flag:SetWide(iconSize)
			elseif (iconSize < 0) then
				local difference = (height - nameHeight) * 0.5

				panel.flag:DockMargin(languageLeftMargin, difference, 0, difference)
				panel.flag:SetWide(nameHeight)
			end

			panel:SetTall(height)

			self.languages[#self.languages + 1] = panel
			self.childrenHeight = self.childrenHeight + height
		end
	end

	if (#newList > 0) then
		self.lastList = newList
	end
end

function PANEL:ReloadLanguageList(filter)
	for _, v in ipairs(self.languages) do
		if (v != self.selectedPanel) then
			local lowerName = v.name:GetText():utf8lower()
			local lowerFilter = filter:utf8lower()

			if (lowerFilter:utf8len() < 1 or lowerName:find(lowerFilter)) then
				v:SetTall(self.languageHeight)
			else
				v:SetTall(0)
			end
		end
	end
end

vgui.Register("ixLanguageSelecter", PANEL, "Panel")
