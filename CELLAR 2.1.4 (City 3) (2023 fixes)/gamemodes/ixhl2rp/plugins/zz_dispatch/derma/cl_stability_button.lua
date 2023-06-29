local function DrawCorners(x, y, w, h, length, thickness)
	-- Top left
	surface.DrawRect(x, y, length, thickness)
	surface.DrawRect(x, y, thickness, length)

	-- Top right
	surface.DrawRect(x + (w - length), y, length, thickness)
	surface.DrawRect(x + (w - thickness), y, thickness, length)

	-- Bottom left
	surface.DrawRect(x, y + (h - length), thickness, length)
	surface.DrawRect(x, y + (h - thickness), length, thickness)

	-- Bottom right
	surface.DrawRect(x + (w - thickness), y + (h - length), thickness, length)
	surface.DrawRect(x + (w - length), y + (h - thickness), length, thickness)
end

local PANEL = {}

function PANEL:Init()
	self.font = "dispatch.stability"

	self.text = ""
	self.color = color_white

	self.borderThickness = 1
	self.borderLength = 6
	self.freq = 1

	self:SetText("")
	self:UpdateStability()
end

function PANEL:UpdateStability(callback)
	local id = dispatch.GetStability()

	if self.lastCode == id then
		return
	end
	
	local stability = dispatch.StabilityCode()

	self.text = stability.text
	self.color = stability.color

	self.lastCode = id

	if callback then
		callback(self, stability.isHidden)
	end
end

function PANEL:PaintText(w, h)
	local text = self.text .. "     ///     "
	surface.SetFont(self.font)

	local textw, texth = surface.GetTextSize(text)

	surface.SetTextColor(self.color)

	local x = RealTime() * 100 % textw * -1

	while (x < w) do
		surface.SetTextPos(x, h / 2 - texth / 2)
		surface.DrawText(text)
		x = x + textw
	end
end

function PANEL:SetThickness(thickness)
	self.borderThickness = tonumber(thickness)
end

function PANEL:SetLength(length)
	self.borderLength = tonumber(length)
end

function PANEL:SetFlashFrequency(freq)
	self.freq = tonumber(freq)
end

local function SinBetween(freq, min, max)
	return math.abs(math.sin(CurTime() * freq)) * (max - min) + min
end

function PANEL:Paint(w, h)
	local red = SinBetween(self.freq, 0, self.color.r / 1.6)
	local green = SinBetween(self.freq, 0, self.color.g / 1.6)
	local blue = SinBetween(self.freq, 0, self.color.b / 1.6)

	surface.SetDrawColor(red, green, blue, 100)
	surface.DrawRect(0, 0, w, h)

	self:PaintText(w, h)
	
	surface.SetDrawColor(self.color)

	DrawCorners(0, 0, w, h, self.borderLength, self.borderThickness)
end

vgui.Register("dispatch.stablity", PANEL, "DButton")