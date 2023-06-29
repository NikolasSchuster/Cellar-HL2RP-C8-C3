att.PrintName = "Tac-Light Foregrip (BO2)"
att.Icon = Material("entities/acwatt_bo2_foregrip.png", "mips smooth")
att.Description = "Vertical foregrip that goes under the weapon's handguard. Has a weapon light."

att.SortOrder = 97

att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.AutoStats = true

att.Ingore = true

att.Slot = {"forgip"}
att.ModelOffset = Vector(-17.5, -2.5, 3.75)

att.LHIK = true

att.Model = "models/weapons/arccw/atts/bo2_foregrip.mdl"

att.Mult_Recoil = 0.85
att.Mult_RecoilSide = 0.75

att.Mult_HipDispersion = 1.15
att.Mult_SpeedMult = 0.95

att.Override_HoldtypeActive = "smg"
att.Override_HoldtypeSights = "smg"

att.Flashlight = false
att.FlashlightFOV = 50
att.FlashlightFarZ = 512 -- how far it goes
att.FlashlightNearZ = 1 -- how far away it starts
att.FlashlightAttenuationType = ArcCW.FLASH_ATT_LINEAR -- LINEAR, CONSTANT, QUADRATIC are available
att.FlashlightColor = Color(255, 255, 255)
att.FlashlightTexture = "effects/flashlight001"
att.FlashlightBrightness = 4
att.FlashlightBone = "1"

att.ToggleStats = {
    {
        PrintName = "High",
        Flashlight = true
    },
    {
        PrintName = "Off",
        Flashlight = false,
    }
}