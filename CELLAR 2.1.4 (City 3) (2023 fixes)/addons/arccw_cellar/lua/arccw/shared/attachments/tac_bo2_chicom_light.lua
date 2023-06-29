att.PrintName = "QCW-05 Sight Lamp (BO2)"
att.Icon = Material("entities/acwatt_tac_bo2_anpeq.png", "mips smooth")
att.Description = "Special tacical flashlight attached under the QCW-05's carry handle iron sight. Unavailable when using other optics."
att.Desc_Pros = {
}
att.Desc_Cons = {
    "- Visible Light Beam"
}
att.AutoStats = true
att.Slot = {"bo2_chicom_light"}
att.GivesFlags = {"bo1_flashlight"}

att.Model = "models/weapons/arccw/atts/bo2_chicom_light.mdl"

att.HideIfBlocked = true
att.ExcludeFlags = {"chicon_no_light"}

att.KeepBaseIrons = true

att.Flashlight = false
att.FlashlightFOV = 50
att.FlashlightFarZ = 512 -- how far it goes
att.FlashlightNearZ = 1 -- how far away it starts
att.FlashlightAttenuationType = ArcCW.FLASH_ATT_LINEAR -- LINEAR, CONSTANT, QUADRATIC are available
att.FlashlightColor = Color(255, 255, 255)
att.FlashlightTexture = "effects/flashlight001"
att.FlashlightBrightness = 4
att.FlashlightBone = "tag_light"

att.ToggleStats = {
    {
        PrintName = "Light",
        Flashlight = true,
    },
    {
        PrintName = "Off",
    }
}