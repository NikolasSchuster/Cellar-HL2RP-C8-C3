
local PLUGIN = PLUGIN

local icons = {
	["Ammunition"] = "briefcase",
	["Clothing"] = "user_suit",
	["Communication"] = "telephone",
	["Consumables"] = "cake",
	["Crafting Resource"] = "cog",
	["Crafting Station"] = "cog",
	["Crafting"] = "cog",
	["Deployables"] = "arrow_down",
	["Filters"] = "weather_clouds",
	["Junk"] = "box",
	["Lights"] = "lightbulb",
	["Literature"] = "book",
	["Medical"] = "heart",
	["Melee Weapons"] = "bomb",
	["Other"] = "brick",
	["Promotional"] = "coins",
	["Reusables"] = "arrow_rotate_clockwise",
	["Storage"] = "package",
	["Tools"] = "wrench",
	["Turret"] = "gun",
	["UU-Branded Items"] = "asterisk_yellow",
	["Weapons"] = "gun",
	["Workstations"] = "page",
}

spawnmenu.AddContentType("ixItem", function(container, data)
	if (!data.name) then return end

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("ixItem")
	icon:SetSpawnName(data.uniqueID)
	icon:SetName(data.name)

	local mdl = data:GetModel()

	if mdl then
		icon.model = vgui.Create("ModelImage", icon)
		icon.model:SetMouseInputEnabled(false)
		icon.model:SetKeyboardInputEnabled(false)
		icon.model:StretchToParent(16, 16, 16, 16)
		icon.model:SetModel(data:GetModel(), data:GetSkin(), "000000000")
		icon.model:MoveToBefore(icon.Image)
	end

	function icon:DoClick()
		net.Start("MenuItemSpawn")
			net.WriteString(data.uniqueID)
		net.SendToServer()
		
		surface.PlaySound("ui/buttonclickrelease.wav")
	end

	function icon:OpenMenu()
		local menu = DermaMenu()
		menu:AddOption("Скопировать Item ID", function()
			SetClipboardText(data.uniqueID)
		end)

		menu:AddOption("Выдать себе", function()
			net.Start("MenuItemGive")
				net.WriteString(data.uniqueID)
			net.SendToServer()
		end)

		menu:Open()
	end

	if (IsValid(container)) then
		container:Add(icon)
	end
end)

local function CreateItemsPanel()
	local base = vgui.Create("SpawnmenuContentPanel")
	local tree = base.ContentNavBar.Tree
	local categories = {}

	vgui.Create("ItemSearchBar", base.ContentNavBar)

	for k, v in SortedPairsByMemberValue(ix.item.list, "category") do
		if (!categories[v.category] and not string.match( v.name, "Base" )) then
			categories[v.category] = true

			local category = tree:AddNode(L(v.category), icons[v.category] and ("icon16/" .. icons[v.category] .. ".png") or "icon16/brick.png")

			function category:DoPopulate()
				if (self.Container) then return end

				self.Container = vgui.Create("ContentContainer", base)
				self.Container:SetVisible(false)
				self.Container:SetTriggerSpawnlistChange(false)


				for uniqueID, itemTable in SortedPairsByMemberValue(ix.item.list, "name") do
					if (itemTable.category == v.category and not string.match( itemTable.name, "Base" )) then
						spawnmenu.CreateContentIcon("ixItem", self.Container, itemTable)
					end
				end
			end

			function category:DoClick()
				self:DoPopulate()
				base:SwitchPanel(self.Container)
			end
		end
	end

	local FirstNode = tree:Root():GetChildNode(0)

	if (IsValid(FirstNode)) then
		FirstNode:InternalDoClick()
	end

	PLUGIN:PopulateContent(base, tree, nil)

	return base
end

spawnmenu.AddCreationTab("Предметы", CreateItemsPanel, "icon16/script_key.png")

-- ensures the spawnmenu repopulates
timer.Simple(0, function()
	RunConsoleCommand("spawnmenu_reload")
end)
