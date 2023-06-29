Schema.scoreboardClasses = {
	["scCityAdm"] = Color(255, 200, 100, 255),
	["scCWU"] = Color(255, 215, 0, 255),
	["scOTA"] = Color(150, 50, 50, 255),
	["scMPF"] = Color(50, 100, 150)
}

local squad_glow_clr = Color(0, 63, 255)

local function scale(px)
	return math.ceil(math.max(480, ScrH()) * (px / 1080))
end

local function stabilityHUD()
	local border_size, stability_w, stability_h = scale(64),  scale(385), scale(52)
	local scrW, scrH = ScrW(), ScrH()

	local stability = vgui.Create("dispatch.stablity")
	stability:SetSize(stability_w, stability_h)
	stability:SetPos(scrW - stability_w - border_size, border_size / 2 - stability_h / 2)
	stability:SetAlpha(0)

	ix.gui.stability = stability

	timer.Create("Stability", 1, 0, function()
		if !IsValid(ix.gui.stability) then
			timer.Remove("Stability")
			return
		end

		ix.gui.stability:UpdateStability(function(self, isHidden)
			if isHidden then
				self:AlphaTo(0, 0.2)
			else
				self:AlphaTo(255, 0.2)
			end
		end)
	end)
end

function PLUGIN:CharacterLoaded(character)
	local faction = ix.faction.Get(character:GetFaction())

	if faction.canSeeWaypoints then
		hook.Add("HUDPaint", "dispatch.waypoints", dispatch.DrawWaypoints)
		hook.Add("CreateMove", "dispatch.radialmenu", dispatch.ShowQuickPingMenu)
	else
		hook.Remove("HUDPaint", "dispatch.waypoints")
		hook.Remove("CreateMove", "dispatch.radialmenu")
	end

	if character:IsCombine() and character:GetFaction() != FACTION_DISPATCH then
		stabilityHUD()

		hook.Add("PlayerButtonDown", "dispatch.quick", function(_, btn) if btn == KEY_LALT then hook.Run("patrolmenu.open") end end)
		hook.Add("PlayerButtonUp", "dispatch.quick", function(_, btn) if btn == KEY_LALT then hook.Run("patrolmenu.close") end end)
	else
		if IsValid(ix.gui.stability) then
			ix.gui.stability:Remove()
		end

		hook.Remove("PlayerButtonDown", "dispatch.quick")
		hook.Remove("PlayerButtonUp", "dispatch.quick")
		hook.Remove("PreDrawHalos", "SquadGlow")
	end
end

function PLUGIN:OnJoinSquad(squad)
	if squad:IsStatic() then
		hook.Run("OnLeftSquad", LocalPlayer():GetCharacter().lastSquad)
		return
	end

	hook.Add("PreDrawHalos", "SquadGlow", function()
		halo.Add(squad:GetPlayers(), squad_glow_clr, 0.5, 0.5, 0, true, true)
	end)

	if IsValid(ix.gui.squads) then
		ix.gui.squads:SetButtonState(false)
	end
end

function PLUGIN:OnLeftSquad(squad)
	hook.Remove("PreDrawHalos", "SquadGlow")

	if IsValid(ix.gui.squads) then
		ix.gui.squads:SetButtonState(true)
	end
end

-- wtf is the km
function PLUGIN:OnSquadChangedLeader(id, squad, character)
	if IsValid(ix.gui.squads) then
		ix.gui.squads:OnSquadChangedLeader(id, squad, character)
	end

	if IsValid(ix.gui.dispatch) then
		ix.gui.dispatch:OnSquadChangedLeader(id, squad, character)
	end
end

function PLUGIN:OnSquadMemberLeft(id, squad, character)
	if IsValid(ix.gui.squads) then
		ix.gui.squads:OnSquadMemberLeft(id, squad, character)
	end

	if IsValid(ix.gui.dispatch) then
		ix.gui.dispatch:OnSquadMemberLeft(id, squad, character)
	end
end

function PLUGIN:OnSquadMemberJoin(id, squad, character)
	if IsValid(ix.gui.squads) then
		ix.gui.squads:OnSquadMemberJoin(id, squad, character)
	end

	if IsValid(ix.gui.dispatch) then
		ix.gui.dispatch:OnSquadMemberJoin(id, squad, character)
	end
end

function PLUGIN:OnSquadDestroy(id, squad)
	if IsValid(ix.gui.squads) then
		ix.gui.squads:OnSquadDestroy(id, squad)
	end

	if IsValid(ix.gui.dispatch) then
		ix.gui.dispatch:OnSquadDestroy(id, squad)
	end
end

function PLUGIN:OnSquadSync(id, squad, full)
	if IsValid(ix.gui.squads) then
		ix.gui.squads:OnSquadSync(id, squad, full)
	end

	if IsValid(ix.gui.dispatch) then
		ix.gui.dispatch:OnSquadSync(id, squad, full)
	end
end