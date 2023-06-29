local PLUGIN = PLUGIN

PLUGIN.RepairTime = 4

function PLUGIN:Tick()
    local curTime = CurTime()

    for _, v in ipairs(player.GetAll()) do
        if (curTime >= (v.ixNextTickDurability or 0) and v:Alive() and v:GetCharacter()) then
            local weapon = v:GetActiveWeapon()

            if (IsValid(weapon) and weapon.ixItem and weapon.ixItem.isWeapon) then

                local cantshoot = weapon.ixItem:GetData("CantWeaponShoot")

                -- if cantshoot and !weapon.ixItem.functions.awFix then
                    
                --     weapon.ixItem:SetData("CantWeaponShoot",nil)

                --     cantshoot = false

                -- end

                local canShoot = weapon.ixItem:GetData("durability", weapon.ixItem.maxDurability or ix.config.Get("maxValueDurability", 100)) > 0

                if cantshoot then //added

                    canShoot = false

                    v:SetNetVar("canShoot", canShoot)

                end

                if (!v:IsWepRaised()) then
                    canShoot = false
                end

                if (canShoot ~= v:CanShootWeapon()) then
                    v:SetNetVar("canShoot", canShoot)
                end
            end

            v.ixNextTickDurability = curTime + 0.1
        end
    end
end

function PLUGIN:EntityFireBullets(entity, bullet)
    if (IsValid(entity) and entity:IsPlayer()) then
        local weapon = entity:GetActiveWeapon()

        if (IsValid(weapon) and weapon.ixItem) then
            local item = weapon.ixItem

            if (item.isWeapon) then
                local durability = item:GetData("durability", item.maxDurability or ix.config.Get("maxValueDurability", 100))
                local oldDurability = durability
                local originalDamage = bullet.Damage

                bullet.Damage = (originalDamage / 100) * durability
                bullet.Spread = bullet.Spread * (1 + (1 - (0.01 * durability)))

                if (originalDamage < 1) then
                    durability = math.max(durability - ix.config.Get("decDurability", 1), 0)
                else
                    durability = math.max(durability - (originalDamage / 100), 0) -- 100 = drainScale
                end

                if (oldDurability ~= durability) then
                    item:SetData("durability", durability)
                end

                if (oldDurability > 0 and durability == 0) then
                    entity:SetNetVar("canShoot", false)
                    entity:NotifyLocalized("DurabilityUnusableTip")
                end

                if durability <= 50 then //added
                    if math.random(100) <= 8 then

                        item:SetData("CantWeaponShoot",true)

                        entity:Notify("Вы словили "..table.Random({"клин","осечку"}).."!")

                    end

                end

                if (ix.config.Get("unequipItemDurability", false) and durability < 1 and item.Unequip) then
                    item:Unequip(entity)
                    local itemname = item.uniqueID
                    local brokenItemsTable = {
                        ["shotgun"] = "broken_shotgun",
                        ["uspmatch"] = "broken_pistol",
                        ["mp7"] = "broken_mp7",
                        ["magnum"] = "broken_357",
                    }
                    local newname = brokenItemsTable[itemname]
                    local inventory = entity:GetCharacter():GetInventory()

                    if (newname) then
                        item:Remove()
                        local result, _ = inventory:Add(newname)
                        if (!result) then
                            local newItem = ix.item.Get(newname)
                            newItem:Spawn(entity:GetItemDropPos(newItem))
                        end
                    end
                end
            end
        end
    end
end