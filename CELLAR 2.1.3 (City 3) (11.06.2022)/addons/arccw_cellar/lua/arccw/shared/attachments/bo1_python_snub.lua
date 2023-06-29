att.PrintName = "Snub Nose Revolver Barrel"
att.AbbrevName = "Snub Nose"
att.Icon = Material("entities/acwatt_bo1_python_snub.png", "mips smooth")
att.Description = "Short barrel that improves handling but worsens recoil and accuracy. Its small size means optics and tactical attachments cannot fit anymore."

att.AutoStats = true

att.Desc_Pros = {
}
att.Desc_Cons = {
    "bo1.pythonsnub"
}
att.Slot = "bo1_python_barrel"
att.GivesFlags = {"python_snub"}
att.ActivateElements = {"python_snub"}

att.Mult_Range = 0.75
att.Mult_Recoil = 1.25
att.Mult_SightTime = 0.75
att.Mult_AccuracyMOA = 1.5

att.Mult_HipDispersion = 0.5
att.Mult_MoveDispersion = 0.5
att.Mult_DrawTime = 0.75
att.Mult_HolsterTime = 0.75