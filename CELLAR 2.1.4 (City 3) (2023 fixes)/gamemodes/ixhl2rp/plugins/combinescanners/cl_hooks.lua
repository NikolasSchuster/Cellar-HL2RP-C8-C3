local PLUGIN = PLUGIN
local zoom = 0
local deltaZoom = zoom
local nextClick = 0

function PLUGIN:CalcView(player, origin, angles, fov, znear, zfar)
	local scanner = player:GetPilotingScanner()
	local thirdperson = ix.option.Get("thirdpersonEnabled", false)

	if player:IsPilotScanner() and !thirdperson then
		local ang = player:EyeAngles()
		ang:RotateAroundAxis(-ang:Forward(), angles.r)

		local data = {
			origin = scanner:GetPos(),
			angles = ang,
			drawviewer = true
		}

		data.fov = fov - deltaZoom

		if math.abs(deltaZoom - zoom) > 5 and nextClick < RealTime() then
			nextClick = RealTime() + 0.05
			player:EmitSound("common/talk.wav", 100, 180)
		end

		return data
	end
end

function PLUGIN:InputMouseApply(command, x, y, angle)
	if LocalPlayer():IsPilotScanner() then
		zoom = math.Clamp(zoom + command:GetMouseWheel() * 1.5, 0, 40)
		deltaZoom = Lerp(FrameTime() * 2, deltaZoom, zoom)
	end
end

surface.CreateFont("ixScannerFont", {
	font = "Lucida Sans Typewriter",
	antialias = false,
	outline = true,
	weight = 800,
	size = 18
})

function PLUGIN:HUDPaint()
	if LocalPlayer():IsPilotScanner() then
		local scrW, scrH = surface.ScreenWidth() * 0.5, surface.ScreenHeight() * 0.5
		local x, y = scrW - self.Picture.w2, scrH - self.Picture.h2

		if ((self.nextPicture or 0) >= CurTime()) then
			local percent = math.Round(math.TimeFraction(self.nextPicture - self.Picture.delay, self.nextPicture, CurTime()), 2) * 100
			local glow = math.sin(RealTime() * 15) * 25

			draw.SimpleText(string.format("RE-CHARGING: %d%%", percent), "ixScannerFont", x, y - 24, Color(255 + glow, 100 + glow, 25, 250))
		end

		local client = LocalPlayer()
		local scanner = client:GetPilotingScanner()
		local position = client:GetPos()
		local angle = client:GetAimVector():Angle()

		draw.SimpleText(string.format("POS (%d, %d, %d)", position[1], position[2], position[3]), "ixScannerFont", x + 8, y + 8, color_white)
		draw.SimpleText(string.format("ANG (%d, %d, %d)", angle[1], angle[2], angle[3]), "ixScannerFont", x + 8, y + 24, color_white)
		draw.SimpleText(string.format("ID (%s)", client:Name()), "ixScannerFont", x + 8, y + 40, color_white)
		draw.SimpleText(string.format("ZM (%d%%)", math.Round(zoom / 40, 2) * 100), "ixScannerFont", x + 8, y + 56, color_white)

		local data = {}
			data.start = scanner:GetPos()
			data.endpos = data.start + client:GetAimVector() * 500
			data.filter = scanner
		local entity = util.TraceLine(data).Entity
		local name = (IsValid(entity) and entity:IsPlayer()) and entity:Name() or "UNKNOWN"

		draw.SimpleText(string.format("TRG (%s)", name), "ixScannerFont", x + 8, y + 72, color_white)

		surface.SetDrawColor(235, 235, 235, 230)

		surface.DrawLine(0, scrH, x - 128, scrH)
		surface.DrawLine(scrW + self.Picture.w2 + 128, scrH, ScrW(), scrH)
		surface.DrawLine(scrW, 0, scrW, y - 128)
		surface.DrawLine(scrW, scrH + self.Picture.h2 + 128, scrW, ScrH())

		surface.DrawLine(x, y, x + 128, y)
		surface.DrawLine(x, y, x, y + 128)

		x = scrW + self.Picture.w2

		surface.DrawLine(x, y, x - 128, y)
		surface.DrawLine(x, y, x, y + 128)

		x = scrW - self.Picture.w2
		y = scrH + self.Picture.h2

		surface.DrawLine(x, y, x + 128, y)
		surface.DrawLine(x, y, x, y - 128)

		x = scrW + self.Picture.w2

		surface.DrawLine(x, y, x - 128, y)
		surface.DrawLine(x, y, x, y - 128)

		surface.DrawLine(scrW - 48, scrH, scrW - 8, scrH)
		surface.DrawLine(scrW + 48, scrH, scrW + 8, scrH)
		surface.DrawLine(scrW, scrH - 48, scrW, scrH - 8)
		surface.DrawLine(scrW, scrH + 48, scrW, scrH + 8)
	end
end

function PLUGIN:PreRender()
	if self.startPicture and LocalPlayer():IsPilotScanner() then
		local scanner = LocalPlayer():GetPilotingScanner()
		scanner.RenderOverride = function() return end
	end
end

function PLUGIN:PostRender()
	if self.startPicture and LocalPlayer():IsPilotScanner() then
		local scanner = LocalPlayer():GetPilotingScanner()
		local data = util.Compress(render.Capture({
			format = "jpeg",
			h = self.Picture.h,
			w = self.Picture.w,
			quality = 50,
			x = ScrW() * 0.5 - self.Picture.w2,
			y = ScrH() * 0.5 - self.Picture.h2
		}))

		net.Start("ScannerData")
			net.WriteUInt(#data, 16)
			net.WriteData(data, #data)
		net.SendToServer()

		scanner.RenderOverride = nil
		self.startPicture = false
	end
end