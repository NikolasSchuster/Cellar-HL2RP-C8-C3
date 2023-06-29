-- Function Cache
local color = Color
local draw_roundedbox = draw.RoundedBox
local draw_simpletext = draw.SimpleText
local draw_notexture = draw.NoTexture
local surface_setdrawcolor = surface.SetDrawColor
-- Color cache
local inputBlack = color(100, 100, 100)
local mainRed = color(155, 50, 50)
local mainBlack = color(38, 38, 38)
local textWhite = color(220, 220, 220)

-- Text Entry
local PANEL = {}
function PANEL:Init()
	self:DockMargin(5, 5, 5, 5)
	self:SetFont("pCasino.Textbox.Static")
	self:SetText("")
	self:SetDisplayText("Input")
end

function PANEL:SetDisplayText(text)
	self.placeholder = text
end

function PANEL:Paint(w, h)
	draw_roundedbox(3, 0, 0, w, h, mainRed)
	draw_roundedbox(3, 1, 1, w - 2, h - 2, mainBlack)

	self:DrawTextEntryText(textWhite, mainRed, mainRed)

	if(self:GetText() == "") and not self:HasFocus() then
		draw_simpletext(self.placeholder, "pCasino.Textbox.Static", 5, h/2, textWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end
vgui.Register('pCasinoEntry', PANEL, 'DTextEntry')

-- Switch
-- Created by Livaco, edited by Owain.
local PANEL = {}
function PANEL:Init()
	self:SetText("")
	self.toggle = true

	self.lerp = 0.2
end
function PANEL:DoClick()
	self:Toggle()
end
function PANEL:Toggle()
	self:SetToggle(not self:GetToggle())
end
function PANEL:GetToggle()
	return self.toggle
end
function PANEL:SetToggle(value)
	self.toggle = value
end
function PANEL:Paint(w, h)
	draw_roundedbox(3, w*0.05, h*0.3, w*0.9, h*0.4, inputBlack)

	if self:GetToggle() then
		self.lerp = Lerp(0.1, self.lerp, 0.8)
	else
		self.lerp = Lerp(0.1, self.lerp, 0.2)
	end

	draw_notexture()
	surface_setdrawcolor(200-(200*self.lerp), 0+(200*self.lerp), 0, 255)
	PerfectCasino.UI.DrawCircle(w*self.lerp, h*0.5, h*0.35, 1)
end
vgui.Register('pCasinoSwitch', PANEL, 'DButton')


-- Circle Function
-- Created by Ben.
local sinCache = {}
local cosCache = {}
for i = 0, 360 do
	sinCache[i] = math.sin(math.rad(i))
	cosCache[i] = math.cos(math.rad(i))
end
function PerfectCasino.UI.DrawCircle(x, y, r, step)
    local positions = {}

    for i = 0, 360, step do
        table.insert(positions, {
            x = x + cosCache[i] * r,
            y = y + sinCache[i] * r
        })
    end

    return surface.DrawPoly(positions)
end

-- Rotate around point
-- Taken from wiki: https://wiki.facepunch.com/gmod/surface.DrawTexturedRectRotated
function PerfectCasino.UI.DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
	local c = math.cos(math.rad(rot))
	local s = math.sin(math.rad(rot))
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

-- Rotate text
-- Taken from wiki: https://wiki.facepunch.com/gmod/cam.PushModelMatrix
function PerfectCasino.UI.TextRotated(text, x, y, color, font, ang, shift)
	local mat = Matrix()
	mat:Rotate(Angle(0, ang, 0))
	mat:SetTranslation(Vector(x, y, shift or 0))
	
	cam.PushModelMatrix(mat, true)
	    draw_simpletext(text, font, 0, 0, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	cam.PopModelMatrix()    
end

-- Apply st, nd, rd, th to a number. This only works to 20, but there will never be an internal usecase past 20
-- Taken from xSits: A custom addon written by Owain
function PerfectCasino.UI.NumberSuffix(i)
	if i == 1 then
		return i.."st"
	elseif i == 2 then
		return i.."nd"
	elseif i == 3 then
		return i.."rd"
	end

	return i.."th"
end

-- Wrap text
-- Taken from XYZUI: A custom UI library written by Owain
function PerfectCasino.UI.WrapText(text, wrap, font, posx, posy, color, align1, align2)
	text = string.Explode("", text)

	local newText = {}
	for i=1, math.ceil(#text/wrap) do
		newText[i] = ""
		for p=1 + ((i-1)*wrap), i*wrap do
			if not text[p] then break end

			newText[i] = newText[i]..text[p]
		end
	end

	text = newText

	local space = 30*#text
	local startingPos = posy-(space/2)+(30/2)

	for k, v in pairs(text) do
		draw_simpletext(v, font, posx, startingPos+((k-1)*30), color or color_white, align1, align2)
	end
end
