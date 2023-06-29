-- TO DO: CLEAN UP THINGS, ACTIONS MENU FOR AI/SQUAD LEADER, MAKE LABELS WORK

local PANEL = {}
local focus_color = Color(0, 0, 0, 225)
local header_colors = {
	{Color(0, 255, 255), Color(0, 255, 255, 19)},
	{Color(251, 213, 0), Color(251, 213, 0, 19)},
	{Color(255, 29, 93), Color(255, 29, 93, 19)},
}
local code_colors = {
	{Color(102, 255, 102), Color(102, 255, 102, 38)},
	{Color(251, 213, 0), Color(251, 213, 0, 38)},
	{Color(255, 29, 93), Color(255, 29, 93, 38)},
}
local area_color = {Color(255, 255, 255), Color(255, 255, 255, 45)}
local leader_ico = Material("cellar/ui/dispatch/leader.png")

function PANEL:GetHeaderColor(isText)
	return (self.hovered and isText) and focus_color or (self.hovered and header_colors[self.type][1] or (isText and header_colors[self.type][1] or header_colors[self.type][2]))
end

function PANEL:GetCodeColor(isText)
	return (self.hovered and isText) and focus_color or (self.hovered and code_colors[1][1] or (isText and code_colors[1][1] or code_colors[1][2]))
end

function PANEL:GetAreaColor(isText)
	return (self.hovered and isText) and focus_color or (self.hovered and area_color[1] or (isText and area_color[1] or area_color[2]))
end

function PANEL:GetTextColors()
	self.text:SetTextColor(self:GetHeaderColor(true))
	self.hp:SetTextColor(self:GetHeaderColor(true))
	self.code_text:SetTextColor(self:GetCodeColor(true))
	self.area_text:SetTextColor(self:GetAreaColor(true))
end

function PANEL:PaintMain(w, h)
	surface.SetDrawColor(self.parent:GetHeaderColor())
	surface.DrawRect(0, 0, w, h)
end

function PANEL:PaintCode(w, h)
	surface.SetDrawColor(self.parent:GetCodeColor())
	surface.DrawRect(0, 0, w, h)
end

function PANEL:PaintPos(w, h)
	surface.SetDrawColor(self.parent:GetAreaColor())
	surface.DrawRect(0, 0, w, h)
end

function PANEL:PaintLeader(w, h)
	if !self.isLeader then return end
	
	surface.SetDrawColor(self.parent:GetHeaderColor(true))
	surface.SetMaterial(leader_ico)
	surface.DrawTexturedRect(w - 16, h / 2 - 8, 16, 16)
end

function PANEL:Init()
	self:SetText("")
	self:SetTall(25)

	self.tag = "ERROR-1"
	self.hovered = false
	self.type = 1

	self.area = self:Add("Panel")
	self.area:Dock(RIGHT)
	self.area:DockMargin(2, 0, 0, 0)
	self.area:SetMouseInputEnabled(false)
	
	self.area_text = self.area:Add("DLabel")
	self.area_text:Dock(FILL)
	self.area_text:SetContentAlignment(5)

	self.code = self:Add("Panel")
	self.code:Dock(RIGHT)
	self.code:DockMargin(2, 0, 0, 0)
	self.code:SetMouseInputEnabled(false)

	self.code_text = self.code:Add("DLabel")
	self.code_text:Dock(FILL)
	self.code_text:SetContentAlignment(5)

	self.header = self:Add("Panel")
	self.header:Dock(FILL)
	self.header:SetMouseInputEnabled(false)

	self.indicator = self.header:Add("Panel")
	self.indicator:Dock(LEFT)
	self.indicator:DockMargin(0, 0, 5, 0)
	self.indicator:SetWide(self:GetTall())
	self.indicator.isLeader = false

	self.text = self.header:Add("DLabel")
	self.text:Dock(FILL)
	self.text:SetContentAlignment(4)

	self.hp = self.header:Add("DLabel")
	self.hp:DockMargin(0, 0, 5, 0)
	self.hp:Dock(RIGHT)
	self.hp:SetContentAlignment(6)

	self.hp:SetFont("dispatch.camera.button")
	self.text:SetFont("dispatch.camera.button")
	self.code_text:SetFont("dispatch.camera.button")
	self.area_text:SetFont("dispatch.camera.button")

	self.hp:SetText("100%")
	self.code_text:SetText("КОД 1")
	self.area_text:SetText("Н/Д")

	self.area.parent = self
	self.code.parent = self
	self.header.parent = self
	self.indicator.parent = self

	self.area.Paint = self.PaintPos
	self.code.Paint = self.PaintCode
	self.header.Paint = self.PaintMain
	self.indicator.Paint = self.PaintLeader
end

function PANEL:UpdateHealth()
	if self.char then
		local client = self.char:GetPlayer()

		if IsValid(client) then
			local health = client:Health()

			self.hp:SetText(health.."%")

			if health < 31 then
				self.type = 3
			elseif health < 71 then
				self.type = 2
			else
				self.type = 1
			end

			self:GetTextColors()
		end
	end
end

function PANEL:OnCursorEntered()
	self.hovered = true

	self:GetTextColors()
end

function PANEL:OnCursorExited()
	self.hovered = false

	self:GetTextColors()
end

local high = Color(0, 100, 64, 2)
function PANEL:PaintOver(w, h)
	if self.char and self.char == LocalPlayer():GetCharacter() then
		render.OverrideBlend(true, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD, BLEND_DST_ALPHA, BLEND_DST_ALPHA, BLENDFUNC_ADD)

		surface.SetDrawColor(high)
		surface.DrawRect(0, 0, w, h)

		render.OverrideBlend(false)
	end
end
function PANEL:Paint(w, h) end

function PANEL:OpenMenu(target)
	local id = target:GetID()
	local character = LocalPlayer():GetCharacter()

	if target == character then
		return
	end
	
	local squads = self:GetSquad()
	local isLeader = squads:IsLeader(character)
	local isDispatch = dispatch.InDispatchMode(LocalPlayer())

	local menu = DermaMenu() 

	local squad, sub

	if isDispatch or isLeader then
		squad, sub = menu:AddSubMenu("Группа")
		sub:SetImage("icon16/arrow_in.png")

		if !squads:IsStatic() and !self.char:GetSquad():IsLeader(self.char) then
			squad:AddOption("Сделать командиром", function() 
				net.Start("squad.menu.leader")
					net.WriteUInt(id, 32)
				net.SendToServer()
			end):SetImage("icon16/star.png")
		end
	end

	if isDispatch then
		local move, sub = squad:AddSubMenu("Переместить в")
		sub:SetImage("icon16/arrow_right.png")

		for k, v in pairs(dispatch.GetSquads()) do
			if k == self.char:GetSquad().tag then continue end
			
			move:AddOption(k == 1 and "Без группы" or v:GetTagName(), function()
				net.Start("squad.menu.move")
					net.WriteUInt(id, 32)
					net.WriteBool(false)
					net.WriteUInt(k, 5)
				net.SendToServer()
			end)
		end

		move:AddOption("Новая группа", function()
			net.Start("squad.menu.move")
				net.WriteUInt(id, 32)
				net.WriteBool(true)
			net.SendToServer()
		end):SetImage("icon16/add.png")
	else
		if isLeader then
			squad:AddOption("Выгнать", function()
				net.Start("squad.menu.move")
					net.WriteUInt(id, 32)
					net.WriteBool(true)
				net.SendToServer()
			end):SetImage("icon16/cross.png")
		end
	end

	if isDispatch then
		menu:AddOption("Наблюдать", function() 
			net.Start("squad.menu.spectate")
				net.WriteUInt(id, 32)
			net.SendToServer()
		end):SetImage("icon16/zoom.png")

		menu:AddOption("Начислить ОС", function() 
			Derma_StringRequest(
				target:GetName(), 
				"Введите желаемое количество очков стерелизации для выдачи (положительное или отрицательное)",
				"3",
				function(value) 
					local points = tonumber(value)

					if points then
						Derma_StringRequest(
							target:GetName(), 
							"Укажите причину",
							"без причины",
							function(text) 
								net.Start("squad.menu.reward")
									net.WriteUInt(id, 32)
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

	menu:AddSpacer()
	menu:AddOption("Открыть личное дело", function() 
		net.Start("squad.menu.datafile")
			net.WriteUInt(id, 32)
		net.SendToServer()
	end):SetImage("icon16/book_open.png")
	menu:Open()
end

function PANEL:PerformLayout(w, h)

	self.code:SetWide(w * 0.15)
	self.area:SetWide(w * 0.25)

	self.header:SetWide(w - self.area:GetWide() - self.code:GetWide())
end

function PANEL:GetSquad()
	return self:GetParent():GetParent().squad
end

function PANEL:SetCharacter(char)
	local squad = self:GetSquad()
	local rank = ix.class.list[char:GetClass()].tag

	self.char = char
	self.tag = string.format("%s%s-%i", rank and rank.."." or "", squad:GetTagName(), squad.members[char] or 0)
	self.text:SetText(self.tag)

	self:GetTextColors()

	self.indicator.isLeader = squad:IsLeader(char)

	self.DoClick = function() self:OpenMenu(char) end
	self.DoRightClick = function() self:OpenMenu(char) end
end

vgui.Register("squad.member.button", PANEL, "DButton")