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

/*hook.Add("HUDPaint", "Test", function()
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
end)*/





DEFINE_BASECLASS("DButton")
local PANEL = {}
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
function PANEL:Init()
	self.BaseClass.SetText(self, "")

	self:SetSize(32, 40)

	self:SetTextColor(btnColors[1][1])
	self:SetFont("cellar.main.btn")
	self:SetTextInset(32 + 13, 0)
	self:SetContentAlignment(4)

	self.text = ""
	self.icon = 0
end
function PANEL:SetText(value)
	self.text = value
end

function PANEL:SetIcon(ico)
	self.icon = math.Clamp(ico, 0, #icons)
end
function PANEL:OnCursorEntered()
	LocalPlayer():EmitSound("Helix.Rollover")
end
function PANEL:OnMousePressed(code)
	if (self:GetDisabled()) then
		return
	end

	LocalPlayer():EmitSound("Helix.Press")

	if (code == MOUSE_LEFT and self.DoClick) then
		self:DoClick(self)
	elseif (code == MOUSE_RIGHT and self.DoRightClick) then
		self:DoRightClick(self)
	end
end
function PANEL:Paint(w, h)
	local clr = self:IsHovered() and 2 or 1
	local color = btnColors[clr]

	surface.SetDrawColor(color[1])
	surface.DrawRect(0, 0, 32, h)

	local x = 32

	surface.SetDrawColor(color[6])
	surface.SetMaterial(bg)
	surface.DrawTexturedRect(32, 1, w - 1, h - 2)

	surface.SetDrawColor(color[2])
	surface.DrawLine(x, 0, w - 1, 0)
	surface.DrawLine(x, h - 1, w - 1, h - 1)
	surface.DrawLine(w - 1, 1, w - 1, h - 1)

	surface.SetDrawColor(color[3])
	surface.DrawLine(w - 1, h - 1, x + w, h - 1)
	surface.DrawLine(w - 1, 0, x + w, 0)


	surface.SetFont("cellar.main.btn")
	local textW, textH = surface.GetTextSize(self.text)
	local x, y = 32 + 13, h / 2 - textH / 2

	surface.SetTextColor(color[5])
	surface.SetTextPos(x, y)
	surface.SetFont("cellar.main.btn.blur")
	surface.DrawText(self.text)

	surface.SetFont("cellar.main.btn")
	surface.SetTextColor(color[1])
	surface.SetTextPos(x, y)
	surface.DrawText(self.text, true)

	if self.icon > 0 then
		surface.SetDrawColor(color[4])
		surface.SetMaterial(icons[self.icon])
		surface.DrawTexturedRect(0, h / 2 - 16, 32, 32)
	end
end
vgui.Register("cellar.main.btn", PANEL, "DButton")

PANEL = {}
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

function PANEL:Init()
	local parent = self:GetParent()
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()

	if IsValid(cellar_main) then

		cellar_main:Remove()
		cellar_main = nil
	end

	local cellar_main = self


	self.background = self:Add("EditablePanel")
	self.background:Dock(FILL)
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

	/*for i = 1, 4 do
		local a = self:Add("cellar.main.btn")
		a:SetPos(110, 602 + 43 * (i - 1))
		a:SetText("TEST")
		a:SetIcon(i)
		a:SizeTo(285, 40, 1, (0.25 * i))
	end*/
	local charcreate = self:Add("cellar.main.btn")
	charcreate:SetPos(110, 602 + 43 * (1))
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

			self:Remove()
			parent.newCharacterPanel:SetActiveSubpanel("faction", 0)
			parent.newCharacterPanel:SlideUp()
	end


	local loadbutton = self:Add('cellar.main.btn')
	loadbutton:SetPos(110, 602 + 43 * (2))
	loadbutton:SetText('ЗАГРУЗИТЬ')
	loadbutton:SetIcon(2)
	loadbutton:SizeTo(285, 40, 1, (0.25 * 2))
	loadbutton.DoClick = function()
		self:Remove()
		parent.loadCharacterPanel:SlideUp()
	end

	--if (!bHasCharacter) then
	--	self.loadButton:SetDisabled(true)
	--end

	local info = self:Add("cellar.main.btn")
	info:SetPos(110, 602 + 43 * (3))
	info:SetText('ИНФОРМАЦИЯ')
	info:SetIcon(3)
	info:SizeTo(285, 40, 1, (0.25 * 3))

	local content = self:Add("cellar.main.btn")
	content:SetPos(110, 602 + 43 * (4))
	content:SetText('КОНТЕНТ')
	content:SetIcon(4)
	content:SizeTo(285, 40, 1, (0.25 * 4))


	local a = self:Add("cellar.main.btn")
	a:SetPos(110, ScrH() - 95 - 40)
	a:SetText("ВЫХОД")
	a:SetIcon(5)
	a:SizeTo(285, 40, 1, 0.25 * 5)
	a.DoClick = function()
		RunConsoleCommand("disconnect")
	end
end
function PANEL:Paint(w, h)
	-- Glowing
	if !self.paint_manual then
		self.background:PaintManual()

		surface.SetDrawColor(color_white)
		surface.SetMaterial(shadow)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetMaterial(rt_mat)
		surface.SetDrawColor(color_white)
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
end

vgui.Register("cellar.main", PANEL, "EditablePanel")

--vgui.Create("cellar.main")



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

if IsValid(cellar_main) then

		cellar_main:Remove()
		cellar_main = nil
	end


