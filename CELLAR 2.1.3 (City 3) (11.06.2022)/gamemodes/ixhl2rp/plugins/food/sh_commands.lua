do
	local COMMAND = {}
	COMMAND.description = "@cmdCharSetHunger"
	COMMAND.superAdminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.number
	}

	function COMMAND:OnRun(client, target, amount)
		amount = math.Clamp(amount, 0, 100)
		target:SetHunger(amount)

		if (client != target:GetPlayer()) then
			target:GetPlayer():NotifyLocalized("needsHungerTarget", client:GetName(), amount)
			client:NotifyLocalized("needsHungerClient", target:GetName(), amount)
		else
			client:NotifyLocalized("needsHungerClient", client:GetName(), amount)
		end
	end

	ix.command.Add("CharSetHunger", COMMAND)

	COMMAND = {}
	COMMAND.description = "@cmdCharSetThirst"
	COMMAND.superAdminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.number
	}

	function COMMAND:OnRun(client, target, amount)
		amount = math.Clamp(amount, 0, 100)
		target:SetThirst(amount)

		if (client != target:GetPlayer()) then
			target:GetPlayer():NotifyLocalized("needsThirstTarget", client:GetName(), amount)
			client:NotifyLocalized("needsThirstClient", target:GetName(), amount)
		else
			client:NotifyLocalized("needsThirstClient", client:GetName(), amount)
		end
	end

	ix.command.Add("CharSetThirst", COMMAND)

	COMMAND = {}
	COMMAND.description = "@cmdCharSetNeeds"
	COMMAND.superAdminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.number
	}

	function COMMAND:OnRun(client, target, amount)
		amount = math.Clamp(amount, 0, 100)
		target:SetHunger(amount)
		target:SetThirst(amount)

		if (client != target:GetPlayer()) then
			target:GetPlayer():NotifyLocalized("needsSetTarget", client:GetName(), amount)
			client:NotifyLocalized("needsSetClient", target:GetName(), amount)
		else
			client:NotifyLocalized("needsSetClient", client:GetName(), amount)
		end
	end

	ix.command.Add("CharSetNeeds", COMMAND)
end