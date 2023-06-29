PLUGIN.name = "NPCs Loot System"
PLUGIN.author = "Vintage Thief & Schwarz Kruppzo"
PLUGIN.description = "Making killing NPCs less pointless."

local TYPE_MPF = 1
local TYPE_ZOMBIES = 2
local TYPE_REBELS = 3
local TYPE_DEFAULT = 4
local TYPE_METAL = 5

local loot = {
    [TYPE_MPF] = {"bandage", "handheld_radio", "health_kit", "pistol", "zip_tie", "smg1", "pistolammo", "357ammo", "shotgunammo"},
    [TYPE_ZOMBIES] = {"water", "ration", "pistolammo", "357ammo", "shotgunammo", "suitcase", "metal_armature", "empty_can", "mat_cloth", "empty_ration", "mat_resine", "mat_wood", "mat_plastic", "electro_circuit", "box_of_nails", "box_of_needles", "box_of_casings", "box_of_gunpowder", "varnish", "chain"},
    [TYPE_REBELS] = {"chinese_takeout", "ration", "health_vial", "pistol", "smg1", "crowbar", "357ammo", "shotgunammo", "resistance_uniform", "rmedic_uniform"},
	[TYPE_DEFAULT] = {"water", "ration", "bandana", "metal_scrap", "metal_armature", "mat_resine", "mat_cloth", "mat_wood", "mat_plastic", "empty_can", "empty_ration", "electro_circuit", "suitcase", "box_of_nails", "box_of_needles", "box_of_casings", "box_of_gunpowder", "varnish", "chain"},
	[TYPE_METAL] = {"metal_scrap", "chain"}
}

function PLUGIN:LootGeneration(type)
    if not loot[type] then
        return false
    end
    return table.Random(loot[type])
end

function PLUGIN:SpawnLoot()
end

if SERVER then
    local npcs = {
        ["npc_combine_s"] = TYPE_MPF,
		["npc_manhack"] = TYPE_METAL,
		["npc_cscanner"] = TYPE_METAL,
        ["npc_combinegunship"] = TYPE_MPF,
		["CombineElite"] = TYPE_MPF,
		["CombinePrison"] = TYPE_MPF,
		["PrisonShotgunner"] = TYPE_MPF,
        ["npc_combinedropship"] = TYPE_MPF,
        ["npc_helicopter"] = TYPE_MPF,
        ["npc_metropolice"] = TYPE_MPF,
        ["npc_strider"] = TYPE_MPF,
        ["npc_fastzombie"] = TYPE_ZOMBIES,
        ["npc_barnacle"] = TYPE_DEFAULT,
        ["npc_headcrab"] = TYPE_ZOMBIES,
        ["npc_headcrab_black"] = TYPE_ZOMBIES,
        ["npc_headcrab_fast"] = TYPE_ZOMBIES,
        ["npc_poisonzombie"] = TYPE_ZOMBIES,
        ["npc_zombie"] = TYPE_ZOMBIES,
        ["npc_zombie_torso"] = TYPE_ZOMBIES,
        ["npc_rebels"] = TYPE_REBELS,
        ["npc_citizen"] = TYPE_DEFAULT
    }

    function PLUGIN:OnNPCKilled(NPC)
	
	print(NPC:GetClass())

        local isHasLootType = npcs[NPC:GetClass()]
		local spos = NPC:GetPos() + (Vector( 0, 0, 36 )) -- Если вектор убрать некоторые айтемы застревают в земле, колхоз но работает

        if !isHasLootType then
            return
        end

        local itemClass = self:LootGeneration(isHasLootType)

        if !itemClass then
            return
        end

		ix.item.Spawn(itemClass, spos, nil, nil, nil)
    end
end