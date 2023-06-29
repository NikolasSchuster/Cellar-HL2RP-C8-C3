
local initialIcon = Material("flags32/flag_gb.png", "smooth")
-- change if different with one in chatbox plugin
local chatBorder = 32
local indentFromChat = 4
local flagMargin = 2

local PANEL = {}

function PANEL:Init()
	ix.gui.languageChatButton = self

	self.flag = self:Add("DImageButton")
	self.flag:Dock(FILL)
	self.flag:DockMargin(flagMargin, flagMargin, flagMargin, flagMargin)
	self.flag.DoClick = function(this)
		if (IsValid(self.frame)) then
			self.frame:Remove()
			self.frame = nil
		end

		local client = LocalPlayer()
		local character = client:GetCharacter()

		if (character) then
			local studiedLanguages = character:GetStudiedLanguages()
			local chatLanguages = {}

			for k, _ in pairs(studiedLanguages) do
				chatLanguages[k] = ix.chatLanguages.Get(k)
				chatLanguages[k].bNotLearnable = nil
			end

			if (!table.IsEmpty(chatLanguages)) then
				self.frame = vgui.Create("DFrame")
				self.frame:SetTitle(L("optLanguage"))
				self.frame:SetSizable(true)
				self.frame:SetWide(ScrW() * 0.15)

				self.languageSelecter = self.frame:Add("ixLanguageSelecter")
				self.languageSelecter:Dock(FILL)
				self.languageSelecter:SetLanguageList(chatLanguages)
				self.languageSelecter.OnLanguageSelect = function(_, id)
					net.Start("ixCharacterChangeUsedLanguage")
						net.WriteString(id)
					net.SendToServer()

					self.frame:Close()
				end
				self.languageSelecter.OnLanguageDeselect = function()
					net.Start("ixCharacterChangeUsedLanguage")
					net.SendToServer()

					self.frame:Close()
				end

				local usedLanguage = character:GetUsedLanguage()
				local languageData =  ix.chatLanguages.Get(usedLanguage)

				if (languageData) then
					local languageName = L(languageData.name):utf8lower()

					for _, v in ipairs(self.languageSelecter:GetLanguageList()) do
						local text = v.name:GetText()

						if (languageName == text:utf8lower()) then
							self.languageSelecter.selectedPanel = v

							break
						end
					end
				end

				local maxHeight = ScrH() * 0.25
				local _, topPadding, _, bottomPadding = self.frame:GetDockPadding()
				local targetHeight = topPadding + bottomPadding + self.languageSelecter:GetChildrenHeight()

				if (targetHeight <= maxHeight) then
					self.frame:SetTall(targetHeight)
				elseif (targetHeight > maxHeight) then
					self.frame:SetTall(maxHeight)
				end

				self.frame:Center()
				self.frame:MakePopup()
			end
		end
	end

	self:SetAlpha(0)
	self.alpha = 0

	self:SetSize(chatBorder, chatBorder)
	self:CorrectPosition()
end

function PANEL:CorrectPosition(chatX, chatY, chatW, chatH)	
	if (!chatX or !chatY or !chatW or !chatH) then
		local chatbox = ix.gui.chat

		chatX, chatY = chatbox:GetPos()
		chatW, chatH = chatbox:GetSize()
	end

	local selfW, selfH = self:GetSize()

	local overChatX = chatX + chatW + indentFromChat
	local chatLevelX = chatX + chatW - selfW
	local underChatY = chatY + chatH + indentFromChat

	if (overChatX + selfW <= ScrW()) then
		self:SetPos(overChatX, chatY + chatH - selfH)
	elseif (underChatY + selfH <= ScrH()) then
		self:SetPos(chatLevelX, underChatY)
	else
		self:SetPos(chatLevelX, chatY - selfH - indentFromChat)
	end
end

function PANEL:ChangeFlagIcon(character, usedLanguage)
	usedLanguage = usedLanguage or character:GetUsedLanguage()
	local languageData = ix.chatLanguages.Get(usedLanguage)
	local icon

	if (languageData and character:CanSpeakLanguage(usedLanguage)) then
		icon = languageData.panelIcon
	else
		icon = initialIcon
	end

	self.flag:SetMaterial(icon)
end

function PANEL:Paint(width, height)
	ix.util.DrawBlur(self)

	surface.SetDrawColor(color_black:Unpack())
	self:DrawOutlinedRect()

	local newAlpha = ix.gui.chat.alpha

	if (self.alpha != newAlpha) then
		self:SetAlpha(newAlpha)

		self.alpha = newAlpha
	end
end

vgui.Register("ixLanguageChatButton", PANEL, "Panel")
