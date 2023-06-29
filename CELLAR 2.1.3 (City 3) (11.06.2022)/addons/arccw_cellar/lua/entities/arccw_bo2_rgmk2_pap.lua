AddCSLuaFile()
ENT.Base = "arccw_bo1_raygun_bolt"
ENT.PrintName = "Mark II Ray Gun Bolt PAP (BO2)"
ENT.Damage = 2000
ENT.ImpactDamage = 2000
ENT.Radius = 75
ENT.RaygunEffect = "rgmk2_pap_impact_glow"
ENT.RaygunSound = "ArcCW_BO2.RGMK2_Impact"

if CLIENT then
    killicon.Add("arccw_bo2_rgmk2_bolt", "arccw/weaponicons/arccw_bo2_raygunmk2", Color(255, 255, 255, 255))
end

DEFINE_BASECLASS(ENT.Base)

if SERVER then
    function ENT:Initialize()
        BaseClass.Initialize(self)
        self:SetModelScale(0.5)
        util.SpriteTrail(self, 0, Color(255, 0, 66), true, 3, 60, 0.1, 1, "effects/laser1.vmt")
    end
end

function ENT:Draw()
    self:DrawModel()
    cam.Start3D()
        render.SetMaterial(Material("effects/blueflare1"))
        render.DrawSprite(self:GetPos(), math.random(30, 45), math.random(30, 45), Color(255, 66, 0))
    cam.End3D()
end