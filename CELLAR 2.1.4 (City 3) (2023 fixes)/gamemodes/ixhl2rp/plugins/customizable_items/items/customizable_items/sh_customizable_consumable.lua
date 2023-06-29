
-- consumable item that can add/take health/stamina
ITEM.name = "Customizable Consumable"

ITEM:AddProperty("giveHealth", ix.type.number, 0, -200, 200)
ITEM:AddProperty("giveStamina", ix.type.number, 0, -100, 100)
ITEM:AddProperty("relieveHunger", ix.type.number, 0, -100, 100)
ITEM:AddProperty("relieveThirst", ix.type.number, 0, -100, 100)
ITEM:AddProperty("sound", ix.type.string, "")

ITEM.functions.Consume = {
	OnRun = function(self)
		local client = self.player
		local character = client:GetCharacter()

		if (!IsValid(client)) then
			return
		end

		local health = client:Health()
		local newHealth = math.Clamp(health + self:GetGiveHealth(), 0, client:GetMaxHealth())

		if (newHealth < health) then
			ix.log.Add(client, "playerHurt", health - newHealth, string.format("item '%s (%s)'",
				self:GetName(), self.uniqueID
			))
		end

		client:SetHealth(newHealth)
		client:RestoreStamina(self:GetGiveStamina())

		if (character and ix.plugin.Get("needs")) then
			character:SetHunger(math.Clamp(character:GetHunger() - self:GetRelieveHunger(), 0, 100))
			character:SetThirst(math.Clamp(character:GetThirst() - self:GetRelieveThirst(), 0, 100))
		end

		local sound = self:GetSound()

		if (sound != "") then
			client:EmitSound(sound)
		end
	end
}
