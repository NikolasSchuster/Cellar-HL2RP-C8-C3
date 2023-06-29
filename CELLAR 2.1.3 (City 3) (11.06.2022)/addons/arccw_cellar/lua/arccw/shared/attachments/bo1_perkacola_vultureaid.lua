att.PrintName = "Vulture Aid"
att.Icon = Material("entities/acwatt_perk_scavenger.png", "mips smooth")
att.Description = "I was hoping for some insight, I was looking far too hard.\nI was searching for the wrong thing, now I don't know where to start!\nI spy with my little eyes, something beginning with V!\nIt's Vulture Aid, and it's not too late!\n\nGet Vulture Aid!"
att.Desc_Pros = {
    "bo1.perkacola.active",
    "bo1.perkacola.vultureaid",
}
att.Desc_Cons = {
}

att.Slot = {"bo1_perk"}
att.NoRandom = true
att.NotForNPCS = true

att.BO1_VultureAid = true

att.AttachSound = "weapons/arccw/bo1_perks/perk_vulture.wav"

local function drop(ent, attacker)
    local wep = IsValid(attacker) and attacker:IsPlayer() and attacker:GetActiveWeapon()
    if not IsValid(wep) or not wep.ArcCW or not wep:GetBuff_Override("BO1_VultureAid") then return end

--    local mult = ent:IsPlayer() and 3 or (math.Clamp(ent:GetMaxHealth() / 100, 0.1, 6))

    local box = ents.Create("arccw_ammo_bo1_drop")
    box.AmmoType = wep.Primary.Ammo
    box.AmmoCount = wep:GetCapacity()
    box:SetPos(ent:WorldSpaceCenter())
    box:SetAngles(AngleRand(-360, 360))
    box:Spawn()
    box:SetOwner(attacker)
    local phys = box:GetPhysicsObject()
    phys:ApplyForceCenter(Vector(math.random() * 100 - 50, math.random() * 100 - 50, 200))
    phys:SetAngleVelocityInstantaneous(VectorRand() * 360)
    SafeRemoveEntityDelayed(box, 15)
end
hook.Add("OnNPCKilled", "ArcCW_BO1_VultureAid", drop)
hook.Add("PlayerDeath", "ArcCW_BO1_VultureAid", function(ply, infl, atk) drop(ply, atk) end)