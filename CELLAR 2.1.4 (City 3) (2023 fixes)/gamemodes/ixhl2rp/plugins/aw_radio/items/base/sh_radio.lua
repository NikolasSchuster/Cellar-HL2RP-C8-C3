-- local PLUGIN = PLUGIN
-- ITEM.name = "Radio Base";
-- ITEM.model = "models/props/cs_office/radio.mdl";
-- ITEM.description = "Base for just item";
-- ITEM.category = "Радио"
-- ITEM.IsRadio = true

-- function ITEM:GetDescription()
--     local id = self:GetData("kassetainside")
--     return self.description..(id and "\nВставленная кассета: "..ix.item.list[id]:GetName() or "")
-- end

-- ITEM.functions.EjectKasseta = {
-- 	name = "Вытащить кассету",
-- 	OnRun = function(item)
--         PLUGIN:EjectKasseta(item)
-- 		return false
--     end,
--     OnCanRun = function(item)
--         return !!item:GetData("kassetainside")
--     end
-- }
-- ITEM.functions.InsertKasseta = {
-- 	name = "Вставить кассету",
-- 	OnRun = function(item)
--         PLUGIN:InsertKasseta(item)
-- 		return false
--     end,
--     OnCanRun = function(item)
--         return !item:GetData("kassetainside") and !table.IsEmpty(item.player:GetCharacter():GetInventory():GetItemsByBase("base_kasseta"))
--     end
-- }

-- ITEM.functions.TurnOn = {
-- 	name = "Включить радио",
-- 	OnRun = function(item)
--         PLUGIN:TurnRadio(item,true)
-- 		return false
--     end,
--     OnCanRun = function(item)
--         local ent = item.entity 

--         if !IsValid(ent) then return false end

--         if CLIENT then
--             return !PLUGIN.stored[ent]
--         end

--         return true
--     end
-- }

-- ITEM.functions.TurnOff = {
-- 	name = "Выключить радио",
-- 	OnRun = function(item)
--         PLUGIN:TurnRadio(item,false)
-- 		return false
--     end,
--     OnCanRun = function(item)
--         local ent = item.entity 

--         if !IsValid(ent) then return false end

--         if CLIENT then
--             return !!PLUGIN.stored[ent]
--         end

--         return true
--     end
-- }