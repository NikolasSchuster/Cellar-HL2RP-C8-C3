ITEM.base = "base_useable"
ITEM.name = "Base Consumable"
ITEM.description = "An item you can use multiple times."
ITEM.model = Model("models/props_junk/watermelon01.mdl")
ITEM.category = "categoryDrink"
ITEM.width = 1
ITEM.height = 1
ITEM.dStamina = 0
ITEM.dHunger = 0
ITEM.dThirst = 0
ITEM.dHealth = 0
ITEM.dDamage = 0
ITEM.dDrunkTime = 0
ITEM.dUses = 1
ITEM.junk = nil
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"}
-- legaz: i really don't want to replicate the same code twice, but the drink base was not made by me
--[[
ITEM.expirationDate = 604800 -- 7d
ITEM.boostsDuration = 3600 -- 1h
ITEM.specialBoosts = {
	["st"] = 1,
}
]]

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		-- expiration date
		local expirationDate = self:GetData("expirationDate")
		local bNotExpired
		local color, text

		if (isnumber(expirationDate)) then
			if (expirationDate > os.time()) then
				bNotExpired = true
			else
				bNotExpired = false
			end
		end

		local expDateT = tooltip:AddRowAfter("name", "expirationDate")

		-- we won't be seeing color change, but it's better we prepare it for time when SC does something good with his interface
		if (bNotExpired == true) then
			color = derma.GetColor("Warning", expDateT)
			text = "Годно до: " .. os.date("%d.%m - %H:%M", expirationDate)
		elseif (bNotExpired == false) then
			color = derma.GetColor("Error", expDateT)
			text = "Просрочено"
		else
			color = derma.GetColor("Success", expDateT)
			text = "Без срока годности"
		end

		expDateT:SetTextColor(color)
		expDateT:SetText(text)

		-- uses left
		local uses = tooltip:AddRowAfter("rarity", "uses")
		uses:SetTextColor(derma.GetColor("Warning", tooltip))
		uses:SetText(L("usesDesc", self:GetData("uses", self.dUses), self.dUses))

		-- boosts on use
		if (isnumber(self.boostsDuration)) then
			local boosts = tooltip:AddRow("boosts")
			text = "На " .. self.boostsDuration / 60 .. " мин.:"
			color = nil

			if (bNotExpired == nil or bNotExpired) then
				if (istable(self.specialBoosts)) then
					for k, v in pairs(self.specialBoosts) do
						local lBoost = tooltip:AddRow("boost_" .. k)
						local text2 = " • " .. L(ix.specials.list[k].name)

						if (v > 0) then
							color = derma.GetColor("Success", lBoost)
							text2 = text2 .. ": +" .. v
						else
							color = derma.GetColor("Error", lBoost)
							text2 = text2 .. ": " .. v
						end

						lBoost:SetText(text2)
						lBoost:SetTextColor(color)
					end

					color = derma.GetColor("Info", boosts)
				end
			else
				color = derma.GetColor("Error", boosts)
				text = text .. " отравление"
			end

			if (color) then
				boosts:SetTextColor(color)
				boosts:SetText(text)
				boosts:SizeToContents()
			else
				boosts:Remove()
			end
		end
	end
else
	function ITEM:GenerateExpirationDate()
		if (isnumber(self.expirationDate)) then
			self:SetData("expirationDate", os.time() + self.expirationDate)

			return true
		end

		return false
	end
end

function ITEM:OnCanUse(client)
	return true
end

function ITEM:OnInstanced()
	self:GenerateExpirationDate()
end

function ITEM:OnRestored()
	if (!self:GetData("expirationDate")) then
		self:GenerateExpirationDate()
	end
end

function ITEM:OnUse(client, all)
	local character = client:GetCharacter()
	local mod = 1
	--local mod = (1.22 * self:GetData("rare"))
	--if mod <= 0 then mod = 1 end;

	local mul = (!all and 1 or self:GetData("uses", self.dUses))
	local giveStamina = (self.dStamina * mul) * mod
	local hunger = (self.dHunger * mul) * mod
	local thirst = (self.dThirst * mul) * mod
	local health = (self.dHealth * mul) * mod
	local damage = (self.dDamage * mul) * mod
	local drunkTime = (self.dDrunkTime * mul) * mod
	local specialBoosts

	if giveStamina > 0 then
		client:RestoreStamina(giveStamina)
	end

	if thirst > 0 then
		character:SetThirst(math.Clamp(character:GetThirst() + thirst, 0, 100))
	end

	if hunger > 0 then
		character:SetHunger(math.Clamp(character:GetHunger() + hunger, 0, 100))
	end

	if health > 0 then
		client:SetHealth(math.Clamp(client:Health() + health, 0, client:GetMaxHealth()))
	end

	if damage > 0 then
		client:TakeDamage(damage, client, client)
	end

	if (isnumber(self.boostsDuration)) then
		local expirationDate = self:GetData("expirationDate")

		if (!expirationDate or expirationDate > os.time()) then
			specialBoosts = istable(self.specialBoosts) and self.specialBoosts or nil
		else
			specialBoosts = {}

			for k, v in pairs(ix.specials.list) do
				specialBoosts[k] = -3
			end
		end

		if (istable(specialBoosts)) then
			for k, v in pairs(specialBoosts) do
				local oldID = self.uniqueID .. k

				if (character:GetSpecialBoost(oldID)) then
					character:AttachDurationToSpecialBoost(oldID, nil)
					character:RemoveSpecialBoost(oldID, k)
				end

				character:AddSpecialBoostWithDuration(self.uniqueID, k, v, self.boostsDuration)
			end
		end
	end

	return true
end

function ITEM:OnRegistered()
	self.functions.Use.name = "useDrink"
end

ITEM.functions.UseAll = {
	name = "useDrinkAll",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		if istable(item.useSound) then
			client:EmitSound(item.useSound[math.random(1, #item.useSound)])
		else
			client:EmitSound(item.useSound)
		end

		if item:OnUse(client, true) == false then
			return false
		end

		local isWorld = false
		local pos, ang
		local data = {
			S = item:GetSkin(),
			M = item:GetModel()
		}

		if isfunction(item.OnJunkCreated) then
			data = item:OnJunkCreated() or data
		end

		if IsValid(item.entity) then
			isWorld = true
			pos, ang = item.entity:GetPos(), item.entity:GetAngles()
		end
		
		item:Remove()

		if isstring(item.junk) then
			if isWorld then
				ix.item.Spawn(item.junk, pos, nil, ang, data)
			else
				local junkItem = character:GetInventory():Add(item.junk, nil, data)

				if !junkItem then
					junkItem = ix.item.Spawn(item.junk, client, nil, nil, data)
				end
			end
		end

		ix.chat.Send(client, "it", L("drinkNotify", client, L(item.PrintName, client)), false, {client})

		return false
	end,
	OnCanRun = function(item)
		return item:OnCanUse(item.player)
	end
}
