local PLUGIN = PLUGIN
PLUGIN.stored = PLUGIN.stored or {}

function PLUGIN:LoadData()
	local query = mysql:Create("ix_datafiles")
		query:Create("datafile_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("character_name", "TEXT DEFAULT NULL")
		query:Create("cid", "TEXT DEFAULT NULL")
		query:Create("regid", "TEXT DEFAULT NULL")
		query:Create("genericdata", "TEXT DEFAULT NULL")
		query:Create("datafile", "TEXT DEFAULT NULL")
		query:Create("access", "TEXT DEFAULT NULL")
		query:PrimaryKey("datafile_id")
	query:Execute()

	self.stored = {}

	query = mysql:Select("ix_datafiles")
		query:Select("datafile_id")
		query:Select("character_name")
		query:Select("cid")
		query:Select("regid")
		query:Select("genericdata")
		query:Select("datafile")
		query:Select("access")
		query:Callback(function(result)
			if istable(result) and #result > 0 then
				for k, v in pairs(result) do
					local id = tonumber(v.datafile_id)

					self.stored[id] = {
						[1] = v.character_name,
						[2] = v.cid,
						[3] = v.regid,
						[4] = util.JSONToTable(v.genericdata),
						[5] = util.JSONToTable(v.datafile),
						[6] = util.JSONToTable(v.access),
					}
				end
			end
		end)
	query:Execute()
end

function PLUGIN:OnWipeTables()
	local query = mysql:Drop("ix_datafiles")
	query:Execute()
end

function PLUGIN:SaveData()
	for k, v in pairs(self.stored) do
		local query = mysql:Update("ix_datafiles")
			query:Where("datafile_id", k)
			query:Update("character_name", v[1])
			query:Update("cid", v[2])
			query:Update("regid", v[3])
			query:Update("genericdata", util.TableToJSON(v[4]))
			query:Update("datafile", util.TableToJSON(v[5]))
			query:Update("access", util.TableToJSON(v[6]))
		query:Execute()
	end
end

function PLUGIN:CreateDatafile(name, cid, regid, access, callback, rank)
	local GenericData = {
		bol = false,
		bol_reason = "",
		points = 0,
		restricted = false,
		restricted_reason = "",
		status = "Citizen",
		last_seen = os.time(),
		rank = rank or 0
	}

	local CivilianData = {
		{
			category = "union",
			text = "TRANSFERRED TO DISTRICT WORKFORCE.",
			unix_time = os.time(),
			points = 0,
			poster_name = "Overwatch",
			poster_color = Color(50, 100, 150),
			poster_steam = 0
		}
	}

	name = name or ""
	cid = cid or ""
	regid = regid or ""
	access = access or {}

	local query = mysql:Insert("ix_datafiles")
		query:Insert("character_name", name)
		query:Insert("cid", cid)
		query:Insert("regid", regid)
		query:Insert("genericdata", util.TableToJSON(GenericData))
		query:Insert("datafile", util.TableToJSON(CivilianData))
		query:Insert("access", util.TableToJSON(access))
		query:Callback(function(result, status, lastID)
			if callback then
				callback(lastID)
			end

			local id = tonumber(lastID)

			self.stored[id] = {
				[1] = name,
				[2] = cid,
				[3] = regid,
				[4] = GenericData,
				[5] = CivilianData,
				[6] = access,
			}
		end)
	query:Execute()
end

function PLUGIN:OnIDCardInstanced(item)
	if item:GetData("datafileID", 0) == 0 then
		local name = item:GetData("name", "")
		local cid = item:GetData("cid", "")
		local regid = item:GetData("number", "")
		local access = item:GetData("access", {})

		self:CreateDatafile(name, cid, regid, access, function(id)
			print("Datafile created for ", item, id)
			item:SetData("datafileID", id)
		end, item.DefaultRank)
	else
		print("Datafile loaded for ", item)
	end
end

function PLUGIN:OnIDCardUpdated(item)
	if item:GetData("datafileID", 0) != 0 then
		local id = tonumber(item:GetData("datafileID", 0))

		if self.stored[id] then
			local name = item:GetData("name", "")
			local cid = item:GetData("cid", "")
			local regid = item:GetData("number", "")
			local access = item:GetData("access", {})

			self.stored[id][1] = name
			self.stored[id][2] = cid
			self.stored[id][3] = regid
			self.stored[id][6] = access
		end
	end
end

function PLUGIN:HandleDatafile(player, target)
	if istable(target) then
		for id, v in pairs(self.stored) do
			if (target[1] and v[2] == target[1]) then
				if (target[2] and v[3] == target[2] or true) then
					target = id
					break
				end
			end
		end
	end

	local playerValue = player:GetCharacter():ReturnDatafilePermission()
	local targetValue
	player.lastDatafile = nil

	if isstring(target) or isnumber(target) then
		targetValue = self:ReturnPermissionByID(target)

		if playerValue >= targetValue then
			if playerValue == 0 then
				return false
			end
			
			local dID, datafile, genericdata = self:ReturnDatafileByID(target)
			local bTargetIsRestricted, restrictedText = self:IsRestricted(genericdata)
			local data = {}
			local db = self.stored[tonumber(dID)]
			if db then
				data = {db[1], db[2], db[3], dID}
			end

			if playerValue == 1 then
				if bTargetIsRestricted then
					--Clockwork.player:Notify(player, "This datafile has been restricted; access denied. REASON: " .. restrictedText)

					return false
				end

				local restrictedDatafile = table.Copy(datafile)
				for k, v in pairs(restrictedDatafile) do
					if v.category == "civil" then
						table.remove(restrictedDatafile, k)
					end
				end

				netstream.Start(player, "CreateRestrictedDatafile", target, genericdata, restrictedDatafile, data)
			else
				netstream.Start(player, "CreateFullDatafile", target, genericdata, datafile, data)
				net.Start("PopulateDatafilePoints")
					net.WriteInt(genericdata.points or 0, 16)
				net.Send(player)
			end

			player.lastDatafile = tonumber(dID)
		elseif playerValue < targetValue then
			return false
		end
	else
		local targetCharacter = target:GetCharacter()

		targetValue = targetCharacter:ReturnDatafilePermission()

		if playerValue >= targetValue then
			if playerValue == 0 then
				--Clockwork.player:Notify(player, "You are not authorized to access this datafile.")

				return false
			end

			local dID, datafile, genericdata = targetCharacter:ReturnDatafile()
			local bTargetIsRestricted, restrictedText = self:IsRestricted(genericdata)
			local data = {}
			local db = self.stored[tonumber(dID)]
			if db then
				data = {db[1], db[2], db[3], dID}
			end

			if playerValue == 1 then
				if bTargetIsRestricted then
					--Clockwork.player:Notify(player, "This datafile has been restricted; access denied. REASON: " .. restrictedText)

					return false
				end

				local restrictedDatafile = table.Copy(datafile)
				for k, v in pairs(restrictedDatafile) do
					if v.category == "civil" then
						table.remove(restrictedDatafile, k)
					end
				end

				netstream.Start(player, "CreateRestrictedDatafile", target, genericdata, restrictedDatafile, data)
			else
				netstream.Start(player, "CreateFullDatafile", target, genericdata, datafile, data)
				net.Start("PopulateDatafilePoints")
					net.WriteInt(genericdata.points or 0, 16)
				net.Send(player)
			end

			player.lastDatafile = tonumber(dID)
		elseif playerValue < targetValue then
			--Clockwork.player:Notify(player, "You are not authorized to access this datafile.")

			return false
		end
	end
end

function PLUGIN:CharacterLoaded(character)
	timer.Simple(1, function()
		local player = character:GetPlayer()
		local cid = character:GetIDCard()

		if cid then
			player.ixDatafile = cid:GetData("datafileID")

			hook.Run("CharacterDatafileLoaded", character)
		end
	end)
end

function PLUGIN:RefreshDatafile(client, datafileID)
	datafileID = tonumber(datafileID) or 0

	local rf = RecipientFilter()
	rf:AddAllPlayers()

	local data = {}
	local db = self.stored[datafileID]
	if db then
		data = {db[1], db[2], db[3], datafileID}
	end

	for _, v in ipairs(rf:GetPlayers()) do
		if v.lastDatafile != datafileID or !v:GetCharacter() then
			rf:RemovePlayer(v)
		else
			continue
		end
	end

	netstream.Start(rf:GetPlayers(), "RefreshDatafile", db[4], db[5], data)
end

netstream.Hook("UpdateLastSeen", function(client, datafileID)
	local char = client:GetCharacter()

	if (char:ReturnDatafilePermission() < 1) then return end
	if PLUGIN:IsRestricted((PLUGIN.stored[tonumber(datafileID)] or {})[4]) then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	PLUGIN:UpdateLastSeen(client, datafileID)
	PLUGIN:RefreshDatafile(client, datafileID)
end)

netstream.Hook("UpdateCivilStatus", function(client, datafileID, civilStatus)
	local char = client:GetCharacter()

	if (char:ReturnDatafilePermission() < 2) then return end
	if PLUGIN:IsRestricted((PLUGIN.stored[tonumber(datafileID)] or {})[4]) then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	PLUGIN:SetCivilStatus(datafileID, civilStatus, client, char)
	PLUGIN:RefreshDatafile(client, datafileID)
end) --{target, tier})

netstream.Hook("UpdateRankStatus", function(client, datafileID, rank)
	local char = client:GetCharacter()

	if char:ReturnDatafilePermission() < 4 then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	PLUGIN:SetRankStatus(datafileID, rank, client, char)
	PLUGIN:RefreshDatafile(client, datafileID)
end)

netstream.Hook("AddDatafileEntry", function(client, datafileID, category, text, points)
	local char = client:GetCharacter()

	if ((char:ReturnDatafilePermission() <= 1 && category == "civil") || char:ReturnDatafilePermission() == 0) then return end
	if PLUGIN:IsRestricted((PLUGIN.stored[tonumber(datafileID)] or {})[4]) then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	PLUGIN:AddEntry(client, datafileID, category, text, points, false)
end) --{target, category, text, points});

netstream.Hook("CmbAddDatafileEntry", function(client, datafileID, category, text, points)
	local char = client:GetCharacter()

	if char:ReturnDatafilePermission() < 4 then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	local new_points = hook.Run("DatafileCombineModifyPoints", client, datafileID, points)

	points = new_points or points
	
	PLUGIN:AddEntry(client, datafileID, category, text, points, false)
end)

netstream.Hook("SetBOL", function(client, datafileID)
	local char = client:GetCharacter()

	if (char:ReturnDatafilePermission() < 1) then return end
	if PLUGIN:IsRestricted((PLUGIN.stored[tonumber(datafileID)] or {})[4]) then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	PLUGIN:SetBOL(client, datafileID, nil)
	PLUGIN:RefreshDatafile(client, datafileID)
end) --{self.Player});

netstream.Hook("RemoveDatafileEntry", function(client, datafileID, key, date, category, text)
	local char = client:GetCharacter()

	if (char:ReturnDatafilePermission() < 4) then return end

	--if (char:ReturnDatafilePermission() < 4) then return end
end) --{target, key, date, category, text})

netstream.Hook("RefreshDatafile", function(client, datafileID)
	PLUGIN:HandleDatafile(client, datafileID)
end) --target)

netstream.Hook("SetRegistryEntry", function(client, datafileID, text)
	local char = client:GetCharacter()

	if (char:ReturnDatafilePermission() < 1) then return end
	if PLUGIN:IsRestricted((PLUGIN.stored[tonumber(datafileID)] or {})[4]) then return end
	if !PLUGIN:HasDatafileAccess(char, datafileID) then return end

	PLUGIN:SetRegistry(client, datafileID, text);
	PLUGIN:RefreshDatafile(client, datafileID)
end);

