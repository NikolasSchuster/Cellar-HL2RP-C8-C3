local texBorder = {
	[1] = Material("cellar/main/border_left.png"),
	[2] = Material("cellar/main/border_hor.png"),
	[3] = Material("cellar/main/border_ver.png"),
	[4] = Material("cellar/main/border_right.png"),
	[5] = Material("cellar/main/border_down.png"),
	[6] = Material("cellar/main/border_end.png")
}
local clrBorder = Color(255, 255, 255, 64)

local logotype = Material("cellar/main/logotype.png")

local offset = 41
local function DrawBorders()
	local w, h = ScrW(), ScrH()
	

	surface.SetDrawColor(clrBorder)


	local x, y = math.floor(w * 0.6869791666666667), 70
	local wide = w - x
	local tall = 0

	surface.SetMaterial(texBorder[2])
	surface.DrawTexturedRect(x, y, wide, 8)

	x = x - 64
	y = y - 29

	surface.SetMaterial(texBorder[4])
	surface.DrawTexturedRect(x, y, 64, 64)

	wide = (w - 169 - (w - x))
	y = y + 6
	x = x - wide


	surface.SetMaterial(texBorder[2])
	surface.DrawTexturedRect(x, y, wide, 8)

	y = y - 6
	x = x - 128

	surface.SetMaterial(texBorder[1])
	surface.DrawTexturedRect(x, y, 128, 128)

	y = y + 128
	x = x + 5
	tall = h - 48 - y

	surface.SetMaterial(texBorder[3])
	surface.DrawTexturedRect(x, y, 8, tall)


	x = x + 3
	y = y - 5 + tall
	wide = math.floor(w * 0.4651041666666667) - x

	surface.SetMaterial(texBorder[2])
	surface.DrawTexturedRect(x, y, wide, 8)

	y = y - 36
	x = x + wide

	surface.SetMaterial(texBorder[5])
	surface.DrawTexturedRect(x, y, 64, 64)

	x = x + 64
	y = y + 51
	wide = w - 128 - x

	surface.SetMaterial(texBorder[2])
	surface.DrawTexturedRect(x, y, wide, 8)

	x = w - 128
	y = y - 115

	surface.SetMaterial(texBorder[6])
	surface.DrawTexturedRect(x, y, 128, 128)
end

local btnWidth = 285 - 32
local btnHeight = 40
local btnColors = {
	[1] = {
		Color(56, 207, 248),
		Color(43, 157, 189, 128),
		Color(43, 157, 189),
	}
}
local bg = Material("cellar/main/btn_background.png")
local clrBG = Color(45, 162, 201, 255)
local function DrawButton(x, y)
	surface.SetDrawColor(btnColors[1][1])
	surface.DrawRect(x, y, 32, btnHeight)

	surface.SetDrawColor(clrBG)
	surface.SetMaterial(bg)
	surface.DrawTexturedRect(x + 32, y + 1, btnWidth - 1, btnHeight - 2)

	surface.SetDrawColor(btnColors[1][2])
	surface.DrawLine(x + 32, y, x + 32 + btnWidth - 1, y)

	surface.SetDrawColor(btnColors[1][3])
	surface.DrawLine(x + 32 + btnWidth - 1, y, x + 32 + btnWidth, y)

	surface.SetDrawColor(btnColors[1][2])
	surface.DrawLine(x + 32, y + 39, x + 32 + btnWidth - 1, y + 39)

	surface.SetDrawColor(btnColors[1][3])
	surface.DrawLine(x + 32 + btnWidth - 1, y + 39, x + 32 + btnWidth, y + 39)

	surface.SetDrawColor(btnColors[1][2])
	surface.DrawLine(x + 32 + btnWidth - 1, y, x + 32 + btnWidth - 1, y + 39)
end


local tex = GetRenderTargetEx( "ExampleMaskRT726", ScrW(), ScrH(), RT_SIZE_OFFSCREEN,
		 MATERIAL_RT_DEPTH_SHARED --[[IMPORTANT]], 0, 0, IMAGE_FORMAT_RGBA8888 )

local rt_mat = CreateMaterial("HUDAdd5czn42634","UnlitGeneric",{
	["$translucent"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$additive"] = 1,
})
rt_mat:Recompute()

--[[hook.Add("HUDPaint", "Test", function()
	render.PushRenderTarget(tex)
		render.Clear( 0, 0, 0, 150)
	
		cam.Start2D()
			if IsValid(cellar_main) then
				cellar_main.paint_manual = true
				cellar_main:SetPaintedManually(true)
					cellar_main:PaintManual()
				cellar_main:SetPaintedManually(false)
				cellar_main.paint_manual = false
			end
		cam.End2D()
		render.BlurRenderTarget( tex, 8, 0, 10)
	render.PopRenderTarget()

	rt_mat:SetTexture("$basetexture", tex)
end)]]





local btnHeight = 40
local btnColors = {
	[1] = {
		Color(56, 207, 248),
		Color(43, 157, 189, 56),
		Color(43, 157, 189),
		Color(9, 32, 96),
		Color(56, 61, 248, 225),
		Color(48, 148, 200, 160)
	},
	[2] = {
		Color(248, 56, 56),
		Color(248, 56, 56, 48),
		Color(248, 56, 56),
		Color(96, 10, 10),
		Color(248, 56, 56, 225),
		Color(201, 45, 45, 160)
	},
}
local bg = Material("cellar/main/btn_background.png")
local icons = {
	Material("cellar/main/new.png"),
	Material("cellar/main/chars.png"),
	Material("cellar/main/info.png"),
	Material("cellar/main/content.png"),
	Material("cellar/main/exit.png"),
}
surface.CreateFont("cellar.main.btn", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
surface.CreateFont("cellar.main.btn.blur", {
	font = "Nagonia",
	extended = true,
	size = 24,
	weight = 500,
	blursize = 4,
	scanlines = 2,

	additive = true,
	outline = false,
})
local console = Material("cellar/main/console")
local clrConsole = Color(102, 150, 190, 64)
local testBG = Material("cellar/main/bg/00.png")
local testBG2 = Material("cellar/main/bg/01.png")
local shadow = Material("cellar/main/shadow.png")
local warning = Material("cellar/main/warning.png")
surface.CreateFont("cellar.main.warn", {
	font = "Nagonia",
	extended = true,
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})
local keyframes2 = {
	{2, 1},
	{4, 0.15},
	{5, 0}
}
local function LerpKeyframes( curTime, keyframes, easein, easeout )
	
	if !keyframes.Sorted then
		table.sort( keyframes, function( a, b ) return a[1] < b[1] end )
		keyframes.Sorted = true
	end
	easein = easein or 0.5
	easeout = easeout or 0.5
	local keyCount = #keyframes
	if curTime < keyframes[1][1] then // we're before the first key; use first value
		return keyframes[1][2]
	elseif curTime >= keyframes[ keyCount ][1] then // we're after the last key; use last value
		return keyframes[ keyCount ][2]
	end
	
	// now find out what key we're on right now
	local keyA, keyB
	for i = 1, keyCount do
		if curTime >= keyframes[i][1] and curTime < keyframes[ i + 1 ][1] then
			keyA = i
			keyB = i + 1
			break
		end
	end
	
	// get progress through these keys
	local percent = math.TimeFraction( keyframes[ keyA ][1], keyframes[ keyB ][1], curTime )
	// ease
	percent = math.EaseInOut( percent, easein or 0, easeout or 0 )
	
	// finally lerp between the two values
	local lerped = Lerp( percent, keyframes[ keyA ][2], keyframes[ keyB ][2] )
	return lerped
	
end
local backgrounds = {
	[1] = {Material("cellar/main/bg/00.png")},
	[2] = {Material("cellar/main/bg/01.png")},
	[3] = {Material("cellar/main/bg/02.png")},
	[4] = {Material("cellar/main/bg/03.png")},
	[5] = {Material("cellar/main/bg/04.png")},
	[6] = {Material("cellar/main/bg/05.png")},
}
local cache_backgrounds = table.Copy(backgrounds)
local rand = math.random
local function shuffle(t)
  local n = #t

  while n > 1 do
	-- n is now the last pertinent index
	local k = rand(n) -- 1 <= k <= n
	-- Quick swap
	t[n], t[k] = t[k], t[n]
	n = n - 1
  end

  return t
end

shuffle(cache_backgrounds)


local tex = GetRenderTargetEx( "ExampleMaskRT5", ScrW(), ScrH(), RT_SIZE_NO_CHANGE,
		 MATERIAL_RT_DEPTH_SHARED --[[IMPORTANT]], 0, 0, IMAGE_FORMAT_RGBA8888 )
local rt_mat = CreateMaterial("HUDAdd5czn423","UnlitGeneric",{
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
})

local scanrt = GetRenderTargetEx( "ScanlineRT3", 2, 2, RT_SIZE_NO_CHANGE,
		 MATERIAL_RT_DEPTH_SHARED, 0, 0, IMAGE_FORMAT_RGBA8888 )
local b = CreateMaterial("scanlines", "UnlitGeneric",{
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$vertexcolor"] = 1,
})

render.PushRenderTarget(scanrt)
	render.Clear(255, 255, 255, 255)

	cam.Start2D()
		render.PushFilterMag(TEXFILTER.POINT)
		render.PushFilterMin(TEXFILTER.POINT)
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.DrawRect(0, 0, 2, 1)
		render.PopFilterMag()
		render.PopFilterMin()
	cam.End2D()
render.PopRenderTarget()

b:SetTexture("$basetexture", scanrt)



--[[hook.Add("PostRenderVGUI", "TestRTHook", function()


	local u0, v0 = 0, 0
	local u1, v1 = 1, 1080 / 2
	local du = 0.5 / 32 -- half pixel anticorrection
	local dv = 0.5 / 32 -- half pixel anticorrection
	local u0, v0 = (u0 - du) / (1 - 2 * du), (v0 - dv) / (1 - 2 * dv)
	local u1, v1 = (u1 - du) / (1 - 2 * du), (v1 - dv) / (1 - 2 * dv)

	render.PushRenderTarget(tex)
		render.Clear(255, 255, 255, 255)

		cam.Start2D()
			render.PushFilterMag( TEXFILTER.POINT )
			render.PushFilterMin( TEXFILTER.POINT )
					surface.SetMaterial(b)
					surface.SetDrawColor(Color(255, 255, 255, 175))
					surface.DrawTexturedRectUV(0, 0, ScrW(), ScrH(), 0, 0, 1, v1)
			render.PopFilterMag()
			render.PopFilterMin()
		cam.End2D()

	render.PopRenderTarget()

	rt_mat:SetTexture("$basetexture", tex)

	render.OverrideBlend( true, BLEND_DST_COLOR, BLEND_ONE_MINUS_SRC_ALPHA, BLENDFUNC_ADD )
		surface.SetMaterial(rt_mat)
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	render.OverrideBlend( false )

/*
	surface.SetDrawColor(Color(155, 155, 155, 6))
	surface.DrawRect(0, 0, ScrW(), ScrH() / 3)

	render.OverrideBlend(true, BLEND_DST_COLOR, BLEND_ONE, BLENDFUNC_ADD)

	surface.SetDrawColor(Color(255, 255, 255, 1))
	surface.DrawRect(0, 0, ScrW(), ScrH() / 3)

	render.OverrideBlend(false)
	*/

end)]]










local gradient = surface.GetTextureID("vgui/gradient-d")
local audioFadeInTime = 2
local animationTime = 0.5
local matrixZScale = Vector(1, 1, 0.0001)

-- character menu panel
DEFINE_BASECLASS("ixSubpanelParent")
local PANEL = {}

function PANEL:Init()
	self:SetSize(self:GetParent():GetSize())
	self:SetPos(0, 0)

	self.childPanels = {}
	self.subpanels = {}
	self.activeSubpanel = ""

	self.currentDimAmount = 0
	self.currentY = 0
	self.currentScale = 1
	self.currentAlpha = 255
	self.targetDimAmount = 255
	self.targetScale = 0.9
end

function PANEL:Dim(length, callback)
	length = length or animationTime
	self.currentDimAmount = 0

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = self.targetDimAmount,
			currentScale = self.targetScale
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnDim()
end

function PANEL:Undim(length, callback)
	length = length or animationTime
	self.currentDimAmount = self.targetDimAmount

	self:CreateAnimation(length, {
		target = {
			currentDimAmount = 0,
			currentScale = 1
		},
		easing = "outCubic",
		OnComplete = callback
	})

	self:OnUndim()
end

function PANEL:OnDim()
end

function PANEL:OnUndim()
end

function PANEL:Paint(width, height)
	local amount = self.currentDimAmount
	local bShouldScale = self.currentScale != 1
	local matrix

	-- draw child panels with scaling if needed
	if (bShouldScale) then
		matrix = Matrix()
		matrix:Scale(matrixZScale * self.currentScale)
		matrix:Translate(Vector(
			ScrW() * 0.5 - (ScrW() * self.currentScale * 0.5),
			ScrH() * 0.5 - (ScrH() * self.currentScale * 0.5),
			1
		))

		cam.PushModelMatrix(matrix)
		self.currentMatrix = matrix
	end

	BaseClass.Paint(self, width, height)

	if (bShouldScale) then
		cam.PopModelMatrix()
		self.currentMatrix = nil
	end

	if (amount > 0) then
		local color = Color(0, 0, 0, amount)

		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, width, height)
	end
end

vgui.Register("ixCharMenuPanel", PANEL, "ixSubpanelParent")




-- character menu main button list
PANEL = {}


function PANEL:Init()
	local parent = self:GetParent()
	self:SetSize(parent:GetWide() * 0.25, parent:GetTall())

	self:GetVBar():SetWide(0)
	self:GetVBar():SetVisible(false)
end

function PANEL:Add(name)
	local panel = vgui.Create(name, self)
	panel:Dock(TOP)

	return panel
end

function PANEL:SizeToContents()
	self:GetCanvas():InvalidateLayout(true)

	-- if the canvas has extra space, forcefully dock to the bottom so it doesn't anchor to the top
	if (self:GetTall() > self:GetCanvas():GetTall()) then
		self:GetCanvas():Dock(BOTTOM)
	else
		self:GetCanvas():Dock(NODOCK)
	end
end

vgui.Register("ixCharMenuButtonList", PANEL, "DScrollPanel")

local PANEL = {}

-- main character menu panel
PANEL = {}

AccessorFunc(PANEL, "bUsingCharacter", "UsingCharacter", FORCE_BOOL)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = ScrW() * 0.5
	local halfPadding = padding * 0.5
	local bHasCharacter = #ix.characters > 0

	

	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:DockPadding(padding, padding, padding, padding)

	/*local infoLabel = self:Add("DLabel")
	infoLabel:SetTextColor(Color(255, 255, 255, 25))
	infoLabel:SetFont("ixMenuMiniFont")
	infoLabel:SetText(L("helix") .. " " .. GAMEMODE.Version)
	infoLabel:SizeToContents()
	infoLabel:SetPos(ScrW() - infoLabel:GetWide() - 4, ScrH() - infoLabel:GetTall() - 4)

	local logoPanel = self:Add("Panel")
	logoPanel:SetSize(ScrW(), ScrH() * 0.25)
	logoPanel:SetPos(0, ScrH() * 0.25)
	logoPanel.Paint = function(panel, width, height)
		local matrix = self.currentMatrix

		-- don't scale the background because it fucks the blur
		if (matrix) then
			cam.PopModelMatrix()
		end

		local newHeight = Lerp(1 - (self.currentDimAmount / 255), 0, height)
		local y = height * 0.5 - newHeight * 0.5
		local _, screenY = panel:LocalToScreen(0, 0)
		screenY = screenY + y

		render.SetScissorRect(0, screenY, width, screenY + newHeight, true)
		ix.util.DrawBlur(panel, 15, nil, 200)

		-- background dim
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(0, y, width, newHeight)

		-- border lines
		surface.SetDrawColor(ix.config.Get("color") or color_white)
		surface.DrawRect(0, y, width, 1)
		surface.DrawRect(0, y + newHeight - 1, width, 1)

		if (matrix) then
			cam.PushModelMatrix(matrix)
		end

		for _, v in ipairs(panel:GetChildren()) do
			v:PaintManual()
		end

		render.SetScissorRect(0, 0, 0, 0, false)
	end

	-- draw schema logo material instead of text if available
	local logo = Schema.logo and ix.util.GetMaterial(Schema.logo)

	if (logo and !logo:IsError()) then
		local logoImage = logoPanel:Add("DImage")
		logoImage:SetMaterial(logo)
		logoImage:SetSize(halfWidth, halfWidth * logo:Height() / logo:Width())
		logoImage:SetPos(halfWidth - logoImage:GetWide() * 0.5, halfPadding)
		logoImage:SetPaintedManually(true)

		logoPanel:SetTall(logoImage:GetTall() + padding)
	else
		local newHeight = padding
		local subtitle = L2("schemaDesc") or Schema.description

		local titleLabel = logoPanel:Add("DLabel")
		titleLabel:SetTextColor(color_white)
		titleLabel:SetFont("ixTitleFont")
		titleLabel:SetText(L2("schemaName") or Schema.name or L"unknown")
		titleLabel:SizeToContents()
		titleLabel:SetPos(halfWidth - titleLabel:GetWide() * 0.5, halfPadding)
		titleLabel:SetPaintedManually(true)
		newHeight = newHeight + titleLabel:GetTall()

		if (subtitle) then
			local subtitleLabel = logoPanel:Add("DLabel")
			subtitleLabel:SetTextColor(color_white)
			subtitleLabel:SetFont("ixSubTitleFont")
			subtitleLabel:SetText(subtitle)
			subtitleLabel:SizeToContents()
			subtitleLabel:SetPos(halfWidth - subtitleLabel:GetWide() * 0.5, 0)
			subtitleLabel:MoveBelow(titleLabel)
			subtitleLabel:SetPaintedManually(true)
			newHeight = newHeight + subtitleLabel:GetTall()
		end

		logoPanel:SetTall(newHeight)
	end*/

	self:SetSize(0, 0)
	self:SetPos(0, 0)
	self:SetAlpha(0)
	self.isAnimating = true
	self:SizeTo(ScrW(), ScrH(), 1, .1, .1, function()
		self.isAnimating = false
	end)
	self:AlphaTo(255, .8, .1)
	self.Think = function()
		if self.isAnimating then
			self:Center()
		end
	end

	if IsValid(cellar_main) then

		cellar_main:Remove()
		cellar_main = nil
	end

	local cellar_main = self


	self.background = self:Add("EditablePanel")
	--self.background:Dock(FILL)
	self.background:SetSize(ScrW(), ScrH())
	self.background:SetPaintedManually(true)
	self.background.frac = 0
	self.background.image1 = cache_backgrounds[1][1]
	self.background.image2 = cache_backgrounds[2][1]
	self.background.Paint = function(this, w, h)
		if !self.paint_manual then
			
			local y = 0 - (ScrH() * this.frac)
			surface.SetDrawColor(color_white)

			surface.SetMaterial(this.image1)
			surface.DrawTexturedRect(0, y, w, h)

			surface.SetMaterial(this.image2)
			surface.DrawTexturedRect(0, y + ScrH(), w, h)
		end
	end
	self.background.StartSlide = function(this, time)
		local timec = CurTime() + time
		
		shuffle(cache_backgrounds)
		local key
		for k, v in ipairs(cache_backgrounds) do
			if v[1] == this.image1 then

				key = k
				break
			end
		end

		key = key + 1


		if key > #cache_backgrounds then
			key = 1
		end
		
		this.image2 = cache_backgrounds[key][1]

		this.Think = function(this)
			this.frac = LerpKeyframes(timec - CurTime(), keyframes2)

			if this.frac >= 1 then
				this.Think = nil
				this.image1 = this.image2

				timer.Simple(2, function()
					cellar_main.background:StartSlide(10)
				end)
			end
		end
	end

	

	timer.Simple(2, function()
		cellar_main.background:StartSlide(10)
	end)

	self.addpaint = self:Add("EditablePanel")
	self.addpaint:SetSize(ScrW(), ScrH())
	self.addpaint:SetPaintedManually(true)
	self.addpaint.Paint = function(this, w, h)
		local shadow = Material("cellar/main/shadow.png")
		local television = Material('cellar/main/tvtexture.png')
		if !self.paint_manual then
			self.background:PaintManual()

			surface.SetDrawColor(color_white)
			surface.SetMaterial(shadow)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

			/*surface.SetMaterial(rt_mat)
			surface.SetDrawColor(ColorAlpha(color_white, 30))
			surface.DrawTexturedRectUV(0, 0, w, h,-0.016, -0.016, 1 + 0.016, 1 + 0.016)*/
		end

		DrawBorders()

		local h = ScrH() - 70 - 155

		surface.SetMaterial(logotype)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(110, 135, ScrW() - ScrW()/2.6, ScrH() - ScrH()/1.33)

		surface.SetMaterial(television)
		surface.SetDrawColor(ColorAlpha(color_white, 90))
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

		surface.SetMaterial(console)
		surface.SetDrawColor(clrConsole)
		surface.DrawTexturedRectUV(ScrW() - 512, 70 + 7, 512, h, 0, 0, 1, h / 1024)

		local clr = Color(248, 230, 80, 140 + 70 * math.abs(math.sin(CurTime() * 2)))
		surface.SetDrawColor(clr)
		surface.SetTextColor(clr)

		local text = "Бета-версия: некоторые функции могут отсутствовать или работать не так, как ожидалось."
		surface.SetFont("cellar.main.warn")
		local w, h = surface.GetTextSize(text)
		surface.SetTextPos(ScrW() * .0573 + 32 + 8, ScrH() *.5093 + 8)

		surface.DrawText(text)

		surface.SetMaterial(warning)
		surface.DrawTexturedRect(ScrW() * .0573, ScrH() *.5093, 32, 32)
	end

	-- button list
	self.mainButtonList = self:Add("ixCharMenuButtonList")
	self.mainButtonList:Dock(LEFT)

	-- create character button
	/*local createButton = self.mainButtonList:Add("ixMenuButton")
	createButton:SetText("create")
	createButton:SizeToContents()
	createButton.DoClick = function()
		local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)
		-- don't allow creation if we've hit the character limit
		if (#ix.characters >= maximum) then
			self:GetParent():ShowNotice(3, L("maxCharacters"))
			return
		end

		self:Dim()
		parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
		parent.newCharacterPanel:SlideUp()
	end*/
	local charcreate = self:Add("cellar.main.btn")
	charcreate:SetPos(ScrW() * .0573, ScrH() *.5972)
	charcreate:SetText('СОЗДАТЬ')
	charcreate:SetIcon(1)
	charcreate:SizeTo(285, 40, 1, (0.25 * 1))
	charcreate.DoClick = function()
		local maximum = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 5)

		-- don't allow creation if we've hit the character limit
		if (#ix.characters >= maximum) then
			self:GetParent():ShowNotice(3, L("maxCharacters"))
			return
		end

		self:Dim()
		parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
		parent.newCharacterPanel:SlideUp()
	end



	-- load character button
	/*self.loadButton = self.mainButtonList:Add("ixMenuButton")
	self.loadButton:SetText("load")
	self.loadButton:SizeToContents()
	self.loadButton.DoClick = function()
		self:Dim()
		parent.loadCharacterPanel:SlideUp()
	end*/

	self.loadbutton = self:Add('cellar.main.btn')
	self.loadbutton:SetPos(ScrW() * .0573, ScrH() *.5972 + 43)
	self.loadbutton:SetText('ЗАГРУЗИТЬ')
	self.loadbutton:SetIcon(2)
	self.loadbutton:SizeTo(285, 40, 1, (0.25 * 2))
	self.loadbutton.DoClick = function()
		if (!bHasCharacter) then
			--self.loadButton:SetDisabled(true)
			self:GetParent():ShowNotice(3, "У вас должен быть хотя бы один персонаж!")
		else
			self:Dim()
			parent.loadCharacterPanel:SlideUp()
		end
	end


	-- community button
	local extraURL = ix.config.Get("communityURL", "")
	local extraText = ix.config.Get("communityText", "@community")

	if (extraURL != "" and extraText != "") then
		if (extraText:sub(1, 1) == "@") then
			extraText = L(extraText:sub(2))
		end

		/*local extraButton = self.mainButtonList:Add("ixMenuButton")
		extraButton:SetText(extraText, true)
		extraButton:SizeToContents()
		extraButton.DoClick = function()
			gui.OpenURL(extraURL)
		end*/
		local info = self:Add("cellar.main.btn")
		info:SetPos(ScrW() * .0573, ScrH() *.5972 + 43 * (2))
		info:SetText('ИНФОРМАЦИЯ')
		info:SetIcon(3)
		info:SizeTo(285, 40, 1, (0.25 * 3))
		info.DoClick = function()
			gui.OpenURL(extraURL)
		end
	end

	local content = self:Add("cellar.main.btn")
	content:SetPos(ScrW() * .0573, ScrH() *.5972 + 43 * (3))
	content:SetText('КОНТЕНТ')
	content:SetIcon(4)
	content:SizeTo(285, 40, 1, (0.25 * 4))
	content.DoClick = function()
		gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2625033591")
	end

	-- leave/return button
	/*self.returnButton = self.mainButtonList:Add("ixMenuButton")
	self:UpdateReturnButton()
	self.returnButton.DoClick = function()
		if (self.bUsingCharacter) then
			parent:Close()
		else
			RunConsoleCommand("disconnect")
		end
	end*/

	local a = self:Add("cellar.main.btn")
	--self:UpdateReturnButton()
	a:SetPos(ScrW() * .0573, ScrH() - ScrH() * .1250)
	a:SetText(self.bUsingCharacter and "НАЗАД" or "ВЫЙТИ")
	a:SetIcon(5)
	a:SizeTo(285, 40, 1, 0.25 * 5)
	a.DoClick = function()
		if (self.bUsingCharacter) then
			parent:Close()
		else
			RunConsoleCommand("disconnect")
		end
	end

	self.mainButtonList:SizeToContents()
end
/*function PANEL:Paint(w, h)
	-- Glowing
	if !self.paint_manual then
		self.background:PaintManual()

		surface.SetDrawColor(ColorAlpha(color_white, 0))
		surface.SetMaterial(shadow)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetMaterial(rt_mat)
		surface.SetDrawColor(ColorAlpha(color_white, 0))
		surface.DrawTexturedRectUV(0, 0, w, h,-0.016, -0.016, 1 + 0.016, 1 + 0.016)
	end

	DrawBorders()

	local h = ScrH() - 70 - 155
	surface.SetMaterial(console)
	surface.SetDrawColor(clrConsole)
	surface.DrawTexturedRectUV(ScrW() - 512, 70 + 7, 512, h, 0, 0, 1, h / 1024)

	local clr = Color(248, 230, 80, 140 + 70 * math.abs(math.sin(CurTime() * 2)))
	surface.SetDrawColor(clr)
	surface.SetTextColor(clr)

	local text = "Альфа-версия: некоторые функции могут отсутствовать или работать не так, как ожидалось."
	surface.SetFont("cellar.main.warn")
	local w, h = surface.GetTextSize(text)
	surface.SetTextPos(110 + 32 + 8, 602 - 56 + 16 - h / 2)

	surface.DrawText(text)

	surface.SetMaterial(warning)
	surface.DrawTexturedRect(110, 602 - 56, 32, 32)
end*/

function PANEL:UpdateReturnButton(bValue)
	if (bValue != nil) then
		self.bUsingCharacter = bValue
	end

	--self.returnButton:SetText(self.bUsingCharacter and "return" or "leave")
	--self.returnButton:SizeToContents()
end

function PANEL:OnDim()
	-- disable input on this panel since it will still be in the background while invisible - prone to stray clicks if the
	-- panels overtop slide out of the way
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
end

function PANEL:OnUndim()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)

	-- we may have just deleted a character so update the status of the return button
	self.bUsingCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()
	self:UpdateReturnButton()
end

function PANEL:OnClose()
	for _, v in pairs(self:GetChildren()) do
		if (IsValid(v)) then
			v:SetVisible(false)
		end
	end
end

function PANEL:PerformLayout(width, height)
	local padding = self:GetPadding()

	self.mainButtonList:SetPos(padding, height - self.mainButtonList:GetTall() - padding)
end



vgui.Register("ixCharMenuMain", PANEL, "ixCharMenuPanel")

-- container panel
PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.loading)) then
		ix.gui.loading:Remove()
	end

	if (IsValid(ix.gui.characterMenu)) then
		if (IsValid(ix.gui.characterMenu.channel)) then
			ix.gui.characterMenu.channel:Stop()
		end

		ix.gui.characterMenu:Remove()
	end

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)

	-- main menu panel
	self.mainPanel = self:Add("ixCharMenuMain")

	-- new character panel
	self.newCharacterPanel = self:Add("ixCharMenuNew")
	self.newCharacterPanel:SlideDown(0)

	-- load character panel
	self.loadCharacterPanel = self:Add("ixCharMenuLoad")
	self.loadCharacterPanel:SlideDown(0)

	-- notice bar
	self.notice = self:Add("ixNoticeBar")

	-- finalization
	self:MakePopup()
	self.currentAlpha = 255
	self.volume = 0

	ix.gui.characterMenu = self
	ix.gui.characterMenu.opened = true

	if (!IsValid(ix.gui.intro)) then
		self:PlayMusic()
	end

	hook.Run("OnCharacterMenuCreated", self)
end

function PANEL:PlayMusic()
	local path = "sound/" .. ix.config.Get("music")
	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay", function(channel, error, message)
		if (!IsValid(self) or !IsValid(channel)) then
			return
		end

		channel:SetVolume(self.volume or 0)
		channel:Play()

		self.channel = channel

		self:CreateAnimation(audioFadeInTime, {
			index = 10,
			target = {volume = 1},

			Think = function(animation, panel)
				if (IsValid(panel.channel)) then
					panel.channel:SetVolume(self.volume * 0.5)
				end
			end
		})
	end)
end

function PANEL:ShowNotice(type, text)
	self.notice:SetType(type)
	self.notice:SetText(text)
	self.notice:Show()
end

function PANEL:HideNotice()
	if (IsValid(self.notice) and !self.notice:GetHidden()) then
		self.notice:Slide("up", 0.5, true)
	end
end

function PANEL:OnCharacterDeleted(character)
	if (#ix.characters == 0) then
		--self.mainPanel.loadButton:SetDisabled(true)
		self.mainPanel:Undim() -- undim since the load panel will slide down
	else
		--self.mainPanel.loadButton:SetDisabled(false)
	end

	self.loadCharacterPanel:OnCharacterDeleted(character)
end

function PANEL:OnCharacterLoadFailed(error)
	self.loadCharacterPanel:SetMouseInputEnabled(true)
	self.loadCharacterPanel:SlideUp()
	self:ShowNotice(3, error)
end

function PANEL:IsClosing()
	return self.bClosing
end

function PANEL:Close(bFromMenu)
	self.bClosing = true
	self.bFromMenu = bFromMenu

	local fadeOutTime = animationTime * 8

	self:CreateAnimation(fadeOutTime, {
		index = 1,
		target = {currentAlpha = 0},

		Think = function(animation, panel)
			panel:SetAlpha(panel.currentAlpha)
		end,

		OnComplete = function(animation, panel)
			panel:Remove()
		end
	})

	self:CreateAnimation(fadeOutTime - 0.1, {
		index = 10,
		target = {volume = 0},

		Think = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:SetVolume(self.volume * 0.5)
			end
		end,

		OnComplete = function(animation, panel)
			if (IsValid(panel.channel)) then
				panel.channel:Stop()
				panel.channel = nil
			end
		end
	})

	-- hide children if we're already dimmed
	if (bFromMenu) then
		for _, v in pairs(self:GetChildren()) do
			if (IsValid(v)) then
				v:SetVisible(false)
			end
		end
	else
		-- fade out the main panel quicker because it significantly blocks the screen
		self.mainPanel.currentAlpha = 255

		self.mainPanel:CreateAnimation(animationTime * 2, {
			target = {currentAlpha = 0},
			easing = "outQuint",

			Think = function(animation, panel)
				panel:SetAlpha(panel.currentAlpha)
			end,

			OnComplete = function(animation, panel)
				panel:SetVisible(false)
			end
		})
	end

	-- relinquish mouse control
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	gui.EnableScreenClicker(false)
end

function PANEL:Paint(width, height)
	surface.SetTexture(gradient)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawTexturedRect(0, 0, width, height)

	if (!ix.option.Get("cheapBlur", false)) then
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawTexturedRect(0, 0, width, height)
		ix.util.DrawBlur(self, Lerp((self.currentAlpha - 200) / 255, 0, 10))
	end
end

function PANEL:PaintOver(width, height)
	if (self.bClosing and self.bFromMenu) then
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, width, height)
	end
end

function PANEL:OnRemove()
	if (self.channel) then
		self.channel:Stop()
		self.channel = nil
	end
	ix.gui.characterMenu.opened = false
end

vgui.Register("ixCharMenu", PANEL, "EditablePanel")

if (IsValid(ix.gui.characterMenu)) then
	ix.gui.characterMenu:Remove()

	--TODO: REMOVE ME
	ix.gui.characterMenu = vgui.Create("ixCharMenu")
end