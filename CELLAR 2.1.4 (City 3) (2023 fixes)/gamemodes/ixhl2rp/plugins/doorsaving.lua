local PLUGIN = PLUGIN

PLUGIN.name = "Door Commands"
PLUGIN.author = "Schwarz Kruppzo"

do
	ix.command.Add("DoorLock", {
		description = "Закрыть дверь",
		privilege = "Manage Doors",
		adminOnly = true,
		OnRun = function(self, client)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsDoor() then
				local partner = entity:GetDoorPartner()

				if IsValid(partner) then
					partner:Fire("lock")
				end

				entity:Fire("lock")

				return "Вы успешно закрыли эту дверь."
			else
				return "@dNotValid"
			end
		end
	})

	ix.command.Add("DoorUnlock", {
		description = "Открыть дверь",
		privilege = "Manage Doors",
		adminOnly = true,
		OnRun = function(self, client)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsDoor() then
				local partner = entity:GetDoorPartner()

				if IsValid(partner) then
					partner:Fire("unlock")
				end

				entity:Fire("unlock")

				return "Вы успешно открыли эту дверь."
			else
				return "@dNotValid"
			end
		end
	})

	local access = {
		["owner"] = DOOR_OWNER,
		["tenant"] = DOOR_TENANT,
		["guest"] = DOOR_GUEST,
	}
	ix.command.Add("DoorSetAccess", {
		description = "Назначить игроку доступ (owner, tenant, guest) к двери на которую вы смотрите.",
		privilege = "Manage Doors",
		adminOnly = true,
		arguments = {ix.type.character, bit.bor(ix.type.string, ix.type.optional)},
		OnRun = function(self, client, target, acc)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsDoor() then
				local a = access[acc] or DOOR_OWNER

				PLUGIN:DoorSetAccess(target:GetPlayer(), entity, a)

				return "Вы успешно изменили доступ."
			else
				return "@dNotValid"
			end
		end
	})

	ix.command.Add("DoorRemoveAccess", {
		description = "Забрать у игрока доступ к двери на которую вы смотрите.",
		privilege = "Manage Doors",
		adminOnly = true,
		arguments = {ix.type.character},
		OnRun = function(self, client, target, acc)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsDoor() then
				PLUGIN:DoorRemoveAccess(target:GetPlayer(), entity)

				return "Вы успешно забрали доступ."
			else
				return "@dNotValid"
			end
		end
	})

	ix.command.Add("DoorResetAccess", {
		description = "Сбросить весь доступ дверям.",
		privilege = "Manage Doors",
		adminOnly = true,
		OnRun = function(self, client, target, acc)
			local entity = client:GetEyeTrace().Entity

			if IsValid(entity) and entity:IsDoor() then
				PLUGIN:DoorResetAccess(entity)

				return "Вы успешно сбросили доступ."
			else
				return "@dNotValid"
			end
		end
	})
end

if SERVER then
	PLUGIN.doors = PLUGIN.doors or {}
	PLUGIN.doorUsers = PLUGIN.doorUsers or {}

	function PLUGIN:SaveData()
		local doorsData = {}

        for k, v in pairs(self.doors) do
			local door = ents.GetMapCreatedEntity(k)

			doorsData[k] = door:IsLocked() and {v, true} or v
		end

		self:SetData(doorsData)
	end

	function PLUGIN:LoadData()
		self.doors = {}
		self.doorUsers = {}

		local data = self:GetData()

		for doorID, info in pairs(data) do
			if (isbool(info[2])) then
				local door = ents.GetMapCreatedEntity(doorID)
				door:Fire("lock")

				info = info[1]
			end

			self.doors[doorID] = info

			for charID, access in pairs(info) do
				self.doorUsers[charID] = self.doorUsers[charID] or {}
				self.doorUsers[charID][doorID] = true
			end
		end
	end

	function PLUGIN:DoorSetAccess(client, door, access, notBuy)
		if door.ixParent then
			self:DoorSetAccess(client, door, access, notBuy)

			return
		end

		local char = client:GetCharacter()
		local doorID = door:MapCreationID()

		if char and doorID then
			local id = char:GetID()

			self.doors[doorID] = self.doors[doorID] or {}
			self.doorUsers[id] = self.doorUsers[id] or {}

			self.doors[doorID][id] = access or DOOR_GUEST
			self.doorUsers[id][doorID] = true

			door.ixAccess = door.ixAccess or {}
			door.ixAccess[client] = access or DOOR_GUEST
		end
	end

	function PLUGIN:DoorRemoveAccess(client, door)
		if door.ixParent then
			self:DoorRemoveAccess(client, door)

			return
		end

		local char = client:GetCharacter()
		local doorID = door:MapCreationID()

		if char and doorID then
			local id = char:GetID()

			self.doors[doorID] = self.doors[doorID] or {}
			self.doorUsers[id] = self.doorUsers[id] or {}

			self.doors[doorID][id] = nil
			self.doorUsers[id][doorID] = nil

			door.ixAccess = door.ixAccess or {}
			door.ixAccess[client] = nil
		end
	end

	function PLUGIN:DoorResetAccess(door)
		if door.ixParent then
			self:DoorResetAccess(door)

			return
		end

		local doorID = door:MapCreationID()

		if doorID then
			self.doors[doorID] = nil

			for charID, doors in pairs(self.doorUsers) do
				if doors[doorID] then
					self.doorUsers[charID][doorID] = nil
				end
			end

			door.ixAccess = {}
		end
	end

	function PLUGIN:PrePlayerLoadedCharacter(client, character, oldcharacter)
		if oldcharacter then
			for doorID, _ in pairs(self.doorUsers[oldcharacter:GetID()] or {}) do
				local door = ents.GetMapCreatedEntity(doorID)

				if IsValid(door) then
					door.ixAccess = door.ixAccess or {}
					door.ixAccess[client] = nil
				end
			end
		end

		local charID = character:GetID()

		for doorID, _ in pairs(self.doorUsers[charID] or {}) do
			local door = ents.GetMapCreatedEntity(doorID)

			if IsValid(door) then
				door.ixAccess = door.ixAccess or {}
				door.ixAccess[client] = (self.doors[doorID] or {})[charID] or nil
			end
		end
	end

	function PLUGIN:PlayerDisconnected(client)
		local character = client:GetCharacter()

		if character then
			for doorID, _ in pairs(self.doorUsers[character:GetID()] or {}) do
				local door = ents.GetMapCreatedEntity(doorID)

				if IsValid(door) then
					door.ixAccess = door.ixAccess or {}
					door.ixAccess[client] = nil
				end
			end
		end
	end

	function PLUGIN:OnDoorAccessChanged(door, target, access, client)
		local doorID = door:MapCreationID()

		if doorID then
			if access and access > 0 then
				self:DoorSetAccess(target, door, access)
			else
				self:DoorRemoveAccess(target, door)
			end
		end
	end

	net.Receive("ixDoorPermission", function(length, client)
		local door = net.ReadEntity()
		local target = net.ReadEntity()
		local access = net.ReadUInt(4)

		if (IsValid(target) and target:GetCharacter() and door.ixAccess and (door:GetDTEntity(0) == client or door:CheckDoorAccess(client, DOOR_OWNER)) and target != client) then
			access = math.Clamp(access or 0, DOOR_NONE, DOOR_TENANT)

			if (access == door.ixAccess[target]) then
				return
			end

			door.ixAccess[target] = access

			hook.Run("OnDoorAccessChanged", door, target, access, client)

			local recipient = {}

			for k, v in pairs(door.ixAccess) do
				if (v > DOOR_GUEST) then
					recipient[#recipient + 1] = k
				end
			end

			if (#recipient > 0) then
				net.Start("ixDoorPermission")
					net.WriteEntity(door)
					net.WriteEntity(target)
					net.WriteUInt(access, 4)
				net.Send(recipient)
			end
		end
	end)
end

