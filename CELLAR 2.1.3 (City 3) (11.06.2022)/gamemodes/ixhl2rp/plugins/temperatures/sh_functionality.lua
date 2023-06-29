local PLUGIN = PLUGIN

PLUGIN.tookColdDamage = false
PLUGIN.shockDamageTook = false


if SERVER then
	function PLUGIN:OnCharacterCreated(client, character)
		character:SetData("coldCounter", 100)
	end

	function PLUGIN:PlayerLoadedCharacter(client, character)
		timer.Simple(0.25, function()
			client:SetLocalVar("coldCounter", character:GetData("coldCounter", 100))
		end)
	end

	function PLUGIN:PostPlayerLoadout(client)
		timer.Simple(0.25, function()
			local character = client:GetCharacter()
			if character then
				client:SetLocalVar("coldCounter", character:GetData("coldCounter", 100))
			end
		end)
	end

	function PLUGIN:CharacterPreSave(character)
		local client = character:GetPlayer()

		if (IsValid(client)) then
			character:SetData("coldCounter", client:GetLocalVar("coldCounter", 0))
		end
	end

	local playerMeta = FindMetaTable("Player")

	function playerMeta:GetColdlevel()
		local char = self:GetCharacter()

		if (char) then
			return char:GetData("coldCounter", 100)
		end
	end

	function playerMeta:SetColdlevel(amount)
		local char = self:GetCharacter()

		if (char) then
			char:SetData("coldCounter", amount)
			self:SetLocalVar("coldCounter", amount)
		end
	end

	function PLUGIN:PlayerTick(client)
		local char = client:GetCharacter()

		if (client:Alive() and char) then
			if client:GetLocalVar("coldCounter") and (client:GetLocalVar("coldCounter") < 100) then
				client:SetColdlevel(client:GetColdlevel() + .2)
			end
		end
	end

end

ix.command.Add("CharSetColdlevel", {
	description = "Sets the character's cold-need level",
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.number
	},
	OnRun = function(self, client, target, amount)
		target:SetColdlevel(amount)
	end
})