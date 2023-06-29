local KEYWORD_NPCNAME = "$NPC$"
local KEYWORD_YOURNAME = "$YOU$"

local function ParseText(text)
	text = text or ""
	
	if text:sub(1, 1) == "@" then
		text = L(text:sub(2))
	end

	if IsValid(ix.gui.dialogue.npc) then text = text:Replace(KEYWORD_NPCNAME, ix.gui.dialogue.npc:GetName()) end
	text = text:Replace(KEYWORD_YOURNAME, LocalPlayer():GetName())

	return text
end

local PANEL = {}
function PANEL:Init()
	self:SetWrap(true)
	self:SetAutoStretchVertical(true)
	self:SetContentAlignment(7)
	self:SetFont("dlgButton")
	self.color = color_white
	self.colorDown = color_white
	self.colorHover = color_white
end

local clr = color_white
function PANEL:Paint()
	if self:IsDown() then 
		clr = self.colorDown
	elseif self.Hovered then 
		clr = ColorAlpha(self.colorHover, 155 + (1 + math.sin(SysTime() * 8)) * 100)
	else
		clr = self.color
	end

	self:SetTextColor(clr)
end

function PANEL:SetBtnColors(clr)
	self.color = table.Copy(clr)

	self.colorDown = table.Copy(clr)
	self.colorDown.r = math.max(self.colorDown.r - 64, 0)
	self.colorDown.g = math.max(self.colorDown.g - 64, 0)
	self.colorDown.b = math.max(self.colorDown.b - 64, 0)

	self.colorHover = table.Copy(clr)
end

function PANEL:IsDown()
	return self.Depressed
end

vgui.Register("dialogChoice", PANEL, "DButton")


PANEL = {}
function PANEL:Init()
	self.left = self:Add("Panel")
	self.left:Dock(LEFT)
	self.left:DockMargin(64, 0, 0, 0)

	self.right = self:Add("Panel")
	self.right:Dock(FILL)
	self.right:DockMargin(10, 7, 10, 0)

	self.mdlIcon = self.left:Add("SpawnIcon")
	self.mdlIcon:SetSize(64, 128)
	self.mdlIcon:InvalidateLayout(true)
	self.mdlIcon:SetMouseInputEnabled(false)
	self.mdlIcon.DoClick = function() end

	self.choices = {}
end

local clr = ColorAlpha(color_white, 16)
function PANEL:Paint(w, h) 
	surface.SetDrawColor(clr)
	surface.DrawLine(64, 0, w - 32, 0)
end

function PANEL:CalculateSize()
    local h = 12
    
    for k, v in pairs(self.choices) do
        h = h + v:GetTall() + 8
    end
    
    h = math.max(h, 128)
    
    self:SetTall(h)
end

function PANEL:PerformLayout(w, h)
    self:CalculateSize()
end

function PANEL:Setup(clr, model)
	self.mdlIcon:SetModel(model)
	self.color = clr
end

function PANEL:SetChoices(choices)
	self.right:Clear()
	self.choices = {}

	if table.Count(choices) <= 0 then
		return
	end

	local i = 1
	for k, v in SortedPairsByMemberValue(choices, "priority") do
		local btn = self.right:Add("dialogChoice")
		btn:Dock(TOP)
		btn:DockMargin(0, 0, 0, 8)
		btn:SetText(string.format("%s. %s", i, ParseText(v.label)))
		btn:SizeToContents()
		btn:SetBtnColors(self.color)
		btn.DoClick = function(this)
			if IsValid(ix.gui.dialogue) then
				ix.gui.dialogue:DoChoice(k)
			end
		end

		self.choices[k] = btn
		i = i + 1
	end

	self:InvalidateLayout()
end

vgui.Register("dialogPlayer.Panel", PANEL, "Panel")


PANEL = {}

function PANEL:Init()
	self.left = self:Add("Panel")
	self.left:Dock(LEFT)

	self.right = self:Add("Panel")
	self.right:Dock(FILL)
	self.right:DockMargin(10, 5, 10, 0)

	self.mdlIcon = self.left:Add("SpawnIcon")
	self.mdlIcon:SetSize(64, 128)
	self.mdlIcon:InvalidateLayout(true)
	self.mdlIcon:SetMouseInputEnabled(false)
	self.mdlIcon.DoClick = function() end

	self.npcName = self.right:Add("DLabel")
	self.npcName:Dock(TOP)
	self.npcName:SetFont("dlgTitle")
	self.npcName:SetText("")
	self.npcName:SizeToContents()

	self.npcText = self.right:Add("DLabel")
	self.npcText:Dock(FILL)
	self.npcText:DockMargin(8, 2, 2, 0)
	self.npcText:SetWrap(true)
	self.npcText:SetAutoStretchVertical(true)
	self.npcText:SetFont("dlgText")
	self.npcText:SetText("")
	self.npcText:SetTextColor(ix.config.Get("chatColor"))
end

function PANEL:Paint(w, h) end

function PANEL:CalculateSize()
	local h = 10

	h = h + self.npcName:GetTall()
	h = h + self.npcText:GetTall()

	h = math.max(h, 128)

	self:SetTall(h)
end

function PANEL:PerformLayout(w, h)
    self:CalculateSize()
end

function PANEL:Setup(clr, name, model, text)
	self.mdlIcon:SetModel(model)

	if isvector(clr) then
		clr = clr:ToColor()
	end

	self.npcName:SetTextColor(clr)
    self.npcName:SetText(name)
    self.npcName:SizeToContents()

    if text then
    	self:SetResponse(text)
    end
end

function PANEL:SetResponse(text)
    self.npcText:SetText(text)
    self.npcText:SizeToContents()

    timer.Simple(0.1, function() 
    	self:InvalidateLayout()
    end)
end

vgui.Register("dialogNPC.Panel", PANEL, "Panel")


PANEL = {}
function PANEL:Init()
	if IsValid(ix.gui.dialogue) then
		ix.gui.dialogue:Remove()
	end

	ix.gui.dialogue = self

	local screenW, screenH = ScrW(), ScrH()
	local w, h = (screenW * 0.6 + 40), (screenH - (screenH / 1.75))

	self:SetSize(w, h)
	self:SetPos(screenW / 2 - w / 2, screenH + h)

	self.Animate = function(this)
		this:MoveTo(screenW / 2 - w / 2, (screenH / 1.75) + 1, 0.5)
	end

	self.scroll = self:Add("DScrollPanel")
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(20, 20, 20, 0)
	self.scroll:GetVBar().btnGrip.Paint = function(panel, width, height)
		local parent = panel:GetParent()
		local upButtonHeight = parent.btnUp:GetTall()
		local downButtonHeight = parent.btnDown:GetTall()

		DisableClipping(true)
			surface.SetDrawColor(72, 72, 72, 128)
			surface.DrawRect(5, -upButtonHeight, width - 10, height + upButtonHeight + downButtonHeight)
		DisableClipping(false)
	end

	self.npcPanel = self.scroll:Add("dialogNPC.Panel")
	self.npcPanel:Dock(TOP)

	self.playerPanel = self.scroll:Add("dialogPlayer.Panel")
	self.playerPanel:Dock(TOP)
	self.playerPanel:DockMargin(0, 5, 0, 0)

	self.dialog = {}
	self.Topics = {}
	self.currentTopic = false
end

function PANEL:GetTopics(id)
	return #((self.Topics[id] or {}).choices or {})
end

function PANEL:RemoveTopic(fromID, ID)
	for k, v in pairs((self.Topics[fromID] or {}).choices) do
		if v == ID then
			table.remove(self.Topics[fromID].choices, k)
		end
	end
end

function PANEL:DoChoice(id)
	self.dialogue:OnSelectChoice(id)
end

function PANEL:Exit()
	ix.gui.dialogue:Remove()
	ix.gui.dialogue = nil
end

function PANEL:OpenNPC(dialog, npc, name, npcColor, npcModel)
	self.dialogue = dialog
	self.npcPanel:Setup(npcColor, name, npcModel or npc:GetModel())
	self.playerPanel:Setup(team.GetColor(LocalPlayer():Team()), LocalPlayer():GetModel())
end

function PANEL:BuildTopic(id, forceRefresh)
	if !forceRefresh and self.currentTopic == id then
		return
	end

	local response = self.dialogue:GetLabel(self.dialogue:GetTopic(id).response)

	if response != "" then
		self.npcPanel:SetResponse(ParseText(response))
	end

	self.playerPanel:SetChoices(self.dialogue.availableTopics)
	self.currentTopic = id

	self.npcPanel:InvalidateLayout()
	self.playerPanel:InvalidateLayout()
end

local bg = Material("dialogui/bg.png")
local leftcorner = Material("dialogui/border_lcorner.png")
local rightcorner = Material("dialogui/border_rcorner.png")
local left = Material("dialogui/border_left.png")
local right = Material("dialogui/border_right.png")
local top = Material("dialogui/border_up.png")
local iconSize = 48
function PANEL:Paint(w, h)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(bg)
	surface.DrawTexturedRect(18, 18, w - 36, h)

	do
		surface.SetMaterial(leftcorner)
		surface.DrawTexturedRect(0, 0, iconSize, iconSize)

		surface.SetMaterial(left)
		surface.DrawTexturedRect(7, iconSize, 14, h - iconSize)

		surface.SetMaterial(top)
		surface.DrawTexturedRect(iconSize, 7, w - (iconSize * 2), 14)

		surface.SetMaterial(rightcorner)
		surface.DrawTexturedRect(w - iconSize, 0, iconSize, iconSize)

		surface.SetMaterial(right)
		surface.DrawTexturedRect(w - 14 - 7, iconSize, 14, h - iconSize)
	end
end

vgui.Register("dialog.Main", PANEL, "Panel")

if IsValid(ix.gui.dialogue) then
	ix.gui.dialogue:Remove()
end