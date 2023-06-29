att.PrintName = "Skullsplitter S-1-6 FCG"
att.AbbrevName = "Skullsplitter"
att.Icon = Material("entities/acwatt_fcg_s13.png", "mips smooth")
att.Description = "Modified fire control group allowing for an absurd 6-round burst with a lightly longer delay between bursts."
att.Desc_Pros = {
    "+ Burst Fire mode allows for ammunition",
    "conservation"
}
att.Desc_Cons = {
    "- Burst Delay"
}
att.AutoStats = true
att.IgnorePickX = true
att.Slot = "fcg_kali"
att.SortOrder = 106
att.Mult_Recoil = 0.75
att.Mult_HipDispersion = 0.85
att.Mult_AccuracyMOA = 0.85
att.Mult_Damage = 35 / 30
att.Mult_DamageMin = 25 / 20

att.RequireFlags = {"papname1"}
att.HideIfBlocked = true

att.Override_Firemodes = {
    {
        Mode = -6,
        PostBurstDelay = 0.25,
        RunawayBurst = true,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}