att.PrintName = "Mauser Scope (WAW)"
att.Icon = Material("entities/acwatt_optic_waw_telescopic.png", "mips smooth")
att.Description = "There is a black crosshair the inner portions being colored red. Ideally it should improve your aim."

att.SortOrder = 100
att.Free = true
att.AutoStats = true

att.Desc_Pros = {
    "autostat.holosight",
    "autostat.zoom",
}
att.Desc_Neutrals = {"bo.desc"}

att.Slot = "bo3_mauserscope"
att.GivesFlags = {"boomhilda"}

att.Model = "models/weapons/arccw/atts/bo3_mauserscope.mdl"
att.ModelOffset = Vector(0, 0, 0)
att.OffsetAng = Angle(0, 0, 0)

att.AdditionalSights = {
    {
        Pos = Vector(0, 10, -1.165),
        Ang = Angle(0, 0, 0),
        Magnification = 1,
        IgnoreExtra = true
    },
}

att.DrawFunc = function(wep, element, wm)
    if table.HasValue(wep:GetWeaponFlags(), "notmauser") then
        element.Model:SetBodygroup(0,1)
    end
end

att.Holosight = true
att.HolosightReticle = Material("hud/scopes/bo3_mauserscope.png", "mips smooth")
att.HolosightNoFlare = true
att.HolosightSize = 12
att.HolosightBone = "holosight"
att.HolosightPiece = "models/weapons/arccw/atts/bo3_mauserscope_hsp.mdl"
att.Colorable = true

att.HolosightBlackbox = true

att.HolosightMagnification = 2

att.Mult_SightTime = 1.1