local rowPaintFunctions = {
	function(width, height)
	end,

	function(width, height)
		surface.SetDrawColor(30, 30, 30, 25)
		surface.DrawRect(0, 0, width, height)
	end
}

-- character icon
-- we can't customize the rendering of ModelImage so we have to do it ourselves
local PANEL = {}
local BODYGROUPS_EMPTY = "000000000"

AccessorFunc(PANEL, "model", "Model", FORCE_STRING)
AccessorFunc(PANEL, "bHidden", "Hidden", FORCE_BOOL)

function PANEL:Init()
	self:SetSize(64, 64)
	self.bodygroups = BODYGROUPS_EMPTY
end

function PANEL:SetModel(model, skin, bodygroups)
	model = model:gsub("\\", "/")

	if (isstring(bodygroups)) then
		if (bodygroups:len() == 9) then
			for i = 1, bodygroups:len() do
				self:SetBodygroup(i, tonumber(bodygroups[i]) or 0)
			end
		else
			self.bodygroups = BODYGROUPS_EMPTY
		end
	end

	self.model = model
	self.skin = skin
	self.path = "materials/spawnicons/" ..
		model:sub(1, #model - 4) .. -- remove extension
		((isnumber(skin) and skin > 0) and ("_skin" .. tostring(skin)) or "") .. -- skin number
		(self.bodygroups != BODYGROUPS_EMPTY and ("_" .. self.bodygroups) or "") .. -- bodygroups
		".png"

	local material = Material(self.path, "smooth")

	-- we don't have a cached spawnicon texture, so we need to forcefully generate one
	if (material:IsError()) then
		self.id = "ixScoreboardIcon" .. self.path
		self.renderer = self:Add("ModelImage")
		self.renderer:SetVisible(false)
		self.renderer:SetModel(model, skin, self.bodygroups)
		self.renderer:RebuildSpawnIcon()

		-- this is the only way to get a callback for generated spawn icons, it's bad but it's only done once
		hook.Add("SpawniconGenerated", self.id, function(lastModel, filePath, modelsLeft)
			filePath = filePath:gsub("\\", "/"):lower()

			if (filePath == self.path) then
				hook.Remove("SpawniconGenerated", self.id)

				self.material = Material(filePath, "smooth")
				self.renderer:Remove()
			end
		end)
	else
		self.material = material
	end
end

function PANEL:SetBodygroup(k, v)
	if (k < 0 or k > 8 or v < 0 or v > 9) then
		return
	end

	self.bodygroups = self.bodygroups:SetChar(k + 1, v)
end

function PANEL:GetModel()
	return self.model or "models/error.mdl"
end

function PANEL:GetSkin()
	return self.skin or 1
end

function PANEL:DoClick()
end

function PANEL:DoRightClick()
end

function PANEL:OnMouseReleased(key)
	if (key == MOUSE_LEFT) then
		self:DoClick()
	elseif (key == MOUSE_RIGHT) then
		self:DoRightClick()
	end
end

function PANEL:Paint(width, height)
	if (!self.material) then
		return
	end

	surface.SetMaterial(self.material)
	surface.SetDrawColor(self.bHidden and color_black or color_white)
	surface.DrawTexturedRect(0, 0, width, height)
end

function PANEL:Remove()
	if (self.id) then
		hook.Remove("SpawniconGenerated", self.id)
	end
end

vgui.Register("ixScoreboardIcon", PANEL, "Panel")

-- player row
PANEL = {}

AccessorFunc(PANEL, "paintFunction", "BackgroundPaintFunction")

function PANEL:Init()
	self:SetTall(64)

	self.icon = self:Add("ixScoreboardIcon")
	self.icon:Dock(LEFT)
	self.icon.DoRightClick = function()
		local client = self.player

		if (!IsValid(client)) then
			return
		end

		local menu = DermaMenu()

		menu:AddOption(L("viewProfile"), function()
			client:ShowProfile()
		end)

		menu:AddOption(L("copySteamID"), function()
			SetClipboardText(client:IsBot() and client:EntIndex() or client:SteamID())
		end)

		hook.Run("PopulateScoreboardPlayerMenu", client, menu)
		menu:Open()
	end

	self.icon:SetHelixTooltip(function(tooltip)
		local client = self.player

		if (IsValid(self) and IsValid(client)) then
			ix.hud.PopulatePlayerTooltip(tooltip, client)
		end
	end)

	self.name = self:Add("DLabel")
	self.name:DockMargin(4, 4, 0, 0)
	self.name:Dock(TOP)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixGenericFont")

	self.description = self:Add("DLabel")
	self.description:DockMargin(5, 0, 0, 0)
	self.description:Dock(TOP)
	self.description:SetTextColor(color_white)
	self.description:SetFont("ixSmallFont")

	self.paintFunction = rowPaintFunctions[1]
	self.nextThink = CurTime() + 1
end

function PANEL:Update()
	local client = self.player
	local model = client:GetModel()
	local skin = client:GetSkin()
	local name = client:GetName()
	local description = hook.Run("GetCharacterDescription", client) or
		(client:GetCharacter() and client:GetCharacter():GetDescription()) or ""

	local bRecognize = false
	local localCharacter = LocalPlayer():GetCharacter()
	local character = IsValid(self.player) and self.player:GetCharacter()

	if (localCharacter and character) then
		bRecognize = hook.Run("IsCharacterRecognized", localCharacter, character:GetID())
			or hook.Run("IsPlayerRecognized", self.player)
	end

	self.icon:SetHidden(!bRecognize)
	self:SetZPos(bRecognize and 1 or 2)

	-- no easy way to check bodygroups so we'll just set them anyway
	for _, v in pairs(client:GetBodyGroups()) do
		self.icon:SetBodygroup(v.id, client:GetBodygroup(v.id))
	end

	if (self.icon:GetModel() != model or self.icon:GetSkin() != skin) then
		self.icon:SetModel(model, skin)
		self.icon:SetTooltip(nil)
	end

	if (self.name:GetText() != name) then
		self.name:SetText(name)
		self.name:SizeToContents()
	end

	if (self.description:GetText() != description) then
		self.description:SetText(description)
		self.description:SizeToContents()
	end
end

function PANEL:Think()
	if (CurTime() >= self.nextThink) then
		local client = self.player

		if (!IsValid(client) or !client:GetCharacter() or self.character != client:GetCharacter() or self.team != client:Team()) then
			self:Remove()
			self:GetParent():SizeToContents()
		end

		self.nextThink = CurTime() + 1
	end
end

function PANEL:SetPlayer(client)
	self.player = client
	self.team = client:Team()
	self.character = client:GetCharacter()

	self:Update()
end

function PANEL:Paint(width, height)
	self.paintFunction(width, height)
end

vgui.Register("ixScoreboardRow", PANEL, "EditablePanel")

-- faction grouping
PANEL = {}

AccessorFunc(PANEL, "faction", "Faction")

function PANEL:Init()
	self:DockMargin(0, 0, 0, 16)
	self:SetTall(32)

	self.nextThink = 0
end

function PANEL:AddPlayer(client, index)
	if (!IsValid(client) or !client:GetCharacter() or hook.Run("ShouldShowPlayerOnScoreboard", client) == false) then
		return false
	end

	local id = index % 2 == 0 and 1 or 2
	local panel = self:Add("ixScoreboardRow")
	panel:SetPlayer(client)
	panel:Dock(TOP)
	panel:SetZPos(2)
	--panel:SetBackgroundPaintFunction(rowPaintFunctions[id])

	self:SizeToContents()
	client.ixScoreboardSlot = panel

	return true
end

function PANEL:SetFaction(faction)
	--self:SetColor(faction.color)
	--self:SetText(L(faction.name))

	self.faction = faction
end

function PANEL:Update()
	local faction = self.faction

	if (team.NumPlayers(faction.index) == 0) then
		self:SetVisible(false)
		self:GetParent():InvalidateLayout()
	else
		local bHasPlayers

		for k, v in ipairs(team.GetPlayers(faction.index)) do
			if (!IsValid(v.ixScoreboardSlot)) then
				if (self:AddPlayer(v, k)) then
					bHasPlayers = true
				end
			else
				v.ixScoreboardSlot:Update()
				bHasPlayers = true
			end
		end

		self:SetVisible(bHasPlayers)
	end
end

vgui.Register("ixScoreboardFaction", PANEL, "ixCategoryPanel")

-- main scoreboard panel
PANEL = {}

function PANEL:Init()
	if (IsValid(ix.gui.scoreboard)) then
		ix.gui.scoreboard:Remove()
	end

	self:Dock(FILL)

	self.factions = {}
	self.nextThink = 0

	for i = 1, #ix.faction.indices do
		local faction = ix.faction.indices[i]

		local panel = self:Add("ixScoreboardFaction")
		panel:SetFaction(faction)
		panel:Dock(TOP)
		panel.Paint = function(me, w, h)
			draw.RoundedBox(0, 0, 29, w, h, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, h - 1, w, 1, Color(56, 207, 248))

			draw.RoundedBox(0, 0, 29, 1, h, Color(56, 207, 248))
			draw.RoundedBox(0, 0, 5, 1, 21, Color(56, 207, 248))

			draw.RoundedBox(0, w - 1, 29, 1, h, Color(56, 207, 248))
			draw.RoundedBox(0, 0, 0, w, 2, Color(56, 207, 248))
			draw.RoundedBox(0, w - 1, 0, 1, 26, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.33, 25, w * .33, 1, Color(56, 207, 248))
			draw.RoundedBox(0, 0, 29, w, 1, Color(56, 207, 248))
			
			draw.RoundedBox(0, w - w*.3307, 24, w * .3307, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3314, 23, w * .3314, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3319, 22, w * .3319, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3325, 21, w * .3325, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3330, 20, w * .3330, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3335, 19, w * .3335, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3340, 18, w * .3340, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3347, 17, w * .3347, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3354, 16, w * .3354, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3361, 15, w * .3361, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3368, 14, w * .3368, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3375, 13, w * .3375, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3380, 12, w * .3380, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3385, 11, w * .3385, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3390, 10, w * .3390, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3400, 9, w * .3400, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3403, 8, w * .3403, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3410, 7, w * .3410, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3415, 6, w * .3415, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3423, 5, w * .3423, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3430, 4, w * .3430, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3435, 3, w * .3435, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, w - w*.3442, 2, w * .3442, 1, Color(43, 157, 189, 43))

			
			--draw.RoundedBox(0, 0, 28, w - w*.3279 - 6, 1, Color(43, 157, 189, 43))
			--draw.RoundedBox(0, 0, 27, w - w*.3285 - 6, 1, Color(43, 157, 189, 43))
			--draw.RoundedBox(0, 0, 26, w - w*.3293 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 25, w - w*.33 - 6, 1, Color(56, 207, 248))
			draw.RoundedBox(0, 0, 24, w - w*.3307 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 23, w - w*.3314 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 22, w - w*.3319 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 21, w - w*.3325 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 20, w - w*.3330 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 19, w - w*.3335 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 18, w - w*.3340 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 17, w - w*.3347 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 16, w - w*.3354 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 15, w - w*.3361 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 14, w - w*.3368 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 13, w - w*.3375 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 12, w - w*.3380 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 11, w - w*.3385 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 10, w - w*.3390 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 9, w - w*.3400 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 8, w - w*.3403 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 7, w - w*.3410 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 6, w - w*.3415 - 6, 1, Color(43, 157, 189, 43))
			draw.RoundedBox(0, 0, 5, w - w*.3423 - 6, 1, Color(43, 157, 189, 43))

			draw.RoundedBox(0, w - w*.3307, 24, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3314, 23, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3319, 22, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3325, 21, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3330, 20, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3335, 19, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3340, 18, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3347, 17, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3354, 16, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3361, 15, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3368, 14, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3375, 13, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3380, 12, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3385, 11, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3392, 10, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3400, 9, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3403, 8, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3410, 7, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3416, 6, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3423, 5, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3430, 4, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3435, 3, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3442, 2, 2, 1, Color(56, 207, 248))

			--draw.RoundedBox(0, w - w*.3272 - 6, 29, 2, 1, Color(56, 207, 248))
			--draw.RoundedBox(0, w - w*.3279 - 6, 28, 2, 1, Color(56, 207, 248))
			--draw.RoundedBox(0, w - w*.3285 - 6, 27, 2, 1, Color(56, 207, 248))
			--draw.RoundedBox(0, w - w*.3293 - 6, 26, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.33 - 6, 25, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3307 - 6, 24, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3314 - 6, 23, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3319 - 6, 22, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3325 - 6, 21, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3330 - 6, 20, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3335 - 6, 19, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3340 - 6, 18, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3347 - 6, 17, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3354 - 6, 16, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3361 - 6, 15, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3368 - 6, 14, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3375 - 6, 13, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3380 - 6, 12, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3385 - 6, 11, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3392 - 6, 10, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3400 - 6, 9, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3403 - 6, 8, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3410 - 6, 7, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3416 - 6, 6, 2, 1, Color(56, 207, 248))
			draw.RoundedBox(0, w - w*.3422 - 6, 5, 2, 1, Color(56, 207, 248))

			draw.RoundedBox(0, 0, 5, w - w*.3423 - 5, 1, Color(56, 207, 248))

			draw.SimpleText(L(faction.name):utf8upper(), 'cellar.main.btn', w - 6, 14, Color(56, 207, 248), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(L(faction.name):utf8upper(), 'cellar.main.btn.blur', w - 6, 14, Color(56, 61, 248, 225), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		end

		self.factions[i] = panel
	end

	ix.gui.scoreboard = self
end

function PANEL:Think()
	if (CurTime() >= self.nextThink) then
		for i = 1, #self.factions do
			local factionPanel = self.factions[i]

			factionPanel:Update()
		end

		self.nextThink = CurTime() + 0.5
	end
end

vgui.Register("ixScoreboard", PANEL, "DScrollPanel")

hook.Add("CreateMenuButtons", "ixScoreboard", function(tabs)
	tabs["scoreboard"] = function(container)
		container:Add("ixScoreboard")
	end
end)
