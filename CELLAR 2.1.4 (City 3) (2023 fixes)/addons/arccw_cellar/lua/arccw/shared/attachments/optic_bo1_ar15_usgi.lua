att.PrintName = "USGI Flip-Up Sights"
att.Icon = Material("entities/acwatt_optic_bo1_irons.png", "mips smooth")
att.Description = "You will aim with sights of iron, and you will like it."

att.SortOrder = 103
att.Free = true

att.Desc_Pros = {
    "+ No carry handle",
}
att.Desc_Cons = {
    "- Anachronistic",
    "- No carry handle"
}
att.Slot = {"car15_irons", "bo2_m27_irons"}
att.GivesFlags = {"ar15_alttop", "usgi_irons"}
att.ExcludeFlags = {"flattop", "flattop2"}
att.AltIrons2 = true