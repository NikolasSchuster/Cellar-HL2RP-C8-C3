local LOOT_TEMPLATE = ix.loot.NewLootTemplate("garbage_common")

local plastic = 45
local metal = 35
local paper = 55

local lootGroup = ix.loot.NewLootGroup()
lootGroup:AddEntry(ix.loot.NewLoot("empty_can", metal))
lootGroup:AddEntry(ix.loot.NewLoot("empty_tin_can", metal))
lootGroup:AddEntry(ix.loot.NewLoot("empty_ration", metal))
lootGroup:AddEntry(ix.loot.NewLoot("empty_carton", paper))
lootGroup:AddEntry(ix.loot.NewLoot("empty_chinese_takeout", paper))
lootGroup:AddEntry(ix.loot.NewLoot("empty_jug", plastic))
lootGroup:AddEntry(ix.loot.NewLoot("empty_plastic_bottle", plastic))
lootGroup:AddEntry(ix.loot.NewLoot("empty_plastic_can", plastic))
lootGroup:AddEntry(ix.loot.NewLoot("empty_glass_bottle", 33))

lootGroup:AddEntry(ix.loot.NewLoot("tool_screw", 10))
lootGroup:AddEntry(ix.loot.NewLoot("tool_hammer", 10))
lootGroup:AddEntry(ix.loot.NewLoot("filter", 10))
lootGroup:AddEntry(ix.loot.NewLoot("chain", 3))
lootGroup:AddEntry(ix.loot.NewLoot("tool_matches", 2))
lootGroup:AddEntry(ix.loot.NewLoot("broken_pistol", 1))
lootGroup:AddEntry(ix.loot.NewLoot("broken_mp7", 0.5))
lootGroup:AddEntry(ix.loot.NewLoot("broken_357", 0.5))

LOOT_TEMPLATE:AddEntry(lootGroup)

LOOT_TEMPLATE:Register()