TOOL.Category = "pCasino"
TOOL.Name = "#tool.pcasino_creator.name"
TOOL.Command = nil
TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
} 


if CLIENT then
	language.Add("tool.pcasino_creator.name", "Entity Creation")
	language.Add("tool.pcasino_creator.desc", "Used to place all the pCasino entities.")

    language.Add("tool.pcasino_creator.left", "Place the configured entity.")
    language.Add("tool.pcasino_creator.right", "Open the menu to configure an entity.")
    language.Add("tool.pcasino_creator.reload", "Remove the entity permanently.")
end

local cooldown = 0
local currentEnt
local offset = {
	["pcasino_slot_machine"] = function(ent) return Vector(0, 0, 48) end,
	["pcasino_roulette_table"] = function(ent) return Vector(0, 0, 20) end,
	["pcasino_blackjack_table"] = function(ent) return Vector(0, 0, 22) end,
	["pcasino_wheel_slot_machine"] = function(ent) return Vector(0, 0, 44) end,
	["pcasino_mystery_wheel"] = function(ent) return Vector(0, 0, 61) end,
	["pcasino_sign_plaque"] = function(ent) return ent:GetForward() * 4 end,
	["pcasino_sign_stand"] = function(ent) return Vector(0, 0, 27) end,
	["pcasino_sign_wall_logo"] = function(ent) return ent:GetForward() * 6 end,
	["pcasino_sign_interior_standing"] = function(ent) return Vector(0, 0, 29	) end,
	["pcasino_sign_interior_wall"] = function(ent) return ent:GetForward() * 2.5 end,
	["pcasino_chair"] = function(ent) return Vector(0, 0, 26) end,
	["pcasino_prize_plinth"] = function(ent) return Vector(0, 0, 0) end,
	["pcasino_npc"] = function(ent) return Vector(0, 0, 1) end
}
local ang = {
	["pcasino_chair"] = function(ent) return Angle(0, 180, 0) end
}

function TOOL:LeftClick(trace)
	if SERVER then return end
	if PerfectCasino.Cooldown.Check("ToolGun:Cooldown", 1) then return end
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	if not PerfectCasino.UI.CurrentSettings.Entity then
		PerfectCasino.Core.Msg(PerfectCasino.Translation.ToolGun.NoEntity)
		return
	end

	if cooldown > CurTime() then return end
	cooldown = CurTime() + 1

	plyAngle = LocalPlayer():GetAngles()
	net.Start("pCasino:ToolGun:CreateEntity")
		net.WriteString(PerfectCasino.UI.CurrentSettings.Entity)
		net.WriteTable(PerfectCasino.UI.CurrentSettings.Settings)
		net.WriteVector(trace.HitPos + plyAngle:Forward() + plyAngle:Up() + (offset[PerfectCasino.UI.CurrentSettings.Entity] and offset[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or vector_origin))
		net.WriteAngle(Angle(0, math.Round(plyAngle.y/10)*10 + 180, plyAngle.z) + (ang[PerfectCasino.UI.CurrentSettings.Entity] and ang[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or angle_zero))
	net.SendToServer()
end

function TOOL:RightClick(trace)
	if SERVER then return end
	if PerfectCasino.Cooldown.Check("ToolGun:Cooldown", 1) then return end
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	if cooldown > CurTime() then return end
	cooldown = CurTime() + 1
	PerfectCasino.UI.Config()
end

function TOOL:Reload(trace)
	if CLIENT then return end
	if not PerfectCasino.Core.Access(self:GetOwner()) then return end
	local entity = trace.Entity
	if not entity.DatabaseID then return end
	PerfectCasino.Database.DeleteEntityByID(entity.DatabaseID)
	entity:Remove()
end

concommand.Add("pcasino_remove_ent", function(ply)
	if CLIENT then return end
	if not PerfectCasino.Core.Access(ply) then return end
	local entity = ply:GetEyeTrace().Entity
	if not entity.DatabaseID then return end
	PerfectCasino.Database.DeleteEntityByID(entity.DatabaseID)
	entity:Remove()
end)

concommand.Add("pcasino_update_pos", function(ply)
	if CLIENT then return end
	if not IsValid(ply) then return end
	if not PerfectCasino.Core.Access(ply) then return end

	PerfectCasino.Database.UpdateAllPositions()
end)


function TOOL:Think()
	if SERVER then return end
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	if not PerfectCasino.UI.CurrentSettings.Entity then
		if IsValid(currentEnt) then currentEnt:Remove() end
		return
	end

	if not IsValid(currentEnt) then
		currentEnt = ents.CreateClientProp()
		currentEnt:SetModel(PerfectCasino.Core.Entites[PerfectCasino.UI.CurrentSettings.Entity].model)
		currentEnt:SetMaterial("models/wireframe")
		currentEnt:Spawn()
	end
	if not (currentEnt:GetModel() == PerfectCasino.Core.Entites[PerfectCasino.UI.CurrentSettings.Entity].model) then
		currentEnt:SetModel(PerfectCasino.Core.Entites[PerfectCasino.UI.CurrentSettings.Entity].model)
	end
	trace = LocalPlayer():GetEyeTrace()
	plyAngle = LocalPlayer():GetAngles()
	currentEnt:SetPos(trace.HitPos + plyAngle:Forward() + plyAngle:Up() + (offset[PerfectCasino.UI.CurrentSettings.Entity] and offset[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or vector_origin))
	currentEnt:SetAngles(Angle(0, math.Round(plyAngle.y/10)*10 + 180, plyAngle.z) + (ang[PerfectCasino.UI.CurrentSettings.Entity] and ang[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or angle_zero))
end

function TOOL:Holster()
	if IsValid(currentEnt) then
		currentEnt:Remove()
		currentEnt = nil
	end
end

local darBack = Color(0, 0, 0, 240)
local red = Color(200, 0, 0)
function TOOL:DrawHUD()
	if not FPP then return end
	
	local ent = self.Owner:GetEyeTrace().Entity
	if not IsValid(ent) then return end
	if not PerfectCasino.Core.Entites[ent:GetClass()] then return end
	if FPP.canTouchEnt(self.Owner:GetEyeTrace().Entity, "Toolgun") then return end
	
	draw.RoundedBox(0, 0, ScrH()*0.5-50, ScrW(), 100, darBack)
	draw.SimpleText(PerfectCasino.Translation.ToolGun.DeletePermissions, "pCasino.Main.Static", ScrW()*0.5, ScrH()*0.5, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(PerfectCasino.Translation.ToolGun.FPPCheck, "pCasino.Nav.Static", ScrW()*0.5, ScrH()*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end