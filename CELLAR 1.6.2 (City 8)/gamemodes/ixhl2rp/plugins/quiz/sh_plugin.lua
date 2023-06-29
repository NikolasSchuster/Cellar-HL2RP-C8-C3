PLUGIN.name = "Quiz Menu"
PLUGIN.author = ""
PLUGIN.description = ""

ix.util.Include("sv_plugin.lua")

if SERVER then
	return
end

local function SScaleMin(size)
	return math.min(ScreenScale(size), size * (ScrH() / 360.0))
end

local PANEL = {}
local questions = {
	[1] = {
		"В какой город вы приехали?",
		{"Сити-17", "Сити-8", "Сити-3", "Токио"}
	},
	[2] = {
		"В вселенной какой игры вы находитесь?",
		{"Half-Life", "Portal", "1984", "Реальная жизнь"}
	},
	[3] = {
		"Как выглядит правильное оформление имени и фамилии пероснажа?",
		{"Денис", "Мясной", "Денис Матковкий или Denis Matkovsky", "Нейт Хиггерс или Nate Higgers"}
	},
	[4] = {
		"Что нужно прежде всего для ролевой игры?",
		{"Нужно много предметов.", "Игрового чата вполне себе достаточно, чтобы отыгрывать роль.", "Нужно получить какой-либо вайтлист, чтобы начать играть.", "Я Мясной."}
	}
}

function PANEL:Init()
	ix.gui.quizAnswering = self

	self.comboboxes = {}
	
	local scale = SScaleMin(700 / 3)

    self:SetSize(scale, scale)
	self:Center()
    self:SetDeleteOnClose(true)
    self:MakePopup()
	
	self.container = self:Add("DScrollPanel")
	self.container:Dock(FILL)

	self:SetTitle("Ответьте на вопросы, прежде чем продолжить")
	self.lblTitle:SizeToContents()
end

function PANEL:Think()
	self:MoveToFront()
end

function PANEL:CreateQuizContent()
	local scale = SScaleMin(20 / 3)

	for k, table in ipairs(questions) do
		local question = table[1]
		local answers = table[2]
				
		local questionTitle = self.container:Add("DLabel")
		questionTitle:Dock(TOP)
		questionTitle:SetText(question or "")
		questionTitle:SetContentAlignment(5)
		questionTitle:DockMargin(scale, k == 1 and scale or 0, scale, SScaleMin(10 / 3))
		questionTitle:SetWrap(true)
		questionTitle:SetAutoStretchVertical(true)
		
		local answerPanel = self.container:Add("DComboBox")
		answerPanel:Dock(TOP)
		answerPanel:DockMargin(scale, 0, scale, scale)
		answerPanel:SetTall(SScaleMin(30 / 3))
		answerPanel:SetValue("Выберите ответ")
		answerPanel.question = k
		answerPanel:SetSortItems(false)
		answerPanel:SetContentAlignment(5)
		answerPanel.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 180)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetDrawColor(180, 180, 180, 2)
			surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
		end
		answerPanel.Think = function(self)
			if IsValid(self.Menu) then
				self.Menu:MoveToFront()
			end
		end

		for _, answer in ipairs(table[2]) do
			answerPanel:AddChoice(answer or "")
		end
		
		self.comboboxes[#self.comboboxes + 1] = answerPanel
	end
	
	local panel = self.container:Add("Panel")
	panel:Dock(TOP)
	panel:DockMargin(scale, 0, scale, SScaleMin(10 / 3))
	panel:SetTall(SScaleMin(60 / 3))

	local panelText = panel:Add("DLabel")
	panelText:SetText("Не уверены в ответе? Ознакомьтесь с информацией в нашем гайде:")
	panelText:SetTextColor(Color(100, 200, 255))
	panelText:Dock(TOP)
	panelText:SetContentAlignment(4)
	panelText:SizeToContents()
	
	local guide = panel:Add("DButton")
	guide:Dock(TOP)
	guide:SetText("ОТКРЫТЬ ВИДЕО-ГАЙД")
	guide:DockMargin(0, SScaleMin(10 / 3), 0, 0)
	guide:SetTall(SScaleMin(30 / 3))
	guide.DoClick = function()
		surface.PlaySound("helix/ui/press.wav")
		gui.OpenURL("https://www.youtube.com/watch?v=FwuQILSwWXE")
	end

	local finish = self:Add("DButton")
	finish:Dock(BOTTOM)
	finish:SetText("ГОТОВО")
	finish:DockMargin(0, scale, 0, 0)
	finish:SetTall(SScaleMin(50 / 3))
	finish.DoClick = function()
		surface.PlaySound("helix/ui/press.wav")
		self:SendAnswers()
	end
end

function PANEL:SendAnswers()	
	local answers = {}
	
	for _, v in ipairs(self.comboboxes) do
		answers[v.question] = answers[v.question] or 0

		if v:GetSelected() and v:GetSelected() != "" and v:GetSelected() != "Выберите ответ" then
			answers[v.question] = v:GetSelectedID()
		end
	end
	
	netstream.Start("ixSendQuiz", answers)
end

vgui.Register("ixQuizMenu", PANEL, "DFrame")

net.Receive("ixRemoveQuiz", function()
	if ix.gui.quizAnswering and IsValid(ix.gui.quizAnswering) then
		ix.gui.quizAnswering:Remove()
	end
end)