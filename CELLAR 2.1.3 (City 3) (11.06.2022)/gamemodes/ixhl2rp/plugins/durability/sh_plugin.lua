PLUGIN.name = "Durability"
PLUGIN.author = "STEAM_0:1:29606990" -- AleXXX_007 - original idea.
PLUGIN.description = "Adds durability for all weapons."

ix.util.Include("sv_plugin.lua")

-- HL2 Weapons bullet damage is not counted.
-- bullet.Damage = (bullet.Damage / 100) * durability
-- bullet.Damage always 0

ix.config.Add("maxValueDurability", 100, "Maximum value of the durability.", nil, {
	data = {min = 1, max = 9999},
	category = PLUGIN.name
})

ix.config.Add("decDurability", 0.5, "By how many units do reduce the durability with each shot?", nil, {
	data = {min = 0.0001, max = 100, decimals = 4},
	category = PLUGIN.name
})

ix.config.Add("unequipItemDurability", false, "Unequip the item if durability is less than zero?", nil, {
	category = PLUGIN.name
})

ix.lang.AddTable("russian", {
	["Repair"] = "Починить",
	["RepairKitWrong"] = "У вас нет ремкомплекта!",
	["DurabilityUnusableTip"] = "Оружие теперь полностью сломано!",
	["DurabilityText"] = "Прочность"
})

ix.lang.AddTable("english", {
	["RepairKitWrong"] = "You do not have a repair kit!",
	["DurabilityUnusableTip"] = "Your weapon is now completely broken!",
	["DurabilityText"] = "Durability"
})

if CLIENT then
	function PLUGIN:PopulateItemTooltip(tooltip, item)
		if (!item.isWeapon) then
			return
		end

		local panel = tooltip:AddRowAfter("description", "durability")
		local maxDurability = item.maxDurability or ix.config.Get("maxValueDurability", 100)
		local durability = math.Clamp(math.floor(item:GetData("durability", maxDurability)), 0, maxDurability)
		durability = math.max(0, math.floor((durability / maxDurability) * 100))

		panel:SetText(Format("%s: %s%% / 100%%", L("DurabilityText"), durability))
		panel:SetBackgroundColor(Color(219, 52, 52))
		panel:SizeToContents()
	end

	-- netstream.Hook("aw_SendDurabilityFunc",function(weapon,id,bool)
	-- 	ix.item.instances[id].functions.awFix = bool and {
	-- 		name = "Исправить",
	-- 		OnRun = function()
	-- 			return false
	-- 		end
	-- 	}
	-- end)
end

function PLUGIN:InitializedPlugins()
	local maxDurability = ix.config.Get("maxValueDurability", 100)

	for _, v in pairs(ix.item.list) do
		if (!v.isWeapon) then continue end

		maxDurability = v.maxDurability or maxDurability

		if CLIENT then
			function v:PaintOver(item, w, h)
				if (item:GetData("equip")) then
					surface.SetDrawColor(110, 255, 110, 100)
					surface.DrawRect(w - 14, h - 14, 8, 8)
				end

				local durability = item:GetData("durability", maxDurability)
				local durabilityPercent = math.Clamp(durability / maxDurability, 0, maxDurability)

				if (durabilityPercent > 0) then
					-- 2.55 = (255 / 100)
					local durabilityColor = Color(2.55 * (100 - durability), 2.55 * durability, 0, 255)

					surface.SetDrawColor(durabilityColor)
					surface.DrawRect(0, h - 2, w * durabilityPercent, 2)
				end
			end
		end

		v.functions.Repair = {
			name = "Repair",
			tip = "equipTip",
			icon = "icon16/bullet_wrench.png",
			OnRun = function(item)
				local client = item.player
				local itemKit = client:GetCharacter():GetInventory():HasItemOfBase("base_repair_kit")

				if (itemKit and itemKit.isWeaponKit) and (item.impulse == itemKit.impulse) then
					local quantity = itemKit:GetData("quantity", itemKit.quantity or 1) - 1


					if (itemKit.UseRepair) then
						itemKit:UseRepair(item, client)
					end

					if (quantity < 1) then
						itemKit:Remove()
					else
						itemKit:SetData("quantity", quantity)
					end

					if (itemKit.useSound) then
						client:EmitSound(itemKit.useSound, 110)
					end

					itemKit = nil
				else
					client:NotifyLocalized("RepairKitWrong")
				end

				return false
			end,

			OnCanRun = function(item)
				if (item:GetData("durability", maxDurability) >= maxDurability) then
					return false
				end

				if (!item.player:GetCharacter():GetInventory():HasItemOfBase("base_repair_kit")) then
					return false
				end

				return true
			end
		}
	end
end

function PLUGIN:CanPlayerEquipItem(_, itemObj)
	if (ix.config.Get("unequipItemDurability", false)) then
		return itemObj:GetData("durability", ix.config.Get("maxValueDurability", 100)) > 0
	end
end