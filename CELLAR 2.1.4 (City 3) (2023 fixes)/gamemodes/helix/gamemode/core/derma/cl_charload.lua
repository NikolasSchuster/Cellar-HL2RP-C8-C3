
local errorModel = "models/error.mdl"
local PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)

local function SetCharacter(self, character)
	self.character = character

	if (character) then
		self:SetModel(character:GetModel())
		self:SetSkin(character:GetData("skin", 0))

		for i = 0, (self:GetNumBodyGroups() - 1) do
			self:SetBodygroup(i, 0)
		end

		local bodygroups = character:GetData("bgcache", nil)

		if (istable(bodygroups)) then
			for k, v in pairs(bodygroups) do
				self:SetBodygroup(k, v)
			end
		end
	else
		self:SetModel(errorModel)
	end
end

local function GetCharacter(self)
	return self.character
end

function PANEL:Init()
	self.activeCharacter = ClientsideModel(errorModel)
	self.activeCharacter:SetNoDraw(true)
	self.activeCharacter.SetCharacter = SetCharacter
	self.activeCharacter.GetCharacter = GetCharacter

	self.lastCharacter = ClientsideModel(errorModel)
	self.lastCharacter:SetNoDraw(true)
	self.lastCharacter.SetCharacter = SetCharacter
	self.lastCharacter.GetCharacter = GetCharacter

	self.animationTime = 0.5

	self.shadeY = 0
	self.shadeHeight = 0

	self.cameraPosition = Vector(80, 0, 35)
	self.cameraAngle = Angle(0, 180, 0)
	self.lastPaint = 0
end

function PANEL:ResetSequence(model, lastModel)
	local sequence = model:LookupSequence("idle_unarmed")

	if (sequence <= 0) then
		sequence = model:SelectWeightedSequence(ACT_IDLE)
	end

	if (sequence > 0) then
		model:ResetSequence(sequence)
	else
		local found = false

		for _, v in ipairs(model:GetSequenceList()) do
			if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
				model:ResetSequence(v)
				found = true

				break
			end
		end

		if (!found) then
			model:ResetSequence(4)
		end
	end

	model:SetIK(false)

	-- copy cycle if we can to avoid a jarring transition from resetting the sequence
	if (lastModel) then
		model:SetCycle(lastModel:GetCycle())
	end
end

function PANEL:RunAnimation(model)
	model:FrameAdvance((RealTime() - self.lastPaint) * 0.5)
end

function PANEL:LayoutEntity(model)
	model:SetIK(false)

	self:RunAnimation(model)
end

function PANEL:SetActiveCharacter(character)
	self.shadeY = self:GetTall()
	self.shadeHeight = self:GetTall()

	-- set character immediately if we're an error (something isn't selected yet)
	if (self.activeCharacter:GetModel() == errorModel) then
		self.activeCharacter:SetCharacter(character)
		self:ResetSequence(self.activeCharacter)

		return
	end

	-- if the animation is already playing, we update its parameters so we can avoid restarting
	local shade = self:GetTweenAnimation(1)
	local shadeHide = self:GetTweenAnimation(2)

	if (shade) then
		shade.newCharacter = character
		return
	elseif (shadeHide) then
		shadeHide.queuedCharacter = character
		return
	end

	self.lastCharacter:SetCharacter(self.activeCharacter:GetCharacter())
	self:ResetSequence(self.lastCharacter, self.activeCharacter)

	shade = self:CreateAnimation(self.animationTime * 0.5, {
		index = 1,
		target = {
			shadeY = 0,
			shadeHeight = self:GetTall()
		},
		easing = "linear",

		OnComplete = function(shadeAnimation, shadePanel)
			shadePanel.activeCharacter:SetCharacter(shadeAnimation.newCharacter)
			shadePanel:ResetSequence(shadePanel.activeCharacter)

			shadePanel:CreateAnimation(shadePanel.animationTime, {
				index = 2,
				target = {shadeHeight = 0},
				easing = "outQuint",

				OnComplete = function(animation, panel)
					if (animation.queuedCharacter) then
						panel:SetActiveCharacter(animation.queuedCharacter)
					else
						panel.lastCharacter:SetCharacter(nil)
					end
				end
			})
		end
	})

	shade.newCharacter = character
end

function PANEL:Paint(width, height)
	local x, y = self:LocalToScreen(0, 0)
	local bTransition = self.lastCharacter:GetModel() != errorModel
	local modelFOV = (ScrW() > ScrH() * 1.8) and 92 or 70

	cam.Start3D(self.cameraPosition, self.cameraAngle, modelFOV, x, y, width, height)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(self.activeCharacter:GetPos())

		-- setup lighting
		render.SetModelLighting(0, 1.5, 1.5, 1.5)

		for i = 1, 4 do
			render.SetModelLighting(i, 0.4, 0.4, 0.4)
		end

		render.SetModelLighting(5, 0.04, 0.04, 0.04)

		-- clip anything out of bounds
		local curparent = self
		local rightx = self:GetWide()
		local leftx = 0
		local topy = 0
		local bottomy = self:GetTall()
		local previous = curparent

		while (curparent:GetParent() != nil) do
			local lastX, lastY = previous:GetPos()
			curparent = curparent:GetParent()

			topy = math.Max(lastY, topy + lastY)
			leftx = math.Max(lastX, leftx + lastX)
			bottomy = math.Min(lastY + previous:GetTall(), bottomy + lastY)
			rightx = math.Min(lastX + previous:GetWide(), rightx + lastX)

			previous = curparent
		end

		ix.util.ResetStencilValues()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(30)
			render.SetStencilTestMask(30)
			render.SetStencilReferenceValue(31)

			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)

			self:LayoutEntity(self.activeCharacter)

			if (bTransition) then
				-- only need to layout while it's used
				self:LayoutEntity(self.lastCharacter)

				render.SetScissorRect(leftx, topy, rightx, bottomy - (self:GetTall() - self.shadeHeight), true)
				self.lastCharacter:DrawModel()

				render.SetScissorRect(leftx, topy + self.shadeHeight, rightx, bottomy, true)
				self.activeCharacter:DrawModel()

				render.SetScissorRect(leftx, topy, rightx, bottomy, true)
			else
				self.activeCharacter:DrawModel()
			end

			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilPassOperation(STENCIL_KEEP)

			cam.Start2D()
				derma.SkinFunc("PaintCharacterTransitionOverlay", self, 0, self.shadeY, width, self.shadeHeight)
			cam.End2D()
		render.SetStencilEnable(false)

		render.SetScissorRect(0, 0, 0, 0, false)
		render.SuppressEngineLighting(false)
	cam.End3D()

	self.lastPaint = RealTime()
end

function PANEL:OnRemove()
	self.lastCharacter:Remove()
	self.activeCharacter:Remove()
end

vgui.Register("ixCharMenuCarousel", PANEL, "Panel")

-- character load panel
PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "backgroundFraction", "BackgroundFraction", FORCE_NUMBER)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 102 or 78

	self.animationTime = 1
	self.backgroundFraction = 1

	-- main panel
	self.panel = self:AddSubpanel("main")
	self.panel:SetTitle("loadTitle")
	self.panel.OnSetActive = function()
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 1},
			easing = "outQuint",
		})
	end

	-- character button list
	local controlList = self.panel:Add("Panel")
	controlList:Dock(LEFT)
	controlList:SetSize(halfWidth, halfHeight)

	local back = controlList:Add("ixMenuButton")
	back:Dock(BOTTOM)
	back:SetFont('cellar.buttonsize')
	back:SetText("")
	back:SizeToContents()
	back.DoClick = function()
		self:SlideDown()
		parent.mainPanel:Undim()
	end
	back.Paint = function(me, w, h)
		local gradient = surface.GetTextureID("vgui/gradient-d")
		local gradientUp = surface.GetTextureID("vgui/gradient-u")
		local gradientLeft = surface.GetTextureID("vgui/gradient-l")
		local gradientRadial = Material("helix/gui/radial-gradient.png")
		
		surface.SetFont('cellar.main.btn')
		local hov = me:IsHovered()
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 25) or ColorAlpha(cellar_darker_blue, 43))
		surface.SetTexture(gradientLeft)
		surface.DrawTexturedRect(0, 0, w, h)
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 255) or ColorAlpha(cellar_blue, 255))
		surface.DrawTexturedRect(0, 0, w, 1)
		surface.DrawTexturedRect(0, h - 1, w, 1)
		
		draw.RoundedBox(0, 0, 0, 4, h, hov and cellar_red or cellar_blue)

		draw.SimpleText("ВЕРНУТЬСЯ", "cellar.main.btn", 12, h/2, hov and cellar_red or cellar_blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("ВЕРНУТЬСЯ", "cellar.main.btn.blur", 12, h/2, hov and cellar_red or cellar_blur_blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.characterList = controlList:Add("ixCharMenuButtonList")
	self.characterList.buttons = {}
	self.characterList:Dock(FILL)

	-- right-hand side with carousel and buttons
	local infoPanel = self.panel:Add("Panel")
	infoPanel:Dock(FILL)

	local infoButtons = infoPanel:Add("Panel")
	infoButtons:Dock(BOTTOM)
	infoButtons:SetTall(back:GetTall()) -- hmm...

	local continueButton = infoButtons:Add("ixMenuButton")
	continueButton:Dock(FILL)
	continueButton:SetText("")
	continueButton:SetFont('cellar.buttonsize')
	continueButton:SetContentAlignment(6)
	continueButton:SizeToContents()
	continueButton.DoClick = function()
		self:SetMouseInputEnabled(false)
		self:Slide("down", self.animationTime, function()
			net.Start("ixCharacterChoose")
				net.WriteUInt(self.character:GetID(), 32)
			net.SendToServer()
		end, true)
	end
	continueButton.Paint = function(me, w, h)
		local gradient = surface.GetTextureID("vgui/gradient-d")
		local gradientUp = surface.GetTextureID("vgui/gradient-u")
		local gradientLeft = surface.GetTextureID("vgui/gradient-l")
		local gradientRadial = Material("helix/gui/radial-gradient.png")
		
		surface.SetFont('cellar.main.btn')
		local hov = me:IsHovered()
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 25) or ColorAlpha(cellar_darker_blue, 43))
		surface.SetTexture(gradientLeft)
		surface.DrawTexturedRectRotated(w * .5 - 1, h * .5, w, h, 180)
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 255) or ColorAlpha(cellar_blue, 255))
		surface.DrawTexturedRectRotated(w * .5 - 1, 0, w, 1, 180)
		surface.DrawTexturedRectRotated(w * .5 - 1, h, w, 1, 180)
		
		draw.RoundedBox(0, w - 4, 0, 4, h, hov and cellar_red or cellar_blue)

		draw.SimpleText("ВЫБРАТЬ", "cellar.main.btn", w - 12, h/2, hov and cellar_red or cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText("ВЫБРАТЬ", "cellar.main.btn.blur", w - 12, h/2, hov and cellar_red or cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	end

	local deleteButton = infoButtons:Add("ixMenuButton")
	deleteButton:Dock(LEFT)
	deleteButton:SetText("                          ")
	deleteButton:SetFont('cellar.buttonsize')
	deleteButton:SetContentAlignment(5)
	deleteButton:SetTextInset(0, 0)
	deleteButton:SizeToContents()
	deleteButton:SetTextColor(derma.GetColor("Error", deleteButton))
	deleteButton.DoClick = function()
		self:SetActiveSubpanel("delete")
	end
	deleteButton.Paint = function(me, w, h)
		local gradient = surface.GetTextureID("vgui/gradient-d")
		local gradientUp = surface.GetTextureID("vgui/gradient-u")
		local gradientLeft = surface.GetTextureID("vgui/gradient-l")
		local gradientRadial = Material("helix/gui/radial-gradient.png")
		local gradientCenter = Material('cellar/main/gradientcenter.png')

		surface.SetFont('cellar.main.btn')
		local hov = me:IsHovered()
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 25) or ColorAlpha(cellar_darker_blue, 43))
		surface.SetMaterial(gradientCenter)
		surface.DrawTexturedRect(0, 0, w, h)
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 255) or ColorAlpha(cellar_blue, 255))
		surface.DrawTexturedRect(0, 0, w, 1)
		surface.DrawTexturedRect(0, h - 1, w, 1)

		draw.SimpleText("УДАЛИТЬ", "cellar.main.btn", w/2, h/2, hov and cellar_red or cellar_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("УДАЛИТЬ", "cellar.main.btn.blur", w/2, h/2, hov and cellar_red or cellar_blur_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.carousel = infoPanel:Add("ixCharMenuCarousel")
	self.carousel:Dock(FILL)

	-- character deletion panel
	self.delete = self:AddSubpanel("delete")
	self.delete:SetTitle(nil)
	self.delete.OnSetActive = function()
		self.deleteModel:SetModel(self.character:GetModel())
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 0},
			easing = "outQuint"
		})
	end

	local deleteInfo = self.delete:Add("Panel")
	deleteInfo:SetSize(parent:GetWide() * 0.5, parent:GetTall())
	deleteInfo:Dock(LEFT)

	local deleteReturn = deleteInfo:Add("ixMenuButton")
	deleteReturn:Dock(BOTTOM)
	deleteReturn:SetText("")
	deleteReturn:SetFont('cellar.buttonsize')
	deleteReturn:SizeToContents()
	deleteReturn.DoClick = function()
		self:SetActiveSubpanel("main")
	end
	deleteReturn.Paint = function(me, w, h)
		local gradient = surface.GetTextureID("vgui/gradient-d")
		local gradientUp = surface.GetTextureID("vgui/gradient-u")
		local gradientLeft = surface.GetTextureID("vgui/gradient-l")
		local gradientRadial = Material("helix/gui/radial-gradient.png")
		
		surface.SetFont('cellar.main.btn')
		local hov = me:IsHovered()
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 25) or ColorAlpha(cellar_darker_blue, 43))
		surface.SetTexture(gradientLeft)
		surface.DrawTexturedRect(0, 0, w, h)
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 255) or ColorAlpha(cellar_blue, 255))
		surface.DrawTexturedRect(0, 0, w, 1)
		surface.DrawTexturedRect(0, h - 1, w, 1)
		
		draw.RoundedBox(0, 0, 0, 4, h, hov and cellar_red or cellar_blue)

		draw.SimpleText("НЕТ", "cellar.main.btn", 12, h/2, hov and cellar_red or cellar_blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("НЕТ", "cellar.main.btn.blur", 12, h/2, hov and cellar_red or cellar_blur_blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local deleteConfirm = self.delete:Add("ixMenuButton")
	deleteConfirm:Dock(BOTTOM)
	deleteConfirm:SetText("")
	deleteConfirm:SetFont('cellar.buttonsize')
	deleteConfirm:SetContentAlignment(6)
	deleteConfirm:SizeToContents()
	deleteConfirm:SetTextColor(derma.GetColor("Error", deleteConfirm))
	deleteConfirm.DoClick = function()
		local id = self.character:GetID()

		parent:ShowNotice(1, L("deleteComplete", self.character:GetName()))
		self:Populate(id)
		self:SetActiveSubpanel("main")

		net.Start("ixCharacterDelete")
			net.WriteUInt(id, 32)
		net.SendToServer()
	end
	deleteConfirm.Paint = function(me, w, h)
		local gradient = surface.GetTextureID("vgui/gradient-d")
		local gradientUp = surface.GetTextureID("vgui/gradient-u")
		local gradientLeft = surface.GetTextureID("vgui/gradient-l")
		local gradientRadial = Material("helix/gui/radial-gradient.png")
		
		surface.SetFont('cellar.main.btn')
		local hov = me:IsHovered()
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 25) or ColorAlpha(cellar_darker_blue, 43))
		surface.SetTexture(gradientLeft)
		surface.DrawTexturedRectRotated(w * .5 - 1, h * .5, w, h, 180)
		surface.SetDrawColor(hov and ColorAlpha(cellar_red, 255) or ColorAlpha(cellar_blue, 255))
		surface.DrawTexturedRectRotated(w * .5 - 1, 0, w, 1, 180)
		surface.DrawTexturedRectRotated(w * .5 - 1, h, w, 1, 180)
		
		draw.RoundedBox(0, w - 4, 0, 4, h, hov and cellar_red or cellar_blue)

		draw.SimpleText("ДА", "cellar.main.btn", w - 12, h/2, hov and cellar_red or cellar_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText("ДА", "cellar.main.btn.blur", w - 12, h/2, hov and cellar_red or cellar_blur_blue, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	end

	self.deleteModel = deleteInfo:Add("ixModelPanel")
	self.deleteModel:Dock(FILL)
	self.deleteModel:SetModel(errorModel)
	self.deleteModel:SetFOV(modelFOV)
	self.deleteModel.PaintModel = self.deleteModel.Paint

	local deleteNag = self.delete:Add("Panel")
	deleteNag:SetTall(parent:GetTall() * 0.5)
	deleteNag:Dock(BOTTOM)

	local deleteTitle = deleteNag:Add("DLabel")
	deleteTitle:SetFont("ixTitleFont")
	deleteTitle:SetText(L("areYouSure"):utf8upper())
	deleteTitle:SetTextColor(ix.config.Get("color"))
	deleteTitle:SizeToContents()
	deleteTitle:Dock(TOP)

	local deleteText = deleteNag:Add("DLabel")
	deleteText:SetFont("ixMenuButtonFont")
	deleteText:SetText(L("deleteConfirm"))
	deleteText:SetTextColor(color_white)
	deleteText:SetContentAlignment(7)
	deleteText:Dock(FILL)

	-- finalize setup
	self:SetActiveSubpanel("main", 0)
end

function PANEL:OnCharacterDeleted(character)
	if (self.bActive and #ix.characters == 0) then
		self:SlideDown()
	end
end

function PANEL:Populate(ignoreID)
	self.characterList:Clear()
	self.characterList.buttons = {}

	local bSelected

	-- loop backwards to preserve order since we're docking to the bottom
	for i = 1, #ix.characters do
		local id = ix.characters[i]
		local character = ix.char.loaded[id]

		if (!character or character:GetID() == ignoreID) then
			continue
		end

		local index = character:GetFaction()
		local faction = ix.faction.indices[index]
		local color = faction and faction.color or color_white

		local button = self.characterList:Add("ixMenuSelectionButton")
		button:SetBackgroundColor(color)
		button:SetText("")
		button:SetFont('cellar.buttonsize')
		button:SizeToContents()
		button:SetButtonList(self.characterList.buttons)
		button.character = character
		button.OnSelected = function(panel)
			self:OnCharacterButtonSelected(panel)
		end
		button.Paint = function(me, w, h)
			local gradient = surface.GetTextureID("vgui/gradient-d")
			local gradientUp = surface.GetTextureID("vgui/gradient-u")
			local gradientLeft = surface.GetTextureID("vgui/gradient-l")
			local gradientRadial = Material("helix/gui/radial-gradient.png")
			
			

			surface.SetFont('cellar.main.btn')
			local hovered = me:IsHovered()
			local selected = me:GetSelected()
			local hov = selected or hovered
			surface.SetDrawColor(hov and ColorAlpha(color, 25) or ColorAlpha(cellar_darker_blue, 43))
			surface.SetTexture(gradientLeft)
			surface.DrawTexturedRect(0, 0, w, h)
			surface.SetDrawColor(hov and ColorAlpha(color, 255) or ColorAlpha(cellar_blue, 255))
			surface.DrawTexturedRect(0, 0, w, 1)
			surface.DrawTexturedRect(0, h - 1, w, 1)
			
			draw.RoundedBox(0, 0, 0, 4, h, hov and color or cellar_blue)

			draw.SimpleText(character:GetName():utf8upper(), "cellar.main.btn", 12, h/2, hov and Color(210, 210, 210) or ColorAlpha(color_white, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(character:GetName():utf8upper(), "cellar.main.btn.blur", 12, h/2, hov and color or ColorAlpha(color_white, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		-- select currently loaded character if available
		local localCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (localCharacter and character:GetID() == localCharacter:GetID()) then
			button:SetSelected(true)
			self.characterList:ScrollToChild(button)

			bSelected = true
		end
	end

	if (!bSelected) then
		local buttons = self.characterList.buttons

		if (#buttons > 0) then
			local button = buttons[#buttons]

			button:SetSelected(true)
			self.characterList:ScrollToChild(button)
		else
			self.character = nil
		end
	end

	self.characterList:SizeToContents()
end

function PANEL:OnSlideUp()
	self.bActive = true
	self:Populate()
end

function PANEL:OnSlideDown()
	self.bActive = false
end

function PANEL:OnCharacterButtonSelected(panel)
	self.carousel:SetActiveCharacter(panel.character)
	self.character = panel.character
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterLoadBackground", self, width, height)

	local w, h = width, height
	local background = Material('cellar/main/tab/otherbackground.png')
	local television = Material('cellar/main/tvtexture.png')
	local staticborder = Material('cellar/main/tab/otherborders.png')
	local vignette = ix.util.GetMaterial("helix/gui/vignette.png")
    local helpframe = Material('cellar/main/tab/helpframe1604x754.png')
	local skillsline = Material('cellar/main/tab/skillsline452x16.png')

	DrawBlurIndependent(self)
	surface.SetDrawColor(ColorAlpha(color_white, 190))
	surface.SetMaterial(background)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_black, 170))
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_white, 90))
	surface.SetMaterial(television)
	surface.DrawTexturedRect(0, 0, w, h)


	surface.SetDrawColor(ColorAlpha(color_white, 240))
	surface.SetMaterial(staticborder)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(ColorAlpha(color_black, 255))
	surface.SetMaterial(vignette)
	surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("ixCharMenuLoad", PANEL, "ixCharMenuPanel")
