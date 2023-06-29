ix.guilds = ix.guilds or {}
local stored = ix.guilds.stored or {}
ix.guilds.stored = stored

function ix.guilds.all()
	return stored
end

function ix.guilds.get(id)
	return stored[id]
end

function ix.guilds.member_count(id)
	local count = 0

	if istable(id) then
		for k, v in pairs(id) do
			count = count + 1
		end
	else
		for k, v in pairs(stored[id].members) do
			count = count + 1
		end
	end

	return count
end

if (SERVER) then
	function ix.guilds.register(character, name)
		if character:GetGuildUID() ~= -1 then return end

		local guild = ix.meta.guild:New(math.random(9000, 9999), character:GetID(), name)
		local query_create = mysql:Insert('ix_guilds')
		query_create:Insert('owner', character:GetID())
		query_create:Insert('name', name)
		query_create:Insert('members', util.TableToJSON(guild:get_members()))
		query_create:Insert('roles', util.TableToJSON(guild:get_roles()))
		query_create:Insert('date_create', os.date('%d.%m.%Y'))

		query_create:Callback(function(result, status, last_id)
			guild.id = last_id
			character:SetGuildUID(last_id)
			stored[last_id] = guild
			guild:sync()
		end)

		query_create:Execute()
	end

	function ix.guilds.invite(character, target_character)
		if target_character:GetGuildUID() ~= -1 then return end
		local id = character:GetGuildUID()
		if id == -1 then return end
		local guild = ix.guild.get(id)

		if guild:has_privilege(character, GUILD_ENUM_PRIVILEGES.INVITE) then
			local invites = guild:get_invites()
			if invites[target_character:GetID()] then return end
			local query_update = mysql:Update('ix_guilds')
			query_update:Where('id', guild:get_id())
			query_update:WhereLT('members_limit', ix.guilds.member_count(guild:get_id()))
			query_update:Update('invites', util.TableToJSON(invites))

			query_update:Callback(function(result)
				local target_invites = target_character:GetPlayer():GetLocalVar('invites', {})

				target_invites[guild:get_id()] = {
					id = guild:get_id(),
					name = guild:get_name(),
					invited_by = character:GetName()
				}

				target_character:GetPlayer():SetLocalVar('invites', target_invites)
				guild:add_invite(target_character)
				guild:sync()
			end)

			query_update:Execute()
		end
	end

	function ix.guilds.accept(character, id, declined)
		if character:GetGuildUID() ~= -1 then return end
		local invite = character:GetPlayer():GetLocalVar('invites', {})[id]
		if not invite then return end
		local guild = stored[invite.id]
		local query_find = mysql:Select('ix_guilds')
		query_find:Where('id', guild:get_id())
		query_find:Select('members')
		query_find:Select('members_limit')

		query_find:Callback(function(result)
			if (not istable(result) or #result == 0) then return end
			result = result[1]
			result.members = util.JSONToTable(result.members)
			result.members_limit = tonumber(result.members_limit)

			if ix.guilds.member_count(result.members) < result.members_limit then
				local invites = character:GetPlayer():GetLocalVar('invites', {})
				invites[guild.id] = nil
				character:GetPlayer():SetLocalVar('invites', invites)
				guild:remove_invite(character)
				guild:add_member(character)
				guild:sync()
			end
		end)

		query_find:Execute()
	end

	function ix.guilds.kick(character, target_character)
		local id, target_id = character:GetGuildUID(), target_character:GetGuildUID()
		if id == -1 or target_id == -1 then return end
		local guild = stored[id]
		if not guild:get_member(target_character:GetID()) then return end

		if guild:has_privilege(character, GUILD_ENUM_PRIVILEGES.KICK) then
			guild:kick_member(target_character)
			guild:sync()
		end
	end

	function ix.guilds.delete(id, character)
		local id = character and character:GetGuildUID() or id
		if id == -1 then return end
		local guild = stored[id]
		local query_drop = mysql:Delete('ix_guilds')
		query_drop:Where('id', id)

		if character then
			query_drop:Where('owner', character:GetID())
		end

		query_drop:Callback(function(result)
			local players = player.GetAll()

			for i = 1, player.GetCount() do
				client = players[i]
				if not client:GetCharacter() then continue end

				if guild then
					if guild:get_member(client:GetCharacter():GetID()) then
						client:GetCharacter():SetGuildUID(-1)
					end
				end
			end

			local query_update = mysql:Update('ix_characters')
			query_update:Where("schema", Schema and Schema.folder or "helix")
			query_update:WhereEqual('guild', id)
			query_update:Update('guild', -1)
			query_update:Execute()
			stored[id] = nil
			ix.guilds.sync(id)
		end)

		query_drop:Execute()
	end

	function ix.guilds.sync(id, reciever)
		local filter = RecipientFilter()

		if reciever then
			if istable(reciever) then
				for i = 1, #reciever do
					filter:AddPlayer(reciever[i])
				end
			else
				filter:AddPlayer(reciever)
			end
		else
			filter:AddAllPlayers()
		end

		local data = {}

		if id then
			data = stored[id] and stored[id]:get_data() or nil
		else
			for k, v in pairs(stored) do
				data[v.id] = v:get_data()
			end
		end

		if not data then
			data = {
				id = id,
				query_remove = true
			}
		end

		local json = util.TableToJSON(data)
		local compressed = util.Compress(json)
		local length = compressed:len()
		net.Start('ix_guild_sync')
		net.WriteUInt(length, 32)
		net.WriteData(compressed, length)
		net.Send(filter)
	end
end