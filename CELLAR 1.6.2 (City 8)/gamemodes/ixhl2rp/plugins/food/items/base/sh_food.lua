ITEM.base = "base_useable"
ITEM.name = "Base Consumable"
ITEM.description = "An item you can use multiple times."
ITEM.model = Model("models/props_junk/watermelon01.mdl")
ITEM.category = "categoryFood"
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

function ITEM:OnCanUse(client)
	return true
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

	return true
end

function ITEM:OnRegistered()
	self.functions.Use.name = "useFood"
end

ITEM.functions.UseAll = {
	name = "useFoodAll",
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

		ix.chat.Send(client, "it", L("foodNotify", client, L(item.PrintName, client)), false, {client})

		return false
	end,
	OnCanRun = function(item)
		return item:OnCanUse(item.player)
	end
}
