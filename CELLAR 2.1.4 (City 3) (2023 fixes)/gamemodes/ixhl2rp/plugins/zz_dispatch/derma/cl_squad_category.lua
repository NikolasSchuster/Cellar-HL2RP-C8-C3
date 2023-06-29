-- TO DO: CLEAN UP THINGS
local PANEL = {}
PANEL.HeaderSize = 28
PANEL.clr = {
	Color(0, 240, 255, 255),
	Color(0, 0, 0, 255),
	Color(255, 255, 255, 200),
	Color(255, 255, 255)
}

function PANEL:Init()
	self.HeaderSize = PANEL.HeaderSize

	self.header = self:Add("Panel")
	self.header:Dock(TOP)
	self.header:SetTall(PANEL.HeaderSize)
	self.header.Paint = function(_, w, h)
		self:HeaderPaint(w, h)
	end

	self.btn = self.header:Add("DButton")
	self.btn:Dock(FILL)
	self.btn:SetText("")
	self.btn.Paint = function() end
	self.btn.DoClick = function()
		self:OnExpand()
	end

	self.join = self.header:Add("DButton")
	self.join:Dock(RIGHT)
	self.join:SetText("")
	self.join:SetWide(24)
	self.join.Paint = function(_, w, h)
		self:JoinPaint(w, h, _)
	end

	self.join.DoClick = function()
		self:OnJoin()
	end

	self.subcontainer = self:Add("Panel")
	self.subcontainer:Dock(FILL)
	self.subcontainer:DockMargin(0, 0, 0, 0)

	self:SetTall(PANEL.HeaderSize)

	self.squad = nil
	self.expanded = false
	self.targetSize = PANEL.HeaderSize
	self.lastTargetSize = self.targetSize
	self.members = {}
end

function PANEL:OnExpand()
	self:SizeTo(-1, self.expanded and PANEL.HeaderSize or self.targetSize, 0.025, 0, -1, function()
		self.expanded = !self.expanded
	end)
end

function PANEL:OnJoin()
	ix.command.Send("SquadJoin", self.squad.tag)
end

function PANEL:RemoveMember(char)
	if IsValid(self.members[char]) then
		self.members[char]:Remove()
		self.members[char] = nil
	end
	
	self.subcontainer:InvalidateLayout(true)
	self.subcontainer:SizeToChildren(false, true)

	self.targetSize = PANEL.HeaderSize + self.subcontainer:GetTall()

	self:SetTall(self.targetSize)

	self.lastTargetSize = self.targetSize

	if self.expanded then
		self:SetTall(self.targetSize)
	end

	self:SortMembers()
end

function PANEL:SortMembers()
	local x = 1
	local leader

	for char, i in SortedPairsByValue(self.squad.members, true) do
		if self.members[char] then
			self.members[char]:SetZPos(-x)

			if self.members[char].indicator.isLeader then
				leader = self.members[char]
			end
			
			x = x + 1
		end
	end

	if leader then
		leader:SetZPos(-x - 1)
	end
end

function PANEL:AddMember(char)
	local a = self.subcontainer:Add("squad.member.button")
	a:DockMargin(0, 2, 0, 0)
	a:Dock(TOP)
	a:SetCharacter(char)

	self.subcontainer:InvalidateLayout(true)
	self.subcontainer:SizeToChildren(false, true)

	self.targetSize = PANEL.HeaderSize + self.subcontainer:GetTall()

	self:SetTall(self.targetSize)

	self.lastTargetSize = self.targetSize

	self.members[char] = a

	self:SortMembers()
end

function PANEL:SetLeader(char)
	for k, v in pairs(self.members) do
		v.indicator.isLeader = k == char
	end

	self:SortMembers()
end

function PANEL:SetupSquad(tag)
	if tag == 1 then
		self.isStatic = true
	end
	
	self.squad_tag = tag
	self.squad = nil
	self.data = {
		name = "",
		count = 0
	}

	self:SetVisible(false)
end

function PANEL:SetupSquadFull(squad)
	if squad.isStatic then
		self.isStatic = true
	end

	self.squad = squad
	self.data = {
		name = self.isStatic and "БЕЗ ПГ" or "ПГ "..squad:GetTagName(),
		count = squad:GetLimitCount(),
		format = "%i / "..(self.isStatic and "∞" or "5")
	}

	for char, _ in pairs(squad.members) do
		self:AddMember(char)
	end

	self:SetVisible(squad.member_counter > 0)
	self:UpdateSquadInfo()

	self.btn.DoRightClick = function() self:OpenMenu(self.squad) end
end

function PANEL:OpenMenu(squad)
	if squad:IsStatic() then
		return
	end

	local character = LocalPlayer():GetCharacter()
	local isLeader = self.squad:IsLeader(character)
	local isDispatch = dispatch.InDispatchMode(LocalPlayer())

	local menu = DermaMenu() 

	if isDispatch or isLeader then
		menu:AddOption("Расформировать", function() 
			net.Start("squad.menu.disband")
				net.WriteUInt(squad.tag, 5)
			net.SendToServer()
		end):SetImage("icon16/cross.png")
	end

	if isDispatch then
		menu:AddOption("Начислить ОС всей группе", function() 
			Derma_StringRequest(
				squad:GetTagName(), 
				"Введите желаемое количество очков стерелизации для выдачи КАЖДОМУ члену патрульной группы (положительное или отрицательное)",
				"3",
				function(value) 
					local points = tonumber(value)

					if points then
						Derma_StringRequest(
							squad:GetTagName(), 
							"Укажите причину",
							"без причины",
							function(text) 
								net.Start("squad.menu.rewardall")
									net.WriteUInt(squad.tag, 5)
									net.WriteInt(points, 32)
									net.WriteString(text)
								net.SendToServer()
							end,
							nil,
							"Применить",
							"Отмена"
						)
					end
				end,
				nil,
				"Далее",
				"Отмена"
			)
		end):SetImage("icon16/award_star_add.png")
	end

	menu:Open()
end

function PANEL:UpdateSquadInfo()
	self.data.count = self.squad:GetLimitCount()
end

function PANEL:JoinPaint(w, h, btn)
	draw.SimpleText("+", "ixSquadTitle", w / 2, h / 2, btn:IsHovered() and self.clr[4] or self.clr[1], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:HeaderPaint(w, h)
	surface.SetDrawColor(self.clr[1])
	surface.DrawRect(0, h - 1, w, 1)

	draw.SimpleText(self.data.name, "ixSquadTitle", 8, h / 2, self.clr[1], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText(string.format(self.data.format, self.data.count), "ixSquadTitleSmall", w - 72, h / 2, self.clr[1], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
end

vgui.Register("squadCategoryBtn", PANEL, "EditablePanel")
