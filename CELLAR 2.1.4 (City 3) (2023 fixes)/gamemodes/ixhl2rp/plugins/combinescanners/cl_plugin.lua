local PLUGIN = PLUGIN
local CURRENT_PHOTO = nil
local TEMPLATE = [[
	<html>
		<body style="background: black; overflow: hidden; margin: 0; padding: 0;">
			<img src="data:image/jpeg;base64,%s" width="%s" height="%s" />
		</body>
	</html>
]]
local SOUNDNOT = Sound("npc/overwatch/radiovoice/preparevisualdownload.wav")

function PLUGIN:PlayerBindPress(player, bind, bPressed)
	if !IsValid(player:GetPilotingScanner()) then return end

	bind = bind:lower()

	if bind:find("invnext") or bind:find("invprev") then
		return true
	elseif bind:find("impulse 100") then
		RunConsoleCommand("scanner_spotlight")
		return true
	elseif bind:find("attack") and bPressed then
		RunConsoleCommand("scanner_photo")
		return true
	end
end

net.Receive("ScannerPhoto", function(len)
	PLUGIN.startPicture = true
	PLUGIN.nextPicture = CurTime() + PLUGIN.Picture.delay
end)

net.Receive("ScannerData", function()
	local data = net.ReadData(net.ReadUInt(16))

	data = util.Base64Encode(util.Decompress(data))

	if data then
		--Schema:AddCombineDisplayLine("Prepare to receive visual download...", Color(255, 255, 255, 255))

		LocalPlayer():EmitSound(SOUNDNOT)

		if IsValid(CURRENT_PHOTO) then
			local panel = CURRENT_PHOTO

			CURRENT_PHOTO:AlphaTo(0, 0.25, 0, function()
				if (IsValid(panel)) then
					panel:Remove()
				end
			end)
		end

		local html = string.format(TEMPLATE, data, PLUGIN.Picture.w, PLUGIN.Picture.h)
		local panel = vgui.Create("DPanel")
		panel:SetSize(PLUGIN.Picture.w + 8, PLUGIN.Picture.h + 8)
		panel:SetPos(ScrW(), 8)
		panel:SetPaintBackground(true)
		panel:SetAlpha(150)

		panel.body = panel:Add("DHTML")
		panel.body:Dock(FILL)
		panel.body:DockMargin(4, 4, 4, 4)
		panel.body:SetHTML(html)

		panel:MoveTo(ScrW() - (panel:GetWide() + 8), 8, 0.5)

		timer.Simple(15, function()
			if IsValid(panel) then
				panel:MoveTo(ScrW(), 8, 0.5, 0, -1, function()
					panel:Remove()
				end)
			end
		end)

		CURRENT_PHOTO = panel

		hook.Run("OnScannerPhotoReceived", CURRENT_PHOTO)
	end
end)

local PANEL = {}

function PANEL:Init()
	self:SetWide(225)
	self:SetTall(32)

	self.ButtonColor = Color(47, 67, 87, 255)
	self.OutlineColor = Color(47, 185, 225, 255)
	self:SetTextColor(self.OutlineColor)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.ButtonColor)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.OutlineColor)
	surface.DrawOutlinedRect(0, 0, w, h)
	surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
end

function PANEL:OnCursorEntered(w, h)
	self.ButtonColor = Color(47, 80, 100, 255)
	self.OutlineColor = Color(47, 255, 255, 255)
end

function PANEL:OnCursorExited(w, h)
	self.ButtonColor = Color(47, 67, 87, 255)
	self.OutlineColor = Color(47, 185, 225, 255)
end;

vgui.Register("cwTrButton", PANEL, "DButton")

net.Receive("ScannerEnter", function(len)
	if IsValid(PLUGIN.ControlPanel) then
		PLUGIN.ControlPanel:Remove()
		PLUGIN.ControlPanel = nil
	end

	PLUGIN.ControlPanel = vgui.Create("DPanel")
	PLUGIN.ControlPanel:Dock(RIGHT)
	PLUGIN.ControlPanel:SetWide(130)
	PLUGIN.ControlPanel.Paint = function() end

	local eject = vgui.Create("cwTrButton", PLUGIN.ControlPanel)
	eject:Dock(BOTTOM)
	eject:SetText("EXIT")
	eject.DoClick = function()
		ix.command.Send("ScannerEject")
	end

	hook.Run("OnScannerControls", PLUGIN.ControlPanel)
end)

net.Receive("ScannerExit", function(len)
	if IsValid(PLUGIN.ControlPanel) then
		PLUGIN.ControlPanel:Remove()
		PLUGIN.ControlPanel = nil
	end

	hook.Run("OnScannerControlsRemove")
end)