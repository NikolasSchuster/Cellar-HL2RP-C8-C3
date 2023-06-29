do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "dispatch", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Dispatch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "broadcast", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Broadcast", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and (target:IsRestricted() or target:GetNetVar("crit"))) then
			if (!client:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				return "@notNow"
			end
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

do
	local COMMAND = {
		arguments = ix.type.text,
		alias = {"C"}
	}

	function COMMAND:OnCheckAccess(client)
		return client:IsDispatch()
	end

	function COMMAND:OnRun(client, message)
		ix.chat.Send(client, "dispatch_radio", message)
	end

	ix.command.Add("DispatchRadio", COMMAND)
end

do
	COMMAND = {
		description = "@cmdLocalEvent",
		arguments = ix.type.text,
		adminOnly = true
	}

	function COMMAND:OnRun(client, text)
		ix.chat.Send(client, "localevent", text)
	end

	ix.command.Add("LocalEvent", COMMAND)
end

do
	COMMAND = {
		description = "@cmdBlind",
		arguments = {
			ix.type.player,
			ix.type.number,
			ix.type.number
		},
		adminOnly = true
	}

	function COMMAND:OnRun(client, target, speed, time)
		target:ScreenFade(SCREENFADE.OUT, color_black, speed, time)
	end

	ix.command.Add("PlyBlind", COMMAND)
end

do
	local COMMAND = {
		description = "@cmdPlayLocalSound",
		arguments = {
			ix.type.string,
			bit.bor(ix.type.number, ix.type.optional),
			bit.bor(ix.type.number, ix.type.optional),
			bit.bor(ix.type.number, ix.type.optional)
		},
		adminOnly = true
	}

	function COMMAND:OnRun(client, path, level, pitch, volume)
		level = math.Clamp(level or 75, 20, 180)
		pitch = math.Clamp(pitch or 100, 0, 255)
		volume = math.Clamp(volume or 100, 0, 100) * 0.01

		netstream.Start(nil, "ixPlayLocalSound", path, client:GetEyeTraceNoCursor().HitPos, level, pitch, volume)
	end

	ix.command.Add("PlayLocalSound", COMMAND)
end

ix.command.Add("PlaceSound", {
	description = "Проиграть звук в радиусе",
	arguments = ix.type.string,
	adminOnly = true,
	OnRun = function(self, client, string)
		client:EmitSound(string, client:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
})

ix.command.Add("CharFallOver", {
	description = "@cmdCharFallOver",
	arguments = ix.type.number,
	OnRun = function(self, client, time)
		if (!client:Alive() or client:GetMoveType() == MOVETYPE_NOCLIP or client:GetNetVar("forcedSequence")) then
			return "@notNow"
		end

		time = math.Clamp(time, 60, 120)

		if (!IsValid(client.ixRagdoll)) then
			client:SetRagdolled(true, time)
		end
	end
})

ix.command.Add("DoorKick", {
	description = "Выбить дверь.",
	OnCheckAccess = function(self, client)
		if (!client:IsCombine()) or (!client:GetData("zombie", false)) then
			return false
		end

		local entity = client:GetEyeTrace().Entity
		if (!IsValid(entity) or !entity:IsDoor() or entity:GetNetVar("disabled")) then
			return false, "Вы не смотрите на дверь!"
		end

		if (client:GetPos():DistToSqr(entity:GetPos()) > 10000) then
			return false, "Вы слишком далеко!"
		end

		return true
	end,
	OnRun = function(self, client)
		local entity = client:GetEyeTrace().Entity
		if (IsValid(entity.ixLock)) then
			return "Вы не можете выбить дверь с замком Альянса!"
		end

		local current = client:GetLocalVar("stm", 0)
		if (current > 90) then
			client:ConsumeStamina(35)
			client:ForceSequence("adoorkick", nil, 1.5)

			timer.Simple(0.5, function()
				entity:Fire("unlock")
				entity:Fire("open")
			end)
		else
			client:Notify("У вас недостаточно выносливости!")
		end
    end
})