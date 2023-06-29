att.PrintName = "A4 Flat Top with USGI Flip-Up Sights"
att.AbbrevName = "A4 USGI"
att.Icon = Material("entities/acwatt_optic_bo1_irons.png", "mips smooth")
att.Description = "You will aim with sights of iron, and you will like it."

att.SortOrder = 1
att.Free = true

att.Desc_Pros = {
}
att.Desc_Cons = {
    "- Some low profile sights might be obstructed by a barrel with a non-removable front sight."
}
att.Slot = "kali_top"
att.GivesFlags = {"a4top", "flattop_carry"}
att.ActivateElements = {"kali_nocarry"}
att.AltIrons2 = true
att.HideIfBlocked = true
att.IgnorePickX = true


att.RandomWeight = 0.25