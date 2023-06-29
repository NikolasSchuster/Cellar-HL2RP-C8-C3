ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Ballistic Knife (BO1)"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Ticks = 0
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE
ENT.CanPickup = true

if CLIENT then
    killicon.Add("arccw_bo1_ballistic_knife", "arccw/weaponicons/arccw_bo1_ballistic_knife", Color(255, 255, 255, 255))
end

if SERVER then
    AddCSLuaFile()

    function ENT:Initialize()
        self:SetModel("models/weapons/arccw/item/bo1_bknife.mdl")
        self:SetNoDraw(false)
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInitBox(Vector(-4, -2, -2), Vector(32, 2, 2))
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:DrawShadow(false)
        local phys = self:GetPhysicsObject()

        if (phys:IsValid()) then
            phys:Wake()
            phys:EnableGravity(true)
            phys:SetBuoyancyRatio(0.1)
            phys:SetDragCoefficient(5)
            phys:SetMass(10) -- avoid collision damage
        end

        util.SpriteTrail(self, 0, Color(255, 255, 255), false, 3, 1, 0.15, 2, "trails/tube.vmt")
        SafeRemoveEntityDelayed(self, 60)
        self:SetPhysicsAttacker(self:GetOwner(), 10)
    end

    function ENT:Think()
        if self.Stuck then
            if self:GetSolid() == SOLID_VPHYSICS then
                return
            elseif not self.AttachToWorld and (not IsValid(self:GetParent())) or (IsValid(self:GetParent()) and self:GetParent():GetSolid() ~= SOLID_VPHYSICS and (self:GetParent():Health() <= 0)) then
                timer.Simple(0, function()
                    self:SetParent()
                    self:PhysicsInit(SOLID_VPHYSICS)
                    self:PhysWake()

                    if self.AttachTime + 0.1 - CurTime() > 0 then
                        self:GetPhysicsObject():SetVelocityInstantaneous(self.OldVelocity * 0.15)
                    end

                    self:SetTrigger(true)
                    self:UseTriggerBounds(true, 16)
                end)
            end
        else
            local v = self:GetVelocity()
            self:SetAngles(v:Angle())
            self:GetPhysicsObject():SetVelocityInstantaneous(v)
        end

        self:NextThink(CurTime() + 0.03)

        return true
    end

    function ENT:StartTouch(ent)
        if self.Stuck and self.CanPickup and ent:IsPlayer() then
            ent:GiveAmmo(1, "xbowbolt")
            self:Remove()
        end
    end

    function ENT:Use(ply)
        if self.Stuck and self.CanPickup then
            ply:GiveAmmo(1, "xbowbolt")
            self:Remove()
        end
    end

    function ENT:PhysicsCollide(data, physobj)
        if self.Stuck then return end
        self.Stuck = true
        self.OldVelocity = data.OurOldVelocity
        self.AttachTime = CurTime()
        local tgt = data.HitEntity
        local dmginfo = DamageInfo()
        dmginfo:SetDamageType(DMG_NEVERGIB)
        dmginfo:SetDamage(self.Damage)
        dmginfo:SetAttacker(self:GetOwner())
        dmginfo:SetInflictor(self)
        dmginfo:SetDamageForce(self.OldVelocity * 10)
        tgt:TakeDamageInfo(dmginfo)

        if IsValid(tgt) then
            self:EmitSound("ArcCW_BO1.Knife_Slash", 80, math.random(70, 90))
        else
            self:EmitSound("^weapons/arccw/bo1_knife/hit_object/0.wav", 80, 95, 0.5)
        end

        local angles = self:GetAngles()

        if tgt:IsWorld() or (IsValid(tgt) and tgt:GetPhysicsObject():IsValid()) then
            timer.Simple(0, function()
                self:SetAngles(angles)
                self:SetPos(data.HitPos - data.OurOldVelocity:GetNormalized() * math.random(18, 24))
                self:GetPhysicsObject():Sleep()

                if tgt:IsWorld() or IsValid(tgt) then
                    self:SetSolid(SOLID_NONE)
                    self:SetMoveType(MOVETYPE_NONE)
                    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

                    local f = {self}
                    table.Add(f, tgt:GetChildren())

                    local tr = util.TraceLine({
                        start = data.HitPos - data.OurOldVelocity * 0.5,
                        endpos = data.HitPos + data.OurOldVelocity,
                        filter = f,
                        mask = MASK_SHOT
                    })

                    local bone = tr.Entity:TranslatePhysBoneToBone(tr.PhysicsBone) or tr.Entity:GetHitBoxBone(tr.HitBox, tr.Entity:GetHitboxSet())
                    local matrix = tgt:GetBoneMatrix(bone or 0)
                    if tr.Entity == tgt and bone and matrix then
                        local pos = matrix:GetTranslation()
                        local ang = matrix:GetAngles()
                        self:FollowBone(tgt, bone)
                        local n_pos, n_ang = WorldToLocal(tr.HitPos, tr.Normal:Angle(), pos, ang)
                        self:SetLocalPos(n_pos)
                        self:SetLocalAngles(n_ang)
                        debugoverlay.Cross(pos, 8, 5, Color(255, 0, 255), true)
                    elseif not tgt:IsWorld() then
                        self:SetParent(tgt)
                        self:GetParent():DontDeleteOnRemove(self)
                    else
                        self.AttachToWorld = true
                    end
                end
            end)

            self:SetTrigger(true)
            self:UseTriggerBounds(true, 16)
        end
    end
end

function ENT:Draw()
    self:DrawModel()
end