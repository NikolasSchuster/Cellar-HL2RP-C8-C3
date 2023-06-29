att.PrintName = "ZF-4 Scope (WAW)"
att.Icon = Material("entities/acwatt_optic_waw_telescopic.png", "mips smooth")
att.Description = "Low Magnification Scope for several World War 2 german firearms."

att.SortOrder = 150

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Cons = {
}
att.AutoStats = true
att.Slot = {"waw_zf4_scope"}

att.Model = "models/weapons/arccw/atts/waw_zf4.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)
att.ModelBodygroups = "000"

att.DrawFunc = function(wep, element, wm)
    if table.HasValue(wep:GetWeaponFlags(), "nochit") then
        element.Model:SetBodygroup(2,1)
    end
end

att.AdditionalSights = {
    {
        Pos = Vector(0.005, 8, -3.29),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        IgnoreExtra = true,
    },
}

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/waw_telescopic.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 7
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/waw_zf4_hsp.mdl"
att.Colorable = true
att.HolosightBlackbox = true
att.HolosightMagnification = 2.5

att.Mult_SightTime = 1.1