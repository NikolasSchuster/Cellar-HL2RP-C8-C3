local PLUGIN = PLUGIN

util.AddNetworkString("PopulateDatafilePoints")

function PLUGIN:ReturnDatafile(CID, RegID, type)
	for k, v in pairs(self.stored) do
		if v[2] == CID and v[3] == RegID then
			if type == true then
				return k, v[5]
			elseif type == false then
				return k, v[4]
			else
				return k, v[5], v[4]
			end
		end
	end
end

function PLUGIN:ReturnDatafileByID(id, type)
	local data = self.stored[id]
	if data then
		if type == true then
			return id, data[5]
		elseif type == false then
			return id, data[4]
		else
			return id, data[5], data[4]
		end
	end
end

function PLUGIN:GetDatafileName(id)
	local data = self.stored[id]
	
	return data and data[1] or id
end

function PLUGIN:GetDatafileCID(id)
	local data = self.stored[id]

	return data and data[2] or id
end

function PLUGIN:GetDatafileRegID(id)
	local data = self.stored[id]

	return data and data[3] or id
end

function PLUGIN:ReturnPermission(CID, RegID, callback)
	local query = mysql:Select("ix_items")
		query:Select("data")
		query:WhereLike("data", "\"cid\":\""..CID.."\"")
		query:WhereLike("data", "\"number\":\""..RegID.."\"")
		query:Callback(function(result)
			local access = 0

			if istable(result) and #result > 0 then
				local data = util.JSONToTable((result[1].data or {}))
				data = (data["access"] or {})
				
				if data["DATAFILE_ELEVATED"] then
					access = 4
				elseif data["DATAFILE_FULL"] then
					access = 3
				elseif data["DATAFILE_MEDIUM"] then
					access = 2
				elseif data["DATAFILE_MINOR"] then
					access = 1
				end
			end

			if callback then
				callback(access)
			end
		end)
	query:Execute()
end

function PLUGIN:ReturnPermissionByID(id)
	local access = 0
	local data = (self.stored[id] or {})[6]

	if data then
		if data["DATAFILE_ELEVATED"] then
			access = 4
		elseif data["DATAFILE_FULL"] then
			access = 3
		elseif data["DATAFILE_MEDIUM"] then
			access = 2
		elseif data["DATAFILE_MINOR"] then
			access = 1
		end
	end

	return access
end

function PLUGIN:HasDatafileAccess(character, value2)
	local a = character:ReturnDatafilePermission() or 0
	local b = 0

	if isstring(value2) or isnumber(value2) then
		b = self:ReturnPermissionByID(value2)
	else
		b = value2:ReturnDatafilePermission()
	end

	return a >= b
end

function PLUGIN:UpdateLastSeen(datafileID)
	datafileID = tonumber(datafileID) or 0

	if !self.stored[datafileID] then return end

	self.stored[datafileID][4].last_seen = os.time()
end

function PLUGIN:SetCivilStatus(datafileID, civilStatus, client, char)
	if !self.CivilStatus[civilStatus] then return end

	datafileID = tonumber(datafileID) or 0

	if !self.stored[datafileID] then return end

	self.stored[datafileID][4].status = civilStatus

	if IsValid(client) then
		self:AddEntry(client, datafileID, "union", Format("%s has changed Civil Status to %s", char:GetName(), civilStatus), 0)
	end
end

local ranks = {
	[1] = "Regular",
	[2] = "Rank Leader"
}
function PLUGIN:SetRankStatus(datafileID, rank, client, char)
	if !ranks[rank] then return end

	datafileID = tonumber(datafileID) or 0

	if !self.stored[datafileID] then return end

	local old_rank = self.stored[datafileID][4].rank
	self.stored[datafileID][4].rank = rank

	if IsValid(client) then
		self:AddEntry(client, datafileID, "civil", Format("%s has changed rank to %s", char:GetName(), ranks[rank]), 0)
	end

	hook.Run("OnCombineRankChanged", datafileID, old_rank, rank)
end

function PLUGIN:AddEntry(poster, player, category, text, points)
	local posterCharacter = poster:GetCharacter()
	if !posterCharacter then return end
	if !self.Categories[category] then return  end

	local id, datafile, genericdata

	if isstring(player) or isnumber(player) then
		id, datafile, genericdata = self:ReturnDatafileByID(player)
		ix.log.AddRaw(poster:Name() .. " has added an entry to #" .. self:GetDatafileCID(id) .. " datafile with category: " .. category)
	else
		id, datafile, genericdata = player:GetCharacter():ReturnDatafile()
		ix.log.AddRaw(poster:Name() .. " has added an entry to " .. player:Name() .. "'s datafile with category: " .. category)
	end

	genericdata.points = (genericdata.points or 0) + points

	datafile[#datafile + 1] = {
		category = category,
		text = text,
		unix_time = os.time(),
		points = points,
		poster_name = posterCharacter:GetName(),
		poster_color = team.GetColor(poster:Team()),
		poster_steam = poster:SteamID()
	}

	local rf = RecipientFilter()
	rf:AddAllPlayers()

	id = tonumber(id)

	for _, v in ipairs(rf:GetPlayers()) do
		if v.lastDatafile != id or !v:GetCharacter() then
			rf:RemovePlayer(v)
		else
			continue
		end
	end

	if IsValid(poster) and points != 0 then
		net.Start("PopulateDatafilePoints")
			net.WriteInt(genericdata.points or 0, 16)
		net.Send(rf)
	end

	netstream.Start(rf:GetPlayers(), "AddDatafileEntry", datafile[#datafile])
end

function PLUGIN:SetBOL(poster, player, bBOL, reason)
	reason = reason or ""

	local id, genericdata

	if isstring(player) or isnumber(player) then
		id, genericdata = self:ReturnDatafileByID(player, false)
	else
		id, genericdata = player:GetCharacter():ReturnDatafile(false)
	end

	if bBOL == true then
		genericdata.bol = true
		genericdata.bol_reason = reason
	elseif bBOL == false then
		genericdata.bol = false
		genericdata.bol_reason = ""
	else
		genericdata.bol = !genericdata.bol
		genericdata.bol_reason = genericdata.bol and reason or ""
	end

	if IsValid(poster) then
		local text = genericdata.bol and "%s has put a bol." or "%s has removed a bol."

		self:AddEntry(poster, id, "union", Format(text, poster:GetCharacter():GetName()), 0)
	end
end

function PLUGIN:SetRestricted(poster, player, bRestricted, text)
	local id, genericdata

	if isstring(player) or isnumber(player) then
		id, genericdata = self:ReturnDatafileByID(player, false)
	else
		id, genericdata = player:GetCharacter():ReturnDatafile(false)
	end

	if bRestricted then
		genericdata.restricted = true
		genericdata.restricted_reason = text

		self:AddEntry(poster, id, "civil", Format("%s has made this file restricted.", poster:GetCharacter():GetName()), 0)
	else
		genericdata.restricted = false
		genericdata.restricted_reason = ""

		self:AddEntry(poster, id, "civil", Format("%s has removed the restriction on this file.", poster:GetCharacter():GetName()), 0)
	end
end

function PLUGIN:SetRegistry(poster, player, text)
	local id, genericdata

	if isstring(player) or isnumber(player) then
		id, genericdata = self:ReturnDatafileByID(player, false)
	else
		id, genericdata = player:GetCharacter():ReturnDatafile(false)
	end

	if text then
		genericdata.aparts = text

		self:AddEntry(poster, id, "reg", Format("%s has registered this file to %s.", poster:GetCharacter():GetName(), text), 0)
	elseif genericdata.aparts != "N/A" then
		genericdata.aparts = "N/A"

		self:AddEntry(poster, id, "reg", Format("%s has removed a registration of this file.", poster:GetCharacter():GetName()), 0)
	end
end

function PLUGIN:ReturnPoints(player)
	local id, genericdata = player:GetCharacter():ReturnDatafile(false)

	return genericdata.points
end

function PLUGIN:ReturnCivilStatus(player)
	local id, genericdata = player:GetCharacter():ReturnDatafile(false)

	return genericdata.status
end

function PLUGIN:ReturnBOL(player)
	local id, genericdata = player:GetCharacter():ReturnDatafile(false)
	local bHasBOL = genericdata.bol

	if bHasBOL then
		return true, genericdata.bol_reason
	else
		return false, ""
	end
end

function PLUGIN:IsRestricted(data)
	data = istable(data) and data or {}

	return data.restricted, data.restricted_reason
end

function PLUGIN:IsRestrictedFaction(character)
	if character:GetFaction() == FACTION_OTA then
		return true
	end

	return false
end

do
	local CHAR = ix.meta.character

	function CHAR:ReturnDatafile(type, callback)
		local player = self:GetPlayer()
		
		if player.ixDatafile then
			local _, v1, v2 = PLUGIN:ReturnDatafileByID(player.ixDatafile, type)

			if (v1 or v2) then
				if callback then
					callback(player.ixDatafile, v1, v2)
				end
				
				return player.ixDatafile, v1, v2
			end
		end

		local cid = self:GetIDCard()

		if cid then
			local did = cid:GetData("datafileID")
			local _, v1, v2 = PLUGIN:ReturnDatafileByID(did, type)

			if (v1 or v2) then
				if callback then
					callback(did, v1, v2)
				end
				
				return did, v1, v2
			end
		end
	end

	function CHAR:ReturnDatafilePermission()
		if self:GetFaction() == FACTION_DISPATCH then
			return 4
		end

		local cid = self:GetIDCard()

		if !cid then 
			return 0 
		end

		local accesses = cid:GetData("access", {})
		
		if accesses["DATAFILE_ELEVATED"] then
			return 4
		elseif accesses["DATAFILE_FULL"] then
			return 3
		elseif accesses["DATAFILE_MEDIUM"] then
			return 2
		elseif accesses["DATAFILE_MINOR"] then
			return 1
		end

		return 0
	end
end

/*
Clockwork.config:Add("mysql_datafile_table", "datafile", nil, nil, true, true, true);

// Update the player their datafile.
function cwDatafile:UpdateDatafile(player, GenericData, datafile)
	if (player:IsValid()) then
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local datafileTable = Clockwork.config:Get("mysql_datafile_table"):Get();
		local character = player:GetCharacter();

		// Update all the values of a player.
		local queryObj = Clockwork.database:Update(datafileTable);
			queryObj:AddWhere("_CharacterID = ?", character.characterID);
			queryObj:AddWhere("_SteamID = ?", player:SteamID());
			queryObj:AddWhere("_Schema = ?", schemaFolder);
			queryObj:SetValue("_CharacterName", character.name);
			queryObj:SetValue("_GenericData", Clockwork.json:Encode(GenericData));
			queryObj:SetValue("_Datafile", Clockwork.json:Encode(datafile));
		queryObj:Push();

		cwDatafile:LoadDatafile(player);
	end;
end;

// Scrub a player their datafile.
function cwDatafile:ScrubDatafile(player)
	cwDatafile:UpdateDatafile(player, PLUGIN.Default.GenericData, PLUGIN.Default.civilianDatafile);
end;

// Remove an entry by checking for the key & validating it is the entry.
function cwDatafile:RemoveEntry(player, target, key, date, category, text)
	local GenericData = cwDatafile:ReturnGenericData(target);
	local datafile = cwDatafile:ReturnDatafile(target);

	if (datafile[key].date == date && datafile[key].category == category && datafile[key].text == text) then
		table.remove(datafile, key);

		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name() .. " has removed an entry of " .. target:Name() .. "'s datafile with category: " .. category);
		cwDatafile:UpdateDatafile(target, GenericData, datafile);
	end;
end;

*/