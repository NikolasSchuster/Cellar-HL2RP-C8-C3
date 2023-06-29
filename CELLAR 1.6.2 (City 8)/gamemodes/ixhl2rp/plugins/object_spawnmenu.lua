local PLUGIN = PLUGIN

PLUGIN.name = "Object Spawnmenu"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

if SERVER then
	return
end

spawnmenu.AddContentType("ixContainer", function(container, data)
	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("ixItem")
	icon:SetSpawnName(data[1])
	icon:SetName(string.format("%s (%sx%s)", data[2], data[3], data[4]))

	icon.model = vgui.Create("ModelImage", icon)
	icon.model:SetMouseInputEnabled(false)
	icon.model:SetKeyboardInputEnabled(false)
	icon.model:StretchToParent(16, 16, 16, 16)
	icon.model:SetModel(data[1], 0, "000000000")
	icon.model:MoveToBefore(icon.Image)

	function icon:DoClick()
		RunConsoleCommand("gm_spawn", data[1])
		
		surface.PlaySound("ui/buttonclickrelease.wav")
	end

	function icon:OpenMenu() end

	if IsValid(container) then
		container:Add(icon)
	end
end)

local types = {
	[0] = "Обычная",
	[1] = "Хорошая",
	[3] = "Медицинская",
}

spawnmenu.AddContentType("ixBed", function(container, data)
	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("ixItem")
	icon:SetSpawnName(data[1])
	icon:SetName(string.format("%s (x%s)", types[data[2]], data[3]))

	icon.model = vgui.Create("ModelImage", icon)
	icon.model:SetMouseInputEnabled(false)
	icon.model:SetKeyboardInputEnabled(false)
	icon.model:StretchToParent(16, 16, 16, 16)
	icon.model:SetModel(data[1], 0, "000000000")
	icon.model:MoveToBefore(icon.Image)

	function icon:DoClick()
		RunConsoleCommand("gm_spawn", data[1])
		
		surface.PlaySound("ui/buttonclickrelease.wav")
	end

	function icon:OpenMenu() end

	if IsValid(container) then
		container:Add(icon)
	end
end)

local function CreateObjectPanel()
	local base = vgui.Create("SpawnmenuContentPanel")
	local tree = base.ContentNavBar.Tree

	local containers = tree:AddNode("Контейнеры", "icon16/package.png")
	function containers:DoPopulate()
		if (self.Container) then return end

		self.Container = vgui.Create("ContentContainer", base)
		self.Container:SetVisible(false)
		self.Container:SetTriggerSpawnlistChange(false)

		
		for model, data in SortedPairsByMemberValue(ix.container.stored, "name") do
			local data = {
				[1] = model,
				[2] = data.name,
				[3] = data.width,
				[4] = data.height
			}

			spawnmenu.CreateContentIcon("ixContainer", self.Container, data)
		end
	end
	function containers:DoClick()
		self:DoPopulate()
		base:SwitchPanel(self.Container)
	end

	local beds = tree:AddNode("Кровати", "icon16/heart.png")
	function beds:DoPopulate()
		if (self.Container) then return end

		self.Container = vgui.Create("ContentContainer", base)
		self.Container:SetVisible(false)
		self.Container:SetTriggerSpawnlistChange(false)

		
		for model, data in SortedPairsByMemberValue(ix.bed.stored, "type") do
			local data = {
				[1] = model,
				[2] = data.type,
				[3] = data.rate,
			}

			spawnmenu.CreateContentIcon("ixBed", self.Container, data)
		end
	end
	function beds:DoClick()
		self:DoPopulate()
		base:SwitchPanel(self.Container)
	end


	local FirstNode = tree:Root():GetChildNode(0)

	if IsValid(FirstNode) then
		FirstNode:InternalDoClick()
	end

	return base
end

spawnmenu.AddCreationTab("Объекты", CreateObjectPanel, "icon16/script_key.png")

timer.Simple(0, function()
	RunConsoleCommand("spawnmenu_reload")
end)
