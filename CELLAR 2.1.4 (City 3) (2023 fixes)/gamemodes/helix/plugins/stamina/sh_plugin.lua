PLUGIN.name = "Stamina"
PLUGIN.author = "Chessnut"
PLUGIN.description = "Adds a stamina system to limit running."

ix.config.Add("punchStamina", 10, "How much stamina punches use up.", nil, {
	data = {min = 0, max = 100},
	category = "characters"
})

do
	local CHAR = ix.meta.character

	function CHAR:GetMaxStamina()
		local maxStamina = hook.Run("CharacterMaxStamina", self) or 100

		return maxStamina
	end
end

local function CalcStaminaChange(client)
	local character = client:GetCharacter()

	if (!character or client:GetMoveType() == MOVETYPE_NOCLIP) then
		return 0
	end

	local walkSpeed = client:GetWalkSpeed()
	local offset = 0

	if (!client:GetNetVar("brth", false) and client:KeyDown(IN_SPEED) and
		client:GetVelocity():LengthSqr() >= walkSpeed * walkSpeed) then
		-- characters could have attribute values greater than max if the config was changed
		offset = -1
		offset = hook.Run("AdjustStaminaOffsetRunning", client, offset) or -1
	else
		offset = hook.Run("AdjustStaminaRegeneration", client, offset) or 2
	end

	offset = hook.Run("AdjustStaminaOffset", client, offset) or offset

	if (CLIENT) then
		return offset -- for the client we need to return the estimated stamina change
	else
		local maxStamina = character:GetMaxStamina()
		local current = client:GetLocalVar("stm", 0)
		local value = math.Clamp(current + offset, 0, maxStamina)

		if (current != value) then
			client:SetLocalVar("stm", value)

			if (value == 0 and !client:GetNetVar("brth", false)) then
				client:SetNetVar("brth", true)

				hook.Run("PlayerStaminaLost", client)
			elseif (value >= (maxStamina * 0.5) and client:GetNetVar("brth", false)) then
				client:SetNetVar("brth", nil)

				hook.Run("PlayerStaminaGained", client)
			end
		end
	end
end

function PLUGIN:SetupMove(client, cMoveData)
	if (client:GetNetVar("brth", false)) then
		cMoveData:SetMaxClientSpeed(client:GetWalkSpeed())
	elseif (client:WaterLevel() > 1) then
		cMoveData:SetMaxClientSpeed(client:GetRunSpeed() * 0.775)
	end
end

if (SERVER) then
	function PLUGIN:PostPlayerLoadout(client)
		local uniqueID = "ixStam" .. client:SteamID()

		timer.Create(uniqueID, 0.25, 0, function()
			if (!IsValid(client)) then
				timer.Remove(uniqueID)
				return
			end

			CalcStaminaChange(client)
		end)
	end

	function PLUGIN:CharacterPreSave(character)
		local client = character:GetPlayer()

		if (IsValid(client)) then
			character:SetData("stamina", client:GetLocalVar("stm", 0))
		end
	end

	function PLUGIN:PlayerLoadedCharacter(client, character)
		timer.Simple(0.25, function()
			client:SetLocalVar("stm", character:GetData("stamina", character:GetMaxStamina()))
		end)
	end

	local playerMeta = FindMetaTable("Player")

	function playerMeta:RestoreStamina(amount)
		local current = self:GetLocalVar("stm", 0)
		local maxStamina = self:GetCharacter():GetMaxStamina()
		local value = math.Clamp(current + amount, 0, maxStamina)

		self:SetLocalVar("stm", value)

		if (value >= (maxStamina * 0.5) and self:GetNetVar("brth", false)) then
			self:SetNetVar("brth", nil)

			hook.Run("PlayerStaminaGained", self)
		end
	end

	function playerMeta:ConsumeStamina(amount)
		local current = self:GetLocalVar("stm", 0)
		local value = math.Clamp(current - amount, 0, self:GetCharacter():GetMaxStamina())

		self:SetLocalVar("stm", value)

		if (value == 0 and !self:GetNetVar("brth", false)) then
			self:SetNetVar("brth", true)

			hook.Run("PlayerStaminaLost", self)
		end
	end
else
	PLUGIN.predictedStamina = 100

	function PLUGIN:Think()
		local offset = CalcStaminaChange(LocalPlayer())
		-- the server check it every 0.25 sec, here we check it every [FrameTime()] seconds
		offset = math.Remap(FrameTime(), 0, 0.25, 0, offset)

		if (offset != 0) then
			self.predictedStamina = math.Clamp(self.predictedStamina + offset, 0, LocalPlayer():GetCharacter():GetMaxStamina())
		end
	end

	function PLUGIN:OnLocalVarSet(key, var)
		if (key != "stm") then return end
		if (math.abs(self.predictedStamina - var) > 5) then
			self.predictedStamina = var
		end
	end
end
