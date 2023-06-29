
local PLUGIN = PLUGIN

-- luacheck: ignore 122

local PANEL = {}
PANEL.Base = "Panel"

-- I took this from the gmod github, don't hurt me
local ContentPanel = nil

function PANEL:Init()

	self:Dock(TOP)
	self:SetHeight(20)
	self:DockMargin(0, 0, 0, 3)

	self.Search = self:Add("DTextEntry")
	self.Search:Dock(FILL)

	self.Search.OnEnter = function() self:RefreshResults() end
	self.Search.OnFocusChanged = function(_, b) if (b) then self:RefreshResults() end end
	self.Search:SetTooltip("Press enter to search")

	local btn = self.Search:Add("DImageButton")

	btn:SetImage("icon16/magnifier.png")
	btn:SetText("")
	btn:Dock(RIGHT)
	btn:DockMargin(4, 2, 4, 2)
	btn:SetSize(16, 16)
	btn:SetTooltip("Press to search")
	btn.DoClick = function()
		self:RefreshResults()
	end

	self.Search.OnKeyCode = function(p, code)

		if (code == KEY_F1) then hook.Run("OnSpawnMenuClose") end
		if (code == KEY_ESCAPE) then hook.Run("OnSpawnMenuClose") end

	end

	self.StartSearch = function(pluginTable)

		if (g_SpawnMenu:IsVisible()) then return hook.Run("OnSpawnMenuClose") end

		hook.Run("OnSpawnMenuOpen")
		hook.Run("OnTextEntryGetFocus", pluginTable.Search)

		pluginTable.Search:RequestFocus()
		pluginTable.Search:SetText("")

		timer.Simple(0.1, function() g_SpawnMenu:HangOpen(false) end)

		ContentPanel:SwitchPanel(pluginTable.searchResultsItem)

	end

	self.SearchUpdate = function(pluginTable)
		if (!g_SpawnMenu:IsVisible() or !IsValid(self)) then
			return
		end

		pluginTable:RefreshResults()
	end

	self.searchResultsItem = vgui.Create("ContentContainer", self)
	self.searchResultsItem:SetVisible(false)
	self.searchResultsItem:SetTriggerSpawnlistChange(false)

	g_SpawnMenu.searchResultsItem = self.searchResultsItem

end

function PANEL:RefreshResults()

	if (self.Search:GetText() == "") then return end

	self.searchResultsItem:Clear()

	local text = self.Search:GetText():lower()
	text = text:PatternSafe()

	local results = {}

	for k, v in pairs(ix.item.list) do
		if (v.name:lower():find(text)) then
			results[k] = v
		end
	end

	local header = self:Add("ContentHeader")

	header:SetText(table.Count(results) .. " Results for \"" .. self.Search:GetText() .. "\"")
	self.searchResultsItem:Add(header)

	if (!table.IsEmpty(results)) then
		for _, itemTable in pairs(results) do
			spawnmenu.CreateContentIcon("ixItem", self.searchResultsItem, itemTable)
		end
	end

	self.searchResultsItem:SetParent(ContentPanel)
	ContentPanel:SwitchPanel(self.searchResultsItem)

end


function PLUGIN:PopulateContent(panel, tree, node)
	ContentPanel = panel
end

vgui.Register("ItemSearchBar", PANEL)
