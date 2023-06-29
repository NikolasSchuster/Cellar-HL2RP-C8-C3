local PLUGIN = PLUGIN

PLUGIN.name = "Basic Quests"
PLUGIN.author = "Schwarz Kruppzo"
PLUGIN.description = ""

if SERVER then
	util.AddNetworkString("ixUpdateQuests")

	function PLUGIN:OnPlayerClearGarbage(client)
		local character = client:GetCharacter()
		local quests = character:GetData("quests", {})

		if quests["cwu_garbage"] then
			local garbages = character:GetData("cwuGarbage", 0)

			if garbages < 4 then
				character:SetData("cwuGarbage", math.Clamp(garbages + 1, 0, 4))
			end
		end
	end

	function PLUGIN:CharacterLoaded(character)
		timer.Simple(1, function()
			net.Start("ixUpdateQuests")
			net.Send(character:GetPlayer())
		end)
	end
else
	surface.CreateFont("ixTaskMain", {
		font = "Roboto Lt",
		size = 22,
		weight = 300,
		antialias = true,
		extended = true
	})

	surface.CreateFont("ixTaskName", {
		font = "Roboto",
		size = 18,
		weight = 300,
		antialias = true,
		extended = true
	})
	surface.CreateFont("ixTaskDesc", {
		font = "Roboto Cn",
		size = 16,
		weight = 300,
		antialias = true,
		extended = true
	})

	local PANEL = {}
	PANEL.minW = 300
	PANEL.minH = 100

	function PANEL:Init()
		if IsValid(ix.gui.quest) then
			ix.gui.quest:Remove()
		end

		ix.gui.quest = self

		timer.Create("ixQuestsFetch", 0.5, 0, function()
			local character = LocalPlayer():GetCharacter()

			if character then
				local quests = character:GetData("quests", {})
				if table.Count(quests) > 0 and !ix.gui.quest:IsVisible() then
					ix.gui.quest:SetVisible(true)
				elseif table.Count(quests) <= 0 then
					if ix.gui.quest:IsVisible() then
						ix.gui.quest:SetVisible(false)
					end
				end
			else
				ix.gui.quest:SetVisible(false)
			end
		end)

		self:SetVisible(false)

		self.quests = {}
		self:SetSize(self.minW, self.minH)
		self:SetPos(ScrW() - self.minW, 10)
		self.title = self:Add("DLabel")
		self.title:SetFont("ixTaskMain")
		self.title:SetText("ЗАДАНИЯ")
		self.title:SizeToContents()
		self.title:Dock(TOP)

		self.container = self:Add("Panel")
		self.container:Dock(TOP)

		self:InvalidateLayout(true)
		self:SizeToChildren(false, true)
	end

	function PANEL:RemoveQuest(id)
		if self.quests[id] then
			self.quests[id]:Remove()
		end

		self.container:InvalidateLayout(true)
		self.container:SizeToChildren(false, true)

		self:InvalidateLayout(true)
		self:SizeToChildren(false, true)
	end

	function PANEL:AddQuest(id, text, value)
		local b = self.container:Add("Panel")
		b:Dock(TOP)
		b:DockMargin(0, 5, 0, 0)
		b:DockPadding(5, 5, 5, 5)
		b.Paint = function(s, w, h)
			surface.SetDrawColor(25, 25, 25, 225)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(90, 90, 90, 255)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local title = b:Add("DLabel")
		title:SetFont("ixTaskName")
		title:SetText(text)
		title:SizeToContents()
		title:Dock(TOP)

		local title = b:Add("DLabel")
		title:SetFont("ixTaskDesc")
		title:DockMargin(0, 2, 0, 0)
		title:SetText("")
		title:SizeToContents()
		title:Dock(TOP)

		local timerID = "ixQuestText"..id
		timer.Create(timerID, 0.25, 0, function()
			if !IsValid(ix.gui.quest) or !IsValid(title) then
				timer.Remove(timerID)
			end

			if IsValid(title) then
				title:SetText(value())
			end
		end)

		b:InvalidateLayout(true)
		b:SizeToChildren(false, true)

		self.quests[id] = b

		self.container:InvalidateLayout(true)
		self.container:SizeToChildren(false, true)

		self:InvalidateLayout(true)
		self:SizeToChildren(false, true)
	end

	vgui.Register("ixQuest", PANEL, "EditablePanel")

	QuestData = QuestData or {}
	QuestData["cwu_garbage"] = {
		title = "Ежедневная работа в ГСР",
		func = function()
			return string.format("Собрать в городе мусор [%s/4]", LocalPlayer():GetCharacter():GetData("cwuGarbage", 0))
		end
	}

	net.Receive("ixUpdateQuests", function(len)
		local character = LocalPlayer():GetCharacter()
		local quests = character:GetData("quests", {})

		if !IsValid(ix.gui.quest) then vgui.Create("ixQuest") end

		ix.gui.quest.container:Clear()
		ix.gui.quest.container:InvalidateLayout(true)
		ix.gui.quest.container:SizeToChildren(false, true)
		ix.gui.quest:InvalidateLayout(true)
		ix.gui.quest:SizeToChildren(false, true)

		if table.Count(quests) > 0 then
			for k, v in pairs(quests) do
				local data = QuestData[k]
				if data then
					ix.gui.quest:AddQuest(k, data.title, data.func)
				end
			end
		end
	end)

	function PLUGIN:CharacterLoaded(character)
		vgui.Create("ixQuest")
	end

	if IsValid(ix.gui.quest) then
		vgui.Create("ixQuest")

		local character = LocalPlayer():GetCharacter()
		local quests = character:GetData("quests", {})

		ix.gui.quest.container:Clear()
		ix.gui.quest.container:InvalidateLayout(true)
		ix.gui.quest.container:SizeToChildren(false, true)
		ix.gui.quest:InvalidateLayout(true)
		ix.gui.quest:SizeToChildren(false, true)

		if table.Count(quests) > 0 then
			for k, v in pairs(quests) do
				local data = QuestData[k]
				if data then
					ix.gui.quest:AddQuest(k, data.title, data.func)
				end
			end
		end
	end
end

